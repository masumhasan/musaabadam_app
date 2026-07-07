import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:musaab_adam/core/services/api_order_service.dart';
import 'package:musaab_adam/core/services/api_favorite_service.dart';
import 'package:musaab_adam/core/services/role_service.dart';
import 'package:musaab_adam/core/utils/app_constants.dart';
import 'package:musaab_adam/core/utils/app_strings.dart';
import 'package:musaab_adam/core/widgets/cached_image_widget.dart';
import 'package:musaab_adam/core/widgets/custom_text.dart';
import 'package:musaab_adam/data/models/order/order_model.dart';
import 'package:musaab_adam/data/models/product/product_model.dart';
import 'package:musaab_adam/routes/app_pages.dart';
import '../../main_nav/components/app_bar.dart';
import '../../../core/widgets/custom_choice_chip.dart';

class MockBidItem {
  final String title;
  final String imageUrl;
  final double amount;
  final String status;
  final String sellerName;

  const MockBidItem({
    required this.title,
    required this.imageUrl,
    required this.amount,
    required this.status,
    required this.sellerName,
  });
}

class MockOfferItem {
  final String title;
  final String imageUrl;
  final double amount;
  final String status;
  final String sellerName;

  const MockOfferItem({
    required this.title,
    required this.imageUrl,
    required this.amount,
    required this.status,
    required this.sellerName,
  });
}

class MockTipItem {
  final String senderName;
  final String imageUrl;
  final double amount;
  final String streamTitle;
  final String date;
  final bool isThisMonth;

