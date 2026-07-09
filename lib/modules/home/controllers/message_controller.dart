import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_dm_service.dart';
import 'package:musaab_adam/data/models/message/message_model.dart';
import 'package:musaab_adam/core/services/socket_service.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';

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

    // Listen to real-time DMs
    ever(SocketService.instance.latestDmMessage, _handleNewMessage);
  }

  void _handleNewMessage(Map<String, dynamic>? data) {
    if (data == null) return;
    
    // Check if the message belongs to this conversation
    final senderId = data['senderId'];
    final receiverId = data['receiverId'];
    final currentUserId = Get.find<AuthController>().currentUser.value?.id;
    
    final isRelevant = (senderId == partnerId && receiverId == currentUserId) || 
                       (senderId == currentUserId && receiverId == partnerId);
                       
    if (isRelevant) {
      // Prevent duplicates if we already added it via sendMsg
      if (!messages.any((m) => m.id == data['_id'])) {
        final msg = MessageModel.fromJson(data, currentUserId ?? '');
        messages.add(msg);
      }
    }
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
      if (!messages.any((m) => m.id == msg.id)) {
        messages.add(msg);
      }
    } catch (_) {}
  }
}
