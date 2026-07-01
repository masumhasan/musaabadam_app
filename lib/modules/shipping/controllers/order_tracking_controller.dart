import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_order_service.dart';
import 'package:musaab_adam/core/services/api_review_service.dart';
import 'package:musaab_adam/core/services/api_shipping_service.dart';
import 'package:musaab_adam/data/models/order/order_model.dart';

class OrderTrackingController extends GetxController {
  final Rx<OrderModel?> order = Rx(null);
  final RxList<Map<String, dynamic>> events = <Map<String, dynamic>>[].obs;
  final RxString trackingNumber = ''.obs;
  final RxString carrier = ''.obs;

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxBool isConfirming = false.obs;
  final RxBool reviewSubmitted = false.obs;

  late final String orderId;

  @override
  void onInit() {
    super.onInit();
    orderId = Get.arguments as String;
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final results = await Future.wait([
        ApiOrderService.instance.getOrder(orderId),
        ApiShippingService.instance.track(orderId),
      ]);
      order.value = results[0] as OrderModel;
      final tracking = results[1] as Map<String, dynamic>;
      trackingNumber.value = tracking['trackingNumber']?.toString() ?? '';
      carrier.value = tracking['carrier']?.toString() ?? '';
      events.assignAll(
        (tracking['events'] as List? ?? []).map((e) => Map<String, dynamic>.from(e as Map)).toList(),
      );
    } on DioException {
      hasError.value = true;
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  /// Submit a rating + comment review for this (delivered/completed) order.
  Future<void> submitReview(int rating, String comment) async {
    try {
      await ApiReviewService.instance.submitReview(orderId: orderId, rating: rating, comment: comment);
      reviewSubmitted.value = true;
      Get.back();
      Get.snackbar('Thanks!', 'Your review was submitted.', snackPosition: SnackPosition.BOTTOM);
    } on DioException catch (e) {
      Get.snackbar('Review', ApiReviewService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// Buyer confirms receipt → order becomes `completed`.
  Future<void> confirmReceipt() async {
    if (isConfirming.value) return;
    isConfirming.value = true;
    try {
      final updated = await ApiOrderService.instance.completeOrder(orderId);
      order.value = updated;
      await load();
      Get.snackbar('Thank you!', 'Order marked as completed.', snackPosition: SnackPosition.BOTTOM);
    } on DioException catch (e) {
      Get.snackbar('Error', ApiOrderService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isConfirming.value = false;
    }
  }
}
