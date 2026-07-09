import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';
import 'package:musaab_adam/modules/profile/controllers/preferences_controller.dart';

class PreferencesScreen extends StatelessWidget {
  PreferencesScreen({super.key});

  final PreferencesController controller = Get.put(PreferencesController());

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: BackButton(color: colorScheme.onSurface),
        title: CustomText(text: "Preferences", fontWeight: FontWeight.bold, fontSize: 18),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children:[
            SizedBoxWidget(height: 10),
            // Country Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.primary),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: Obx(() => DropdownButton<String>(
                  value: controller.selectedCountry.value,
                  dropdownColor: colorScheme.surface,
                  isExpanded: true,
                  hint: CustomText(text: "Select Country", fontColor: colorScheme.outline),
                  items:["USA", "UK", "CANADA", "GERMANY", "FRANCE", "NETHERLANDS"]
                      .map((e) => DropdownMenuItem(value: e, child: CustomText(text: e)))
                      .toList(),
                  onChanged: controller.onCountryChanged,
                )),
              ),
            ),
            SizedBoxWidget(height: 20),
            _switchTile(AppStrings.directMessages, controller.directMessages, controller.onDirectMessagesChanged),
            _switchTile(AppStrings.showSensitiveContent, controller.showSensitiveContent, controller.onShowSensitiveContentChanged),
            _switchTile(AppStrings.enablePrivateEntry, controller.enablePrivateEntry, controller.onEnablePrivateEntryChanged),
            _switchTile(AppStrings.contentCommunityBoost, controller.contentBoost, controller.onContentBoostChanged),
            _switchTile(AppStrings.showRealtimePromoteTool, controller.realtimeTool, controller.onRealtimeToolChanged),
            _switchTile(AppStrings.displayRewardsClubStatus, controller.rewardsStatus, controller.onRewardsStatusChanged),
            _switchTile(AppStrings.yourPastShows, controller.pastShows, controller.onPastShowsChanged),
            _switchTile(AppStrings.activityStatus, controller.activityStatus, controller.onActivityStatusChanged),
            _switchTile(AppStrings.syncContacts, controller.syncContacts, controller.onSyncContactsChanged),
            _switchTile(AppStrings.suggestAccountToOthers, controller.suggestAccount, controller.onSuggestAccountChanged),
            SizedBoxWidget(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _switchTile(String title, RxBool state, Function(bool) onChanged) {
    return Builder(builder: (context) {
      final colorScheme = Theme.of(context).colorScheme;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Expanded(child: CustomText(text: title, textAlignment: TextAlign.left, fontWeight: FontWeight.w700)),
            Obx(() => Switch(
              value: state.value,
              activeTrackColor: colorScheme.primary,
              activeThumbColor: colorScheme.surface,
              inactiveTrackColor: colorScheme.outline.withValues(alpha: 0.3),
              onChanged: onChanged,
            )),
          ],
        ),
      );
    });
  }
}