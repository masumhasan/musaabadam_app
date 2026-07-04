import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide ApiClient;
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/core/services/socket_service.dart';
import 'package:musaab_adam/core/services/stream_service.dart';
import 'package:musaab_adam/core/services/api_chat_service.dart';
import 'package:musaab_adam/core/services/api_auction_service.dart';
import 'package:musaab_adam/core/services/api_order_service.dart';
import 'package:musaab_adam/core/services/api_giveaway_service.dart';
import 'package:musaab_adam/core/services/api_favorite_service.dart';
import 'package:musaab_adam/data/models/chat/chat_message_model.dart';
import 'package:musaab_adam/data/models/product/product_model.dart';
import 'package:musaab_adam/data/models/stream/stream_model.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:musaab_adam/core/services/social_service.dart';

// ignore_for_file: unawaited_futures

class LivestreamController extends GetxController {
  final Rx<JoinStreamResult?> joinResult = Rx(null);
  final Rx<ProductModel?> pinnedProduct = Rx(null);
  final Rx<Call?> call = Rx(null);
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  // Follow seller state
  final RxBool isFollowingSeller = false.obs;
  final RxBool followLoading = false.obs;

  // Live auction state (driven by socket events)
  final RxInt bidCount = 0.obs;
  final RxString leadingBidderName = ''.obs;
  final RxString leadingBidderId = ''.obs;
  final Rx<Map<String, dynamic>?> lastAuctionResult = Rx(null);
  final RxString auctionState = 'none'.obs; // none | running | paused
  final RxBool isAuctionBusy = false.obs;

  // Live chat state
  final RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;

  // Giveaway state
  final Rx<Map<String, dynamic>?> activeGiveaway = Rx(null);
  final RxBool giveawayJoined = false.obs;
  final RxBool isGiveawayBusy = false.obs;

  Call? _sdkCall;

  String get sellerName => joinResult.value?.stream.sellerName ?? '';
  String? get sellerAvatarUrl => joinResult.value?.stream.sellerAvatarUrl;
  String? get thumbnailUrl => joinResult.value?.stream.thumbnailUrl;
  String get streamTitle => joinResult.value?.stream.title ?? '';
  bool get isHost => joinResult.value?.role == 'host';

  String get viewerCountText {
    // Prefer the live socket count; fall back to the persisted total.
    final live = SocketService.instance.viewerCount.value;
    final count = live > 0 ? live : (joinResult.value?.stream.totalViewers ?? 0);
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }

  // Currently pinned chat message (from socket), or null.
  Map<String, dynamic>? get pinnedMessage => SocketService.instance.pinnedMessage.value;

  StreamModel? get stream => joinResult.value?.stream;

  String? _streamId;

