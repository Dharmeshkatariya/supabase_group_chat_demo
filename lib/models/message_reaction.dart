import 'package:equatable/equatable.dart';

class MessageReaction extends Equatable {
  final String id;
  final String messageId;
  final String userId;
  String reaction;
  String createdAt;

  MessageReaction({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.reaction,
    required this.createdAt,
  });

  factory MessageReaction.fromJson(Map<String, dynamic> json) {
    return MessageReaction(
      id: json['id'],
      messageId: json['message_id'],
      userId: json['user_id'],
      reaction: json['reaction'],
      createdAt: DateTime.now().toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message_id': messageId,
      'user_id': userId,
      'reaction': reaction,
      'created_at': createdAt,
    };
  }

  @override
  List<Object?> get props => [id, messageId, userId, reaction, createdAt];
}
