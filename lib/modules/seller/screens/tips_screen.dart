import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/sized_box_widget.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  final List<Map<String, String>> sellerTips = const [
    {
      'title': '📅 Schedule Shows Early',
      'desc': 'Schedule your live streams at least 24 to 48 hours in advance. This gives followers ample time to receive notifications and set reminders.',
    },
    {
      'title': '💡 Lighting & Visuals',
      'desc': 'Ensure your items are well-lit and held close to the camera. Buyers want to see fine details, texture, and the exact condition of the product.',
    },
    {
      'title': '⚡ Fast Fulfillment',
      'desc': 'Ship orders within 1 to 2 business days. Fast shipping results in premium ratings, boosts repeat buyers, and elevates your rank in search feeds.',
    },
    {
      'title': '🎁 Grow With Giveaways',
      'desc': 'Host low-cost item giveaways during quiet moments of your stream. This instantly draws in new viewers and keeps chat activity high.',
    },
    {
      'title': '💬 Interactive Chatting',
      'desc': 'Address your chat members by name! Answering questions in real-time builds trust and turns casual viewers into loyal buyers.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: AppStrings.tips,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        itemCount: sellerTips.length,
        separatorBuilder: (_, __) => SizedBoxWidget(height: 12.h),
        itemBuilder: (context, index) {
          final tip = sellerTips[index];
          return Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
              side: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            color: colorScheme.surfaceContainerLow,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: tip['title']!,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontColor: colorScheme.onSurface,
                    textAlignment: TextAlign.start,
                  ),
                  SizedBoxWidget(height: 8.h),
                  CustomText(
                    text: tip['desc']!,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontColor: colorScheme.onSurfaceVariant,
                    textAlignment: TextAlign.start,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