  const MockTipItem({
    required this.senderName,
    required this.imageUrl,
    required this.amount,
    required this.streamTitle,
    required this.date,
    required this.isThisMonth,
  });
}

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
  List<ProductModel> _favorites = [];

  // Mock Datasets
  final List<MockBidItem> _mockBuyerBids = [
    const MockBidItem(
      title: 'Vintage Leather Jacket',
      imageUrl: Dummy.product1,
      amount: 120.0,
      status: 'Active',
      sellerName: 'retro_vintage',
    ),
    const MockBidItem(
      title: 'Air Jordan 1 Retro',
      imageUrl: Dummy.product1,
      amount: 195.0,
      status: 'Won',
      sellerName: 'kicks_store',
    ),
    const MockBidItem(
      title: 'Supreme Classic Tee',
      imageUrl: Dummy.product1,
      amount: 65.0,
      status: 'Lost',
      sellerName: 'hype_beast',
    ),
  ];

  final List<MockBidItem> _mockSellerBids = [
    const MockBidItem(
      title: 'Custom Painted Sneakers',
      imageUrl: Dummy.product1,
      amount: 250.0,
      status: 'Active',
      sellerName: 'bids_user1',
    ),
    const MockBidItem(
      title: 'Handmade Wooden Chair',
      imageUrl: Dummy.product1,
      amount: 180.0,
      status: 'Ended',
      sellerName: 'woodwork_master',
    ),
  ];

  final List<MockOfferItem> _mockBuyerOffers = [
    const MockOfferItem(
      title: 'Designer Watch',
      imageUrl: Dummy.product1,
      amount: 450.0,
      status: 'Active',
      sellerName: 'watch_collector',
    ),
    const MockOfferItem(
      title: 'Leather Boots',
      imageUrl: Dummy.product1,
      amount: 70.0,
      status: 'Accepted',
      sellerName: 'boot_barn',
    ),
    const MockOfferItem(
      title: 'Gaming Mouse',
      imageUrl: Dummy.product1,
      amount: 30.0,
      status: 'Declined',
      sellerName: 'tech_store',
    ),
  ];

  final List<MockOfferItem> _mockSellerOffers = [
    const MockOfferItem(
      title: 'Autographed Baseball',
      imageUrl: Dummy.product1,
      amount: 150.0,
      status: 'Pending',
      sellerName: 'sports_fan99',
    ),
    const MockOfferItem(
      title: 'Vintage Record Player',
      imageUrl: Dummy.product1,
      amount: 200.0,
      status: 'Accepted',
      sellerName: 'vinyl_lover',
    ),
    const MockOfferItem(
      title: 'Modern Art Canvas',
      imageUrl: Dummy.product1,
      amount: 500.0,
      status: 'Declined',
      sellerName: 'art_collector',
    ),
  ];

  final List<MockTipItem> _mockSellerTips = [
    const MockTipItem(
      senderName: 'john_doe',
      imageUrl: Dummy.user1,
      amount: 10.0,
      streamTitle: 'Monday Live Auction',
      date: 'Today',
      isThisMonth: true,
    ),
    const MockTipItem(
      senderName: 'mary_jane',
      imageUrl: Dummy.user2,
      amount: 25.0,
      streamTitle: 'Vintage Bag Unboxing',
      date: 'Yesterday',
      isThisMonth: true,
    ),
    const MockTipItem(
      senderName: 'dave_k',
      imageUrl: Dummy.user1,
      amount: 5.0,
      streamTitle: 'Collectibles Showcase',
      date: '2 weeks ago',
      isThisMonth: true,
    ),
    const MockTipItem(
      senderName: 'alice_w',
      imageUrl: Dummy.user2,
      amount: 15.0,
      streamTitle: 'Sneaker Drop Special',
      date: 'Last Month',
      isThisMonth: false,
    ),
  ];

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
      } else if (_selectedTabIndex == 3 && !isSeller) {
        _favorites = await ApiFavoriteService.instance.list();
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
      // Bids (Mock)
      final rawList = isSeller ? _mockSellerBids : _mockBuyerBids;
      final list = rawList.where((b) {
        if (_selectedChipIndex == 0) return true;
        if (isSeller) {
          if (_selectedChipIndex == 1) return b.status == 'Active';
          if (_selectedChipIndex == 2) return b.status == 'Ended';
        } else {
          if (_selectedChipIndex == 1) return b.status == 'Active';
          if (_selectedChipIndex == 2) return b.status == 'Won';
          if (_selectedChipIndex == 3) return b.status == 'Lost';
        }
        return true;
      }).toList();

      if (list.isEmpty) {
        return Center(child: CustomText(text: 'No bids found', fontColor: colorScheme.outline));
      }

      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final b = list[index];
          return ProductTile(
            imageUrl: b.imageUrl,
            title: b.title,
            subtitle: 'Bid: £${b.amount.toStringAsFixed(2)}',
            badgeText: b.status,
            badgeColor: b.status == 'Won' || b.status == 'Active' ? const Color(0xFF008BAA) : const Color(0xffFFA0A0),
            nameLabel: isSeller ? 'Bidder: ${b.sellerName}' : 'Seller: ${b.sellerName}',
          );
        },
      );
    } else if (_selectedTabIndex == 2) {
      // Offers (Mock)
      final rawList = isSeller ? _mockSellerOffers : _mockBuyerOffers;
      final list = rawList.where((o) {
        if (_selectedChipIndex == 0) return true;
        if (isSeller) {
          if (_selectedChipIndex == 1) return o.status == 'Pending';
          if (_selectedChipIndex == 2) return o.status == 'Accepted';
          if (_selectedChipIndex == 3) return o.status == 'Declined';
        } else {
          if (_selectedChipIndex == 1) return o.status == 'Active';
          if (_selectedChipIndex == 2) return o.status == 'Accepted';
          if (_selectedChipIndex == 3) return o.status == 'Declined';
        }
        return true;
      }).toList();

      if (list.isEmpty) {
        return Center(child: CustomText(text: 'No offers found', fontColor: colorScheme.outline));
      }

      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          final o = list[index];
          return ProductTile(
            imageUrl: o.imageUrl,
            title: o.title,
            subtitle: 'Offer: £${o.amount.toStringAsFixed(2)}',
            badgeText: o.status,
            badgeColor: o.status == 'Accepted' || o.status == 'Active' || o.status == 'Pending' ? const Color(0xFF008BAA) : const Color(0xffFFA0A0),
            nameLabel: isSeller ? 'Offered By: ${o.sellerName}' : 'Seller: ${o.sellerName}',
          );
        },
      );
    } else if (_selectedTabIndex == 3) {
      if (isSeller) {
        // Tips (Mock)
        final list = _mockSellerTips.where((t) {
          if (_selectedChipIndex == 0) return true;
          if (_selectedChipIndex == 1) return t.isThisMonth;
          if (_selectedChipIndex == 2) return !t.isThisMonth;
          return true;
        }).toList();

        if (list.isEmpty) {
          return Center(child: CustomText(text: 'No tips found', fontColor: colorScheme.outline));
        }

        return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final t = list[index];
            return ProductTile(
              imageUrl: t.imageUrl,
              title: 'Tip from @${t.senderName}',
              subtitle: 'Amount: £${t.amount.toStringAsFixed(2)}',
              badgeText: 'Tip',
              badgeColor: Colors.green,
              nameLabel: '${t.streamTitle} (${t.date})',
            );
          },
        );
      } else {
        // Saved (Real DB Favorites)
        // Saved has sub-chips: All, Live Shows, Sellers, Items. We show favorites under "Items" and "All".
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