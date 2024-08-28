import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:supabase_app_demo/services/supabase_service.dart';
import 'package:supabase_app_demo/sql/table.dart';
import 'package:supabase_app_demo/sql/table_column/message.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/Message.dart';
import '../../models/message_reaction.dart';
import '../../models/user_model.dart';
import '../../utils/env.dart';

class ChatServices extends GetxService {
  final client = SupabaseClient(Env.supabaseUrl, Env.supabaseKey);

  Future<Map<String, dynamic>?> getSingleMessage(String messageId) async {
    final response = await client
        .from(TableName.message)
        .select()
        .eq(MessageTable.id, messageId)
        .single()
        .execute();
    return response.data as Map<String, dynamic>?;
  }

  Future<void> updateMessageToRead({
    required String chatRoomId,
    required String messageId,
    required String userId,
  }) async {
    final messageData = await getSingleMessage(messageId);
    if (messageData == null) {
      return;
    }
    final currentReadAt =
        messageData[MessageTable.readAt] as Map<String, dynamic>? ?? {};
    final currentPendingRead =
        messageData[MessageTable.pendingRead] as List<dynamic>? ?? [];
    final currentTime = DateTime.now().toIso8601String();
    final updatedReadAt = {...currentReadAt, userId: currentTime};
    final updatedPendingRead =
        currentPendingRead.where((uid) => uid != userId).toList();
    final response = await client
        .from(TableName.message)
        .update({
          MessageTable.readAt: updatedReadAt,
          MessageTable.pendingRead: updatedPendingRead,
        })
        .eq(MessageTable.id, messageId)
        .execute();
  }

  Future<List<Message>> getChatMessages(String chatRoomId) async {
    final response = await client
        .from(TableName.message)
        .select()
        .eq(MessageTable.chatRoomId, chatRoomId)
        .order(MessageTable.createdAt, ascending: false)
        .execute();
    final dataList = response.data as List<dynamic>;
    return dataList
        .map((data) => Message.fromJson(data as Map<String, dynamic>))
        .toList();
  }

  Future<Either<String, List<Message>>> getChats(chatRoomId) async {
    try {
      final response = await client
          .from(TableName.message)
          .select()
          .eq(MessageTable.chatRoomId, chatRoomId)
          .order(MessageTable.createdAt, ascending: true)
          .execute();
      final mList = (response.data as List<dynamic>)
          .map((item) => Message.fromJson(item as Map<String, dynamic>))
          .toList();

      return Right(mList);
    } catch (e) {
      print(e);
      return Left(e.toString());
    }
  }

  Stream<List<Map<String, dynamic>>> getMessages(String chatRoomId) {
    return client
        .from(TableName.message)
        .stream(primaryKey: [MessageTable.chatRoomId])
        .eq(MessageTable.chatRoomId, chatRoomId)
        .order(MessageTable.createdAt, ascending: false)
        .map((data) => List<Map<String, dynamic>>.from(data));
  }

  Future<void> sendMessage({
    required String message,
    required String chatRoomId,
    required String userId,
    required List<String> participants,
    required List<UserModel> typingUser,
    required MessageType type,
    required UserModel user,
    Message? replyMessage,
  }) async {
    final loggedUid = Get.find<SupabaseService>().loggedUid;

    final Map<String, Object?> myMap = {
      MessageTable.chatRoomId: chatRoomId,
      MessageTable.userId: userId,
      MessageTable.sentAt: DateTime.now().toIso8601String(),
      MessageTable.receivedAt: {},
      MessageTable.readAt: {},
      MessageTable.participants: participants,
      MessageTable.typingUsers: [],
      MessageTable.userSendInfo: user,
      MessageTable.messageType: type.name,
      MessageTable.message: message,
      MessageTable.pendingRead:
          participants.where((uid) => uid != loggedUid).toList(),
      MessageTable.pendingReceivement:
          participants.where((uid) => uid != loggedUid).toList(),
      MessageTable.createdAt: DateTime.now().toIso8601String(),
    };
    if (replyMessage != null) {
      myMap[MessageTable.replyMessage] = replyMessage.toJson();
    }
    await client.from(TableName.message).insert(myMap).execute();
  }

