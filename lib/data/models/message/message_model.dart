class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String text;
  final bool isMe;
  final DateTime createdAt;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.isMe,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json, String currentUserId) {
    final sender = json['senderId'] as String;
    return MessageModel(
      id: json['_id'] as String,
      senderId: sender,
      receiverId: json['receiverId'] as String,
      text: json['text'] as String,
      isMe: sender == currentUserId,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}