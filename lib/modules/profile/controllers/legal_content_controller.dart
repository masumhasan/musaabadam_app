import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_settings_service.dart';

class LegalContentController extends GetxController {
  final RxString content = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;

  // Determined from Get.arguments (the title string passed by the navigation call)
  late final String _type;

  @override
  void onInit() {
    super.onInit();
    final title = (Get.arguments as String?) ?? '';
    _type = title.toLowerCase().contains('terms') ? 'terms' : 'privacy';
    _fetchContent();
  }

  Future<void> retry() => _fetchContent();

  Future<void> _fetchContent() async {
    hasError.value = false;
    isLoading.value = true;
    try {
      final result = _type == 'terms'
          ? await ApiSettingsService.instance.getTerms()
          : await ApiSettingsService.instance.getPrivacyPolicy();
      content.value = result;
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
