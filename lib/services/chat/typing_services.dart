import 'dart:async';
import 'package:get/get.dart';
import 'package:supabase_app_demo/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TypingServices extends GetxService {
  final client = SupabaseService.client;

  Future<void> updateImTyping(String chatRoomId) async {
    final userId = client.auth.currentUser!.id;
    await client.from('typing').upsert({
      'chat_room_id': chatRoomId,
      'id': chatRoomId,
      'user_id': userId,
      'is_typing': true
    }).execute();
  }

  Future<void> updateNotTyping(String chatRoomId) async {
    final userId = client.auth.currentUser!.id;
    await client.from('typing').upsert({
      'chat_room_id': chatRoomId,
      'id': chatRoomId,
      'user_id': userId,
      'is_typing': false
    }).execute();
  }

  RefreshTypingListener addListener({
    required String conversationId,
    required void Function(Set<String> typingUids) listener,
  }) {
    return RefreshTypingListener(
        conversationId: conversationId, listener: listener, client: client);
  }

  void removeListener({required RefreshTypingListener listener}) {
    listener.dispose();
  }
}

class RefreshTypingListener {
  final String conversationId;
  final SupabaseClient client;
  final void Function(Set<String> typingUids) listener;
  late final RealtimeChannel _channel;

  RefreshTypingListener(
      {required this.client,
      required this.conversationId,
      required this.listener}) {
    _channel = client.channel('public:typing');

    _channel.on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: 'UPDATE',
        schema: 'public',
        table: 'typing',
      ),
      (payload, [ref]) {
        // final updatedMessage =
        //     Message.fromJson(payload["new"] as Map<String, dynamic>);
        // var _messages = [];
        // _messages = _messages.map((msg) {
        //   if (msg is MessageChatListItemEntity &&
        //       msg.message.id == updatedMessage.id) {
        //     return MessageChatListItemEntity(message: updatedMessage);
        //   }
        //   return msg;
        // }).toList();
      },
    );
  }

  void dispose() {
    _channel.unsubscribe();
  }
}
