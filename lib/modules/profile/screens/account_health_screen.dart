import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';

class AccountHealthScreen extends StatelessWidget {
  const AccountHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = Get.find<AuthController>().currentUser.value;
    final health = user?.accountHealth ?? 'Action Required';

    double gaugeValue = 2.0;
    Color healthColor = Colors.red;

    if (health == 'Excellent') {
      gaugeValue = 9.0;
      healthColor = const Color(0xFF10B981);
    } else if (health == 'Good') {
      gaugeValue = 7.0;
      healthColor = Colors.teal;
    } else if (health == 'Average') {
      gaugeValue = 4.5;
      healthColor = Colors.amber;
    } else {
      // Action Required
      gaugeValue = 2.0;
      healthColor = Colors.red;
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: CustomText(text: AppStrings.accountHealth, fontSize: 18, fontWeight: FontWeight.w700),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colorScheme.onSurface),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          spacing: 20.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: AppStrings.policyStanding, fontWeight: FontWeight.w600),
            CustomText(
              text: 'Our policy is to ensure transparency, safety, and compliance. Your account health directly reflects your document status and community standing.',
              textAlignment: TextAlign.start,
              fontSize: 14.sp,
              fontColor: colorScheme.outline,
            ),
            Center(
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 80.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          text: health,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          fontColor: healthColor,
                        ),
                        SizedBox(height: 4.h),
                        CustomText(
                          text: _getHealthDescription(health),
                          fontSize: 12.sp,
                          fontColor: colorScheme.outline,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 200.h,
                    width: 200.w,
                    child: PieChart(
                      PieChartData(
                        startDegreeOffset: 90,
                        sectionsSpace: 0,
                        centerSpaceRadius: 70.r,
                        sections: [
                          PieChartSectionData(
                            value: 10,
                            radius: 12.r,
                            color: Colors.transparent,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: gaugeValue,
                            radius: 12.r,
                            color: healthColor,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            value: 10 - gaugeValue,
                            radius: 12.r,
                            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                            showTitle: false,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getHealthDescription(String health) {
    switch (health) {
      case 'Excellent':
        return 'Fully verified with clean history';
      case 'Good':
        return 'Verified with minor warnings';
      case 'Average':
        return 'KYC verification under review';
      default:
        return 'KYC required or account restricted';
    }
  }
}