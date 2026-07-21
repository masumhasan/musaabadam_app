import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/stream_service.dart';
import 'package:musaab_adam/data/models/stream/stream_model.dart';

/// Loads the list of past shows (replays) that have a recording stored in S3.
///
/// Optionally scoped to a single seller via `Get.arguments` (a sellerId string).
class PastShowsController extends GetxController {
  final RxList<StreamModel> replays = <StreamModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;

  String? _sellerId;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is String) _sellerId = arg;
    loadReplays();
  }

  Future<void> loadReplays() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final list = await StreamService.instance.getEndedStreams(sellerId: _sellerId);
      list.sort((a, b) {
        final dateA = a.endedAt ?? a.createdAt;
        final dateB = b.endedAt ?? b.createdAt;
        return dateB.compareTo(dateA); // Descending: newest first
      });

      replays.value = list;
    } on DioException {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }
}
