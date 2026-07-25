import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_auth_service.dart';
import 'package:musaab_adam/core/services/api_upload_service.dart';
import 'package:musaab_adam/core/services/token_storage_service.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';

class UpdateProfileController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final Rxn<File> avatarFile = Rxn<File>();
  final RxBool isLoading = false.obs;

  // Username validation state variables
  final RxString usernameError = ''.obs;
  final RxBool isCheckingUsername = false.obs;
  final RxBool isUsernameAvailable = false.obs;
  Timer? _usernameDebounce;

  @override
  void onInit() {
    super.onInit();
    _populate();
    usernameController.addListener(_onUsernameChanged);
  }

  @override
  void onClose() {
    usernameController.removeListener(_onUsernameChanged);
    usernameController.dispose();
    _usernameDebounce?.cancel();
    displayNameController.dispose();
    bioController.dispose();
    locationController.dispose();
    super.onClose();
  }

  void _populate() {
    final user = Get.find<AuthController>().currentUser.value;
    if (user == null) return;
    usernameController.text = user.username;
    displayNameController.text = user.displayName ?? '';
    bioController.text = user.bio ?? '';
    locationController.text = user.location ?? '';

    // Initially, current username is considered available
    isUsernameAvailable.value = true;
    usernameError.value = 'Available';
  }

  void _onUsernameChanged() {
    final newUsername = usernameController.text.trim();
    final currentUser = Get.find<AuthController>().currentUser.value;

    if (newUsername.isEmpty) {
      isUsernameAvailable.value = false;
      usernameError.value = '';
      return;
    }

    // If it matches the user's current username, consider it available immediately
    if (newUsername == currentUser?.username) {
      isUsernameAvailable.value = true;
      usernameError.value = 'Available';
      isCheckingUsername.value = false;
      _usernameDebounce?.cancel();
      return;
    }

    // Validate format locally
    final usernameRegex = RegExp(r'^[a-zA-Z0-9_.-]+$');
    if (!usernameRegex.hasMatch(newUsername)) {
      isUsernameAvailable.value = false;
      usernameError.value = 'May only contain letters, numbers, underscores, hyphens, and dots';
      isCheckingUsername.value = false;
      _usernameDebounce?.cancel();
      return;
    }

    if (newUsername.length < 3 || newUsername.length > 30) {
      isUsernameAvailable.value = false;
      usernameError.value = 'Must be 3-30 characters long';
      isCheckingUsername.value = false;
      _usernameDebounce?.cancel();
      return;
    }

    isCheckingUsername.value = true;
    usernameError.value = '';
    isUsernameAvailable.value = false;

    _usernameDebounce?.cancel();
    _usernameDebounce = Timer(const Duration(milliseconds: 600), () async {
      try {
        final available = await ApiAuthService.instance.checkUsernameAvailability(newUsername);
        isUsernameAvailable.value = available;
        if (available) {
          usernameError.value = 'Available';
        } else {
          usernameError.value = 'Not available';
        }
      } catch (_) {
        isUsernameAvailable.value = false;
        usernameError.value = 'Error checking availability';
      } finally {
        isCheckingUsername.value = false;
      }
    });
  }

  void onAvatarPicked(File file) {
    avatarFile.value = file;
  }

  Future<void> updateProfile() async {
    if (isLoading.value) return;

    final newUsername = usernameController.text.trim();
    final currentUser = Get.find<AuthController>().currentUser.value;

    if (newUsername.isEmpty) {
      Get.snackbar(
        'Error',
        'Username cannot be empty',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (newUsername != currentUser?.username && !isUsernameAvailable.value) {
      Get.snackbar(
        'Error',
        'Please choose an available username before updating.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      String? uploadedAvatarUrl;

      if (avatarFile.value != null) {
        uploadedAvatarUrl = await ApiUploadService.instance.uploadFile(
          file: avatarFile.value!,
          folder: 'profile',
          contentType: _mimeType(avatarFile.value!.path),
        );
      }

      final user = await ApiAuthService.instance.updateProfile(
        username: newUsername != currentUser?.username ? newUsername : null,
        displayName: displayNameController.text.trim().isNotEmpty
            ? displayNameController.text.trim()
            : null,
        bio: bioController.text.trim().isNotEmpty
            ? bioController.text.trim()
            : null,
        location: locationController.text.trim().isNotEmpty
            ? locationController.text.trim()
            : null,
        avatarUrl: uploadedAvatarUrl,
      );
      await TokenStorageService.instance.saveUser(user);
      Get.find<AuthController>().currentUser.value = user;
      Get.back();
      Get.snackbar(
        'Profile Updated',
        'Your profile has been saved.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on DioException catch (e) {
      Get.snackbar(
        'Error',
        ApiAuthService.extractError(e),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  static String _mimeType(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'png': return 'image/png';
      case 'webp': return 'image/webp';
      case 'gif': return 'image/gif';
      default: return 'image/jpeg';
    }
  }
}
