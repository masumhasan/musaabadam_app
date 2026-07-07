import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_dm_service.dart';
import 'package:musaab_adam/data/models/message/message_model.dart';

class MessageController extends GetxController {
  late final String partnerId;
  late final String partnerName;
  late final String? partnerAvatar;

  final RxList<MessageModel> messages = <MessageModel>[].obs;
  final RxBool isLoading = false.obs;
  final TextEditingController textCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>;
    partnerId = args['id'] as String;
    partnerName = args['name'] as String;
    partnerAvatar = args['avatar'] as String?;
    loadMessages();
  }

  Future<void> loadMessages() async {
    isLoading.value = true;
    try {
      messages.value = await ApiDmService.instance.getMessages(partnerId);
    } catch (_) {} finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMsg() async {
    final text = textCtrl.text.trim();
    if (text.isEmpty) return;
    textCtrl.clear();
    try {
      final msg = await ApiDmService.instance.sendMessage(partnerId, text);
      messages.add(msg);
    } catch (_) {}
  }
}