  Future<void> sendImageMessage({
    required String imageUrl,
    required String chatRoomId,
    required List<String> participants,
    required List<UserModel> typingUser,
    required String userId,
    required MessageType type,
    required UserModel user,
    Message? replyMessage,
  }) async {
    final loggedUid = Get.find<SupabaseService>().loggedUid;
    final Map<String, Object?> myMap = {
      MessageTable.chatRoomId: chatRoomId,
      MessageTable.userId: userId,
      MessageTable.messageType: type.name,
      MessageTable.sentAt: DateTime.now().toIso8601String(),
      MessageTable.receivedAt: {},
      MessageTable.typingUsers: [],
      MessageTable.readAt: {},
      MessageTable.participants: participants,
      MessageTable.userSendInfo: user,
      MessageTable.message: imageUrl,
      MessageTable.pendingRead:
          participants.where((uid) => uid != loggedUid).toList(),
      MessageTable.pendingReceivement:
          participants.where((uid) => uid != loggedUid).toList(),
      MessageTable.createdAt: DateTime.now().toIso8601String(),
    };
    if (replyMessage != null) {
      myMap[MessageTable.replyMessage] = replyMessage.toJson();
    }
    await client.from(TableName.message).insert(myMap).execute();
  }

  handleUserTypingStatus({
    required String chatRoomId,
    required List<UserModel> typingUserIds,
  }) async {
    await updateTypingUsers(
      chatRoomId: chatRoomId,
      typingUserIds: typingUserIds,
    );
  }

  Future<void> updateTypingUsers({
    required String chatRoomId,
    required List<UserModel> typingUserIds,
  }) async {
    try {
      final updateResponse = await client
          .from(TableName.message)
          .update({MessageTable.typingUsers: typingUserIds.toList()})
          .eq(MessageTable.chatRoomId, chatRoomId)
          .execute();
    } catch (e) {}
  }

  Future<Either<String, PostgrestResponse<dynamic>>> updateMessage({
    required String messageId,
    required String newContent,
    Message? replyMessage,
  }) async {
    try {
      final updateData = {
        MessageTable.message: newContent,
        if (replyMessage != null)
          MessageTable.replyMessage: replyMessage.toJson(),
      };
      final response = await client
          .from(TableName.message)
          .update(updateData)
          .eq(MessageTable.id, messageId)
          .execute();
      return Right(response);
    } catch (e) {
      print(e);
      return Left(e.toString());
    }
  }

  Future<Either<String, PostgrestResponse<dynamic>>> deleteMessage(
      String messageId) async {
    try {
      final response = await client
          .from(TableName.message)
          .delete()
          .eq(MessageTable.id, messageId)
          .execute();
      return Right(response);
    } catch (e) {
      print(e);
      return Left(e.toString());
    }
  }

  Future<void> markAllMessagesAsRead({
    required String chatRoomId,
    required String loggedUid,
  }) async {
    final client = Supabase.instance.client;

    try {
      final response = await client
          .from(TableName.message)
          .select()
          .eq(MessageTable.chatRoomId, chatRoomId)
          .contains(MessageTable.pendingRead, [loggedUid]).execute();
      final List<dynamic> messages = response.data as List<dynamic>;
      final updates = messages.map((message) async {
        final messageId = message[MessageTable.id] as String;
        final updateResponse = await client
            .from(TableName.message)
            .update({
              MessageTable.readAt: {
                loggedUid: DateTime.now().toUtc().toIso8601String()
              },
              MessageTable.pendingRead: {loggedUid: null}
            })
            .eq(MessageTable.id, messageId)
            .execute();
      });
      await Future.wait(updates);
    } catch (error) {}
  }

  Future<List<Message>> searchMessages({
    required String chatRoomId,
    required String query,
  }) async {
    final response = await client
        .from(TableName.message)
        .select()
        .eq(MessageTable.chatRoomId, chatRoomId)
        .textSearch(MessageTable.message, query)
        .order(MessageTable.createdAt, ascending: false)
        .execute();
    final dataList = response.data as List<dynamic>;
    return dataList
        .map((data) => Message.fromJson(data as Map<String, dynamic>))
        .toList();
  }

