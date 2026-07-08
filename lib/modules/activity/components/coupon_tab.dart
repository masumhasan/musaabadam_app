import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musaab_adam/core/services/api_reward_service.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import '../../../core/assets_gen/assets.gen.dart';

class CouponTab extends StatefulWidget {
  const CouponTab({super.key});

  @override
  State<CouponTab> createState() => _CouponTabState();
}

class _CouponTabState extends State<CouponTab> {
  final ApiRewardService _rewardService = ApiRewardService.instance;
  List<Map<String, dynamic>> _coupons = [];
  bool _isLoading = true;

  @override
  void onInit() {
    _loadCoupons();
  }

  @override
  void initState() {
    super.initState();
    _loadCoupons();
  }

  Future<void> _loadCoupons() async {
    setState(() => _isLoading = true);
    final coupons = await _rewardService.getMyRewards();
    setState(() {
      _coupons = coupons;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_coupons.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Assets.images.giftBox.keyName,
                height: 180.h,
              ),
              const SizedBox(height: 30),
              const CustomText(
                text: "You don't have any coupons yet.",
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 12),
              const CustomText(
                text: "Join live shows, visit the Gem Store, or complete challenges to earn more",
                fontSize: 14,
                fontColor: Colors.grey,
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadCoupons,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        itemCount: _coupons.length,
        itemBuilder: (context, index) {
          final coupon = _coupons[index];
          final title = coupon['title'] ?? 'Reward Coupon';
          final code = coupon['code'] ?? '';
          final value = (coupon['discountValue'] as num?)?.toDouble() ?? 0.0;
          final minSpend = (coupon['minOrderValue'] as num?)?.toDouble() ?? 0.0;
          final expiresAt = coupon['expiresAt']?.toString().split('T')[0] ?? '';
          final type = coupon['discountType'] ?? 'fixed';

          final discountText = type == 'fixed' ? '£${value.toStringAsFixed(0)}' : '${value.toStringAsFixed(0)}%';

          return Container(
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: colorScheme.outlineVariant),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Row(
                children: [
                  // Left discount tag
                  Container(
                    width: 90.w,
                    height: 100.h,
                    color: colorScheme.primary,
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: discountText,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          fontColor: Colors.white,
                        ),
                        CustomText(
                          text: 'OFF',
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          fontColor: Colors.white.withValues(alpha: 0.9),
                        ),
                      ],
                    ),
                  ),
                  SizedBoxWidget(width: 14.w),
                  // Coupon details
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: title,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            fontColor: colorScheme.onSurface,
                            textAlignment: TextAlign.start,
                          ),
                          SizedBoxWidget(height: 4.h),
                          CustomText(
                            text: 'Code: $code',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontColor: colorScheme.primary,
                          ),
                          SizedBoxWidget(height: 8.h),
                          CustomText(
                            text: 'Min. spend: £${minSpend.toStringAsFixed(2)}',
                            fontSize: 11,
                            fontColor: colorScheme.onSurfaceVariant,
                          ),
                          CustomText(
                            text: 'Expires: $expiresAt',
                            fontSize: 11,
                            fontColor: colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
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