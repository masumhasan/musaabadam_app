import 'package:get/get.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/core/services/token_storage_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

typedef BidUpdateCallback = void Function(Map<String, dynamic> update);

class SocketService {
  SocketService._();
  static final SocketService instance = SocketService._();

  io.Socket? _socket;

  final Rx<Map<String, dynamic>?> latestBidUpdate = Rx(null);
  final Rx<Map<String, dynamic>?> latestAuctionStarted = Rx(null);
  final Rx<Map<String, dynamic>?> latestAuctionClosed = Rx(null);
  final Rx<Map<String, dynamic>?> latestAuctionState = Rx(null); // paused/resumed/cancelled

  // Chat
  final Rx<Map<String, dynamic>?> latestChatMessage = Rx(null);
  final Rx<Map<String, dynamic>?> latestReaction = Rx(null);
  final Rx<String?> lastDeletedMessageId = Rx(null);

  // Presence + moderation
  final RxInt viewerCount = 0.obs;
  final Rx<Map<String, dynamic>?> pinnedMessage = Rx(null); // null when unpinned
  final Rx<Map<String, dynamic>?> lastBanEvent = Rx(null);

  // Buy Now realtime
  final Rx<Map<String, dynamic>?> latestProductPinned = Rx(null);
  final Rx<Map<String, dynamic>?> latestProductUnpinned = Rx(null);
  final Rx<Map<String, dynamic>?> latestSoldOut = Rx(null);

  // Per-user notifications (delivered to the user's personal room)
  final Rx<Map<String, dynamic>?> latestNotification = Rx(null);

  // Giveaways
  final Rx<Map<String, dynamic>?> latestGiveawayStarted = Rx(null);
  final Rx<Map<String, dynamic>?> latestGiveawayJoined = Rx(null);
  final Rx<Map<String, dynamic>?> latestGiveawayWinner = Rx(null);

  static Map<String, dynamic>? _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return null;
  }

  // Connect to the server with JWT auth
  Future<void> connect() async {
    if (_socket != null && _socket!.connected) return;

    final token = await TokenStorageService.instance.getAccessToken();
    if (token == null) return;

    _socket = io.io(
      ApiConstants.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    _socket!.connect();

    _socket!.on('connect', (_) {});
    _socket!.on('disconnect', (_) {});
    _socket!.on('error', (_) {});

    _socket!.on('bid-updated', (data) {
      final map = _asMap(data);
      if (map != null) latestBidUpdate.value = map;
    });

    _socket!.on('auction-started', (data) {
      final map = _asMap(data);
      if (map != null) latestAuctionStarted.value = map;
    });

    _socket!.on('auction-closed', (data) {
      final map = _asMap(data);
      if (map != null) latestAuctionClosed.value = map;
    });

    for (final ev in ['auction-paused', 'auction-resumed', 'auction-cancelled']) {
      _socket!.on(ev, (data) {
        final map = _asMap(data);
        if (map != null) latestAuctionState.value = {...map, '_event': ev};
      });
    }

    _socket!.on('chat-message', (data) {
      final map = _asMap(data);
      if (map != null) latestChatMessage.value = map;
    });

    _socket!.on('reaction', (data) {
      final map = _asMap(data);
      if (map != null) latestReaction.value = map;
    });

    _socket!.on('message-deleted', (data) {
      final map = _asMap(data);
      if (map != null) lastDeletedMessageId.value = map['messageId']?.toString();
    });

    _socket!.on('viewer-count', (data) {
      final map = _asMap(data);
      if (map != null && map['count'] != null) viewerCount.value = (map['count'] as num).toInt();
    });

    _socket!.on('message-pinned', (data) {
      final map = _asMap(data);
      if (map != null) pinnedMessage.value = _asMap(map['message']);
    });

    _socket!.on('message-unpinned', (_) => pinnedMessage.value = null);

    _socket!.on('banned', (data) => lastBanEvent.value = _asMap(data) ?? {'banned': true});

    _socket!.on('user-banned', (data) {
      final map = _asMap(data);
      if (map != null) lastBanEvent.value = map;
    });

    _socket!.on('product-pinned', (data) => latestProductPinned.value = _asMap(data));
    _socket!.on('product-unpinned', (data) => latestProductUnpinned.value = _asMap(data));
    _socket!.on('product-sold-out', (data) => latestSoldOut.value = _asMap(data));

    _socket!.on('notification', (data) => latestNotification.value = _asMap(data));

    _socket!.on('giveaway-started', (data) => latestGiveawayStarted.value = _asMap(data));
    _socket!.on('giveaway-joined', (data) => latestGiveawayJoined.value = _asMap(data));
    _socket!.on('giveaway-winner', (data) => latestGiveawayWinner.value = _asMap(data));
  }

  void banUser({required String streamId, required String userId, bool ban = true}) {
    _socket?.emit('ban-user', {'streamId': streamId, 'userId': userId, 'ban': ban});
  }

  void pinMessage({required String streamId, String? messageId}) {
    _socket?.emit('pin-message', {'streamId': streamId, 'messageId': ?messageId});
  }

  void sendMessage({required String streamId, required String text, String? replyTo}) {
    _socket?.emit('send-message', {'streamId': streamId, 'text': text, 'replyTo': ?replyTo});
  }

  void setSlowMode({required String streamId, required int seconds}) {
    _socket?.emit('set-slow-mode', {'streamId': streamId, 'seconds': seconds});
  }

  void sendReaction({required String streamId, required String emoji}) {
    _socket?.emit('send-reaction', {'streamId': streamId, 'emoji': emoji});
  }

  void deleteMessage(String messageId) {
    _socket?.emit('delete-message', {'messageId': messageId});
  }

  void onChatError(void Function(String message) handler) {
    _socket?.off('chat-error');
    _socket?.on('chat-error', (data) {
      final msg = data is Map ? (data['message'] as String? ?? 'Chat error') : 'Chat error';
      handler(msg);
    });
  }

  void joinStream(String streamId) {
    _socket?.emit('join-stream', {'streamId': streamId});
  }

  void placeBid({
    required String streamId,
    required String productId,
    required double amount,
    double? maxAmount,
    bool isAutoBid = false,
  }) {
    _socket?.emit('place-bid', {
      'streamId': streamId,
      'productId': productId,
      'amount': amount,
      if (isAutoBid) 'isAutoBid': true,
      'maxAmount': ?maxAmount,
    });
  }

  void leaveStream(String streamId) {
    _socket?.emit('leave-stream', {'streamId': streamId});
  }

  void onBidError(void Function(String message) handler) {
    _socket?.off('bid-error');
    _socket?.on('bid-error', (data) {
      final msg = data is Map ? (data['message'] as String? ?? 'Bid failed') : 'Bid failed';
      handler(msg);
    });
  }

  void resetStreamState() {
    latestBidUpdate.value = null;
    latestAuctionStarted.value = null;
    latestAuctionClosed.value = null;
    latestAuctionState.value = null;
    latestChatMessage.value = null;
    latestReaction.value = null;
    lastDeletedMessageId.value = null;
    viewerCount.value = 0;
    pinnedMessage.value = null;
    lastBanEvent.value = null;
    latestProductPinned.value = null;
    latestProductUnpinned.value = null;
    latestSoldOut.value = null;
    latestGiveawayStarted.value = null;
    latestGiveawayJoined.value = null;
    latestGiveawayWinner.value = null;
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}
