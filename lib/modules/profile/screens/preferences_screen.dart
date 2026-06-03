import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/core/widgets/sized_box_widget.dart';

class PreferencesScreen extends StatelessWidget {
  PreferencesScreen({super.key});

  final RxnString selectedCountry = RxnString();
  final RxBool directMessages = false.obs;
  final RxBool showSensitiveContent = false.obs;
  final RxBool enablePrivateEntry = false.obs;
  final RxBool contentBoost = false.obs;
  final RxBool realtimeTool = false.obs;
  final RxBool rewardsStatus = false.obs;
  final RxBool pastShows = false.obs;
  final RxBool activityStatus = false.obs;
  final RxBool syncContacts = false.obs;
  final RxBool suggestAccount = false.obs;

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
                  value: selectedCountry.value,
                  dropdownColor: colorScheme.surface,
                  isExpanded: true,
                  hint: CustomText(text: "Select Country", fontColor: colorScheme.outline),
                  items:["USA", "UK", "CANADA", "GERMANY", "FRANCE", "NETHERLANDS"]
                      .map((e) => DropdownMenuItem(value: e, child: CustomText(text: e)))
                      .toList(),
                  onChanged: (value) => selectedCountry.value = value,
                )),
              ),
            ),
            SizedBoxWidget(height: 20),
            _switchTile(AppStrings.directMessages, directMessages),
            _switchTile(AppStrings.showSensitiveContent, showSensitiveContent),
            _switchTile(AppStrings.enablePrivateEntry, enablePrivateEntry),
            _switchTile(AppStrings.contentCommunityBoost, contentBoost),
            _switchTile(AppStrings.showRealtimePromoteTool, realtimeTool),
            _switchTile(AppStrings.displayRewardsClubStatus, rewardsStatus),
            _switchTile(AppStrings.yourPastShows, pastShows),
            _switchTile(AppStrings.activityStatus, activityStatus),
            _switchTile(AppStrings.syncContacts, syncContacts),
            _switchTile(AppStrings.suggestAccountToOthers, suggestAccount),
            SizedBoxWidget(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _switchTile(String title, RxBool state) {
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
              onChanged: (v) => state.value = v,
            )),
          ],
        ),
      );
    });
  }
}