import 'package:get/get.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/services/stream_service.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';

class EndShowInsightsController extends GetxController {
  final RxBool isLoading = true.obs;
  
  final RxInt sales = 0.obs;
  final RxInt orders = 0.obs;
  final RxInt shares = 0.obs;
  final RxInt viewers = 0.obs;
  final RxInt newFollowers = 0.obs;
  final RxInt totalBids = 0.obs;
  final RxInt firstTimeBuyers = 0.obs;
  final RxInt promoSales = 0.obs;
  final RxInt spend = 0.obs;
  final RxString sellerName = "".obs;

  @override
  void onInit() {
    super.onInit();
    final streamId = Get.arguments as String?;
    if (streamId != null) {
      _loadInsights(streamId);
    } else {
      // Dummy data if accessed directly without stream id
      sales.value = 4;
      orders.value = 2;
      shares.value = 1;
      viewers.value = 375;
      newFollowers.value = 5;
      totalBids.value = 2;
      firstTimeBuyers.value = 1;
      promoSales.value = 4;
      spend.value = 40;
      sellerName.value = "branddealsstyle";
      isLoading.value = false;
    }
  }

  Future<void> _loadInsights(String streamId) async {
    try {
      final stream = await StreamService.instance.getStream(streamId);
      final user = Get.find<AuthController>().currentUser.value;
      
      sales.value = 0;
      orders.value = 0;
      shares.value = 0;
      viewers.value = stream.totalViewers;
      newFollowers.value = 0;
      totalBids.value = 0; // Wait, actually if you don't have them in model just leave 0
      firstTimeBuyers.value = 0;
      promoSales.value = 0;
      spend.value = 0;
      sellerName.value = user?.displayName ?? user?.username ?? "Seller";
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to load stream insights.');
    } finally {
      isLoading.value = false;
    }
  }

  void scheduleNextShow() {
    Get.offNamed(AppRoutes.scheduleLiveShowScreen);
  }

  void closeInsights() {
    Get.back();
  }
}
