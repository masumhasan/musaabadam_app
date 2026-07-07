class InboxConversationModel {
  final String partnerId;
  final String partnerName;
  final String? partnerAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  InboxConversationModel({
    required this.partnerId,
    required this.partnerName,
    this.partnerAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
  });

  factory InboxConversationModel.fromJson(Map<String, dynamic> json) {
    return InboxConversationModel(
      partnerId: json['partnerId'] as String,
      partnerName: json['partnerName'] as String,
      partnerAvatar: json['partnerAvatar'] as String?,
      lastMessage: json['lastMessage'] as String,
      lastMessageTime: DateTime.parse(json['lastMessageTime'] as String),
      unreadCount: json['unreadCount'] as int? ?? 0,
    );
  }
}
