import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/stream_service.dart';
import 'package:musaab_adam/data/models/stream/stream_model.dart';

class HomeScreenController extends GetxController {
  final RxList<StreamModel> liveStreams = <StreamModel>[].obs;
  final RxList<StreamModel> pastShows = <StreamModel>[].obs;
  final RxBool isLoadingStreams = false.obs;

  // Discovery feed selection + infinite scroll.
  static const feeds = ['live', 'trending', 'following', 'recommended'];
  final RxString selectedFeed = 'live'.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  int _page = 1;

  @override
  void onInit() {
    super.onInit();
    loadLiveStreams();
    loadPastShows();
  }

  void selectFeed(String feed) {
    if (selectedFeed.value == feed) return;
    selectedFeed.value = feed;
    loadLiveStreams();
  }

  Future<void> loadLiveStreams() async {
    isLoadingStreams.value = true;
    _page = 1;
    hasMore.value = true;
    try {
      final streams = await StreamService.instance.getFeed(feed: selectedFeed.value, page: _page);
      liveStreams.value = streams;
      hasMore.value = streams.length >= 20;
    } on DioException {
      // Silently fail — home screen falls back to empty list gracefully
    } finally {
      isLoadingStreams.value = false;
    }
  }

  /// Loads the next page and appends (infinite scroll).
  Future<void> loadMoreStreams() async {
    if (isLoadingMore.value || !hasMore.value || isLoadingStreams.value) return;
    isLoadingMore.value = true;
    try {
      final next = await StreamService.instance.getFeed(feed: selectedFeed.value, page: _page + 1);
      if (next.isEmpty) {
        hasMore.value = false;
      } else {
        _page += 1;
        liveStreams.addAll(next);
        hasMore.value = next.length >= 20;
      }
    } on DioException {
      // ignore — keep what we have
    } finally {
      isLoadingMore.value = false;
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
