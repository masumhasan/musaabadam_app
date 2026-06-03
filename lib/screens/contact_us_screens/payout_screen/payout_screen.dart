import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/assets_gen/assets.gen.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/tile_button.dart';

class PayoutScreen extends StatelessWidget {
  const PayoutScreen({super.key});

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
            TileButton(title: AppStrings.addNewPayoutMethod, svgIconPath: Assets.icons.newPayment, isIconDefault: false),
            TileButton(title: AppStrings.earlyPayoutAccess, svgIconPath: Assets.icons.earlyPayout, isIconDefault: false),
            TileButton(title: AppStrings.feeInquiries, svgIconPath: Assets.icons.feeInquiry, isIconDefault: false),
            TileButton(title: AppStrings.incorrectBalance, svgIconPath: Assets.icons.insufficientBalance, isIconDefault: false),
            TileButton(title: AppStrings.stripeCashOutError, svgIconPath: Assets.icons.stripe, isIconDefault: false),
          ],
        ),
      ),
    );
  }
}