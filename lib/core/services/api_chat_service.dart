import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/data/models/chat/chat_message_model.dart';

class ApiChatService {
  ApiChatService._();
  static final ApiChatService instance = ApiChatService._();

  final Dio _dio = ApiClient.instance;

  Future<List<ChatMessageModel>> getHistory(String streamId, {int limit = 50}) async {
    final response = await _dio.get(
      ApiConstants.chatMessages(streamId),
      queryParameters: {'limit': limit},
    );
    final list = response.data['data']['messages'] as List;
    return list.map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String extractError(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) return data['message'] as String;
    } catch (_) {}
    return e.message ?? 'Network error. Please try again.';
  }
}
