import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_user_service.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';

class PreferencesController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();

  final RxnString selectedCountry = RxnString();
  final RxBool directMessages = true.obs;
  final RxBool showSensitiveContent = false.obs;
  final RxBool enablePrivateEntry = false.obs;
  final RxBool contentBoost = true.obs;
  final RxBool realtimeTool = true.obs;
  final RxBool rewardsStatus = true.obs;
  final RxBool pastShows = true.obs;
  final RxBool activityStatus = true.obs;
  final RxBool suggestAccount = true.obs;
  final RxBool syncContacts = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadPreferences();
  }

  void _loadPreferences() {
    final user = _authController.currentUser.value;
    if (user != null) {
      final prefs = user.appPreferences;
      selectedCountry.value = prefs.country;
      directMessages.value = prefs.directMessages;
      showSensitiveContent.value = prefs.showSensitiveContent;
      enablePrivateEntry.value = prefs.enablePrivateEntry;
      contentBoost.value = prefs.contentCommunityBoost;
      realtimeTool.value = prefs.showRealtimePromoteTool;
      rewardsStatus.value = prefs.displayRewardsClubStatus;
      pastShows.value = prefs.yourPastShows;
      activityStatus.value = prefs.activityStatus;
      suggestAccount.value = prefs.suggestAccountToOthers;
      syncContacts.value = prefs.syncContacts;
    }
  }

  Future<void> updatePreference(String key, dynamic value) async {
    try {
      await ApiUserService.instance.updateAppPreferences({key: value});
      // Optionally reload user profile here if needed:
      // await _authController.loadUser();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update preference: $key');
      // Revert the UI state if needed, or simply log it
    }
  }

  void onCountryChanged(String? val) {
    if (val != null) {
      selectedCountry.value = val;
      updatePreference('country', val);
    }
  }

  void onDirectMessagesChanged(bool val) {
    directMessages.value = val;
    updatePreference('directMessages', val);
  }

  void onShowSensitiveContentChanged(bool val) {
    showSensitiveContent.value = val;
    updatePreference('showSensitiveContent', val);
  }

  void onEnablePrivateEntryChanged(bool val) {
    enablePrivateEntry.value = val;
    updatePreference('enablePrivateEntry', val);
  }

  void onContentBoostChanged(bool val) {
    contentBoost.value = val;
    updatePreference('contentCommunityBoost', val);
  }

  void onRealtimeToolChanged(bool val) {
    realtimeTool.value = val;
    updatePreference('showRealtimePromoteTool', val);
  }

  void onRewardsStatusChanged(bool val) {
    rewardsStatus.value = val;
    updatePreference('displayRewardsClubStatus', val);
  }

  void onPastShowsChanged(bool val) {
    pastShows.value = val;
    updatePreference('yourPastShows', val);
  }

  void onActivityStatusChanged(bool val) {
    activityStatus.value = val;
    updatePreference('activityStatus', val);
  }

  void onSuggestAccountChanged(bool val) {
    suggestAccount.value = val;
    updatePreference('suggestAccountToOthers', val);
  }

  void onSyncContactsChanged(bool val) {
    syncContacts.value = val;
    updatePreference('syncContacts', val);
  }
}
