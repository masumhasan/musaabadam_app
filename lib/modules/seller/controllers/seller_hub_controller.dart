import 'package:get/get.dart';
import 'package:musaab_adam/core/services/stream_service.dart';

class SellerHubController extends GetxController {
  final RxInt upcomingShowsCount = 0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUpcomingShowsCount();
  }

  Future<void> loadUpcomingShowsCount() async {
    isLoading.value = true;
    try {
      final streams = await StreamService.instance.getMyStreams(status: 'scheduled');
      upcomingShowsCount.value = streams.length;
    } catch (_) {
      // Ignore error to avoid blocking the main hub UI if backend is offline
    } finally {
      isLoading.value = false;
    }
  }
}
