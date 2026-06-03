import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';

class AccountHealthScreen extends StatelessWidget {
  const AccountHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
          children:[
            CustomText(text: AppStrings.policyStanding, fontWeight: FontWeight.w600),
            CustomText(text: AppStrings.ourPolicy, textAlignment: TextAlign.start, fontSize: 16),
            Stack(
              alignment: Alignment.topCenter,
              children:[
                Padding(
                  padding: EdgeInsets.only(top: 60.h),
                  child: CustomText(text: "Average", fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 200.h,
                  child: PieChart(
                    PieChartData(
                      sections:[
                        PieChartSectionData(value: 10, radius: 20.r, color: Colors.transparent, showTitle: false),
                        PieChartSectionData(value: 3, radius: 20.r, color: colorScheme.primary, showTitle: false),
                        PieChartSectionData(value: 7, radius: 20.r, color: colorScheme.outline, showTitle: false),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}