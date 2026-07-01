import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/modules/home/controllers/search_controller.dart';
import 'package:musaab_adam/routes/app_pages.dart';

class SearchScreen extends GetView<SearchScreenController> {
  const SearchScreen({super.key});

  static const _teal = Color(0xFF1E90B0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _teal, width: 1.5),
                ),
                child: TextField(
                  autofocus: true,
                  onChanged: controller.onQueryChanged,
                  decoration: const InputDecoration(
                    hintText: 'Search sellers, products, shows',
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search, color: Colors.black54),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Type chips
              Obx(() => Wrap(
                    spacing: 8,
                    children: [
                      for (final t in const ['all', 'sellers', 'products', 'streams'])
                        ChoiceChip(
                          label: Text(t[0].toUpperCase() + t.substring(1)),
                          selected: controller.type.value == t,
                          selectedColor: _teal.withValues(alpha: 0.2),
                          onSelected: (_) => controller.setType(t),
                        ),
                    ],
                  )),

              // Contextual filter chips
              Obx(() {
                final t = controller.type.value;
                final filters = t == 'streams'
                    ? const ['live', 'upcoming', 'ended']
                    : t == 'products'
                        ? const ['auction', 'buy_now']
                        : const <String>[];
                if (filters.isEmpty) return const SizedBox(height: 4);
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Wrap(
                    spacing: 8,
                    children: [
                      for (final f in filters)
                        FilterChip(
                          label: Text(f.replaceAll('_', ' ')),
                          selected: controller.filter.value == f,
                          selectedColor: _teal.withValues(alpha: 0.2),
                          onSelected: (_) => controller.setFilter(f),
                        ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 8),

              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.query.value.trim().isEmpty) {
                    return const Center(child: Text('Search for sellers, products, or live shows'));
                  }
                  final r = controller.results.value;
                  if (r.isEmpty) {
                    return const Center(child: Text('No results'));
                  }
                  return ListView(
                    children: [
                      if (r.sellers.isNotEmpty) ...[
                        _sectionTitle('Sellers'),
                        ...r.sellers.map(_sellerTile),
                      ],
                      if (r.streams.isNotEmpty) ...[
                        _sectionTitle('Live shows'),
                        ...r.streams.map(_streamTile),
                      ],
                      if (r.products.isNotEmpty) ...[
                        _sectionTitle('Products'),
                        ...r.products.map(_productTile),
                      ],
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      );

  Widget _sellerTile(Map<String, dynamic> s) {
    final id = (s['_id'] ?? s['id'])?.toString();
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(s['displayName']?.toString() ?? s['username']?.toString() ?? 'Seller'),
      subtitle: Text('@${s['username'] ?? ''}  ·  ★ ${s['averageRating'] ?? 0}'),
      onTap: id == null ? null : () => Get.toNamed(AppRoutes.otherUserProfileScreen, arguments: id),
    );
  }

  Widget _streamTile(Map<String, dynamic> s) {
    final id = (s['_id'] ?? s['id'])?.toString();
    final seller = s['sellerId'] is Map ? Map<String, dynamic>.from(s['sellerId'] as Map) : const {};
    return ListTile(
      leading: const Icon(Icons.videocam, color: _teal),
      title: Text(s['title']?.toString() ?? 'Show'),
      subtitle: Text('${s['status']} · ${seller['displayName'] ?? seller['username'] ?? ''}'),
      onTap: (id == null || s['status'] != 'live') ? null : () => Get.toNamed(AppRoutes.livestreamScreen, arguments: id),
    );
  }

  Widget _productTile(Map<String, dynamic> p) {
    final flash = p['flashSale'] == true && p['flashSalePrice'] != null;
    final price = flash ? p['flashSalePrice'] : p['price'];
    return ListTile(
      leading: const Icon(Icons.shopping_bag_outlined),
      title: Text(p['title']?.toString() ?? 'Product'),
      subtitle: Text('${p['listingType']} · £$price${flash ? '  ⚡' : ''}'),
    );
  }
}
