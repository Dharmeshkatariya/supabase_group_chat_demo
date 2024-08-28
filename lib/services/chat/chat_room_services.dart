import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:supabase_app_demo/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../models/chat model.dart';
import '../../models/user_model.dart';
import '../../sql/table.dart';
import '../../sql/table_column/chat_room.dart';
import '../../sql/table_column/message.dart';
import '../../utils/env.dart';

class ChatRoomServices extends GetxService {
  final client = SupabaseClient(Env.supabaseUrl, Env.supabaseKey);

  Future<Either<String, List<ChatRoomModel>>> getChatRooms() async {
    try {
      final userId = Get.find<SupabaseService>().loggedUid;

      if (userId == null) {
        return const Left('User not authenticated');
      }

      final response = await SupabaseService.client
          .from(TableName.chatRoom)
          .select('''
            id, name, created_at, user_id, chat_room_id, creator_id, typing_users
          ''')
          .contains(ChatRoomTable.userId, [userId])
          .order(ChatRoomTable.createdAt, ascending: false)
          .execute();

      if (response.data is List) {
        var chatRooms = (response.data as List<dynamic>)
            .map((item) => ChatRoomModel.fromJson(item as Map<String, dynamic>))
            .toList();
        return Right(chatRooms);
      } else {
        return const Left('Unexpected response data type');
      }
    } catch (e) {
      print('Error fetching chat rooms: $e');
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> createChatRoom(
    String name,
    List<String> userIds,
    String currentUserId,
    List<UserModel> usermodel,
  ) async {
    try {
      var chatRoomId = const Uuid().v4();

      final response = await client.from(TableName.chatRoom).insert({
        ChatRoomTable.name: name,
        ChatRoomTable.id: chatRoomId,
        ChatRoomTable.typingUsers: usermodel,
        ChatRoomTable.chatRoomId: chatRoomId,
        ChatRoomTable.creatorId: currentUserId,
        ChatRoomTable.createdAt: DateTime.now().toIso8601String(),
        ChatRoomTable.joinedAt: DateTime.now().toIso8601String(),
        ChatRoomTable.userId: userIds,
      }).execute();
      return Right(chatRoomId);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, void>> addParticipant(
    String chatRoomId,
    List<String> newUserIds,
    List<UserModel> newUserModeList,
  ) async {
    try {
      final response = await client
          .from(TableName.chatRoom)
          .select('${ChatRoomTable.userId}, ${ChatRoomTable.typingUsers}')
          .eq(MessageTable.id, chatRoomId)
          .maybeSingle()
          .execute();
      final currentParticipants =
          List<String>.from(response.data[ChatRoomTable.userId]);
      final currentTypingUsersJson = List<Map<String, dynamic>>.from(
          response.data[ChatRoomTable.typingUsers] ?? []);
      List<UserModel> currentTypingUsers = currentTypingUsersJson
          .map((json) => UserModel.fromJson(json))
          .toList();
      Set<String> updatedParticipantsSet = {
        ...currentParticipants,
        ...newUserIds
      };
      Set<UserModel> updateUserSet = {
        ...currentTypingUsers,
        ...newUserModeList
      };
      List<String> updatedParticipants = updatedParticipantsSet.toList();
      List<UserModel> updateUserList = updateUserSet.toList();
      final updateResponse = await client
          .from(TableName.chatRoom)
          .update({
            ChatRoomTable.userId: updatedParticipants,
            ChatRoomTable.typingUsers: updateUserList
          })
          .eq(ChatRoomTable.id, chatRoomId)
          .execute();
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
