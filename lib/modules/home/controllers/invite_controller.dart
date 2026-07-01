import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:musaab_adam/core/services/api_auth_service.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';

class InviteController extends GetxController {
  final RxString referralCode = ''.obs;
  final RxInt credit = 0.obs;
  final RxInt complete = 0.obs;
  final RxInt pending = 0.obs;

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final info = await ApiAuthService.instance.getReferralInfo();
      referralCode.value = info.referralCode;
      credit.value = info.credit;
      complete.value = info.complete;
      pending.value = info.pending;
    } on DioException {
      hasError.value = true;
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  String get shareMessage =>
      'Join me on BidsRush! Use my referral code ${referralCode.value} when you sign up.';

  void copyCode() {
    if (referralCode.value.isEmpty) return;
    Clipboard.setData(ClipboardData(text: referralCode.value));
    Get.snackbar(AppStrings.copied, AppStrings.referralCodeCopied, snackPosition: SnackPosition.BOTTOM);
  }

  Future<void> shareCode() async {
    if (referralCode.value.isEmpty) return;
    await SharePlus.instance.share(ShareParams(text: shareMessage));
  }
}
