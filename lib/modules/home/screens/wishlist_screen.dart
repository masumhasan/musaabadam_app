import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/data/models/product/product_model.dart';
import 'package:musaab_adam/modules/home/controllers/wishlist_controller.dart';

class WishlistScreen extends GetView<WishlistController> {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: cs.onSurface),
        title: CustomText(text: 'Wishlist', fontWeight: FontWeight.w700),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.products.isEmpty) {
          return Center(child: CustomText(text: 'Your wishlist is empty', fontColor: cs.outline));
        }
        return RefreshIndicator(
          onRefresh: controller.load,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            itemCount: controller.products.length,
            separatorBuilder: (_, _) => SizedBox(height: 12.h),
            itemBuilder: (context, index) => _tile(controller.products[index], cs),
          ),
        );
      }),
    );
  }

  Widget _tile(ProductModel p, ColorScheme cs) {
    final price = p.isAuction
        ? (p.currentHighBid > 0 ? p.currentHighBid : (p.startingPrice ?? 0))
        : p.effectivePrice;
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: CachedImageWidget(
            imageUrl: p.images.isNotEmpty ? p.images.first : Dummy.product1,
            height: 64.h,
            width: 64.w,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(text: p.title, fontWeight: FontWeight.w600, textAlignment: TextAlign.start, maxLines: 1),
              CustomText(
                text: '£${price.toStringAsFixed(2)}  ·  ${p.listingType.replaceAll('_', ' ')}',
                fontSize: 13,
                fontColor: cs.outline,
                textAlignment: TextAlign.start,
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () => controller.remove(p),
          tooltip: 'Remove',
        ),
      ],
    );
  }
}
