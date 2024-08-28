import 'package:get/get.dart';
import 'package:supabase_app_demo/models/message_reaction.dart';
import 'package:supabase_app_demo/models/user_model.dart';
import 'package:supabase_app_demo/services/supabase_service.dart';
import 'package:collection/collection.dart';

enum MessageType {
  text,
  image,
  video,
  file,
}

class Message {
  final String id;
  final String chatRoomId;
  final String userId;
  final List<String> participants;
  final UserModel? userSendInfoModel;
  final String message;
  final DateTime createdAt;
  final bool isSending;
  final Map<String, DateTime> receivedAt;
  final Map<String, DateTime> readAt;
  final MessageType mtype;
  final bool hasPendingWrites;
  final List<String> pendingReceivement;
  final List<String> pendingRead;
  final DateTime? sentAt;
  final List<UserModel> typingUsers;
  final List<MessageReaction> messageReaction;
  final bool isForwarded;
  final String? originalMessageId;
  final String? forwardedFrom;
  final Message? replyMessage;

  Message(
      {required this.id,
      required this.chatRoomId,
      required this.messageReaction,
      required this.typingUsers,
      required this.userId,
      this.userSendInfoModel,
      required this.participants,
      this.sentAt,
      required this.message,
      required this.mtype,
      this.receivedAt = const {},
      this.readAt = const {},
      this.hasPendingWrites = false,
      this.pendingRead = const [],
      this.pendingReceivement = const [],
      required this.createdAt,
      this.isSending = false,
      this.isForwarded = false, // Default to false
      this.originalMessageId,
      this.forwardedFrom,
      this.replyMessage});

  factory Message.fromJson(Map<String, dynamic> json) {
    MessageType type;
    switch (json['message_type'] as String) {
      case 'text':
        type = MessageType.text;
        break;
      case 'image':
        type = MessageType.image;
        break;
      case 'video':
        type = MessageType.video;
        break;
      case 'file':
        type = MessageType.file;
        break;
      default:
        throw Exception('Unknown message type');
    }

    return Message(
      id: json['id'],
      replyMessage: json['reply_message'] != null
          ? Message.fromJson(json['reply_message'] as Map<String, dynamic>)
          : null,
      typingUsers: json['typing_users'] != null
          ? (json['typing_users'] as List<dynamic>)
              .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      messageReaction: json['message_reactions'] != null
          ? (json['message_reactions'] as List<dynamic>)
              .map((e) => MessageReaction.fromJson(e as Map<String, dynamic>))
              .toList()
          : [],
      userSendInfoModel: json['user_send_info'] != null
          ? UserModel.fromJson(json['user_send_info'] as Map<String, dynamic>)
          : null,
      chatRoomId: json['chat_room_id'],
      isForwarded: json['is_forwarded'] ?? false,
      originalMessageId: json['original_message_id'],
      forwardedFrom: json['forwarded_from'],
      userId: json['user_id'],
      mtype: type,
      participants: json['participants'] != null
          ? List<String>.from(json['participants'] as List<dynamic>)
          : [],
      message: json['message'],
      createdAt: DateTime.parse(json['created_at']),
      isSending: json['is_sending'] ?? false,
      sentAt: json['sent_at'] != null
          ? DateTime.parse(json['sent_at'] as String)
          : null,
      receivedAt: json['received_at'] != null
          ? Map<String, DateTime>.from(
              (json['received_at'] as Map<String, dynamic>).map((key, value) =>
                  MapEntry(key, DateTime.parse(value as String))))
          : {},
      readAt: json['read_at'] != null
          ? Map<String, DateTime>.from((json['read_at'] as Map<String, dynamic>)
              .map((key, value) =>
                  MapEntry(key, DateTime.parse(value as String))))
          : {},
      hasPendingWrites: json['has_pending_writes'] as bool? ?? false,
      pendingReceivement: List<String>.from(json['pending_receivement'] ?? []),
      pendingRead: List<String>.from(json['pending_read'] ?? []),
    );
  }

  List<UserModel> get typingUserList =>
      typingUsers.where((user) => participants.contains(user.id)).toList();

  final loggedUid = Get.find<SupabaseService>().loggedUid;

  Map<String, dynamic> toJson() {
    final json = {
      'id': id,
      'pending_read': participants.where((uid) => uid != loggedUid).toList(),
      'pending_receivement':
          participants.where((uid) => uid != loggedUid).toList(),
      'chat_room_id': chatRoomId,
      'user_id': userId,
      'message_type': mtype.toString().split('.').last,
      'user_send_info': userSendInfoModel?.toJson(),
      'typing_users': typingUsers.map((user) => user.toJson()).toList(),
      'message': message,
      'is_forwarded': isForwarded,
      'participants': participants, //
      'original_message_id': originalMessageId,
      'forwarded_from': forwardedFrom,
      'created_at': DateTime.now().toIso8601String(),
    };
    if (replyMessage != null) {
      json['reply_message'] = replyMessage!.toJson();
    }

    if (sentAt != null) {
      json['sent_at'] = sentAt!.toIso8601String();
    }

    if (receivedAt.isNotEmpty) {
      json['received_at'] = receivedAt
          .map((key, value) => MapEntry(key, value.toIso8601String()));
    }

    if (readAt.isNotEmpty) {
      json['read_at'] =
          readAt.map((key, value) => MapEntry(key, value.toIso8601String()));
    }

    if (typingUsers.isNotEmpty) {
      json['typing_users'] = typingUsers.map((user) => user.toJson()).toList();
    }

    if (messageReaction.isNotEmpty) {
      json['message_reactions'] =
          messageReaction.map((reaction) => reaction.toJson()).toList();
    }

    if (replyMessage != null) {
      json['reply_message'] = replyMessage!.toJson();
    }
    return json;
  }

  Map<String, DateTime> _notMeMap(Map<String, DateTime> map) {
    return Map<String, DateTime>.from(map)
      ..removeWhere(
          (key, value) => key == Get.find<SupabaseService>().loggedUid);
  }

  DateTime get sent => sentAt!;

  bool get iAmNotTheSender => userId != Get.find<SupabaseService>().loggedUid;

  DateTime? get lastReceivedAt {
    if (_notMeMap(receivedAt).length < participants.length - 1) {
      return null;
    }
    return _notMeMap(receivedAt)
        .values
        .sorted((a, b) => a.compareTo(b))
        .lastOrNull;
  }

  DateTime? get lastReadAt {
    if (_notMeMap(readAt).length < participants.length - 1) {
      return null;
    }
    return _notMeMap(readAt).values.sorted((a, b) => a.compareTo(b)).lastOrNull;
  }

  bool get received {
    return lastReceivedAt != null;
  }

  bool get read {
    return lastReadAt != null;
  }

  bool get iReceived {
    assert(userId != Get.find<SupabaseService>().loggedUid,
        'This message was sent by the logged user');
    return receivedAt[Get.find<SupabaseService>().loggedUid] != null;
  }

  bool get iRead {
    assert(userId != Get.find<SupabaseService>().loggedUid,
        'This message was sent by the logged user');
    return readAt[Get.find<SupabaseService>().loggedUid] != null;
  }
}
