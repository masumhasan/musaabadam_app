import 'package:musaab_adam/core/utils/app_constants.dart';

class MessageModel {

  String imageUrl;
  String message;
  bool isMe;

  MessageModel({
    this.imageUrl = Dummy.user1,
    this.message = "Hello",
    this.isMe = false,
  });
}