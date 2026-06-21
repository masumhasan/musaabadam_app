import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:musaab_adam/core/services/stream_service.dart';
import 'package:musaab_adam/data/models/stream/stream_model.dart';

/// Plays a recorded past show (replay) stored in S3.
///
/// Accepts either a [StreamModel] or a stream id as `Get.arguments`. When given
/// a model that already carries a ready recording URL, it plays directly;
/// otherwise it asks the backend to resolve the replay URL.
class ReplayController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  final Rx<StreamModel?> stream = Rx<StreamModel?>(null);

  VideoPlayerController? videoController;
  final Rx<ChewieController?> chewie = Rx<ChewieController?>(null);

  String? _streamId;

  String get title => stream.value?.title ?? 'Replay';
  String get sellerName => stream.value?.sellerName ?? '';

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is StreamModel) {
      stream.value = arg;
      _streamId = arg.id;
      if (arg.hasReplay) {
        _initPlayer(arg.recordingUrl!);
        return;
      }
    } else if (arg is String) {
      _streamId = arg;
    }
    _resolveAndPlay();
  }

  Future<void> _resolveAndPlay() async {
    final id = _streamId;
    if (id == null) {
      _fail('Replay not available.');
      return;
    }
    isLoading.value = true;
    hasError.value = false;
    try {
      final result = await StreamService.instance.getReplay(id);
      stream.value = result.stream;
      await _initPlayer(result.recordingUrl);
    } on DioException catch (e) {
      _fail(StreamService.extractError(e));
    } catch (_) {
      _fail('Could not load replay.');
    }
  }

  Future<void> _initPlayer(String url) async {
    try {
      final controller = VideoPlayerController.networkUrl(Uri.parse(url));
      videoController = controller;
      await controller.initialize();
      chewie.value = ChewieController(
        videoPlayerController: controller,
        autoPlay: true,
        looping: false,
        allowFullScreen: true,
        allowMuting: true,
        aspectRatio: controller.value.aspectRatio == 0 ? 16 / 9 : controller.value.aspectRatio,
      );
      hasError.value = false;
    } catch (_) {
      _fail('Could not play this replay.');
    } finally {
      isLoading.value = false;
    }
  }

  void _fail(String message) {
    hasError.value = true;
    errorMessage.value = message;
    isLoading.value = false;
  }

  Future<void> retry() => _resolveAndPlay();

  @override
  void onClose() {
    chewie.value?.dispose();
    videoController?.dispose();
    super.onClose();
  }
}
