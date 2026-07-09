import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide ApiClient;
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/core/services/stream_service.dart';
import 'package:musaab_adam/data/models/auth/user_model.dart';
import 'package:musaab_adam/data/models/product/product_model.dart';
import 'package:musaab_adam/data/models/stream/stream_model.dart';
import 'package:musaab_adam/core/services/api_auth_service.dart';
import 'package:musaab_adam/routes/app_pages.dart';
class StartShowController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isCameraEnabled = true.obs;
  final RxBool isMicEnabled = true.obs;
  
  final RxString sellerName = ''.obs;
  final RxString sellerAvatarUrl = ''.obs;
  
  final Rx<ProductModel?> selectedProduct = Rx<ProductModel?>(null);
  
  Call? _call;
  String? _streamId;
  
  late bool isRehearsal;
  StreamModel? scheduledStream;

  Call? get call => _call;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['isRehearsal'] == true) {
      isRehearsal = true;
    } else if (args is StreamModel) {
      scheduledStream = args;
      isRehearsal = false;
      _streamId = scheduledStream!.id;
    } else {
      isRehearsal = true; // fallback
    }
    _setup();
  }

  Future<void> _setup() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      // 1. Get current seller profile
      final user = await ApiAuthService.instance.getMyProfile();
      sellerName.value = user.displayName ?? user.username;
      sellerAvatarUrl.value = user.avatarUrl ?? '';

      // 2. Stream ID
      if (isRehearsal) {
        final stream = await StreamService.instance.createStream(
          title: 'Rehearsal — ${sellerName.value}',
        );
        _streamId = stream.id;
      }

      // 3. Join as host
      final joinResult = await StreamService.instance.joinStream(_streamId!);

      // 4. Initialize StreamVideo SDK
      if (StreamVideo.isInitialized()) StreamVideo.reset();
      StreamVideo(
        joinResult.apiKey,
        user: User.regular(
          userId: user.id,
          name: sellerName.value,
          image: sellerAvatarUrl.value.isNotEmpty ? sellerAvatarUrl.value : null,
        ),
        userToken: joinResult.token,
        failIfSingletonExists: false,
      );

      // 5. Create call reference
      _call = StreamVideo.instance.makeCall(
        callType: StreamCallType.fromString(joinResult.callType),
        id: joinResult.callId,
      );
      await _call!.getOrCreate();

      isLoading.value = false;
    } on DioException catch (e) {
      _handleError(ApiAuthService.extractError(e));
    } catch (e) {
      _handleError(e.toString());
    }
  }

  Future<void> retry() => _setup();

  Future<void> toggleCamera() async {
    if (_call == null) return;
    await _call!.setCameraEnabled(enabled: !isCameraEnabled.value);
    isCameraEnabled.value = !isCameraEnabled.value;
  }

  Future<void> toggleMic() async {
    if (_call == null) return;
    await _call!.setMicrophoneEnabled(enabled: !isMicEnabled.value);
    isMicEnabled.value = !isMicEnabled.value;
  }
  
  void setProduct(ProductModel product) {
    selectedProduct.value = product;
  }

  Future<void> goLive() async {
    if (isRehearsal) {
      Get.snackbar('Rehearsal', 'You cannot go live in rehearsal mode.');
      return;
    }
    
    Get.offNamed(AppRoutes.livestreamScreen, arguments: _streamId);
  }

  Future<void> endShow() async {
    await _leaveAndCleanUp();
    Get.back();
  }

  Future<void> _leaveAndCleanUp() async {
    try {
      await _call?.leave();
    } catch (_) {}
    if (isRehearsal && _streamId != null) {
      try {
        await StreamService.instance.cancelStream(_streamId!);
      } catch (_) {}
      _streamId = null;
    }
    try {
      if (StreamVideo.isInitialized()) StreamVideo.reset();
    } catch (_) {}
  }

  void _handleError(String msg) {
    errorMessage.value = msg;
    hasError.value = true;
    isLoading.value = false;
  }

  @override
  void onClose() {
    _leaveAndCleanUp();
    super.onClose();
  }
}
