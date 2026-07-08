import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musaab_adam/core/services/api_reward_service.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import '../../../core/assets_gen/assets.gen.dart';
import '../../../core/widgets/image_widget.dart';

class MyRewardsScreen extends StatefulWidget {
  const MyRewardsScreen({super.key});

  @override
  State<MyRewardsScreen> createState() => _MyRewardsScreenState();
}

class _MyRewardsScreenState extends State<MyRewardsScreen> {
  final ApiRewardService _rewardService = ApiRewardService.instance;
  List<Map<String, dynamic>> _coupons = [];
  bool _isLoading = true;

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
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(text: AppStrings.myRewards, fontSize: 18, fontWeight: FontWeight.w700),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _coupons.isEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 40.h),
                    Center(child: ImageWidget(width: 183, height: 153, imagePath: Assets.images.giftBox.keyName)),
                    SizedBox(height: 30.h),
                    CustomText(text: AppStrings.theresNothingHereAtTheMoment)
                  ],
                )
              : RefreshIndicator(
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
                ),
    );
  }
}