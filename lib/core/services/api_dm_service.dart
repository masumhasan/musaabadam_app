import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/data/models/message/conversation_model.dart';
import 'package:musaab_adam/data/models/message/message_model.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';

class ApiDmService {
  ApiDmService._();
  static final ApiDmService instance = ApiDmService._();

  final Dio _dio = ApiClient.instance;

  Future<List<InboxConversationModel>> getConversations() async {
    final response = await _dio.get(ApiConstants.dmConversations);
    final list = response.data['data']['conversations'] as List;
    return list.map((e) => InboxConversationModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<MessageModel>> getMessages(String partnerId) async {
    final currentUserId = Get.find<AuthController>().currentUser.value?.id ?? '';
    final response = await _dio.get(ApiConstants.dmMessages(partnerId));
    final list = response.data['data']['messages'] as List;
    return list.map((e) => MessageModel.fromJson(e as Map<String, dynamic>, currentUserId)).toList();
  }

  Future<MessageModel> sendMessage(String partnerId, String text) async {
    final currentUserId = Get.find<AuthController>().currentUser.value?.id ?? '';
    final response = await _dio.post(
      ApiConstants.dmMessages(partnerId),
      data: {'text': text},
    );
    final data = response.data['data'];
    return MessageModel.fromJson(data as Map<String, dynamic>, currentUserId);
  }
}
