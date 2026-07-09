import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/core/services/api_upload_service.dart';
import 'package:musaab_adam/core/services/category_service.dart';
import 'package:musaab_adam/core/services/stream_service.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/data/models/category/category_model.dart';
import 'package:musaab_adam/data/models/stream/stream_model.dart';

class ScheduleShowController extends GetxController {
  // ─── Form fields ─────────────────────────────────────────────────────────
  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  final RxString selectedRepeat = AppStrings.doesNotRepeat.obs;
  final RxBool explicitContent = false.obs;
  final RxString discoverability = 'Public'.obs;

  // ─── Scheduled date/time ─────────────────────────────────────────────────
  final Rx<DateTime?> scheduledAt = Rx<DateTime?>(null);
  DateTime? _pickedDate;
  TimeOfDay? _pickedTime;

  // ─── Categories ──────────────────────────────────────────────────────────
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool categoriesLoading = false.obs;
  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);

  // ─── Tags ────────────────────────────────────────────────────────────────
  final RxList<String> tags = <String>[].obs;

  // ─── Loading ─────────────────────────────────────────────────────────────
  final RxBool isLoading = false.obs;

  // ─── Media Pickers ───────────────────────────────────────────────────────
  final RxString thumbnailUrl = ''.obs;
  final RxString videoPreviewUrl = ''.obs;

  // ─── Format, Shipping, Language, Muted Words ────────────────────────────
  final RxString primarySellingFormat = 'auction'.obs;
  final RxString shippingSettings = ''.obs;
  final RxBool freePickup = false.obs;
  final RxString primaryLanguage = 'English'.obs;
  final RxList<String> mutedWords = <String>[].obs;
  final RxList<String> moderatorIds = <String>[].obs;

  // ─── Edit mode ───────────────────────────────────────────────────────────
  String? _editStreamId;
  bool get isEditMode => _editStreamId != null;

  // ─── Platform Settings ───────────────────────────────────────────────────
  final RxList<String> availableTags = <String>[].obs;
  final RxList<String> availableMutedWords = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadPlatformSettings();
    final arg = Get.arguments;
    if (arg is StreamModel) {
      _editStreamId = arg.id;
      titleController.text = arg.title;
      thumbnailUrl.value = arg.thumbnailUrl ?? '';
      videoPreviewUrl.value = arg.videoPreviewUrl ?? '';
      primarySellingFormat.value = arg.primarySellingFormat;
      selectedRepeat.value = arg.repeatOption;
      shippingSettings.value = arg.shippingSettings ?? '';
      freePickup.value = arg.freePickup;
      explicitContent.value = arg.explicitContent;
      mutedWords.assignAll(arg.mutedWords);
      primaryLanguage.value = arg.primaryLanguage;
      moderatorIds.assignAll(arg.moderatorIds);
      tags.assignAll(arg.tags);
      
      if (arg.scheduledAt != null) {
        final local = arg.scheduledAt!.toLocal();
        _pickedDate = DateTime(local.year, local.month, local.day);
        _pickedTime = TimeOfDay(hour: local.hour, minute: local.minute);
        dateController.text = '${local.day} ${_month(local.month)}, ${local.year}';
        timeController.text = _formatTimeOfDay(_pickedTime!);
        scheduledAt.value = local;
      }
    }
    loadCategories();
    loadPlatformSettings();
  }

  @override
  void onClose() {
    titleController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.onClose();
  }

  Future<void> pickThumbnail() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    
    isLoading.value = true;
    try {
      final url = await ApiUploadService.instance.uploadFile(
        file: File(image.path),
        folder: 'stream_thumbnail',
        contentType: 'image/jpeg',
      );
      thumbnailUrl.value = url;
      Get.snackbar('Image Uploaded', 'Thumbnail added successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Upload Failed', 'Failed to upload thumbnail', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (video == null) return;

    isLoading.value = true;
    try {
      final url = await ApiUploadService.instance.uploadFile(
        file: File(video.path),
        folder: 'stream_video',
        contentType: 'video/mp4',
      );
      videoPreviewUrl.value = url;
      Get.snackbar('Video Uploaded', 'Preview video added successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Upload Failed', 'Failed to upload video', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCategories() async {
    categoriesLoading.value = true;
    try {
      final result = await CategoryService.instance.getTopLevelCategories();
      categories.assignAll(result);
    } catch (_) {}
    finally {
      categoriesLoading.value = false;
    }
  }

  Future<void> loadPlatformSettings() async {
    try {
      final response = await ApiClient.instance.get(ApiConstants.platformSettings);
      final data = response.data['data']['settings'];
      if (data != null) {
        availableTags.assignAll(List<String>.from(data['allowedTags'] ?? []));
        availableMutedWords.assignAll(List<String>.from(data['selectiveMutedWords'] ?? []));
      }
    } catch (_) {}
  }

  Future<void> pickDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: _pickedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null) return;
    _pickedDate = date;
    dateController.text = '${date.day} ${_month(date.month)}, ${date.year}';
    _updateScheduledAt();
  }

  Future<void> pickTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: _pickedTime ?? TimeOfDay.now(),
    );
    if (time == null) return;
    _pickedTime = time;
    timeController.text = _formatTimeOfDay(time);
    _updateScheduledAt();
  }

  void _updateScheduledAt() {
    if (_pickedDate == null || _pickedTime == null) return;
    scheduledAt.value = DateTime(
      _pickedDate!.year,
      _pickedDate!.month,
      _pickedDate!.day,
      _pickedTime!.hour,
      _pickedTime!.minute,
    );
  }

  bool _validate() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar('Required', 'Please enter a name for your show.', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (scheduledAt.value == null) {
      Get.snackbar('Required', 'Please pick a date and time for your show.', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    if (scheduledAt.value!.isBefore(DateTime.now())) {
      Get.snackbar('Invalid', 'Schedule time must be in the future.', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  // Maps the UI discoverability label to the backend visibility value.
  String get _visibility {
    switch (discoverability.value.toLowerCase()) {
      case 'followers':
      case 'followers only':
        return 'followers';
      case 'private':
        return 'private';
      default:
        return 'public';
    }
  }

  Future<void> scheduleShow({bool asDraft = false}) async {
    if (isLoading.value) return;
    if (!_validate()) return;

    isLoading.value = true;
    try {
      if (isEditMode) {
        await StreamService.instance.updateStream(
          _editStreamId!,
          title: titleController.text.trim(),
          categoryId: selectedCategory.value?.id,
          scheduledAt: scheduledAt.value,
          tags: tags.isEmpty ? null : tags.toList(),
          visibility: _visibility,
          thumbnailUrl: thumbnailUrl.value.isEmpty ? null : thumbnailUrl.value,
          videoPreviewUrl: videoPreviewUrl.value.isEmpty ? null : videoPreviewUrl.value,
          primarySellingFormat: primarySellingFormat.value,
          repeatOption: selectedRepeat.value,
          shippingSettings: shippingSettings.value.isEmpty ? null : shippingSettings.value,
          freePickup: freePickup.value,
          explicitContent: explicitContent.value,
          mutedWords: mutedWords.toList(),
          primaryLanguage: primaryLanguage.value,
          moderatorIds: moderatorIds.toList(),
        );
        Get.back();
        Get.snackbar(
          'Show Updated!',
          'Your scheduled show has been updated.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      } else {
        await StreamService.instance.createStream(
          title: titleController.text.trim(),
          categoryId: selectedCategory.value?.id,
          scheduledAt: scheduledAt.value,
          tags: tags.isEmpty ? null : tags.toList(),
          chatEnabled: true,
          visibility: _visibility,
          asDraft: asDraft,
          thumbnailUrl: thumbnailUrl.value.isEmpty ? null : thumbnailUrl.value,
          videoPreviewUrl: videoPreviewUrl.value.isEmpty ? null : videoPreviewUrl.value,
          primarySellingFormat: primarySellingFormat.value,
          repeatOption: selectedRepeat.value,
          shippingSettings: shippingSettings.value.isEmpty ? null : shippingSettings.value,
          freePickup: freePickup.value,
          explicitContent: explicitContent.value,
          mutedWords: mutedWords.toList(),
          primaryLanguage: primaryLanguage.value,
          moderatorIds: moderatorIds.toList(),
        );
        Get.back();
        Get.snackbar(
          asDraft ? 'Draft Saved!' : 'Show Scheduled!',
          asDraft ? 'Your show was saved as a draft.' : 'Your live show has been scheduled.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } on DioException catch (e) {
      Get.snackbar('Error', StreamService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  static String _month(int m) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[m - 1];
  }

  static String _formatTimeOfDay(TimeOfDay time) {
    final h = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final m = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $period';
  }
}
