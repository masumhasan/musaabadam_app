import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_settings_service.dart';

class FaqController extends GetxController {
  final String type;
  FaqController({required this.type});

  final RxList<Map<String, String>> faqs = <Map<String, String>>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFaqs();
  }

  Future<void> loadFaqs() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final list = await ApiSettingsService.instance.getFaqs(type);
      if (list.isEmpty) {
        // If server returns empty list, use local fallback so screen is populated
        faqs.assignAll(_fallbackFaqs());
      } else {
        faqs.assignAll(list);
      }
    } catch (_) {
      hasError.value = true;
      faqs.assignAll(_fallbackFaqs());
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, String>> _fallbackFaqs() {
    if (type == 'seller') {
      return [
        {
          'question': 'How do I unlock my seller access?',
          'answer': 'To unlock seller access, complete your profile verification under verify account.',
        },
        {
          'question': 'Can I have a second selling account?',
          'answer': 'Currently, we only allow one seller account per person to prevent identity duplicate check issues.',
        },
        {
          'question': 'When can I schedule a show?',
          'answer': 'Once your application is approved, you can schedule and start live auction shows immediately.',
        },
      ];
    } else {
      return [
        {
          'question': 'How do I buy an item?',
          'answer': 'You can browse live shows or categories and bid or purchase directly from the catalog.',
        },
        {
          'question': 'What payment methods are supported?',
          'answer': 'We support Visa, Mastercard, AMEX, Discover, and dynamic credit/debit card checkout.',
        },
        {
          'question': 'How does shipping work?',
          'answer': 'Sellers ship directly to buyers, and shipping rates are estimated dynamically at checkout.',
        },
      ];
    }
  }
}

class SellerFaqController extends FaqController {
  SellerFaqController() : super(type: 'seller');
}

class GlobalFaqController extends FaqController {
  GlobalFaqController() : super(type: 'global');
}
