import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/category_service.dart';
import 'package:musaab_adam/core/services/stream_service.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/data/models/category/category_model.dart';

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

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  @override
  void onClose() {
    titleController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.onClose();
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
    if (time == null || !context.mounted) return;
    _pickedTime = time;
    timeController.text = time.format(context);
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

  Future<void> scheduleShow() async {
    if (isLoading.value) return;
    if (!_validate()) return;

    isLoading.value = true;
    try {
      await StreamService.instance.createStream(
        title: titleController.text.trim(),
        categoryId: selectedCategory.value?.id,
        scheduledAt: scheduledAt.value,
        tags: tags.isEmpty ? null : tags.toList(),
        chatEnabled: true,
      );

      Get.back();
      Get.snackbar(
        'Show Scheduled!',
        'Your live show has been scheduled.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
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
}
