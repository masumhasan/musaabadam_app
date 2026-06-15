import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_auth_service.dart';
import 'package:musaab_adam/core/services/api_user_service.dart';
import 'package:musaab_adam/data/models/address/address_model.dart';
import 'package:musaab_adam/modules/profile/controllers/addresses_controller.dart';

class AddressFormController extends GetxController {
  // ── Set from route argument ────────────────────────────────────────────────
  AddressModel? _editing; // non-null when editing an existing address
  late String _defaultType; // 'shipping' or 'pickup'

  // ── Type selector ─────────────────────────────────────────────────────────
  final RxString selectedType = 'shipping'.obs;

  // ── Form ──────────────────────────────────────────────────────────────────
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final labelController = TextEditingController();
  final line1Controller = TextEditingController();
  final line2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final postalCodeController = TextEditingController();
  final phoneController = TextEditingController();
  final RxString selectedCountry = 'United States'.obs;
  final RxBool isDefault = false.obs;

  final RxBool isLoading = false.obs;

  bool get isEditing => _editing != null;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map?;
    _editing = args?['address'] as AddressModel?;
    _defaultType = args?['type'] as String? ?? 'shipping';

    if (_editing != null) {
      _populate(_editing!);
    } else {
      selectedType.value = _defaultType;
    }
  }

  void _populate(AddressModel a) {
    selectedType.value = a.type;
    labelController.text = a.label ?? '';
    fullNameController.text = a.fullName;
    line1Controller.text = a.line1;
    line2Controller.text = a.line2 ?? '';
    cityController.text = a.city;
    stateController.text = a.state ?? '';
    postalCodeController.text = a.postalCode;
    phoneController.text = a.phone ?? '';
    selectedCountry.value = a.country;
    isDefault.value = a.isDefault;
  }

  @override
  void onClose() {
    fullNameController.dispose();
    labelController.dispose();
    line1Controller.dispose();
    line2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    postalCodeController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;
    if (isLoading.value) return;
    isLoading.value = true;

    final body = {
      'type': selectedType.value,
      'label': labelController.text.trim().isNotEmpty ? labelController.text.trim() : null,
      'fullName': fullNameController.text.trim(),
      'line1': line1Controller.text.trim(),
      'line2': line2Controller.text.trim().isNotEmpty ? line2Controller.text.trim() : null,
      'city': cityController.text.trim(),
      'state': stateController.text.trim().isNotEmpty ? stateController.text.trim() : null,
      'postalCode': postalCodeController.text.trim(),
      'country': selectedCountry.value,
      'phone': phoneController.text.trim().isNotEmpty ? phoneController.text.trim() : null,
      'isDefault': isDefault.value,
    };
    body.removeWhere((_, v) => v == null);

    try {
      final List<AddressModel> updated;
      if (isEditing) {
        updated = await ApiUserService.instance.updateAddress(_editing!.id, body);
      } else {
        updated = await ApiUserService.instance.addAddress(body);
      }

      // Notify the addresses list controller if it's alive
      if (Get.isRegistered<AddressesController>()) {
        Get.find<AddressesController>().onAddressSaved(updated);
      }

      Get.back();
      Get.snackbar(
        'Success',
        isEditing ? 'Address updated.' : 'Address added.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on DioException catch (e) {
      Get.snackbar('Error', ApiAuthService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
