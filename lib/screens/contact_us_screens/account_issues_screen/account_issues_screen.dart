import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_strings.dart';
import '../../../core/widgets/custom_text.dart';
import '../../../core/widgets/tile_button.dart';

class AccountIssuesScreen extends StatelessWidget {
  const AccountIssuesScreen({super.key});

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
            TileButton(title: AppStrings.accountDeletion, defaultIcon: Icons.person_remove_alt_1_outlined),
            TileButton(title: AppStrings.banningOrBanned, defaultIcon: Icons.block),
            TileButton(title: AppStrings.duplicateAccount, defaultIcon: Icons.switch_account_outlined),
            TileButton(title: AppStrings.orderHistoryRequest, defaultIcon: Icons.history_outlined),
            TileButton(title: AppStrings.referralCreditInquiries, defaultIcon: Icons.credit_score_outlined),
            TileButton(title: AppStrings.updateAccountInformation, defaultIcon: Icons.tips_and_updates_outlined),
          ],
        ),
      ),
    );
  }
}