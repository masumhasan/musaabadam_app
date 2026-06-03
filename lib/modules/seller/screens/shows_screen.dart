import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/routes/app_pages.dart';

import '../../../core/assets_gen/assets.gen.dart';
import '../../../core/widgets/sized_box_widget.dart';
import '../../../core/widgets/text_button_widget.dart';

class ShowsScreen extends StatelessWidget {
  ShowsScreen({super.key});

  final RxInt selectedTabIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(
          text: AppStrings.shows,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.scheduleLiveShowScreen);
        },
        backgroundColor: colorScheme.primary,
        child: Icon(Icons.add, color: Colors.white, size: 30.sp),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children:[
            // 1. Tabs
            Row(
              spacing: 20.w,
              children:[
                _buildTab(AppStrings.shows, 0, colorScheme),
                _buildTab(AppStrings.pastShows, 1, colorScheme),
              ],
            ),

            // 2. Empty State
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Image.asset(Assets.images.appLogo.keyName, width: 180.w,),
                  SizedBoxWidget(height: 20),
                  CustomText(
                    text: AppStrings.nothingHere,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontColor: colorScheme.onSurface,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String title, int index, ColorScheme colorScheme) {
    return Obx(() {
      final isSelected = selectedTabIndex.value == index;
      return TextButtonWidget(
        text: title,
        textColor: isSelected ? colorScheme.onSurface : colorScheme.outline,
        decoration: isSelected ? TextDecoration.underline : null,
        decorationColor: colorScheme.primary,
        fontWeight: FontWeight.w700,
        fontSize: 16,
        onPressed: () => selectedTabIndex.value = index,
      );
    });
  }
}