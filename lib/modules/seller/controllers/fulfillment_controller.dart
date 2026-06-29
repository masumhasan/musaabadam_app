import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_order_service.dart';
import 'package:musaab_adam/core/services/api_shipping_service.dart';
import 'package:musaab_adam/data/models/order/order_model.dart';

enum FulfillmentFilter { none, needLabel, readyToShip, unfulfilled }

class FulfillmentController extends GetxController {
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final Rx<FulfillmentFilter> filter = FulfillmentFilter.none.obs;

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxnString busyOrderId = RxnString();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final result = await ApiOrderService.instance.getSellerOrders();
      orders.assignAll(result);
    } on DioException {
      hasError.value = true;
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  bool _needsLabel(OrderModel o) =>
      o.isPaid && o.trackingNumber == null && !['delivered', 'cancelled', 'refunded'].contains(o.status);

  bool _unfulfilled(OrderModel o) => !['delivered', 'cancelled', 'refunded'].contains(o.status);

  List<OrderModel> get filtered {
    switch (filter.value) {
      case FulfillmentFilter.needLabel:
      case FulfillmentFilter.readyToShip:
        return orders.where(_needsLabel).toList();
      case FulfillmentFilter.unfulfilled:
        return orders.where(_unfulfilled).toList();
      case FulfillmentFilter.none:
        return orders.where(_unfulfilled).toList();
    }
  }

  int get shipmentCount => orders.where(_unfulfilled).length;

  /// Generates a shipping label (advances the order to "shipped").
  Future<void> generateLabel(OrderModel order) async {
    if (busyOrderId.value != null) return;
    busyOrderId.value = order.id;
    try {
      await ApiShippingService.instance.generateLabel(order.id);
      await load();
      Get.snackbar('Label created', 'The order has been marked as shipped.',
          snackPosition: SnackPosition.BOTTOM);
    } on DioException catch (e) {
      Get.snackbar('Error', ApiShippingService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      busyOrderId.value = null;
    }
  }

  /// Marks a shipped order as delivered (releases escrow to the seller).
  Future<void> markDelivered(OrderModel order) async {
    if (busyOrderId.value != null) return;
    busyOrderId.value = order.id;
    try {
      await ApiOrderService.instance.updateStatus(order.id, 'delivered');
      await load();
      Get.snackbar('Delivered', 'Funds will be released from escrow to your balance.',
          snackPosition: SnackPosition.BOTTOM);
    } on DioException catch (e) {
      Get.snackbar('Error', ApiOrderService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      busyOrderId.value = null;
    }
  }
}
