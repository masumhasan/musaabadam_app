import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/modules/activity/components/challenges_tab.dart';
import 'package:musaab_adam/modules/activity/components/coupon_tab.dart';
import 'package:musaab_adam/modules/activity/components/gem_store_tab.dart';
import 'package:musaab_adam/modules/activity/components/referral_tab.dart';
import '../../../core/widgets/text_button_widget.dart';

class RewardsPerksScreen extends StatelessWidget {
  RewardsPerksScreen({super.key});

  final RxInt selectedTabIndex = 0.obs;
  final List<String> tabs = [
    AppStrings.referrals,
    "Challenges",
    "Gem Store",
    "Coupons"
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: Text(
          'Earn Rewards & Unlock Perks',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        elevation: 0,
        backgroundColor: colorScheme.surface,
      ),
      body: Column(
        children: [
          // ── Custom Tab Bar ──────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(tabs.length, (index) {
                return Obx(() {
                  final isSelected = selectedTabIndex.value == index;
                  return TextButtonWidget(
                    text: tabs[index].tr,
                    textColor: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 14.sp,
                    decoration: isSelected ? TextDecoration.underline : null,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    onPressed: () => selectedTabIndex.value = index,
                  );
                });
              }),
            ),
          ),

          // ── Tab Content ─────────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              switch (selectedTabIndex.value) {
                case 0: return const ReferralTab();
                case 1: return const ChallengesTab();
                case 2: return const GemStoreTab();
                case 3: return const CouponTab();
                default: return const SizedBox.shrink();
              }
            }),
          ),
        ],
      ),
    );
  }
}