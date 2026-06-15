import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide ApiClient;
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/core/services/stream_service.dart';
import 'package:musaab_adam/data/models/auth/user_model.dart';

class RehearsalController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isCameraEnabled = true.obs;
  final RxBool isMicEnabled = true.obs;
  final RxString sellerName = ''.obs;
  final RxString sellerAvatarUrl = ''.obs;

  Call? _call;
  String? _streamId;

  Call? get call => _call;

  @override
  void onInit() {
    super.onInit();
    _setup();
  }

  Future<void> _setup() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      // 1. Get current seller profile
      final profileRes = await ApiClient.instance.get(ApiConstants.myProfile);
      final user = UserModel.fromJson(
        profileRes.data['data']['user'] as Map<String, dynamic>,
      );
      sellerName.value = user.displayName ?? user.username;
      sellerAvatarUrl.value = user.avatarUrl ?? '';

      // 2. Create a rehearsal stream on the backend
      final stream = await StreamService.instance.createStream(
        title: 'Rehearsal — ${sellerName.value}',
      );
      _streamId = stream.id;

      // 3. Join as host → get token, callId, apiKey
      final joinResult = await StreamService.instance.joinStream(stream.id);

      // 4. Initialize StreamVideo SDK (reset first if already initialized from a previous session)
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

      // 5. Create call reference — StreamCallContainer handles join() internally
      _call = StreamVideo.instance.makeCall(
        callType: StreamCallType.fromString(joinResult.callType),
        id: joinResult.callId,
      );
      await _call!.getOrCreate();

      isLoading.value = false;
    } on DioException catch (e) {
      _handleError(_extractDioError(e));
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

  Future<void> endRehearsal() async {
    await _leaveAndCleanUp();
    Get.back();
  }

  Future<void> _leaveAndCleanUp() async {
    try {
      await _call?.leave();
    } catch (_) {}
    if (_streamId != null) {
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

  static String _extractDioError(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) return data['message'] as String;
    } catch (_) {}
    return e.message ?? 'Network error. Please try again.';
  }

  @override
  void onClose() {
    _leaveAndCleanUp();
    super.onClose();
  }
}
