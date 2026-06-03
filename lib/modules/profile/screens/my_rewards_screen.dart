import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import '../../../core/assets_gen/assets.gen.dart';
import '../../../core/widgets/image_widget.dart';

class MyRewardsScreen extends StatelessWidget {
  const MyRewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        title: CustomText(text: AppStrings.myRewards, fontSize: 18, fontWeight: FontWeight.w700),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:[
          SizedBox(height: 40.h),
          Center(child: ImageWidget(width: 183, height: 153, imagePath: Assets.images.giftBox.keyName)),
          SizedBox(height: 30.h),
          CustomText(text: AppStrings.theresNothingHereAtTheMoment)
        ],
      ),
    );
  }
}