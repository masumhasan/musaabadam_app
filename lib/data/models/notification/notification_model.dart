class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String? body;
  final String? actorName;
  final String? actorAvatarUrl;
  final String? streamId;
  final String? productId;
  final String? orderId;
  final String? giveawayId;
  final bool isRead;
  final DateTime? createdAt;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    this.body,
    this.actorName,
    this.actorAvatarUrl,
    this.streamId,
    this.productId,
    this.orderId,
    this.giveawayId,
    this.isRead = false,
    this.createdAt,
  });

  NotificationModel copyWith({bool? isRead}) => NotificationModel(
        id: id,
        type: type,
        title: title,
        body: body,
        actorName: actorName,
        actorAvatarUrl: actorAvatarUrl,
        streamId: streamId,
        productId: productId,
        orderId: orderId,
        giveawayId: giveawayId,
        isRead: isRead ?? this.isRead,
        createdAt: createdAt,
      );

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final actor = json['actor'] is Map ? Map<String, dynamic>.from(json['actor'] as Map) : const {};
    final data = json['data'] is Map ? Map<String, dynamic>.from(json['data'] as Map) : const {};
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'system',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString(),
      actorName: actor['displayName']?.toString(),
      actorAvatarUrl: actor['avatarUrl']?.toString(),
      streamId: data['streamId']?.toString(),
      productId: data['productId']?.toString(),
      orderId: data['orderId']?.toString(),
      giveawayId: data['giveawayId']?.toString(),
      isRead: json['isRead'] == true,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
    );
  }
}
