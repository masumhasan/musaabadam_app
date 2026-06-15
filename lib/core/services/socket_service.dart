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
      if (data is Map<String, dynamic>) {
        latestBidUpdate.value = data;
      } else if (data is Map) {
        latestBidUpdate.value = Map<String, dynamic>.from(data);
      }
    });
  }

  void joinStream(String streamId) {
    _socket?.emit('join-stream', {'streamId': streamId});
  }

  void placeBid({required String streamId, required String productId, required double amount}) {
    _socket?.emit('place-bid', {
      'streamId': streamId,
      'productId': productId,
      'amount': amount,
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