  Future<Either<String, void>> addOrUpdateReactions({
    required String messageId,
    required List<MessageReaction> reactions,
    Message? replyMessage,
  }) async {
    try {
      final existingReactionsResponse = await client
          .from(TableName.message)
          .select('${TableName.messageReaction}, ${MessageTable.replyMessage}')
          .eq(MessageTable.id, messageId)
          .maybeSingle()
          .execute();

      List<MessageReaction> existingReactions = [];
      Message? existingReplyMessage;

      if (existingReactionsResponse.data != null) {
        if (existingReactionsResponse.data
                .containsKey(TableName.messageReaction) &&
            existingReactionsResponse.data[TableName.messageReaction] != null) {
          existingReactions = (existingReactionsResponse
                  .data[TableName.messageReaction] as List)
              .map((e) => MessageReaction.fromJson(e))
              .toList();
        }
        if (existingReactionsResponse.data
                .containsKey(MessageTable.replyMessage) &&
            existingReactionsResponse.data[MessageTable.replyMessage] != null) {
          existingReplyMessage = Message.fromJson(
              existingReactionsResponse.data[MessageTable.replyMessage]);
        }
      }

      for (var reaction in reactions) {
        final existingReactionIndex =
            existingReactions.indexWhere((r) => r.userId == reaction.userId);
        if (existingReactionIndex != -1) {
          existingReactions[existingReactionIndex] = reaction;
        } else {
          existingReactions.add(reaction);
        }
      }

      final updateData = {
        TableName.messageReaction:
            existingReactions.map((r) => r.toJson()).toList(),
        MessageTable.updatedAt: DateTime.now().toIso8601String(),
        MessageTable.replyMessage: replyMessage?.toJson() ??
            existingReplyMessage?.toJson(), // Update reply_message
      };

      // Execute update
      final response = await client
          .from(TableName.message)
          .update(updateData)
          .eq(MessageTable.id, messageId)
          .execute();

      return const Right(null);
    } catch (e) {
      print(e);
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> deleteReaction({
    required String messageId,
    required String userId,
  }) async {
    try {
      final existingReactionsResponse = await client
          .from(TableName.message)
          .select(TableName.messageReaction)
          .eq(MessageTable.id, messageId)
          .maybeSingle()
          .execute();
      if (existingReactionsResponse.data == null ||
          !existingReactionsResponse.data
              .containsKey(TableName.messageReaction) ||
          existingReactionsResponse.data[TableName.messageReaction] == null) {
        return const Right(null);
      }
      List<MessageReaction> existingReactions =
          (existingReactionsResponse.data[TableName.messageReaction] as List)
              .map((e) => MessageReaction.fromJson(e))
              .toList();
      existingReactions.removeWhere((reaction) => reaction.userId == userId);

      final response = await client
          .from(TableName.message)
          .update({
            TableName.messageReaction:
                existingReactions.map((r) => r.toJson()).toList(),
            MessageTable.updatedAt: DateTime.now().toIso8601String(),
          })
          .eq(MessageTable.id, messageId)
          .execute();

      return const Right(null);
    } catch (e) {
      print(e);
      return Left(e.toString());
    }
  }

  Future<Either<String, Map<String, dynamic>>> getChatRoomStatistics(
      String chatRoomId) async {
    try {
      final messagesResponse = await client
          .from(TableName.message)
          .select(MessageTable.id)
          .eq(MessageTable.chatRoomId, chatRoomId)
          .execute();
      final participantsResponse = await client
          .from(TableName.chatRoom)
          .select(MessageTable.userId)
          .eq(MessageTable.id, chatRoomId)
          .execute();

      final messageCount = (messagesResponse.data as List).length;
      final participantCount = (participantsResponse.data as List).length;

      return Right({
        'message_count': messageCount,
        'participant_count': participantCount,
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, PostgrestResponse<dynamic>>> forwardMessage({
    required String message,
    required String chatRoomId,
    required String userId,
    required List<String> participants,
    required List<UserModel> typingUser,
    required MessageType type,
    required UserModel user,
    required String originalMessageId,
    required String forwardedChatRoomId,
  }) async {
    try {
      final response = await client
          .from(TableName.message)
          .select()
          .eq(MessageTable.id, originalMessageId)
          .single()
          .execute();
      if (response.data == null) {
        return const Left('Original message not found');
      }
      final originalMessage = response.data as Map<String, dynamic>;
      final loggedUid = Get.find<SupabaseService>().loggedUid;
      var res = await client.from(TableName.message).insert({
        MessageTable.chatRoomId: chatRoomId,
        MessageTable.userId: userId,
        MessageTable.messageType: type.name,
        MessageTable.sentAt: DateTime.now().toIso8601String(),
        MessageTable.receivedAt: {},
        MessageTable.typingUsers: [],
        MessageTable.readAt: {},
        MessageTable.participants: participants,
        MessageTable.userSendInfo: user,
        MessageTable.message: message,
        MessageTable.pendingRead:
            participants.where((uid) => uid != loggedUid).toList(),
        MessageTable.pendingReceivement:
            participants.where((uid) => uid != loggedUid).toList(),
        MessageTable.createdAt: DateTime.now().toIso8601String(),
        MessageTable.isForwarded: true,
        MessageTable.originalMessageId: originalMessageId,
        MessageTable.forwardedFrom: originalMessage[MessageTable.chatRoomId],
      }).execute();
      return Right(res);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
