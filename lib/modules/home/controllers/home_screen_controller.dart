import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/stream_service.dart';
import 'package:musaab_adam/data/models/stream/stream_model.dart';

class HomeScreenController extends GetxController {
  final RxList<StreamModel> liveStreams = <StreamModel>[].obs;
  final RxList<StreamModel> pastShows = <StreamModel>[].obs;
  final RxBool isLoadingStreams = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadLiveStreams();
    loadPastShows();
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

  Future<void> loadPastShows() async {
    try {
      pastShows.value = await StreamService.instance.getEndedStreams();
    } on DioException {
      // Silently fail — the past-streams section is simply hidden when empty
    }
  }

  String get liveShowCountText {
    final count = liveStreams.length;
    if (count == 0) return 'Live Shows';
    return '$count Live Show${count == 1 ? '' : 's'}';
  }
}
