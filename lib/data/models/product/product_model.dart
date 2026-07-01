class ProductModel {
  final String id;
  final String sellerId;
  final String title;
  final String description;
  final String category;
  final String condition;
  final String listingType;
  final String status;
  final double price;
  final double? startingPrice;
  final double? reservePrice;
  final double currentHighBid;
  final DateTime? auctionEndsAt;
  final int quantity;
  final int quantitySold;
  final List<String> images;
  final bool flashSale;
  final double? flashSalePrice;
  final DateTime? flashSaleEndsAt;
  final bool acceptOffers;
  final double maxDiscount;
  final bool reserveForLive;
  final bool hazardousMaterials;
  final String? sku;
  final double? costPerItem;
  final double? shippingWeight;
  final List<String> tags;
  final int viewsCount;
  final int favoritesCount;
  final DateTime createdAt;

  const ProductModel({
    required this.id,
    required this.sellerId,
    required this.title,
    required this.description,
    required this.category,
    required this.condition,
    required this.listingType,
    required this.status,
    required this.price,
    this.startingPrice,
    this.reservePrice,
    required this.currentHighBid,
    this.auctionEndsAt,
    required this.quantity,
    required this.quantitySold,
    required this.images,
    required this.flashSale,
    this.flashSalePrice,
    this.flashSaleEndsAt,
    required this.acceptOffers,
    required this.maxDiscount,
    required this.reserveForLive,
    required this.hazardousMaterials,
    this.sku,
    this.costPerItem,
    this.shippingWeight,
    required this.tags,
    required this.viewsCount,
    required this.favoritesCount,
    required this.createdAt,
  });

  bool get isAuction => listingType == 'auction';
  bool get isBuyItNow => listingType == 'buy_it_now';
  bool get isGiveaway => listingType == 'giveaway';
  bool get isActive => status == 'active';
  bool get isDraft => status == 'draft';

  bool get isFlashSaleActive =>
      flashSale &&
      flashSalePrice != null &&
      flashSaleEndsAt != null &&
      flashSaleEndsAt!.isAfter(DateTime.now());

  /// Price the buyer actually pays right now (honours an active flash sale).
  double get effectivePrice => isFlashSaleActive ? flashSalePrice! : price;

  String get displayPrice {
    if (isGiveaway) return 'Free';
    if (isAuction) return '\$${(startingPrice ?? 0).toStringAsFixed(2)} start';
    return '\$${price.toStringAsFixed(2)}';
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] as String? ?? json['id'] as String,
      sellerId: _extractId(json['sellerId']),
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      condition: json['condition'] as String,
      listingType: json['listingType'] as String,
      status: json['status'] as String,
      price: _toDouble(json['price']),
      startingPrice: json['startingPrice'] != null ? _toDouble(json['startingPrice']) : null,
      reservePrice: json['reservePrice'] != null ? _toDouble(json['reservePrice']) : null,
      currentHighBid: _toDouble(json['currentHighBid']),
      auctionEndsAt: json['auctionEndsAt'] != null
          ? DateTime.parse(json['auctionEndsAt'] as String)
          : null,
      quantity: json['quantity'] as int? ?? 1,
      quantitySold: json['quantitySold'] as int? ?? 0,
      images: List<String>.from(json['images'] ?? []),
      flashSale: json['flashSale'] as bool? ?? false,
      flashSalePrice: json['flashSalePrice'] != null ? _toDouble(json['flashSalePrice']) : null,
      flashSaleEndsAt: json['flashSaleEndsAt'] != null ? DateTime.tryParse(json['flashSaleEndsAt'].toString()) : null,
      acceptOffers: json['acceptOffers'] as bool? ?? false,
      maxDiscount: _toDouble(json['maxDiscount']),
      reserveForLive: json['reserveForLive'] as bool? ?? false,
      hazardousMaterials: json['hazardousMaterials'] as bool? ?? false,
      sku: json['sku'] as String?,
      costPerItem: json['costPerItem'] != null ? _toDouble(json['costPerItem']) : null,
      shippingWeight: json['shippingWeight'] != null ? _toDouble(json['shippingWeight']) : null,
      tags: List<String>.from(json['tags'] ?? []),
      viewsCount: json['viewsCount'] as int? ?? 0,
      favoritesCount: json['favoritesCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  static String _extractId(dynamic v) {
    if (v is String) return v;
    if (v is Map) return v['_id'] as String? ?? v['id'] as String? ?? '';
    return '';
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is int) return v.toDouble();
    if (v is double) return v;
    return double.tryParse(v.toString()) ?? 0.0;
  }
}
