import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_analytics_service.dart';

class SellerAnalyticsController extends GetxController {
  final RxMap<String, dynamic> overview = <String, dynamic>{}.obs;
  final RxList<dynamic> revenueTrend = <dynamic>[].obs;

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxInt selectedDays = 30.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final overviewData = await ApiAnalyticsService.instance.getSellerOverview();
      final trendData = await ApiAnalyticsService.instance.getSellerRevenueTrend(selectedDays.value);
      
      overview.value = overviewData;
      revenueTrend.assignAll(trendData);
    } on DioException {
      hasError.value = true;
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeTimeline(int days) async {
    selectedDays.value = days;
    isLoading.value = true;
    hasError.value = false;
    try {
      final trendData = await ApiAnalyticsService.instance.getSellerRevenueTrend(days);
      revenueTrend.assignAll(trendData);
    } on DioException {
      hasError.value = true;
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
