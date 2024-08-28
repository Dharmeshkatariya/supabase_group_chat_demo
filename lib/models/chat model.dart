import 'package:supabase_app_demo/models/user_model.dart';

class ChatRoomModel {
  final String id;
  final String chat_room_id;
  final String name;
  final List<String> userIds;
  final DateTime createdAt;
  final List<UserModel> typingUsers;

  ChatRoomModel({
    required this.id,
    required this.chat_room_id,
    required this.typingUsers,
    required this.name,
    required this.userIds,
    required this.createdAt,
  });

  // Factory method to create a ChatRoom from a JSON map
  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'] as String,
      typingUsers: json['typing_users'] != null
          ? (json['typing_users'] as List<dynamic>)
              .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      chat_room_id: json['chat_room_id'] ?? "",
      name: json['name'] as String,
      userIds: List<String>.from(json['user_id'] ?? []),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  List<UserModel> get typingUsersList =>
      typingUsers.where((user) => userIds.contains(user.id)).toList();
  // Method to convert ChatRoom to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_room_id': chat_room_id,
      'name': name,
      'user_ids': userIds,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
