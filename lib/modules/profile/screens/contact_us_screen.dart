import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/tile_button.dart';
import '../../../core/assets_gen/assets.gen.dart';

class ContactUsScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final RxBool isAccountExpanded = false.obs;
  final RxBool isGeneralExpanded = false.obs;

  ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: CustomText(
          text: AppStrings.contactUs,
          fontSize: 18,
          fontWeight: FontWeight.w900,
        ),
        centerTitle: true,
        leading: BackButton(color: colorScheme.onSurface),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            spacing: 10.h,
            children:[
              if (authController.isSeller.value)
                TileButton(
                  title: AppStrings.payouts,
                  svgIconPath: Assets.icons.payouts,
                  isIconDefault: false,
                  onClick: () => Get.toNamed(AppRoutes.payoutScreen),
                ),
              _buildExpandableSection(
                context,
                title: AppStrings.account,
                isExpanded: isAccountExpanded,
                children:[
                  _tileButtonWithNavigator(AppStrings.accountDeletion, Icons.no_accounts_outlined),
                  _tileButtonWithNavigator(AppStrings.banningOrBanned, Icons.block_flipped),
                  _tileButtonWithNavigator(AppStrings.duplicateAccount, Icons.control_point_duplicate),
                  _tileButtonWithNavigator(AppStrings.orderHistoryRequest, Icons.history),
                  _tileButtonWithNavigator(AppStrings.referralCreditInquiries, Icons.credit_card),
                  _tileButtonWithNavigator(AppStrings.updateAccountInformation, Icons.lightbulb_outline),
                ],
              ),
              _buildExpandableSection(
                context,
                title: AppStrings.general,
                isExpanded: isGeneralExpanded,
                children:[
                  _tileButtonWithNavigator(AppStrings.addNewPayoutMethod, null, Assets.icons.newPayment, false),
                  _tileButtonWithNavigator(AppStrings.earlyPayoutAccess, null, Assets.icons.earlyPayout, false),
                  _tileButtonWithNavigator(AppStrings.feeInquiries, null, Assets.icons.feeInquiry, false),
                  _tileButtonWithNavigator(AppStrings.incorrectBalance, null, Assets.icons.insufficientBalance, false),
                  _tileButtonWithNavigator(AppStrings.stripeCashOutError, null, Assets.icons.stripe, false),
                ],
              ),
              SizedBox(height: 30.h)
            ],
          ),
        ),
      ),
    );
  }

  Widget _tileButtonWithNavigator(String title,[IconData? icon, String? svg, bool isDefault = true]) {
    return TileButton(
      title: title,
      defaultIcon: icon,
      svgIconPath: svg,
      isIconDefault: isDefault,
      onClick: () => Get.toNamed(AppRoutes.orderSupportScreen, arguments: title),
    );
  }

  Widget _buildExpandableSection(BuildContext context, {
    required String title,
    required RxBool isExpanded,
    required List<Widget> children
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Obx(() => Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: CustomText(text: title, fontWeight: FontWeight.w600),
        tilePadding: EdgeInsets.zero,
        initiallyExpanded: isExpanded.value,
        onExpansionChanged: (val) => isExpanded.value = val,
        trailing: Icon(
          isExpanded.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          color: colorScheme.onSurface,
        ),
        children: children.map((child) => Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: child,
        )).toList(),
      ),
    ));
  }
}