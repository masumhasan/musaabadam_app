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

  // Chat
  final Rx<Map<String, dynamic>?> latestChatMessage = Rx(null);
  final Rx<Map<String, dynamic>?> latestReaction = Rx(null);
  final Rx<String?> lastDeletedMessageId = Rx(null);

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
  }

  void sendMessage({required String streamId, required String text}) {
    _socket?.emit('send-message', {'streamId': streamId, 'text': text});
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

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }
}
