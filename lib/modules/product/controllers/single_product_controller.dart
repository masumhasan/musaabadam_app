import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_offer_service.dart';
import 'package:musaab_adam/core/services/api_review_service.dart';
import 'package:musaab_adam/core/services/product_service.dart';
import 'package:musaab_adam/core/services/social_service.dart';
import 'package:musaab_adam/data/models/product/product_model.dart';
import 'package:musaab_adam/data/models/review/review_model.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import 'package:share_plus/share_plus.dart';

class SingleProductController extends GetxController {
  final Rxn<ProductModel> product = Rxn<ProductModel>();
  final RxBool isLoading = true.obs;
  final RxInt selectedTab = 0.obs; // 0 = Details, 1 = Seller Info
  final RxBool isSaved = false.obs; // UI only save state
  final RxBool isFollowing = false.obs;
  final RxBool actionLoading = false.obs;

  // Seller info & dynamic stats
  final Rxn<Map<String, dynamic>> sellerProfile = Rxn<Map<String, dynamic>>();
  final RxList<ProductModel> sellerProducts = <ProductModel>[].obs;
  final RxList<ReviewModel> sellerReviews = <ReviewModel>[].obs;
  final RxDouble sellerRating = 5.0.obs;
  final RxInt ratingCount = 0.obs;
  final RxInt followersCount = 0.obs;
  final RxInt itemsSold = 0.obs;
  final RxString avgShipTime = '2d'.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is ProductModel) {
      product.value = args;
      _loadProductDetails(args.id, passedProduct: args);
    } else if (args is Map) {
      final p = args['product'] as ProductModel?;
      final id = args['productId'] as String? ?? p?.id;
      if (p != null) product.value = p;
      if (id != null) {
        _loadProductDetails(id, passedProduct: p);
      } else {
        isLoading.value = false;
      }
    } else if (args is String) {
      _loadProductDetails(args);
    } else {
      isLoading.value = false;
    }
  }

  Future<void> _loadProductDetails(String productId, {ProductModel? passedProduct}) async {
    isLoading.value = true;
    try {
      if (passedProduct == null) {
        final fetched = await ProductService.instance.getPublicProducts(status: 'all');
        final match = fetched.firstWhereOrNull((p) => p.id == productId);
        if (match != null) product.value = match;
      }

      final p = product.value;
      if (p != null && p.sellerId.isNotEmpty) {
        await Future.wait([
          _loadSellerProfile(p.sellerId),
          _loadSellerProducts(p.sellerId),
          _loadSellerReviews(p.sellerId),
        ]);
      }
    } catch (e) {
      debugPrint('Error loading single product details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadSellerProfile(String sellerId) async {
    try {
      final res = await SocialService.instance.getPublicProfile(sellerId);
      sellerProfile.value = {
        '_id': res.id,
        'displayName': res.displayNameOrUsername,
        'username': res.username,
        'avatarUrl': res.avatarUrl,
        'bio': res.bio,
      };
      isFollowing.value = res.isFollowing;
      followersCount.value = res.followersCount;

      final sp = res.sellerProfile;
      if (sp != null) {
        if (sp['averageRating'] != null) {
          sellerRating.value = (sp['averageRating'] as num).toDouble();
        } else if (res.buyerRating > 0) {
          sellerRating.value = res.buyerRating;
        }
        if (sp['totalSales'] != null) {
          itemsSold.value = (sp['totalSales'] as num).toInt();
        }
        if (sp['avgShipTime'] != null && sp['avgShipTime'].toString().isNotEmpty) {
          avgShipTime.value = sp['avgShipTime'].toString();
        }
      } else if (res.buyerRating > 0) {
        sellerRating.value = res.buyerRating;
      }
    } catch (_) {}
  }

  Future<void> _loadSellerProducts(String sellerId) async {
    try {
      final list = await ProductService.instance.getPublicProducts(sellerId: sellerId, status: 'all');
      sellerProducts.assignAll(list.where((element) => element.id != product.value?.id).toList());

      // If itemsSold hasn't been set by seller profile, calculate total quantity sold
      if (itemsSold.value == 0) {
        final soldCount = list.fold<int>(0, (sum, item) => sum + item.quantitySold);
        itemsSold.value = soldCount;
      }
    } catch (_) {}
  }

  Future<void> _loadSellerReviews(String sellerId) async {
    try {
      final data = await ApiReviewService.instance.getSellerReviews(sellerId);
      sellerReviews.assignAll(data.reviews);
      if (data.averageRating > 0) {
        sellerRating.value = data.averageRating;
      }
      ratingCount.value = data.ratingCount;
    } catch (_) {}
  }

  String formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)} M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)} K';
    return count.toString();
  }

  void toggleSaveUI() {
    isSaved.value = !isSaved.value;
    Get.snackbar(
      isSaved.value ? 'Saved' : 'Removed',
      isSaved.value ? 'Product saved to your favorites (UI preview)' : 'Product removed from saved items',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.black.withValues(alpha: 0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  void shareProduct() {
    final p = product.value;
    if (p != null) {
      // ignore: deprecated_member_use
      Share.share('Check out this ${p.title} on BidsRush for £${p.price.toStringAsFixed(2)}!');
    }
  }

  void openMessage() {
    final p = product.value;
    final seller = sellerProfile.value;
    final sellerId = p?.sellerId ?? seller?['_id'] ?? seller?['id'];
    final sellerName = seller?['displayName'] ?? seller?['username'] ?? 'Seller';
    final avatar = seller?['avatarUrl'] ?? '';

    if (sellerId != null && sellerId.toString().isNotEmpty) {
      Get.toNamed(AppRoutes.messageScreen, arguments: {
        'id': sellerId.toString(),
        'name': sellerName,
        'avatar': avatar,
      });
    } else {
      Get.snackbar('Notice', 'Seller contact information unavailable');
    }
  }

  Future<void> toggleFollow() async {
    final p = product.value;
    if (p == null || p.sellerId.isEmpty) return;
    actionLoading.value = true;
    try {
      if (isFollowing.value) {
        await SocialService.instance.unfollowUser(p.sellerId);
        isFollowing.value = false;
        if (followersCount.value > 0) followersCount.value--;
        Get.snackbar('Unfollowed', 'You unfollowed this seller');
      } else {
        await SocialService.instance.followUser(p.sellerId);
        isFollowing.value = true;
        followersCount.value++;
        Get.snackbar('Following', 'You are now following this seller');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update follow status');
    } finally {
      actionLoading.value = false;
    }
  }

  void makeOffer() {
    final p = product.value;
    if (p == null) return;
    final amountController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('Make an Offer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                prefixText: '£ ',
                labelText: 'Offer Amount (Original: £${p.price.toStringAsFixed(2)})',
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text);
              if (amount == null || amount <= 0) {
                Get.snackbar('Error', 'Please enter a valid amount');
                return;
              }
              Get.back();
              try {
                await ApiOfferService.instance.createOffer(productId: p.id, amount: amount);
                Get.snackbar('Success', 'Offer sent successfully!', backgroundColor: Colors.green, colorText: Colors.white);
              } catch (_) {
                Get.snackbar('Error', 'Failed to send offer');
              }
            },
            child: const Text('Submit Offer'),
          ),
        ],
      ),
    );
  }

  void buyNow() {
    final p = product.value;
    if (p == null) return;
    Get.toNamed(AppRoutes.checkout, arguments: {
      'product': p,
      'price': p.effectivePrice,
    });
  }
}
