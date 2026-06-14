import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_auth_service.dart';
import 'package:musaab_adam/core/services/token_storage_service.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';

class UpdateProfileController extends GetxController {
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final Rxn<File> avatarFile = Rxn<File>();
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _populate();
  }

  @override
  void onClose() {
    displayNameController.dispose();
    bioController.dispose();
    locationController.dispose();
    super.onClose();
  }

  void _populate() {
    final user = Get.find<AuthController>().currentUser.value;
    if (user == null) return;
    displayNameController.text = user.displayName ?? '';
    bioController.text = user.bio ?? '';
    locationController.text = user.location ?? '';
  }

  void onAvatarPicked(File file) {
    avatarFile.value = file;
  }

  Future<void> updateProfile() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final user = await ApiAuthService.instance.updateProfile(
        displayName: displayNameController.text.trim().isNotEmpty
            ? displayNameController.text.trim()
            : null,
        bio: bioController.text.trim().isNotEmpty
            ? bioController.text.trim()
            : null,
        location: locationController.text.trim().isNotEmpty
            ? locationController.text.trim()
            : null,
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
}
