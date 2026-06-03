import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../modules/auth/controllers/auth_controller.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/tile_button.dart';

class GeneralIssuesScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  GeneralIssuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: CustomText(text: AppStrings.contactUs),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: colorScheme.onSurface),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          spacing: 10.h,
          children:[
            TileButton(title: AppStrings.appFeaturesOrFeedback, defaultIcon: Icons.feedback_outlined),
            TileButton(title: AppStrings.featureRequest, defaultIcon: Icons.app_shortcut_sharp),
            TileButton(title: AppStrings.legalAndSafety, defaultIcon: Icons.health_and_safety),
            TileButton(title: AppStrings.policies, defaultIcon: Icons.policy_outlined),
            TileButton(title: AppStrings.referralCredits, defaultIcon: Icons.credit_score_outlined),
            TileButton(title: AppStrings.reportAUser, defaultIcon: Icons.report),
            // SELLER SPECIFIC OPTIONS
            Obx(() => authController.isSeller.value
                ? Column(
              spacing: 10.h,
              children:[
                TileButton(title: AppStrings.liveRecordingRequest, defaultIcon: Icons.live_tv),
                TileButton(title: AppStrings.salesDataRequest, defaultIcon: Icons.add_shopping_cart_rounded),
                TileButton(title: AppStrings.showSchedulingHelp, defaultIcon: Icons.schedule),
                TileButton(title: AppStrings.marketingAndPromotions, defaultIcon: Icons.reviews),
                TileButton(title: AppStrings.appealAReview, defaultIcon: Icons.reviews),
              ],
            )
                : const SizedBox.shrink()),
          ],
        ),
      ),
    );
  }
}