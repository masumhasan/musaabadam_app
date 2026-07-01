import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musaab_adam/core/services/api_review_service.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import 'package:musaab_adam/data/models/review/review_model.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/widgets/cached_image_widget.dart';
import '../../../core/widgets/custom_text.dart';

class ReviewTab extends StatefulWidget {
  /// Seller whose reviews to show. When null, renders an empty state.
  final String? sellerId;
  const ReviewTab({super.key, this.sellerId});

  @override
  State<ReviewTab> createState() => _ReviewTabState();
}

class _ReviewTabState extends State<ReviewTab> {
  SellerReviews? _data;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.sellerId == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final data = await ApiReviewService.instance.getSellerReviews(widget.sellerId!);
      if (mounted) setState(() => _data = data);
    } catch (_) {
      // leave empty
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    if (_loading) {
      return const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()));
    }
    final data = _data;
    if (data == null || data.reviews.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 30.h),
        child: Center(child: CustomText(text: 'No reviews yet', fontColor: colorScheme.outline)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        Row(
          children: [
            Icon(Icons.star, color: AppColors.orange, size: 20.sp),
            SizedBox(width: 4.w),
            CustomText(
              text: '${data.averageRating.toStringAsFixed(1)}  ·  ${data.ratingCount} review${data.ratingCount == 1 ? '' : 's'}',
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: data.reviews.length,
          itemBuilder: (context, index) => _reviewItem(context, data.reviews[index]),
        ),
      ],
    );
  }

  Widget _reviewItem(BuildContext context, ReviewModel r) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedImageWidget(
            imageUrl: (r.buyerAvatarUrl?.isNotEmpty ?? false) ? r.buyerAvatarUrl! : Dummy.user1,
            width: 40.w,
            height: 40.h,
            borderRadius: 50,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        text: r.buyerName,
                        fontWeight: FontWeight.w700,
                        textAlignment: TextAlign.start,
                        fontColor: colorScheme.onSurface,
                        maxLines: 1,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < r.rating ? Icons.star : Icons.star_border,
                          color: AppColors.orange,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                if ((r.comment ?? '').isNotEmpty)
                  CustomText(
                    text: r.comment!,
                    fontSize: 14.sp,
                    fontColor: colorScheme.onSurface.withValues(alpha: 0.7),
                    textAlignment: TextAlign.start,
                    maxLines: 4,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
