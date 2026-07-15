import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_payment_service.dart';

class PayoutHistoryController extends GetxController {
  final RxList<Map<String, dynamic>> payouts = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasError = false.obs;

  final ScrollController scrollController = ScrollController();

  int _currentPage = 1;
  bool _hasMore = true;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.hasClients &&
          scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        loadPayouts();
      }
    });
    loadPayouts(refresh: true);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> loadPayouts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      isLoading.value = true;
    } else {
      if (!_hasMore || isLoadingMore.value) return;
      isLoadingMore.value = true;
    }

    hasError.value = false;

    try {
      final list = await ApiPaymentService.instance.listPayouts(page: _currentPage);
      if (refresh) {
        payouts.assignAll(list);
      } else {
        payouts.addAll(list);
      }

      if (list.length < 20) {
        _hasMore = false;
      } else {
        _currentPage++;
      }
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }
}
