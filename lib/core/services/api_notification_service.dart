import 'package:dio/dio.dart';
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/data/models/notification/notification_model.dart';

class NotificationPage {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final int totalPages;
  final int page;

  const NotificationPage({
    required this.notifications,
    required this.unreadCount,
    required this.totalPages,
    required this.page,
  });
}

class ApiNotificationService {
  ApiNotificationService._();
  static final ApiNotificationService instance = ApiNotificationService._();

  final Dio _dio = ApiClient.instance;

  Future<NotificationPage> list({int page = 1, bool unreadOnly = false}) async {
    final response = await _dio.get(ApiConstants.notifications, queryParameters: {
      'page': page,
      'limit': 20,
      if (unreadOnly) 'unreadOnly': true,
    });
    final data = response.data['data'] as Map<String, dynamic>;
    final list = (data['notifications'] as List)
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return NotificationPage(
      notifications: list,
      unreadCount: (data['unreadCount'] as num?)?.toInt() ?? 0,
      totalPages: (data['totalPages'] as num?)?.toInt() ?? 1,
      page: (data['page'] as num?)?.toInt() ?? 1,
    );
  }

  Future<int> unreadCount() async {
    final response = await _dio.get(ApiConstants.notificationsUnreadCount);
    return (response.data['data']['unreadCount'] as num?)?.toInt() ?? 0;
  }

  Future<int> markRead(String id) async {
    final response = await _dio.patch(ApiConstants.notificationRead(id));
    return (response.data['data']['unreadCount'] as num?)?.toInt() ?? 0;
  }

  Future<void> markAllRead() async {
    await _dio.post(ApiConstants.notificationsReadAll);
  }

  static String extractError(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) return data['message'] as String;
    } catch (_) {}
    return e.message ?? 'Network error. Please try again.';
  }
}
