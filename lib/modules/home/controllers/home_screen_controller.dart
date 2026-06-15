import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/stream_service.dart';
import 'package:musaab_adam/data/models/stream/stream_model.dart';

class HomeScreenController extends GetxController {
  final RxList<StreamModel> liveStreams = <StreamModel>[].obs;
  final RxBool isLoadingStreams = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadLiveStreams();
  }

  Future<void> loadLiveStreams() async {
    isLoadingStreams.value = true;
    try {
      final streams = await StreamService.instance.getLiveStreams();
      liveStreams.value = streams;
    } on DioException {
      // Silently fail — home screen falls back to empty list gracefully
    } finally {
      isLoadingStreams.value = false;
    }
  }

  String get liveShowCountText {
    final count = liveStreams.length;
    if (count == 0) return 'Live Shows';
    return '$count Live Show${count == 1 ? '' : 's'}';
  }
}
