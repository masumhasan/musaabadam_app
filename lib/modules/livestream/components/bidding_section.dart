import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/widgets/cached_image_widget.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/livestream_controller.dart';
import 'livestream_dialogs.dart';

class BiddingSection extends StatelessWidget {
  const BiddingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final lsCtrl = Get.find<LivestreamController>();

    return Obx(() {
      final product = lsCtrl.pinnedProduct.value;

      if (product == null) {
        return const SizedBox.shrink();
      }

      final price = product.isAuction
          ? (product.currentHighBid > 0 ? product.currentHighBid : (product.startingPrice ?? 0))
          : product.price;
      final priceText = '£${price.toStringAsFixed(2)}';
      final imageUrl = product.images.isNotEmpty ? product.images.first : Dummy.product1;

      return Container(
        padding: const EdgeInsets.all(12),
        color: Colors.white.withOpacity(0.9),
        child: Column(
          children: [
            Row(
              children: [
                CachedImageWidget(
                  imageUrl: imageUrl,
                  height: 48,
                  width: 48,
                  borderRadius: 8,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        product.condition,
                        style: const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      Text(
                        "+shipping+taxes",
                        style: TextStyle(color: Colors.cyan.shade700, fontSize: 11),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      priceText,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    if (product.isAuction && product.auctionEndsAt != null)
                      Row(
                        children: const [
                          Icon(Icons.timer_outlined, size: 14, color: Colors.black),
                          SizedBox(width: 4),
                          Text(
                            "Auction",
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    label: AppStrings.custom,
                    backgroundColor: Colors.transparent,
                    textColor: AppColors.primaryColor,
                    fontWeight: FontWeight.w900,
                    borderWidth: 2,
                    borderColor: AppColors.primaryColor,
                    buttonRadius: 8,
                    onPressed: () {
                      showBiddingDialog();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    label: AppStrings.bid,
                    backgroundColor: AppColors.orange,
                    textColor: AppColors.white,
                    fontWeight: FontWeight.w900,
                    buttonRadius: 8,
                    onPressed: product.isAuction
                        ? () => lsCtrl.placeBid(price + 1.0)
                        : null,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
