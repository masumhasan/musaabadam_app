import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_search_service.dart';

class SearchScreenController extends GetxController {
  final Rx<SearchResults> results = const SearchResults().obs;
  final RxBool isLoading = false.obs;
  final RxString query = ''.obs;

  // type: all | sellers | products | streams
  final RxString type = 'all'.obs;
  // filter: null | live | upcoming | ended | auction | buy_now
  final Rxn<String> filter = Rxn<String>();

  Timer? _debounce;

  void onQueryChanged(String value) {
    query.value = value;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), _run);
  }

  void setType(String t) {
    type.value = t;
    // Clear an incompatible filter when switching scope.
    if (t == 'sellers') filter.value = null;
    _run();
  }

  void setFilter(String? f) {
    filter.value = filter.value == f ? null : f;
    _run();
  }

  Future<void> _run() async {
    final q = query.value.trim();
    if (q.isEmpty) {
      results.value = const SearchResults();
      return;
    }
    isLoading.value = true;
    try {
      results.value = await ApiSearchService.instance.search(q, type: type.value, filter: filter.value);
    } on DioException catch (e) {
      Get.snackbar('Search', ApiSearchService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}
