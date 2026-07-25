import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_favorite_service.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/text_button_widget.dart';
import 'package:musaab_adam/data/models/product/product_model.dart';
import 'package:musaab_adam/modules/product/bindings/single_product_binding.dart';
import 'package:musaab_adam/modules/product/screens/single_product_screen.dart';
import 'package:musaab_adam/routes/app_pages.dart';

class SavedProductsTab extends StatefulWidget {
  const SavedProductsTab({super.key});

  @override
  State<SavedProductsTab> createState() => _SavedProductsTabState();
}

class _SavedProductsTabState extends State<SavedProductsTab> {
  List<ProductModel> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedProducts();
  }

  Future<void> _loadSavedProducts() async {
    setState(() => _loading = true);
    try {
      final list = await ApiFavoriteService.instance.list();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.bookmark_border_rounded, size: 48, color: Colors.grey),
              SizedBox(height: 16.h),
              CustomText(
                text: 'No Saved Products',
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                fontColor: colorScheme.onSurface,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: _products
          .map((p) => Padding(
                padding: EdgeInsets.only(bottom: 15.h),
                child: savedProduct(context, p),
              ))
          .toList(),
    );
  }

  Widget savedProduct(BuildContext context, ProductModel product) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Get.to(
        () => const SingleProductScreen(),
        binding: SingleProductBinding(),
        arguments: product,
      ),
      child: Container(
        color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            SizedBox(width: 10.w),
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
                  const SizedBox(height: 6),
                  // Seller hyperlink
                  Row(
                    children: [
                      CustomText(
                        text: "Seller: ",
                        fontSize: 12,
                        fontColor: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      TextButtonWidget(
                        text: product.sellerName ?? 'Seller',
                        textColor: colorScheme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        onPressed: () {
                          Get.toNamed(
                            AppRoutes.otherUserProfileScreen,
                            arguments: product.sellerId,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
