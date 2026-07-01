import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/stream_service.dart';
import 'package:musaab_adam/data/models/stream/stream_model.dart';

class ShowsController extends GetxController {
  final RxList<StreamModel> upcomingShows = <StreamModel>[].obs;
  final RxList<StreamModel> draftShows = <StreamModel>[].obs;
  final RxList<StreamModel> pastShows = <StreamModel>[].obs;
  final RxInt selectedTabIndex = 0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadShows();
  }

  Future<void> loadShows() async {
    isLoading.value = true;
    try {
      // Load all seller streams (no status filter) then split client-side
      final all = await StreamService.instance.getMyStreams(page: 1);
      upcomingShows.assignAll(all.where((s) => s.status == 'scheduled' || s.status == 'live').toList());
      draftShows.assignAll(all.where((s) => s.status == 'draft').toList());
      pastShows.assignAll(all.where((s) => s.status == 'ended' || s.status == 'cancelled').toList());
    } on DioException catch (e) {
      Get.snackbar('Error', StreamService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> publishShow(String streamId) async {
    try {
      await StreamService.instance.publishStream(streamId);
      await loadShows();
      Get.snackbar('Published', 'Your draft is now scheduled.', snackPosition: SnackPosition.BOTTOM);
    } on DioException catch (e) {
      Get.snackbar('Error', StreamService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> deleteShow(String streamId) async {
    try {
      await StreamService.instance.deleteStream(streamId);
      await loadShows();
      Get.snackbar('Deleted', 'The show has been removed.', snackPosition: SnackPosition.BOTTOM);
    } on DioException catch (e) {
      Get.snackbar('Error', StreamService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    }
  }

  List<StreamModel> get currentList =>
      selectedTabIndex.value == 0 ? upcomingShows : pastShows;

  void selectTab(int index) {
    if (selectedTabIndex.value == index) return;
    selectedTabIndex.value = index;
  }
}