  @override
  void onInit() {
    super.onInit();
    _streamId = Get.arguments as String?;
    if (_streamId != null) {
      _load(_streamId!);
    } else {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    if (_streamId != null) {
      SocketService.instance.leaveStream(_streamId!);
      // End the stream on the backend when the host leaves
      if (isHost) {
        StreamService.instance.endStream(_streamId!).catchError((_) {});
      }
    }
    // Keep the socket connected app-wide for notifications — only leave the room.
    _leaveCall();
    super.onClose();
  }

  void _leaveCall() {
    try { _sdkCall?.leave(); } catch (_) {}
    try { if (StreamVideo.isInitialized()) StreamVideo.reset(); } catch (_) {}
  }

  /// Explicitly ends the stream (for host only). Ends on backend, leaves call, and pops.
  Future<void> endStream() async {
    if (_streamId == null || !isHost) return;
    try {
      await StreamService.instance.endStream(_streamId!);
    } catch (_) {}
    Get.back();
  }

  Future<void> _load(String streamId) async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final result = await StreamService.instance.joinStream(streamId);
      joinResult.value = result;

      if (result.stream.pinnedProducts.isNotEmpty) {
        await _loadPinnedProduct(result.stream.pinnedProducts.first);
      }

      await _initStreamVideo(result);
      await _connectSocket(streamId);

      // Fetch follow status of the seller
      final sellerId = result.stream.sellerId;
      if (sellerId != null) {
        SocialService.instance.getPublicProfile(sellerId).then((profile) {
          isFollowingSeller.value = profile.isFollowing;
        }).catchError((_) {});
      }
    } on DioException {
      hasError.value = true;
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _initStreamVideo(JoinStreamResult result) async {
    final currentUser = Get.find<AuthController>().currentUser.value;
    if (currentUser == null) return;

    if (StreamVideo.isInitialized()) StreamVideo.reset();
    StreamVideo(
      result.apiKey,
      user: User.regular(
        userId: currentUser.id,
        name: currentUser.displayName ?? currentUser.username,
        image: currentUser.avatarUrl,
      ),
      userToken: result.token,
      failIfSingletonExists: false,
    );

    _sdkCall = StreamVideo.instance.makeCall(
      callType: StreamCallType.fromString(result.callType),
      id: result.callId,
    );
    await _sdkCall!.join();
    if (isHost) {
      await _sdkCall!.goLive();
    }
    call.value = _sdkCall;
  }

  Future<void> _connectSocket(String streamId) async {
    SocketService.instance.resetStreamState();
    await SocketService.instance.connect();
    SocketService.instance.joinStream(streamId);

    // Listen for real-time bid updates
    SocketService.instance.latestBidUpdate.listen((update) {
      if (update == null) return;
      final product = pinnedProduct.value;
      if (product == null) return;
      final updatedProductId = update['productId'] as String?;
      if (updatedProductId != product.id) return;

      final newBid = _toDouble(update['currentHighBid']);
      pinnedProduct.value = _copyProductWithBid(product, newBid);

      if (update['bidCount'] != null) bidCount.value = (update['bidCount'] as num).toInt();
      final leader = update['leadingBidder'];
      if (leader is Map) {
        leadingBidderName.value = leader['displayName']?.toString() ?? '';
        leadingBidderId.value = leader['userId']?.toString() ?? '';
      }
    });

    // A pinned auction was opened by the seller — refresh the product state.
    SocketService.instance.latestAuctionStarted.listen((started) {
      if (started == null) return;
      auctionState.value = 'running';
      final productId = started['productId'] as String?;
      if (productId != null) _loadPinnedProduct(productId);
    });

    // Auction pause/resume/cancel state changes.
    SocketService.instance.latestAuctionState.listen((data) {
      if (data == null) return;
      final ev = data['_event'];
      if (ev == 'auction-paused') {
        auctionState.value = 'paused';
        Get.snackbar('Auction paused', 'The seller paused bidding.', snackPosition: SnackPosition.BOTTOM);
      } else if (ev == 'auction-resumed') {
        auctionState.value = 'running';
      } else if (ev == 'auction-cancelled') {
        auctionState.value = 'none';
        Get.snackbar('Auction cancelled', 'The seller cancelled this auction.', snackPosition: SnackPosition.BOTTOM);
      }
    });

    // Auction closed — notify the winner so they can complete checkout.
    SocketService.instance.latestAuctionClosed.listen((r) {
      auctionState.value = 'none';
      _onAuctionClosed(r);
    });

    // Buy-now realtime: pinned product changes + sold-out.
    SocketService.instance.latestProductPinned.listen((data) {
      if (data == null || data['streamId'] != streamId) return;
      final productId = data['productId']?.toString();
      if (productId != null) _loadPinnedProduct(productId);
    });
    SocketService.instance.latestProductUnpinned.listen((data) {
      if (data == null || data['streamId'] != streamId) return;
      if (data['productId'] == pinnedProduct.value?.id) pinnedProduct.value = null;
    });
    SocketService.instance.latestSoldOut.listen((data) {
      if (data == null || data['streamId'] != streamId) return;
      if (data['productId'] == pinnedProduct.value?.id) {
        Get.snackbar('Sold out', 'This item just sold out.', snackPosition: SnackPosition.BOTTOM);
      }
    });

    // ── Giveaways ──
    _loadActiveGiveaway(streamId);
    SocketService.instance.latestGiveawayStarted.listen((data) {
      if (data == null || data['streamId'] != streamId) return;
      activeGiveaway.value = data;
      giveawayJoined.value = false;
    });
    SocketService.instance.latestGiveawayJoined.listen((data) {
      if (data == null) return;
      final g = activeGiveaway.value;
      if (g != null && g['id'] == data['giveawayId']) {
        activeGiveaway.value = {...g, 'entryCount': data['entryCount']};
      }
    });
    SocketService.instance.latestGiveawayWinner.listen((data) {
      if (data == null || data['streamId'] != streamId) return;
      final winner = data['winner'];
      final myId = Get.find<AuthController>().currentUser.value?.id;
      final title = data['title'] ?? 'the giveaway';
      if (winner is Map && winner['userId'] == myId) {
        Get.snackbar('You won! 🎁', 'You won $title!', snackPosition: SnackPosition.TOP, duration: const Duration(seconds: 6));
      } else if (winner is Map) {
        Get.snackbar('Giveaway winner', '${winner['displayName'] ?? 'Someone'} won $title', snackPosition: SnackPosition.BOTTOM);
      }
      activeGiveaway.value = null;
      giveawayJoined.value = false;
    });

    SocketService.instance.onBidError((msg) {
      Get.snackbar('Bid Error', msg, snackPosition: SnackPosition.BOTTOM);
    });

    // ── Live chat ──
    _loadChatHistory(streamId);

    SocketService.instance.latestChatMessage.listen((data) {
      if (data == null) return;
      if (data['streamId'] != streamId) return;
      messages.add(ChatMessageModel.fromJson(data));
      if (messages.length > 200) messages.removeRange(0, messages.length - 200);
    });

    SocketService.instance.lastDeletedMessageId.listen((id) {
      if (id == null) return;
      messages.removeWhere((m) => m.id == id);
    });

    SocketService.instance.onChatError((msg) {
      Get.snackbar('Chat', msg, snackPosition: SnackPosition.BOTTOM);
    });

    // If THIS user is banned, leave the stream.
    SocketService.instance.lastBanEvent.listen((data) {
      if (data == null) return;
      final myId = Get.find<AuthController>().currentUser.value?.id;
      final targetId = data['userId']?.toString();
      final isMe = targetId == null || targetId == myId; // 'banned' event has no userId
      if (isMe && data['banned'] != false) {
        Get.snackbar('Removed', data['message']?.toString() ?? 'You were removed from this stream.',
            snackPosition: SnackPosition.BOTTOM);
        Get.back();
      }
    });
  }

  // ── Moderator actions ──
  void banViewer(String userId) {
    final streamId = _streamId;
    if (streamId == null) return;
    SocketService.instance.banUser(streamId: streamId, userId: userId, ban: true);
    Get.snackbar('Moderation', 'User banned.', snackPosition: SnackPosition.BOTTOM);
  }

  void pinChatMessage(String messageId) {
    final streamId = _streamId;
    if (streamId == null) return;
    SocketService.instance.pinMessage(streamId: streamId, messageId: messageId);
  }

  void unpinChatMessage() {
    final streamId = _streamId;
    if (streamId == null) return;
    SocketService.instance.pinMessage(streamId: streamId, messageId: null);
  }

  bool get canModerate => isHost;

  Future<void> _loadChatHistory(String streamId) async {
    try {
      final history = await ApiChatService.instance.getHistory(streamId);
      messages.assignAll(history);
    } catch (_) {}
  }

  // Message the user is currently replying to (null = not replying).
  final Rx<ChatMessageModel?> replyingTo = Rx(null);
  void startReply(ChatMessageModel m) => replyingTo.value = m;
  void cancelReply() => replyingTo.value = null;

  /// Sends a chat message over the socket (optimistic broadcast comes back via
  /// the `chat-message` event, so we don't append locally here).
  void sendComment(String text) {
    final streamId = _streamId;
    final trimmed = text.trim();
    if (streamId == null || trimmed.isEmpty) return;
    SocketService.instance.sendMessage(streamId: streamId, text: trimmed, replyTo: replyingTo.value?.id);
    replyingTo.value = null;
  }

  /// Host sets chat slow-mode interval (seconds; 0 = off).
  void setSlowMode(int seconds) {
    final streamId = _streamId;
    if (streamId == null) return;
    SocketService.instance.setSlowMode(streamId: streamId, seconds: seconds);
    Get.snackbar('Slow mode', seconds == 0 ? 'Turned off' : 'Set to ${seconds}s', snackPosition: SnackPosition.BOTTOM);
  }

  void sendReaction(String emoji) {
    final streamId = _streamId;
    if (streamId == null) return;
    SocketService.instance.sendReaction(streamId: streamId, emoji: emoji);
  }

  // ── Host auction controls ──
  Future<void> startAuctionRound({int durationMs = 30000, double? startingPrice, double? reservePrice, double? bidIncrement}) async {
    final product = pinnedProduct.value;
    final streamId = _streamId;
    if (product == null || streamId == null || isAuctionBusy.value) return;
    isAuctionBusy.value = true;
    try {
      await ApiAuctionService.instance.startAuction(
        productId: product.id,
        streamId: streamId,
        durationMs: durationMs,
        startingPrice: startingPrice,
        reservePrice: reservePrice,
        bidIncrement: bidIncrement,
      );
      auctionState.value = 'running';
    } on DioException catch (e) {
      Get.snackbar('Auction', ApiAuctionService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isAuctionBusy.value = false;
    }
  }

  Future<void> _auctionAction(Future<Map<String, dynamic>> Function(String productId) action) async {
    final product = pinnedProduct.value;
    if (product == null || isAuctionBusy.value) return;
    isAuctionBusy.value = true;
    try {
      await action(product.id);
    } on DioException catch (e) {
      Get.snackbar('Auction', ApiAuctionService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isAuctionBusy.value = false;
    }
  }

  Future<void> pauseAuction() => _auctionAction(ApiAuctionService.instance.pauseAuction);
  Future<void> resumeAuction() => _auctionAction(ApiAuctionService.instance.resumeAuction);
  Future<void> cancelAuction() => _auctionAction(ApiAuctionService.instance.cancelAuction);

  // ── Giveaways ──
  Future<void> _loadActiveGiveaway(String streamId) async {
    try {
      final list = await ApiGiveawayService.instance.forStream(streamId);
      if (list.isNotEmpty) activeGiveaway.value = list.first;
    } catch (_) {}
  }

  Future<void> joinGiveaway() async {
    final g = activeGiveaway.value;
    if (g == null || isGiveawayBusy.value) return;
    isGiveawayBusy.value = true;
    try {
      await ApiGiveawayService.instance.join(g['id'].toString());
      giveawayJoined.value = true;
      Get.snackbar('Entered', 'You joined the giveaway. Good luck!', snackPosition: SnackPosition.BOTTOM);
    } on DioException catch (e) {
      Get.snackbar('Giveaway', ApiGiveawayService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isGiveawayBusy.value = false;
    }
  }

  Future<void> hostCreateGiveaway(String title, String restriction) async {
    final streamId = _streamId;
    if (streamId == null || isGiveawayBusy.value) return;
    isGiveawayBusy.value = true;
    try {
      final g = await ApiGiveawayService.instance.create(
        title: title,
        streamId: streamId,
        productId: pinnedProduct.value?.id,
        restriction: restriction,
      );
      activeGiveaway.value = g;
    } on DioException catch (e) {
      Get.snackbar('Giveaway', ApiGiveawayService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isGiveawayBusy.value = false;
    }
  }

  Future<void> hostDrawGiveaway() async {
    final g = activeGiveaway.value;
    if (g == null || isGiveawayBusy.value) return;
    isGiveawayBusy.value = true;
    try {
      await ApiGiveawayService.instance.draw(g['id'].toString());
    } on DioException catch (e) {
      Get.snackbar('Giveaway', ApiGiveawayService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isGiveawayBusy.value = false;
    }
  }

  // ── Wishlist: favorite the pinned product ──
  final RxBool pinnedFavorited = false.obs;
  Future<void> toggleFavorite() async {
    final p = pinnedProduct.value;
    if (p == null) return;
    try {
      pinnedFavorited.value = await ApiFavoriteService.instance.toggle(p.id);
    } on DioException catch (e) {
      Get.snackbar('Wishlist', ApiFavoriteService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    }
  }

  // ── One-tap Buy Now on the pinned product ──
  final RxBool isBuying = false.obs;
  Future<void> buyNow() async {
    final product = pinnedProduct.value;
    if (product == null || isBuying.value) return;
    isBuying.value = true;
    try {
      final order = await ApiOrderService.instance.createOrder(
        items: [
          {'productId': product.id, 'quantity': 1},
        ],
        streamId: _streamId,
      );
      Get.toNamed(AppRoutes.checkout, arguments: order.id);
    } on DioException catch (e) {
      Get.snackbar('Buy Now', ApiOrderService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isBuying.value = false;
    }
  }

  void _onAuctionClosed(Map<String, dynamic>? result) {
    if (result == null) return;
    final product = pinnedProduct.value;
    if (product != null && result['productId'] == product.id) {
      pinnedProduct.value = _copyProductWithBid(product, _toDouble(result['currentHighBid']));
    }
    lastAuctionResult.value = result;

    final myId = Get.find<AuthController>().currentUser.value?.id;
    final winner = result['winner'];
    if (result['sold'] == true && winner is Map && winner['userId'] == myId) {
      // Winner — surface the pending order for checkout (payments pillar).
      final orderId = result['orderId']?.toString();
      Get.snackbar(
        'You won! 🎉',
        'Tap to complete payment for "${product?.title ?? 'your item'}".',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 6),
        onTap: (_) {
          if (orderId != null) Get.toNamed(AppRoutes.checkout, arguments: orderId);
        },
      );
    }
  }

  Future<void> _loadPinnedProduct(String productId) async {
    try {
      final response = await ApiClient.instance.get(ApiConstants.product(productId));
      final raw = response.data['data'];
      final json = raw is Map && raw.containsKey('product')
          ? raw['product'] as Map<String, dynamic>
          : raw as Map<String, dynamic>;
      pinnedProduct.value = ProductModel.fromJson(json);
    } catch (_) {}
  }

  void placeBid(double amount, {double? maxAmount, bool isAutoBid = false}) {
    final product = pinnedProduct.value;
    final streamId = _streamId;
    if (product == null || streamId == null) return;

    SocketService.instance.placeBid(
      streamId: streamId,
      productId: product.id,
      amount: amount,
      maxAmount: maxAmount,
      isAutoBid: isAutoBid,
    );
  }

  ProductModel _copyProductWithBid(ProductModel p, double newBid) => ProductModel(
        id: p.id,
        sellerId: p.sellerId,
        title: p.title,
        description: p.description,
        category: p.category,
        condition: p.condition,
        listingType: p.listingType,
        status: p.status,
        price: p.price,
        startingPrice: p.startingPrice,
        reservePrice: p.reservePrice,
        currentHighBid: newBid,
        auctionEndsAt: p.auctionEndsAt,
        quantity: p.quantity,
        quantitySold: p.quantitySold,
        images: p.images,
        flashSale: p.flashSale,
        acceptOffers: p.acceptOffers,
        maxDiscount: p.maxDiscount,
        reserveForLive: p.reserveForLive,
        hazardousMaterials: p.hazardousMaterials,
        sku: p.sku,
        costPerItem: p.costPerItem,
        shippingWeight: p.shippingWeight,
        tags: p.tags,
        viewsCount: p.viewsCount,
        favoritesCount: p.favoritesCount,
        createdAt: p.createdAt,
      );

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is int) return v.toDouble();
    if (v is double) return v;
    return double.tryParse(v.toString()) ?? 0.0;
  }

  Future<void> toggleFollowSeller() async {
    final sellerId = joinResult.value?.stream.sellerId;
    if (sellerId == null || followLoading.value) return;
    followLoading.value = true;
    try {
      if (isFollowingSeller.value) {
        await SocialService.instance.unfollowUser(sellerId);
        isFollowingSeller.value = false;
        Get.snackbar('Success', 'Unfollowed successfully', snackPosition: SnackPosition.BOTTOM);
      } else {
        await SocialService.instance.followUser(sellerId);
        isFollowingSeller.value = true;
        Get.snackbar('Success', 'Followed successfully', snackPosition: SnackPosition.BOTTOM);
      }
    } on DioException catch (e) {
      Get.snackbar('Error', SocialService.extractError(e), snackPosition: SnackPosition.BOTTOM);
    } catch (_) {
      Get.snackbar('Error', 'Failed to update follow status', snackPosition: SnackPosition.BOTTOM);
    } finally {
      followLoading.value = false;
    }
  }

}
