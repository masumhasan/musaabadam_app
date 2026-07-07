import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_order_service.dart';
import 'package:musaab_adam/core/services/social_service.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/data/models/order/order_model.dart';
import 'package:musaab_adam/data/models/social/public_profile_model.dart';
import 'package:musaab_adam/routes/app_pages.dart';

import '../../../core/utils/app_constants.dart';
import '../../../core/widgets/cached_image_widget.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/tile_button.dart';

class ActivityDetailsScreen extends StatefulWidget {
  const ActivityDetailsScreen({super.key});

  @override
  State<ActivityDetailsScreen> createState() => _ActivityDetailsScreenState();
}

class _ActivityDetailsScreenState extends State<ActivityDetailsScreen> {
  late final String _orderId;
  OrderModel? _order;
  PublicProfileModel? _sellerProfile;
  bool _loading = true;
  bool _followLoading = false;
  bool _isFollowing = false;
  int _followersCount = 0;

  @override
  void initState() {
    super.initState();
    _orderId = Get.arguments as String? ?? '';
    _loadData();
  }

  Future<void> _loadData() async {
    if (_orderId.isEmpty) {
      setState(() => _loading = false);
      return;
    }
    setState(() => _loading = true);
    try {
      final order = await ApiOrderService.instance.getOrder(_orderId);
      _order = order;
      
      // Load seller public profile for avatar, stats, bio, and follow status
      final profile = await SocialService.instance.getPublicProfile(order.sellerId);
      _sellerProfile = profile;
      _isFollowing = profile.isFollowing;
      _followersCount = profile.followersCount;
    } catch (_) {
      // Non-fatal
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _toggleFollow() async {
    if (_sellerProfile == null || _followLoading) return;
    setState(() => _followLoading = true);
    try {
      if (_isFollowing) {
        await SocialService.instance.unfollowUser(_sellerProfile!.id);
        setState(() {
          _isFollowing = false;
          if (_followersCount > 0) _followersCount--;
        });
      } else {
        await SocialService.instance.followUser(_sellerProfile!.id);
        setState(() {
          _isFollowing = true;
          _followersCount++;
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update follow status', snackPosition: SnackPosition.BOTTOM);
    } finally {
      setState(() => _followLoading = false);
    }
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return '';
  }

  String _getCleanOrderStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Order Placed';
      case 'confirmed':
        return 'Confirmed';
      case 'processing':
        return 'Preparing Package';
      case 'shipped':
        return 'Shipped';
      case 'delivered':
        return 'Delivered';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'refunded':
        return 'Refunded';
      default:
        return status.toUpperCase();
    }
  }

  double _getProgressValue(String status) {
    switch (status) {
      case 'pending':
      case 'confirmed':
        return 0.2;
      case 'processing':
        return 0.5;
      case 'shipped':
        return 0.8;
      case 'delivered':
      case 'completed':
        return 1.0;
      case 'cancelled':
      case 'refunded':
      default:
        return 0.0;
    }
  }

  String _getProgressDescription(String status) {
    switch (status) {
      case 'pending':
      case 'confirmed':
        return 'Your order has been confirmed by the seller and is waiting to be processed.';
      case 'processing':
        return 'The seller is preparing your package for shipment.';
      case 'shipped':
        return 'This seller has printed the shipping label, which means your order is being prepared for shipment! Once the package is scanned, you\'ll receive tracking updates to follow its journey.';
      case 'delivered':
        return 'Your package has been delivered! Please confirm receipt to complete the order.';
      case 'completed':
        return 'This order has been completed successfully.';
      case 'cancelled':
        return 'This order has been cancelled.';
      case 'refunded':
        return 'This order has been refunded.';
      default:
        return 'Status update available.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_loading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          title: const Text("Activity", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_order == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          title: const Text("Activity", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(child: Text('Order not found.')),
      );
    }

    final hasItems = _order!.items.isNotEmpty;
    final productTitle = hasItems ? _order!.items.first.title : 'Order';
    final productQty = hasItems ? _order!.items.first.quantity : 1;
    final orderPlacedDate = "${_order!.createdAt.day} ${_getMonthName(_order!.createdAt.month)}, ${_order!.createdAt.year}";
    final orderDetailsDate = "${_order!.createdAt.day} ${_getMonthName(_order!.createdAt.month)} ${_order!.createdAt.year}";

    final statusText = _getCleanOrderStatusLabel(_order!.status);
    final progressValue = _getProgressValue(_order!.status);
    final progressDesc = _getProgressDescription(_order!.status);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text("Activity", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Text(statusText, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text("Order placed $orderPlacedDate", style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 12),

          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressValue,
              minHeight: 12,
              backgroundColor: Colors.grey[300],
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFF59D)), // Light yellow
            ),
          ),
          const SizedBox(height: 12),

          Text(
            progressDesc,
            style: const TextStyle(color: Colors.grey, height: 1.4),
          ),
          const SizedBox(height: 20),

          // Primary Actions
          TileButton(
            title: "Message the seller",
            defaultIcon: Icons.chat_bubble_outline,
            onClick: () {
              Get.toNamed(AppRoutes.messageScreen, arguments: {
                'id': _order!.sellerId,
                'name': _sellerProfile?.displayNameOrUsername ?? _order!.sellerUsername ?? 'Seller',
                'avatar': _sellerProfile?.avatarUrl,
              });
            },
          ),
          const SizedBox(height: 12),
          TileButton(
            title: "Get help with this purchase",
            defaultIcon: Icons.help_outline,
            onClick: () {
              Get.toNamed(AppRoutes.purchaseHelpScreen);
            },
          ),
          const SizedBox(height: 12),
          TileButton(
            title: "Refer a friend, earn up to £200",
            defaultIcon: Icons.monetization_on_outlined,
            onClick: () {
              Get.toNamed(AppRoutes.rewardPerksScreen);
            },
          ),
          const SizedBox(height: 12),
          TileButton(
            title: "Track your purchase",
            defaultIcon: Icons.location_on_outlined,
            onClick: () {
              Get.toNamed(AppRoutes.orderTrackingScreen, arguments: _order!.id);
            },
          ),

          const SizedBox(height: 24),
          Text(productTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          const Text("Order Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const Divider(),

          // Order Details Table
          _buildDetailRow("Order ID", _order!.id),
          _buildDetailRow("Order date", orderDetailsDate),
          _buildDetailRow("Sort by", _sellerProfile?.displayNameOrUsername ?? _order!.sellerUsername ?? 'Seller'),
          _buildDetailRow("QTY", productQty.toString()),

          const SizedBox(height: 20),

          // Bottom Actions
          TileButton(
            title: "Receipt & shipping details",
            defaultIcon: Icons.inventory_2_outlined,
            onClick: () {
              Get.toNamed(AppRoutes.receiptDetailsScreen, arguments: _order!.id);
            },
          ),
          const SizedBox(height: 12),
          TileButton(
            title: "Video receipt",
            defaultIcon: Icons.videocam_outlined,
            onClick: () {
              Get.toNamed(AppRoutes.videoReceiptScreen, arguments: _order!.id);
            },
          ),
          const SizedBox(height: 24),
          const Text(
            'About the seller',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Seller Header
          Center(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: CachedImageWidget(
                    imageUrl: _sellerProfile?.avatarUrl ?? Dummy.user1,
                    height: 80,
                    width: 80,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _sellerProfile?.displayNameOrUsername ?? _order!.sellerUsername ?? 'Seller',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Stats Banner
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF008EAF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatColumn(_sellerProfile?.buyerRating.toStringAsFixed(1) ?? '0.0', 'Rating', isStar: true),
                _buildDivider(),
                _buildStatColumn(_formatCount(_followersCount), 'Followers'),
                _buildDivider(),
                _buildStatColumn('7.4 K', 'Sold'), // Mock placeholder or calculate from store if available
                _buildDivider(),
                _buildStatColumn('2d', 'Avg Ship'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            _sellerProfile?.bio ?? 'Hi! I\'m here to make your shopping easy and enjoyable. I offer quality items, fast responses, and honest service. Happy to help anytime!',
            style: const TextStyle(color: Colors.black87, height: 1.4),
          ),
          const SizedBox(height: 20),
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  label: _isFollowing ? 'Unfollow' : 'Follow',
                  buttonHeight: 40,
                  isLoading: _followLoading,
                  onPressed: _toggleFollow,
                  backgroundColor: _isFollowing ? Colors.grey.shade500 : colorScheme.primary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.otherUserProfileScreen, arguments: _order!.sellerId);
                },
                child: const Text(
                  'View All',
                  style: TextStyle(color: Color(0xFF008EAF), fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          // Feedback Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Seller Feedback (1.9k)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 15),
          _buildFeedbackTile(),
          const SizedBox(height: 30),
          // Product Section
          const Text(
            'More from this seller',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _buildProductRow(),
          const SizedBox(height: 40),
          // Bottom Action
          CustomButton(
            label: AppStrings.viewProfile,
            buttonHeight: 45,
            onPressed: () {
              Get.toNamed(AppRoutes.otherUserProfileScreen, arguments: _order!.sellerId);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black87, fontSize: 15)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black54, fontSize: 15),
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String value, String label, {bool isStar = false}) {
    return Column(
      children: [
        Row(
          children: [
            if (isStar) const Icon(Icons.star, color: Colors.orange, size: 18),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 30, width: 1, color: Colors.white24);
  }

  Widget _buildFeedbackTile() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: CachedImageWidget(
            imageUrl: Dummy.user2,
            height: 50,
            width: 50,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Isabela Silveira', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Desenvolvedora', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
        Row(
          children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.orange, size: 18)),
        )
      ],
    );
  }

  Widget _buildProductRow() {
    final hasItems = _order!.items.isNotEmpty;
    final title = hasItems ? _order!.items.first.title : 'Product';
    final imageUrl = hasItems ? (_order!.items.first.imageUrl ?? '') : '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: CachedImageWidget(
            imageUrl: imageUrl,
            height: 120,
            width: 120,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            const Text('One Size', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(
              'Price: £${_order!.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }

  String _formatCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)} K';
    }
    return count.toString();
  }
}