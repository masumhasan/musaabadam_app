class OrderItemModel {
  final String productId;
  final String title;
  final String? imageUrl;
  final int quantity;
  final double unitPrice;
  final double totalPrice;

  const OrderItemModel({
    required this.productId,
    required this.title,
    this.imageUrl,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) => OrderItemModel(
        productId: (json['productId'] as String?) ?? '',
        title: json['title'] as String,
        imageUrl: json['imageUrl'] as String?,
        quantity: json['quantity'] as int,
        unitPrice: _toDouble(json['unitPrice']),
        totalPrice: _toDouble(json['totalPrice']),
      );

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is int) return v.toDouble();
    if (v is double) return v;
    return double.tryParse(v.toString()) ?? 0.0;
  }
}

class OrderModel {
  final String id;
  final String buyerId;
  final String sellerId;
  final String? streamId;
  final List<OrderItemModel> items;
  final double subtotal;
  final double shippingCost;
  final double taxAmount;
  final double totalAmount;
  final String status;
  final String? trackingNumber;
  final String? trackingCarrier;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;
  final DateTime? cancelledAt;
  final String? cancelReason;
  final bool isPaid;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    this.streamId,
    required this.items,
    required this.subtotal,
    required this.shippingCost,
    required this.taxAmount,
    required this.totalAmount,
    required this.status,
    this.trackingNumber,
    this.trackingCarrier,
    this.shippedAt,
    this.deliveredAt,
    this.cancelledAt,
    this.cancelReason,
    required this.isPaid,
    required this.createdAt,
  });

  bool get isPending => status == 'pending';
  bool get isDelivered => status == 'delivered';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] as String? ?? json['_id'] as String,
        buyerId: _extractId(json['buyerId']),
        sellerId: _extractId(json['sellerId']),
        streamId: _extractIdOrNull(json['streamId']),
        items: (json['items'] as List? ?? [])
            .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        subtotal: _toDouble(json['subtotal']),
        shippingCost: _toDouble(json['shippingCost']),
        taxAmount: _toDouble(json['taxAmount']),
        totalAmount: _toDouble(json['totalAmount']),
        status: json['status'] as String,
        trackingNumber: json['trackingNumber'] as String?,
        trackingCarrier: json['trackingCarrier'] as String?,
        shippedAt: json['shippedAt'] != null ? DateTime.parse(json['shippedAt'] as String) : null,
        deliveredAt: json['deliveredAt'] != null ? DateTime.parse(json['deliveredAt'] as String) : null,
        cancelledAt: json['cancelledAt'] != null ? DateTime.parse(json['cancelledAt'] as String) : null,
        cancelReason: json['cancelReason'] as String?,
        isPaid: json['isPaid'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  static String _extractId(dynamic v) {
    if (v is String) return v;
    if (v is Map) return v['_id'] as String? ?? v['id'] as String? ?? '';
    return '';
  }

  static String? _extractIdOrNull(dynamic v) {
    if (v == null) return null;
    return _extractId(v);
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is int) return v.toDouble();
    if (v is double) return v;
    return double.tryParse(v.toString()) ?? 0.0;
  }
}
