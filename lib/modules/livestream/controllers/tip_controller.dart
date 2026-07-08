import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_payment_service.dart';
import 'package:musaab_adam/core/services/api_tip_service.dart';
import 'package:musaab_adam/data/models/payment/payment_method_model.dart';

class TipController extends GetxController {
  final RxDouble selectedAmount = 10.0.obs;
  final RxString messageNote = ''.obs;
  final RxBool isNoteEnabled = false.obs;

  final RxBool isLoading = false.obs;
  final RxList<PaymentMethodModel> cards = <PaymentMethodModel>[].obs;
  final Rxn<String> selectedCardId = Rxn<String>();

  late String sellerId;
  String? streamId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    sellerId = args['sellerId']?.toString() ?? '';
    streamId = args['streamId']?.toString();
    _loadCards();
  }

  Future<void> _loadCards() async {
    isLoading.value = true;
    try {
      final list = await ApiPaymentService.instance.listMethods();
      cards.assignAll(list);
      final def = cards.firstWhereOrNull((c) => c.isDefault) ?? (cards.isNotEmpty ? cards.first : null);
      selectedCardId.value = def?.id;
    } catch (_) {}
    isLoading.value = false;
  }

  void selectAmount(double val) => selectedAmount.value = val;

  Future<bool> sendTip() async {
    if (selectedCardId.value == null) {
      Get.snackbar('Payment Card', 'Please add or select a card payment method.');
      return false;
    }
    isLoading.value = true;
    final result = await ApiTipService.instance.sendTip(
      sellerId: sellerId,
      streamId: streamId,
      amount: selectedAmount.value,
      paymentMethodId: selectedCardId.value!,
      message: isNoteEnabled.value ? messageNote.value : null,
    );
    isLoading.value = false;

    if (result != null) {
      Get.back(); // Close tip amount screen
      Get.back(); // Close send tip screen
      Get.snackbar('Thank You!', 'Your tip was sent successfully! 🎉');
      return true;
    } else {
      Get.snackbar('Tipping Failed', 'Could not complete the tip transaction.');
      return false;
    }
  }

  Future<void> addCardQuick() async {
    try {
      final added = await ApiPaymentService.instance.addMethod(
        card: {'number': '4242424242424242', 'brand': 'visa', 'expMonth': 12, 'expYear': 2030},
        makeDefault: cards.isEmpty,
      );
      cards.add(added);
      selectedCardId.value = added.id;
    } catch (_) {}
  }
}
