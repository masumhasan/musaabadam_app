import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/social_service.dart';
import 'package:musaab_adam/core/services/stream_service.dart';
import 'package:musaab_adam/data/models/social/public_profile_model.dart';
import 'package:musaab_adam/data/models/stream/stream_model.dart';

class OtherUserProfileController extends GetxController {
  final String userId;
  OtherUserProfileController({required this.userId});

  final Rx<PublicProfileModel?> profile = Rx<PublicProfileModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool actionLoading = false.obs;
  final RxBool isFollowing = false.obs;
  final RxBool isBlockedByMe = false.obs;
  final RxInt followersCount = 0.obs;

  // Seller's shows for the profile tabs.
  final RxList<StreamModel> upcomingShows = <StreamModel>[].obs;
  final RxList<StreamModel> previousShows = <StreamModel>[].obs;
  final RxBool showsLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
    _loadShows();
  }

  Future<void> _loadProfile() async {
    isLoading.value = true;
    try {
      final data = await SocialService.instance.getPublicProfile(userId);
      profile.value = data;
      isFollowing.value = data.isFollowing;
      isBlockedByMe.value = data.isBlockedByMe;
      followersCount.value = data.followersCount;
    } on DioException catch (e) {
      Get.snackbar('Error', SocialService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadShows() async {
    showsLoading.value = true;
    try {
      final results = await Future.wait([
        StreamService.instance.getSellerStreams(sellerId: userId, status: 'live'),
        StreamService.instance.getSellerStreams(sellerId: userId, status: 'scheduled'),
        StreamService.instance.getSellerStreams(sellerId: userId, status: 'ended'),
      ]);
      upcomingShows.assignAll([...results[0], ...results[1]]);
      previousShows.assignAll(results[2]);
    } catch (_) {
      // Non-fatal: profile still renders without shows.
    } finally {
      showsLoading.value = false;
    }
  }

  Future<void> toggleFollow() async {
    if (actionLoading.value) return;
    actionLoading.value = true;
    try {
      if (isFollowing.value) {
        await SocialService.instance.unfollowUser(userId);
        isFollowing.value = false;
        if (followersCount.value > 0) followersCount.value--;
      } else {
        await SocialService.instance.followUser(userId);
        isFollowing.value = true;
        followersCount.value++;
      }
    } on DioException catch (e) {
      Get.snackbar('Error', SocialService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      actionLoading.value = false;
    }
  }

  Future<void> blockThisUser() async {
    if (actionLoading.value) return;
    actionLoading.value = true;
    try {
      await SocialService.instance.blockUser(userId);
      isBlockedByMe.value = true;
      if (isFollowing.value) {
        isFollowing.value = false;
        if (followersCount.value > 0) followersCount.value--;
      }
      Get.snackbar(
        'User blocked',
        'You will no longer see content from this user.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on DioException catch (e) {
      Get.snackbar('Error', SocialService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      actionLoading.value = false;
    }
  }

  Future<void> unblockThisUser() async {
    if (actionLoading.value) return;
    actionLoading.value = true;
    try {
      await SocialService.instance.unblockUser(userId);
      isBlockedByMe.value = false;
      Get.snackbar(
        'User unblocked',
        'You can now follow and interact with this user.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on DioException catch (e) {
      Get.snackbar('Error', SocialService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      actionLoading.value = false;
    }
  }

  static String formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}m';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }
}
