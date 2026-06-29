class ChatMessageModel {
  final String id;
  final String streamId;
  final String type;
  final String text;
  final String senderId;
  final String senderName;
  final String? senderAvatarUrl;
  final DateTime? createdAt;

  const ChatMessageModel({
    required this.id,
    required this.streamId,
    required this.type,
    required this.text,
    required this.senderId,
    required this.senderName,
    this.senderAvatarUrl,
    this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final sender = json['sender'] is Map ? Map<String, dynamic>.from(json['sender'] as Map) : <String, dynamic>{};
    return ChatMessageModel(
      id: json['id']?.toString() ?? '',
      streamId: json['streamId']?.toString() ?? '',
      type: json['type']?.toString() ?? 'message',
      text: json['text']?.toString() ?? '',
      senderId: sender['userId']?.toString() ?? '',
      senderName: sender['displayName']?.toString() ?? 'User',
      senderAvatarUrl: sender['avatarUrl']?.toString(),
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null,
    );
  }
}
