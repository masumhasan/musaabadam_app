import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_order_service.dart';
import 'package:musaab_adam/core/services/api_favorite_service.dart';
import 'package:musaab_adam/core/services/api_auction_service.dart';
import 'package:musaab_adam/core/services/api_offer_service.dart';
import 'package:musaab_adam/core/services/social_service.dart';
import 'package:musaab_adam/core/services/role_service.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/data/models/order/order_model.dart';
import 'package:musaab_adam/data/models/product/product_model.dart';
import 'package:musaab_adam/data/models/auction/bid_model.dart';
import 'package:musaab_adam/data/models/offer/offer_model.dart';
import 'package:musaab_adam/modules/auth/controllers/auth_controller.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import '../../main_nav/components/app_bar.dart';
import '../../../core/widgets/custom_choice_chip.dart';
import 'package:musaab_adam/core/services/api_tip_service.dart';
import 'package:intl/intl.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  final RoleService _roleService = Get.find<RoleService>();

  int _selectedTabIndex = 0;
  int _selectedChipIndex = 0;
  bool _loading = true;

  // Real Database Lists
  List<OrderModel> _orders = [];
  List<BidModel> _bids = [];
  List<OfferModel> _offers = [];
  List<ProductModel> _favorites = [];
  List<dynamic> _followingSellers = [];
  List<Map<String, dynamic>> _realSellerTips = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _loading = true);
    final isSeller = _roleService.getUpdatedRole() == Role.seller;

    try {
      if (_selectedTabIndex == 0) {
        if (isSeller) {
          _orders = await ApiOrderService.instance.getSellerOrders();
        } else {
          _orders = await ApiOrderService.instance.getMyOrders();
        }
      } else if (_selectedTabIndex == 1) {
        if (!isSeller) {
          _bids = await ApiAuctionService.instance.getMyBids();
        }
      } else if (_selectedTabIndex == 2) {
        if (isSeller) {
          _offers = await ApiOfferService.instance.getSellerOffers();
        } else {
          _offers = await ApiOfferService.instance.getBuyerOffers();
        }
      } else if (_selectedTabIndex == 3) {
        if (isSeller) {
          _realSellerTips = await ApiTipService.instance.getReceivedTips();
        } else {
          if (_selectedChipIndex == 0 || _selectedChipIndex == 3) {
            _favorites = await ApiFavoriteService.instance.list();
          } else if (_selectedChipIndex == 2) {
            final currentUser = Get.find<AuthController>().currentUser.value;
            if (currentUser != null) {
              final res = await SocialService.instance.getFollowing(currentUser.id);
              _followingSellers = res['users'] as List? ?? [];
            }
          }
        }
      }
    } catch (_) {
      // Non-fatal
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  List<String> _getTabLabels(bool isSeller) {
    if (isSeller) {
      return ['Sales', 'Bids', 'Offers', 'Tips'];
    } else {
      return ['Purchases', 'Bids', 'Offers', 'Saved'];
    }
  }

  List<String> _getChipLabels(bool isSeller) {
    if (_selectedTabIndex == 0) {
      return ['All', 'In Progress', 'Completed', 'Refunds', 'Cancelled', 'Pending Review'];
    } else if (_selectedTabIndex == 1) {
      return isSeller ? ['All', 'Active', 'Ended'] : ['All', 'Active', 'Won', 'Lost'];
    } else if (_selectedTabIndex == 2) {
      return isSeller ? ['All', 'Pending', 'Accepted', 'Declined'] : ['All', 'Active', 'Accepted', 'Declined'];
    } else if (_selectedTabIndex == 3) {
      return isSeller ? ['All', 'This Month', 'Past Tips'] : ['All', 'Live Shows', 'Sellers', 'Items'];
    }
    return ['All'];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSeller = _roleService.getUpdatedRole() == Role.seller;
    final tabs = _getTabLabels(isSeller);
    final chips = _getChipLabels(isSeller);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: appBar,
      body: Column(
        children: [
          // Top tabs
          Row(
            children: List.generate(tabs.length, (index) => Expanded(child: _buildTab(tabs[index], index))),
          ),
          const SizedBox(height: 10),
          // Sub-chips scrollbar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 20),
                ...List.generate(chips.length, (index) {
                  return Row(
                    children: [
                      CustomChoiceChip(
                        label: chips[index],
                        borderRadius: 100,
                        padding: const [8, 4],
                        selected: _selectedChipIndex == index,
                        colorChangeable: true,
                        onSelected: (isSelected) {
                          if (isSelected && _selectedChipIndex != index) {
                            setState(() {
                              _selectedChipIndex = index;
                            });
                            // Reload if we switch chips in Saved tab to load followers/favorites
                            if (_selectedTabIndex == 3) {
                              _loadData();
                            }
                          }
                        },
                      ),
                      if (index != chips.length - 1) const SizedBox(width: 10),
                    ],
                  );
                }),
                const SizedBox(width: 20),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Content
          Expanded(
            child: _buildContent(isSeller, colorScheme),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String text, int index) {
    final isSelected = _selectedTabIndex == index;
    return TextButton(
      onPressed: () {
        if (_selectedTabIndex != index) {
          setState(() {
            _selectedTabIndex = index;
            _selectedChipIndex = 0;
          });
          _loadData();
        }
      },
      child: CustomText(
        text: text,
        underline: isSelected,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        underlineWidth: 2,
      ),
    );
  }

  Widget _buildContent(bool isSeller, ColorScheme colorScheme) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_selectedTabIndex == 0) {
      // Real DB Orders
      List<OrderModel> list = _orders;
      if (_selectedChipIndex == 1) {
        list = _orders.where((o) => ['pending', 'confirmed', 'processing', 'shipped', 'delivered'].contains(o.status)).toList();
      } else if (_selectedChipIndex == 2) {
        list = _orders.where((o) => o.status == 'completed').toList();
      } else if (_selectedChipIndex == 3) {
        list = _orders.where((o) => o.status == 'refunded').toList();
      } else if (_selectedChipIndex == 4) {
        list = _orders.where((o) => o.status == 'cancelled').toList();
      } else if (_selectedChipIndex == 5) {
        list = _orders.where((o) => ['delivered', 'completed'].contains(o.status)).toList();
      }

      if (list.isEmpty) {
        return Center(child: CustomText(text: 'No orders found', fontColor: colorScheme.outline));
      }

      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final o = list[index];
          final hasItems = o.items.isNotEmpty;
          final title = hasItems ? o.items.first.title : 'Order';
          final imageUrl = hasItems ? (o.items.first.imageUrl ?? '') : '';
          final dateString = "${o.createdAt.day}/${o.createdAt.month}/${o.createdAt.year % 100}";

          final badgeText = _getCleanOrderStatusLabel(o.status);
          final badgeColor = _getOrderStatusColor(o.status);

          return GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.activityDetailsScreen, arguments: o.id),
            child: ProductTile(
              imageUrl: imageUrl,
              title: title,
              subtitle: isSeller ? 'Sold for: £${o.totalAmount.toStringAsFixed(2)}' : 'Purchased: $dateString',
              badgeText: badgeText,
              badgeColor: badgeColor,
              nameLabel: isSeller ? 'Buyer: ${o.buyerUsername ?? 'buyer'}' : 'From: ${o.sellerUsername ?? 'seller'}',
            ),
          );
        },
      );
    } else if (_selectedTabIndex == 1) {
      if (isSeller) {
        // Seller Bids (Mock placeholder, or empty)
        return Center(child: CustomText(text: 'No auction bids received.', fontColor: colorScheme.outline));
      }

      // Buyer Bids (Real DB Bids)
      List<BidModel> list = _bids;
      if (_selectedChipIndex == 1) { // Active
        list = _bids.where((b) => b.status == 'active' || b.status == 'outbid').toList();
      } else if (_selectedChipIndex == 2) { // Won
        list = _bids.where((b) => b.status == 'won').toList();
      } else if (_selectedChipIndex == 3) { // Lost
        list = _bids.where((b) => b.status == 'lost').toList();
      }

      if (list.isEmpty) {
        return Center(child: CustomText(text: 'No bids found', fontColor: colorScheme.outline));
      }

      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final b = list[index];
          final title = b.productTitle ?? 'Product';
          final imageUrl = b.productImageUrl ?? '';

          return ProductTile(
            imageUrl: imageUrl,
            title: title,
            subtitle: 'Bid: £${b.amount.toStringAsFixed(2)}',
            badgeText: b.status.toUpperCase(),
            badgeColor: b.status == 'won' || b.status == 'active' ? const Color(0xFF008BAA) : const Color(0xffFFA0A0),
            nameLabel: 'Seller: ${b.sellerUsername ?? 'seller'}',
          );
        },
      );
    } else if (_selectedTabIndex == 2) {
      // Real DB Offers (Both Buyer and Seller!)
      List<OfferModel> list = _offers;
      if (_selectedChipIndex == 1) { // Pending
        list = _offers.where((o) => o.status == 'pending').toList();
      } else if (_selectedChipIndex == 2) { // Accepted
        list = _offers.where((o) => o.status == 'accepted').toList();
      } else if (_selectedChipIndex == 3) { // Declined
        list = _offers.where((o) => o.status == 'declined').toList();
      }

      if (list.isEmpty) {
        return Center(child: CustomText(text: 'No offers found', fontColor: colorScheme.outline));
      }

      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final o = list[index];
          final title = o.productTitle ?? 'Product';
          final imageUrl = o.productImageUrl ?? '';

          return ProductTile(
            imageUrl: imageUrl,
            title: title,
            subtitle: 'Offer: £${o.amount.toStringAsFixed(2)}',
            badgeText: o.status.toUpperCase(),
            badgeColor: o.status == 'accepted' || o.status == 'pending' ? const Color(0xFF008BAA) : const Color(0xffFFA0A0),
            nameLabel: isSeller ? 'Offered By: ${o.buyerUsername ?? 'buyer'}' : 'Seller: ${o.sellerUsername ?? 'seller'}',
          );
        },
      );
    } else if (_selectedTabIndex == 3) {
      if (isSeller) {
        // Tips (Real DB data, filtered locally)
        final list = _realSellerTips.where((t) {
          if (_selectedChipIndex == 0) return true;

          DateTime? createdAt;
          try {
            createdAt = DateTime.parse(t['createdAt'].toString());
          } catch (_) {}
          if (createdAt == null) return false;

          final now = DateTime.now();
          final isThisMonth = createdAt.year == now.year && createdAt.month == now.month;

          if (_selectedChipIndex == 1) return isThisMonth;
          if (_selectedChipIndex == 2) return !isThisMonth;
          return true;
        }).toList();

        if (list.isEmpty) {
          return Center(child: CustomText(text: 'No tips found', fontColor: colorScheme.outline));
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemCount: list.length,
          itemBuilder: (context, index) {
            final tip = list[index];
            final buyer = tip['buyerId'] as Map<String, dynamic>? ?? {};
            final buyerName = buyer['displayName']?.toString() ??
                buyer['username']?.toString() ??
                'Anonymous';
            final avatarUrl = buyer['avatarUrl']?.toString() ?? '';
            final message = tip['message']?.toString();
            final amount = tip['amount'] is num
                ? (tip['amount'] as num).toDouble()
                : 0.0;

            DateTime? createdAt;
            try {
              createdAt = DateTime.parse(tip['createdAt'].toString());
            } catch (_) {}
            final dateStr = createdAt != null
                ? DateFormat('yMMMd').add_jm().format(createdAt)
                : '';

            return Card(
              elevation: 0,
              margin: EdgeInsets.only(bottom: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              color: colorScheme.surfaceContainerLow,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedImageWidget(
                            imageUrl: avatarUrl,
                            height: 36.h,
                            width: 36.w,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                text: buyerName.toUpperCase(),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                fontColor: colorScheme.onSurface,
                              ),
                              if (dateStr.isNotEmpty)
                                CustomText(
                                  text: dateStr,
                                  fontSize: 11.sp,
                                  fontColor: colorScheme.onSurfaceVariant,
                                ),
                            ],
                          ),
                        ),
                        CustomText(
                          text: '£${amount.toStringAsFixed(2)}',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          fontColor: colorScheme.primary,
                        ),
                      ],
                    ),
                    if (message != null && message.trim().isNotEmpty) ...[
                      SizedBox(height: 10.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                          ),
                        ),
                        child: CustomText(
                          text: '"$message"',
                          fontSize: 13.sp,
                          fontStyle: FontStyle.italic,
                          fontColor: colorScheme.onSurface,
                          textAlignment: TextAlign.start,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      } else {
        // Saved (Real DB Favorites / Follows)
        if (_selectedChipIndex == 2) {
          // Sellers (real follows!)
          if (_followingSellers.isEmpty) {
            return Center(child: CustomText(text: 'No followed sellers found', fontColor: colorScheme.outline));
          }
          return ListView.builder(
            itemCount: _followingSellers.length,
            itemBuilder: (context, index) {
              final s = _followingSellers[index];
              final username = s['username']?.toString() ?? 'User';
              final displayName = s['displayName']?.toString() ?? username;
              final avatarUrl = s['avatarUrl']?.toString() ?? '';
              final count = s['followersCount'] ?? 0;

              return ProductTile(
                imageUrl: avatarUrl,
                title: displayName,
                subtitle: 'Followers: $count',
                badgeText: 'SELLER',
                badgeColor: const Color(0xFF008BAA),
                nameLabel: '@$username',
              );
            },
          );
        }

        final list = (_selectedChipIndex == 0 || _selectedChipIndex == 3) ? _favorites : <ProductModel>[];

        if (list.isEmpty) {
          return Center(child: CustomText(text: 'No saved items found', fontColor: colorScheme.outline));
        }

        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final p = list[index];
            return ProductTile(
              imageUrl: p.images.isNotEmpty ? p.images.first : '',
              title: p.title,
              subtitle: 'Price: £${p.price.toStringAsFixed(2)}',
              badgeText: p.status.toUpperCase(),
              badgeColor: p.status == 'active' ? const Color(0xFF008BAA) : const Color(0xffFFA0A0),
              nameLabel: 'Condition: ${p.condition.replaceAll('_', ' ').toUpperCase()}',
            );
          },
        );
      }
    }

    return const SizedBox.shrink();
  }

  String _getCleanOrderStatusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
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

  Color _getOrderStatusColor(String status) {
    switch (status) {
      case 'pending':
      case 'confirmed':
      case 'processing':
        return const Color(0xFFFFCC99);
      case 'shipped':
      case 'delivered':
        return const Color(0xFF81D4FA);
      case 'completed':
        return const Color(0xFF008BAA);
      case 'cancelled':
      case 'refunded':
      default:
        return const Color(0xffFFA0A0);
    }
  }
}

class ProductTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;
  final String badgeText;
  final Color badgeColor;
  final String nameLabel;

  const ProductTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.badgeText,
    required this.badgeColor,
    required this.nameLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedImageWidget(
              imageUrl: imageUrl,
              icon: Icons.image_outlined,
              iconSize: 40,
              width: 120,
              height: 120,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                ),
                const SizedBox(height: 4),
                Text(
                  nameLabel,
                  style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.w500, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// MockTipItem removed