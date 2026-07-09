import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/product_service.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/data/models/product/product_model.dart';
import 'package:musaab_adam/core/services/api_offer_service.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/widgets/custom_choice_chip.dart';

class ShopTab extends StatefulWidget {
  final String? sellerId;
  const ShopTab({super.key, this.sellerId});

  @override
  State<ShopTab> createState() => _ShopTabState();
}

class _ShopTabState extends State<ShopTab> {
  int _currentIndex = 0;
  List<ProductModel> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void didUpdateWidget(covariant ShopTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sellerId != widget.sellerId) {
      _loadProducts();
    }
  }

  Future<void> _loadProducts() async {
    if (widget.sellerId == null) {
      setState(() {
        _products = [];
        _loading = false;
      });
      return;
    }

    setState(() => _loading = true);

    String? status;
    if (_currentIndex == 1) {
      status = 'active';
    } else if (_currentIndex == 2) {
      status = 'inactive';
    } else if (_currentIndex == 3) {
      status = 'sold_out';
    } else {
      status = 'all';
    }

    try {
      final list = await ProductService.instance.getPublicProducts(
        sellerId: widget.sellerId,
        status: status,
      );
      if (mounted) {
        setState(() {
          _products = list;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _products = [];
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SearchBar(
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(width: 2, color: colorScheme.primary),
            ),
          ),
          trailing: [Icon(Icons.search, color: colorScheme.primary)],
        ),
        const SizedBox(height: 20),
        Row(
          spacing: 10.w,
          children: [
            _buildTab(AppStrings.all, 0),
            _buildTab(AppStrings.active, 1),
            _buildTab(AppStrings.inactive, 2),
            _buildTab(AppStrings.sold, 3),
          ],
        ),
        const SizedBox(height: 20),
        _buildContent(colorScheme),
      ],
    );
  }

  Widget _buildContent(ColorScheme colorScheme) {
    if (_loading) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_products.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h),
        child: Center(
          child: CustomText(
            text: 'No products found',
            fontColor: colorScheme.outline,
          ),
        ),
      );
    }

    return Column(
      spacing: 15.h,
      children: _products.map((p) => shopProduct(context, p)).toList(),
    );
  }

  Widget _buildTab(String label, int index) {
    return CustomChoiceChip(
      label: label.tr,
      selected: _currentIndex == index,
      colorChangeable: true,
      borderRadius: 100,
      padding: const [10, 4],
      showShadow: true,
      onSelected: (_) {
        if (_currentIndex != index) {
          setState(() {
            _currentIndex = index;
          });
          _loadProducts();
        }
      },
    );
  }

  Widget shopProduct(BuildContext context, ProductModel product) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10.w,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: CachedImageWidget(
            imageUrl: product.images.isNotEmpty ? product.images.first : '',
            borderRadius: 20,
            height: 100.h,
            width: 100.w,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                text: product.title,
                translate: false,
                fontColor: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                textAlignment: TextAlign.start,
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              CustomText(
                text: "£${product.price.toStringAsFixed(2)} · ${product.condition.replaceAll('_', ' ').toUpperCase()}",
                translate: false,
                fontColor: colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 14,
                textAlignment: TextAlign.start,
              ),
              const SizedBox(height: 4),
              CustomText(
                text: "${product.quantity} left",
                translate: false,
                fontColor: colorScheme.primary,
                fontSize: 12,
                textAlignment: TextAlign.start,
              ),
              const SizedBox(height: 8),
              if (product.status == 'active')
                OutlinedButton(
                  onPressed: () => _showMakeOfferDialog(context, product, colorScheme),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                    minimumSize: Size.zero,
                  ),
                  child: const Text('Make Offer', style: TextStyle(fontSize: 12)),
                ),
            ],
          ),
        )
      ],
    );
  }

  void _showMakeOfferDialog(BuildContext context, ProductModel product, ColorScheme colorScheme) {
    final TextEditingController amountController = TextEditingController();
    Get.dialog(
      AlertDialog(
        backgroundColor: colorScheme.surface,
        title: CustomText(text: 'Make Offer', fontColor: colorScheme.onSurface, fontWeight: FontWeight.bold),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: product.title, maxLines: 1, textAlignment: TextAlign.start),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                prefixText: '\$ ',
                labelText: 'Offer Amount',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text);
              if (amount == null || amount <= 0) {
                Get.snackbar('Error', 'Please enter a valid amount');
                return;
              }
              Get.back();
              try {
                await ApiOfferService.instance.createOffer(productId: product.id, amount: amount);
                Get.snackbar('Success', 'Offer sent successfully!', backgroundColor: Colors.green, colorText: Colors.white);
              } catch (e) {
                Get.snackbar('Error', 'Failed to send offer');
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}