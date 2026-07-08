import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_order_service.dart';
import 'package:musaab_adam/core/services/api_payment_service.dart';
import 'package:musaab_adam/core/services/api_user_service.dart';
import 'package:musaab_adam/core/services/api_reward_service.dart';
import 'package:musaab_adam/data/models/address/address_model.dart';
import 'package:musaab_adam/data/models/order/order_model.dart';
import 'package:musaab_adam/data/models/payment/payment_method_model.dart';
import 'package:musaab_adam/routes/app_pages.dart';

class CheckoutController extends GetxController {
  final Rx<OrderModel?> order = Rx(null);
  final RxList<PaymentMethodModel> methods = <PaymentMethodModel>[].obs;
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final Rxn<String> selectedMethodId = Rxn<String>();
  final Rxn<String> selectedAddressId = Rxn<String>();

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxBool isPaying = false.obs;

  final RxList<Map<String, dynamic>> coupons = <Map<String, dynamic>>[].obs;
  final Rxn<Map<String, dynamic>> selectedCoupon = Rxn<Map<String, dynamic>>();

  late final String orderId;

  @override
  void onInit() {
    super.onInit();
    orderId = Get.arguments as String;
    _load();
  }

  Future<void> _load() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final results = await Future.wait([
        ApiOrderService.instance.getOrder(orderId),
        ApiPaymentService.instance.listMethods(),
        ApiUserService.instance.getAddresses(),
        ApiRewardService.instance.getMyRewards(),
      ]);
      order.value = results[0] as OrderModel;
      methods.assignAll(results[1] as List<PaymentMethodModel>);
      addresses.assignAll(results[2] as List<AddressModel>);
      coupons.assignAll(results[3] as List<Map<String, dynamic>>);

      final def = methods.firstWhereOrNull((m) => m.isDefault) ??
          (methods.isNotEmpty ? methods.first : null);
      selectedMethodId.value = def?.id;

      // Auto-apply the default address so tax/shipping compute up front.
      final defAddr = addresses.firstWhereOrNull((a) => a.isDefault) ??
          (addresses.isNotEmpty ? addresses.first : null);
      if (defAddr != null) await selectAddress(defAddr);
    } on DioException {
      hasError.value = true;
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void selectMethod(String id) => selectedMethodId.value = id;

  /// Applies an address to the order → recomputes shipping + tax on the server.
  Future<void> selectAddress(AddressModel a) async {
    selectedAddressId.value = a.id;
    try {
      final updated = await ApiOrderService.instance.setAddress(orderId, {
        'fullName': a.fullName,
        'line1': a.line1,
        'line2': a.line2,
        'city': a.city,
        'state': a.state,
        'postalCode': a.postalCode,
        'country': a.country,
        'phone': a.phone,
      });
      order.value = updated;
    } on DioException catch (e) {
      Get.snackbar('Address', ApiPaymentService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> addCardQuick() async {
    // Adds a default test card via the provider, then refreshes the list.
    try {
      final added = await ApiPaymentService.instance.addMethod(
        card: {'number': '4242424242424242', 'brand': 'visa', 'expMonth': 12, 'expYear': 2030},
        makeDefault: methods.isEmpty,
      );
      methods.add(added);
      selectedMethodId.value = added.id;
    } on DioException catch (e) {
      Get.snackbar('Error', ApiPaymentService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> pay() async {
    if (isPaying.value) return;
    if (selectedMethodId.value == null) {
      Get.snackbar('Payment method', 'Please add or select a payment method.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isPaying.value = true;
    try {
      await ApiPaymentService.instance.startCheckout(
        orderId,
        paymentMethodId: selectedMethodId.value,
        couponId: selectedCoupon.value?['_id']?.toString(),
      );
      final result = await ApiPaymentService.instance.confirmPayment(orderId, paymentMethodId: selectedMethodId.value);

      if (result['order'] != null) {
        order.value = OrderModel.fromJson(Map<String, dynamic>.from(result['order'] as Map));
      }

      Get.snackbar('Payment complete', 'Your order is confirmed and held in escrow until delivery.',
          snackPosition: SnackPosition.BOTTOM);
      Get.offNamedUntil(AppRoutes.orderTrackingScreen, (route) => route.isFirst, arguments: orderId);
    } on DioException catch (e) {
      Get.snackbar('Payment failed', ApiPaymentService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isPaying.value = false;
    }
  }
}
