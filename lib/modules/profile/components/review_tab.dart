import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musaab_adam/core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/widgets/cached_image_widget.dart';
import '../../../core/widgets/custom_text.dart';

class ReviewTab extends StatelessWidget {
  const ReviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 4,
      itemBuilder: (context, index) => _reviewItem(context),
    );
  }

  Widget _reviewItem(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: CachedImageWidget(
        imageUrl: Dummy.user1,
        width: 40.w,
        height: 40.h,
        borderRadius: 50,
      ),
      title: CustomText(
        text: "Isabella Silveria",
        maxLines: 1,
        fontWeight: FontWeight.w700,
        textAlignment: TextAlign.start,
        fontColor: colorScheme.onSurface,
      ),
      subtitle: CustomText(
        text: "Desenvolvedora",
        fontSize: 14.sp,
        fontColor: colorScheme.onSurface.withValues(alpha: 0.6),
        textAlignment: TextAlign.start,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(5, (index) => Icon(
          Icons.star,
          color: AppColors.orange,
          size: 18.sp,
        )),
      ),
    );
  }
}