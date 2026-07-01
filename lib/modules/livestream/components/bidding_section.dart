import 'dart:async';

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
          : product.effectivePrice;
      final priceText = '£${price.toStringAsFixed(2)}';
      final flashActive = product.isFlashSaleActive;
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
                Obx(() => IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: Icon(
                        lsCtrl.pinnedFavorited.value ? Icons.favorite : Icons.favorite_border,
                        color: lsCtrl.pinnedFavorited.value ? Colors.red : Colors.black54,
                        size: 22,
                      ),
                      onPressed: lsCtrl.toggleFavorite,
                    )),
                const SizedBox(width: 4),
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
                    // Flash sale: original price struck through + live countdown.
                    if (flashActive) ...[
                      Text(
                        '£${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('⚡ ', style: TextStyle(fontSize: 12)),
                          _FlashCountdown(endsAt: product.flashSaleEndsAt!),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Auction → Custom + Bid. Buy-now → single full-width Buy now.
            if (product.isAuction)
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
                      onPressed: () => lsCtrl.placeBid(price + 1.0),
                    ),
                  ),
                ],
              )
            else
              Obx(() => CustomButton(
                    label: 'Buy now  £${price.toStringAsFixed(2)}',
                    backgroundColor: AppColors.orange,
                    textColor: AppColors.white,
                    fontWeight: FontWeight.w900,
                    buttonRadius: 8,
                    buttonWidth: double.infinity,
                    isLoading: lsCtrl.isBuying.value,
                    onPressed: lsCtrl.buyNow,
                  )),
          ],
        ),
      );
    });
  }
}

/// Live MM:SS countdown to a flash-sale end time.
class _FlashCountdown extends StatefulWidget {
  final DateTime endsAt;
  const _FlashCountdown({required this.endsAt});

  @override
  State<_FlashCountdown> createState() => _FlashCountdownState();
}

class _FlashCountdownState extends State<_FlashCountdown> {
  late Duration _left;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final left = widget.endsAt.difference(DateTime.now());
    if (mounted) setState(() => _left = left.isNegative ? Duration.zero : left);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = _left.inHours;
    final m = _left.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = _left.inSeconds.remainder(60).toString().padLeft(2, '0');
    final text = h > 0 ? '${h}h ${m}m' : '$m:$s';
    return Text(
      text,
      style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 12),
    );
  }
}
