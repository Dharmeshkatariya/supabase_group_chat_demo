import 'package:supabase_app_demo/models/user_model.dart';

import '../../../../../models/Message.dart';

class ChatListItemEntity {}

class SeparatorDateForMessages extends ChatListItemEntity {
  DateTime date;

  SeparatorDateForMessages({required this.date});
}

class MessageChatListItemEntity extends ChatListItemEntity {
  final Message message;

  MessageChatListItemEntity({required this.message});
}

class TypingIndicatorChatListItemEntity extends ChatListItemEntity {
  UserModel user;

  TypingIndicatorChatListItemEntity({required this.user});
}
