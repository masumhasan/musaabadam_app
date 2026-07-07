class BidBidder {
  final String userId;
  final String username;
  final String displayName;
  final String? avatarUrl;

  const BidBidder({
    required this.userId,
    required this.username,
    required this.displayName,
    this.avatarUrl,
  });

  factory BidBidder.fromJson(Map<String, dynamic> json) => BidBidder(
        userId: json['userId']?.toString() ?? '',
        username: json['username']?.toString() ?? '',
        displayName: json['displayName']?.toString() ?? json['username']?.toString() ?? '',
        avatarUrl: json['avatarUrl']?.toString(),
      );
}

class BidModel {
  final String id;
  final double amount;
  final bool isAutoBid;
  final String status;
  final DateTime? createdAt;
  final BidBidder? bidder;
  final String? productTitle;
  final String? productImageUrl;
  final String? sellerUsername;

  const BidModel({
    required this.id,
    required this.amount,
    required this.isAutoBid,
    required this.status,
    this.createdAt,
    this.bidder,
    this.productTitle,
    this.productImageUrl,
    this.sellerUsername,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) => BidModel(
        id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
        amount: _toDouble(json['amount']),
        isAutoBid: json['isAutoBid'] == true,
        status: json['status']?.toString() ?? 'active',
        createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
        bidder: json['bidder'] != null ? BidBidder.fromJson(Map<String, dynamic>.from(json['bidder'] as Map)) : null,
        productTitle: _extractProductTitle(json['productId']),
        productImageUrl: _extractProductImageUrl(json['productId']),
        sellerUsername: _extractSellerUsername(json['productId']),
      );

  static String? _extractProductTitle(dynamic product) {
    if (product is Map) return product['title']?.toString();
    return null;
  }

  static String? _extractProductImageUrl(dynamic product) {
    if (product is Map) {
      final imgs = product['images'];
      if (imgs is List && imgs.isNotEmpty) return imgs.first.toString();
    }
    return null;
  }

  static String? _extractSellerUsername(dynamic product) {
    if (product is Map) {
      final seller = product['sellerId'];
      if (seller is Map) return seller['username']?.toString();
    }
    return null;
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is int) return v.toDouble();
    if (v is double) return v;
    return double.tryParse(v.toString()) ?? 0.0;
  }
}
