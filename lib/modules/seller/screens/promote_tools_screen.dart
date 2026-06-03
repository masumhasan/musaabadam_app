import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';

import '../../../core/widgets/sized_box_widget.dart';
import '../../../core/widgets/text_button_widget.dart';
import '../../../core/widgets/tile_button.dart';

class PromoteToolsScreen extends StatelessWidget {
  PromoteToolsScreen({super.key});

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
          text: AppStrings.promoteTools,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          fontColor: colorScheme.onSurface,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            // 1. Tabs Row
            Row(
              spacing: 20.w,
              children:[
                _buildTab(AppStrings.overview, 0, colorScheme),
                _buildTab(AppStrings.promotedShows, 1, colorScheme),
              ],
            ),
            SizedBoxWidget(height: 25),

            // 2. Main Title
            CustomText(
              text: AppStrings.promoteTools,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontColor: colorScheme.onSurface,
            ),
            SizedBoxWidget(height: 15),

            // 3. Action Tiles
            TileButton(
              title: AppStrings.learnToPromote,
              defaultIcon: Icons.lightbulb_outline,
              onClick: () {
                // Add navigation
              },
            ),
            SizedBoxWidget(height: 10),
            TileButton(
              title: AppStrings.readyToPromote,
              defaultIcon: Icons.lightbulb_outline,
              onClick: () {
                // Add navigation
              },
            ),
          ],
        ),
      ),
    );
  }

  // Tab builder helper
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