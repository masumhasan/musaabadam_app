import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_settings_service.dart';

class PremierShopController extends GetxController {
  final RxMap<String, dynamic> config = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> status = <String, dynamic>{}.obs;

  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPremierShopData();
  }

  Future<void> loadPremierShopData() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final data = await ApiSettingsService.instance.getSellerPremierShopStatus();
      if (data.containsKey('config')) {
        config.value = Map<String, dynamic>.from(data['config'] as Map);
      }
      if (data.containsKey('status')) {
        status.value = Map<String, dynamic>.from(data['status'] as Map);
      }
    } on DioException {
      hasError.value = true;
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  bool get isPremierShop => status['isPremierShop'] == true;
  int get activeDays => (status['sellerActiveDays'] as num?)?.toInt() ?? 0;
  int get hostedShows => (status['sellerHostedShows'] as num?)?.toInt() ?? 0;
  int get completedOrders => (status['sellerCompletedOrders'] as num?)?.toInt() ?? 0;
  double get gmvAmount => (status['sellerGmvAmount'] as num?)?.toDouble() ?? 0.0;
  int get timelyShippingPercent => (status['sellerTimelyShippingPercent'] as num?)?.toInt() ?? 100;
  int get orderReliabilityPercent => (status['sellerOrderReliabilityPercent'] as num?)?.toInt() ?? 100;

  // Config target getters
  int get targetActiveDays => (config['activeDays'] as num?)?.toInt() ?? 90;
  int get targetHostedShows => (config['hostedShows'] as num?)?.toInt() ?? 10;
  int get targetCompletedOrders => (config['completedOrders'] as num?)?.toInt() ?? 250;
  double get targetGmvAmount => (config['gmvAmount'] as num?)?.toDouble() ?? 50000.0;
  int get targetTimelyShippingPercent => (config['timelyShippingPercent'] as num?)?.toInt() ?? 95;
  int get targetShippingHours => (config['shippingHours'] as num?)?.toInt() ?? 48;
  int get targetOrderReliabilityPercent => (config['orderReliabilityPercent'] as num?)?.toInt() ?? 99;
  String get policyAdherenceText => (config['policyAdherenceText'] as String?) ?? 'Full compliance with BidsRush Community Guidelines & Trust Standards';
  int get commissionDiscountPercent => (config['commissionDiscountPercent'] as num?)?.toInt() ?? 10;
  List<String> get perks => (config['perks'] as List?)?.map((e) => e.toString()).toList() ?? [
    "10% Commission Discount on standard platform fees",
    "Premier Shop Badge on your profile and show thumbnails",
    "Boosted search placement & recommendations",
    "Prioritized Dedicated Seller Support"
  ];
}
