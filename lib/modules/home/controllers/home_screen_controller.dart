import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/stream_service.dart';
import 'package:musaab_adam/core/services/category_service.dart';
import 'package:musaab_adam/data/models/stream/stream_model.dart';
import 'package:musaab_adam/data/models/category/category_model.dart';

class HomeScreenController extends GetxController {
  final RxList<StreamModel> liveStreams = <StreamModel>[].obs;
  final RxList<StreamModel> pastShows = <StreamModel>[].obs;
  final RxBool isLoadingStreams = false.obs;

  // Real categories
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoadingCategories = false.obs;

  // Category filtering
  // selectedCategoryType: 'for_you' | 'followed' | 'category'
  final RxString selectedCategoryType = 'for_you'.obs;
  final Rxn<CategoryModel> selectedCategory = Rxn<CategoryModel>();

  // Discovery feed selection + infinite scroll.
  static const feeds = ['live', 'trending', 'following', 'recommended'];
  final RxString selectedFeed = 'live'.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMore = true.obs;
  int _page = 1;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadLiveStreams();
    loadPastShows();
  }

  void selectFeed(String feed) {
    if (selectedFeed.value == feed && selectedCategoryType.value == 'for_you') return;
    selectedFeed.value = feed;
    // Selecting a feed chip defaults the category selection back to 'For You'
    selectedCategoryType.value = 'for_you';
    selectedCategory.value = null;
    loadLiveStreams();
  }

  void selectCategory(String type, {CategoryModel? category}) {
    selectedCategoryType.value = type;
    selectedCategory.value = category;
    loadLiveStreams();
  }

  Future<void> loadCategories() async {
    isLoadingCategories.value = true;
    try {
      final list = await CategoryService.instance.getTopLevelCategories();
      categories.value = list;
    } catch (_) {
      // Silently fail - falls back to empty category list
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> loadLiveStreams() async {
    isLoadingStreams.value = true;
    _page = 1;
    hasMore.value = true;
    try {
      List<StreamModel> streams;
      if (selectedCategoryType.value == 'followed') {
        streams = await StreamService.instance.getFeed(feed: 'following', page: _page);
      } else if (selectedCategoryType.value == 'category' && selectedCategory.value != null) {
        streams = await StreamService.instance.getLiveStreams(categoryId: selectedCategory.value!.id, page: _page);
      } else {
        streams = await StreamService.instance.getFeed(feed: selectedFeed.value, page: _page);
      }
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
      List<StreamModel> next;
      if (selectedCategoryType.value == 'followed') {
        next = await StreamService.instance.getFeed(feed: 'following', page: _page + 1);
      } else if (selectedCategoryType.value == 'category' && selectedCategory.value != null) {
        next = await StreamService.instance.getLiveStreams(categoryId: selectedCategory.value!.id, page: _page + 1);
      } else {
        next = await StreamService.instance.getFeed(feed: selectedFeed.value, page: _page + 1);
      }

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
