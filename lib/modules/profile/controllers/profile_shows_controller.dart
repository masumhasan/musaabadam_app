import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/stream_service.dart';
import 'package:musaab_adam/data/models/stream/stream_model.dart';

class ProfileShowsController extends GetxController {
  final RxList<StreamModel> shows = <StreamModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadShows();
  }

  Future<void> loadShows() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final all = await StreamService.instance.getMyStreams(page: 1);
      shows.assignAll(
        all.where((s) => s.status == 'ended' || s.status == 'cancelled').toList()
          ..sort((a, b) {
            final aDate = a.startedAt ?? a.createdAt;
            final bDate = b.startedAt ?? b.createdAt;
            return bDate.compareTo(aDate);
          }),
      );
    } on DioException catch (e) {
      errorMessage.value = StreamService.extractError(e);
    } catch (_) {
      errorMessage.value = 'Failed to load shows.';
    } finally {
      isLoading.value = false;
    }
  }
}
