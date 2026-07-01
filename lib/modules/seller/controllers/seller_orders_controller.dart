import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_order_service.dart';
import 'package:musaab_adam/data/models/order/order_model.dart';

class SellerOrdersController extends GetxController {
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxInt selectedTabIndex = 0.obs;
  final RxString search = ''.obs;

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

  // Tab → backend statuses. 0 All · 1 Created · 2 Processing · 3 Completed
  static const _tabStatuses = <int, List<String>>{
    1: ['pending', 'confirmed'],
    2: ['processing', 'shipped'],
    3: ['delivered', 'completed'],
  };

  List<OrderModel> get filtered {
    Iterable<OrderModel> list = orders;
    final statuses = _tabStatuses[selectedTabIndex.value];
    if (statuses != null) list = list.where((o) => statuses.contains(o.status));
    final q = search.value.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((o) =>
          o.items.any((i) => i.title.toLowerCase().contains(q)) || o.id.toLowerCase().contains(q));
    }
    return list.toList();
  }
}
