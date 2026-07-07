class OfferModel {
  final String id;
  final String productId;
  final String buyerId;
  final String sellerId;
  final double amount;
  final String status;
  final String? productTitle;
  final String? productImageUrl;
  final String? sellerUsername;
  final String? buyerUsername;
  final DateTime createdAt;

  const OfferModel({
    required this.id,
    required this.productId,
    required this.buyerId,
    required this.sellerId,
    required this.amount,
    required this.status,
    this.productTitle,
    this.productImageUrl,
    this.sellerUsername,
    this.buyerUsername,
    required this.createdAt,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
        productId: _extractId(json['productId']),
        buyerId: _extractId(json['buyerId']),
        sellerId: _extractId(json['sellerId']),
        amount: _toDouble(json['amount']),
        status: json['status']?.toString() ?? 'pending',
        productTitle: _extractProductTitle(json['productId']),
        productImageUrl: _extractProductImageUrl(json['productId']),
        sellerUsername: _extractUsername(json['sellerId']),
        buyerUsername: _extractUsername(json['buyerId']),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  static String _extractId(dynamic v) {
    if (v is String) return v;
    if (v is Map) return v['_id'] as String? ?? v['id'] as String? ?? '';
    return '';
  }

  static String? _extractUsername(dynamic v) {
    if (v is Map) return v['username'] as String?;
    return null;
  }

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

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is int) return v.toDouble();
    if (v is double) return v;
    return double.tryParse(v.toString()) ?? 0.0;
  }
}
