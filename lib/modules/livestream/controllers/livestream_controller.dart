import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' hide ApiClient;
import 'package:musaab_adam/core/network/api_client.dart';
import 'package:musaab_adam/core/network/api_constants.dart';
import 'package:musaab_adam/core/services/socket_service.dart';
import 'package:musaab_adam/core/services/stream_service.dart';
import 'package:musaab_adam/data/models/product/product_model.dart';
import 'package:musaab_adam/data/models/stream/stream_model.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';

// ignore_for_file: unawaited_futures

class LivestreamController extends GetxController {
  final Rx<JoinStreamResult?> joinResult = Rx(null);
  final Rx<ProductModel?> pinnedProduct = Rx(null);
  final Rx<Call?> call = Rx(null);
  final RxBool isLoading = true.obs;
  final RxBool hasError = false.obs;

  Call? _sdkCall;

  String get sellerName => joinResult.value?.stream.sellerName ?? '';
  String? get sellerAvatarUrl => joinResult.value?.stream.sellerAvatarUrl;
  String? get thumbnailUrl => joinResult.value?.stream.thumbnailUrl;
  String get streamTitle => joinResult.value?.stream.title ?? '';
  bool get isHost => joinResult.value?.role == 'host';

  String get viewerCountText {
    final count = joinResult.value?.stream.totalViewers ?? 0;
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}k';
    return count.toString();
  }

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
    SocketService.instance.disconnect();
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
    await _sdkCall!.getOrCreate();
    call.value = _sdkCall;
  }

  Future<void> _connectSocket(String streamId) async {
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
    });

    SocketService.instance.onBidError((msg) {
      Get.snackbar('Bid Error', msg, snackPosition: SnackPosition.BOTTOM);
    });
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

  void placeBid(double amount) {
    final product = pinnedProduct.value;
    final streamId = _streamId;
    if (product == null || streamId == null) return;

    SocketService.instance.placeBid(
      streamId: streamId,
      productId: product.id,
      amount: amount,
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

}
