import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_notification_service.dart';
import 'package:musaab_adam/core/services/socket_service.dart';
import 'package:musaab_adam/data/models/notification/notification_model.dart';

/// App-wide notification state: inbox list, unread badge, and realtime arrival.
/// Registered permanently once the user is authenticated (main nav shell).
class NotificationController extends GetxController {
  final RxList<NotificationModel> items = <NotificationModel>[].obs;
  final RxInt unreadCount = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;

  int _page = 1;
  final RxBool hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Ensure the socket is up so realtime notifications arrive app-wide.
    SocketService.instance.connect();
    SocketService.instance.latestNotification.listen(_onRealtime);
    load(refresh: true);
    _refreshUnread();
  }

  void _onRealtime(Map<String, dynamic>? data) {
    if (data == null) return;
    final n = NotificationModel.fromJson(data);
    items.insert(0, n);
    unreadCount.value += 1;
    Get.snackbar(n.title, n.body ?? '', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 3));
  }

  Future<void> _refreshUnread() async {
    try {
      unreadCount.value = await ApiNotificationService.instance.unreadCount();
    } catch (_) {}
  }

  Future<void> load({bool refresh = false}) async {
    if (isLoading.value) return;
    if (refresh) {
      _page = 1;
      hasMore.value = true;
    }
    if (!hasMore.value) return;

    isLoading.value = true;
    hasError.value = false;
    try {
      final result = await ApiNotificationService.instance.list(page: _page);
      if (refresh) {
        items.assignAll(result.notifications);
      } else {
        items.addAll(result.notifications);
      }
      unreadCount.value = result.unreadCount;
      hasMore.value = _page < result.totalPages;
      if (hasMore.value) _page += 1;
    } on DioException {
      hasError.value = true;
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> markRead(NotificationModel n) async {
    if (n.isRead) return;
    final idx = items.indexWhere((e) => e.id == n.id);
    if (idx >= 0) items[idx] = items[idx].copyWith(isRead: true);
    try {
      unreadCount.value = await ApiNotificationService.instance.markRead(n.id);
    } catch (_) {}
  }

  Future<void> markAllRead() async {
    for (var i = 0; i < items.length; i++) {
      items[i] = items[i].copyWith(isRead: true);
    }
    unreadCount.value = 0;
    try {
      await ApiNotificationService.instance.markAllRead();
    } catch (_) {}
  }
}
