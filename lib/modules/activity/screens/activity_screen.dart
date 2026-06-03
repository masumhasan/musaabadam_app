import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import '../../../core/utils/app_constants.dart';
import '../../main_nav/components/app_bar.dart';
import '../../main_nav/components/chip_buttons.dart';

class ActivityProductItem {
  final String imageUrl;
  final String? status;
  final Color? statusColor;
  final String title;
  final String subtitle;
  final String sellerName;

  ActivityProductItem({
    required this.imageUrl,
    this.status,
    this.statusColor,
    required this.title,
    required this.subtitle,
    required this.sellerName,
  });
}

class ActivityScreen extends StatelessWidget {
  ActivityScreen({super.key});

  final RxInt selectedTabIndex = 0.obs;

  final List<ActivityProductItem> products =[
    ActivityProductItem(
      imageUrl: Dummy.product1,
      title: 'adg',
      subtitle: 'Purchased: 12/12/25',
      sellerName: 'aum_burgains',
    ),
    ActivityProductItem(
      imageUrl: Dummy.product1,
      status: 'Cancelled',
      statusColor: const Color(0xffFFA0A0),
      title: 'Hand Bag',
      subtitle: 'Sold for: £5,000',
      sellerName: 'aum_burgains',
    ),
    ActivityProductItem(
      imageUrl: Dummy.product1,
      status: 'Completed',
      statusColor: const Color(0xFF008BAA),
      title: 'Hand Bag',
      subtitle: 'Sold for: £5,000',
      sellerName: 'aum_burgains',
    ),
    ActivityProductItem(
      imageUrl: Dummy.product1,
      status: 'Preparing Package',
      statusColor: const Color(0xFFFFCC99),
      title: 'Hand Bag',
      subtitle: 'Sold for: £5,000',
      sellerName: 'aum_burgains',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: appBar,
      body: Column(
        children: [
          Row(
            children:[
              _buildTab(AppStrings.purchases.tr, 0),
              _buildTab(AppStrings.bids.tr, 1),
              _buildTab(AppStrings.offers.tr, 2),
              _buildTab(AppStrings.saved.tr, 3),
            ],
          ),
          ChipButtonsBar(),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.activityDetailsScreen),
                  child: ProductTile(item: products[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    return Obx(() => TextButton(
      onPressed: () => selectedTabIndex.value = index,
      child: CustomText(
        text: text,
        underline: selectedTabIndex.value == index,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        underlineWidth: 2,
      ),
    ));
  }
}

class ProductTile extends StatelessWidget {
  final ActivityProductItem item;

  const ProductTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedImageWidget(
              imageUrl: item.imageUrl,
              icon: Icons.image_outlined,
              iconSize: 40,
              width: 120,
              height: 120,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:[
                if (item.status != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.statusColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      item.status!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8), // Keeping contrast for colored badges
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else
                  Text(
                    "Label Created",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: colorScheme.onSurface),
                  ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  style: TextStyle(fontSize: 18, color: colorScheme.onSurface),
                ),
                Text(
                  item.subtitle,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    text: 'From: ',
                    style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.8), fontSize: 14),
                    children:[
                      TextSpan(
                        text: item.sellerName,
                        style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}