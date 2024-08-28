import 'package:get/get.dart';
import 'package:supabase_app_demo/services/database_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../models/post_model.dart';
import '../../../../models/user_model.dart';
import '../../../../services/supabase_service.dart';

class HomeController extends GetxController {
  RxList<PostModel> posts = RxList<PostModel>();
  var loading = false.obs;

  late SupabaseClient client;
  late RealtimeChannel _channel;

  void setupRealtimeSubscription() {
    _channel = client.channel('public:posts');
    _channel.on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: 'INSERT',
        schema: 'public',
        table: 'posts',
      ),
      (payload, [ref]) {
        final newMessage =
            PostModel.fromJson(payload["new"] as Map<String, dynamic>);
        posts.add(newMessage);
      },
    );
    _channel.on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: 'UPDATE',
        schema: 'public',
        table: 'posts',
      ),
      (payload, [ref]) {
        final updatedMessage =
            PostModel.fromJson(payload["new"] as Map<String, dynamic>);
        posts.value = posts.value.map((post) {
          if (post.id == updatedMessage.id) {
            return updatedMessage;
          }
          return post;
        }).toList();
      },
    );

    _channel.on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: 'DELETE',
        schema: 'public',
        table: 'posts',
      ),
      (payload, [ref]) {
        final deletedMessageId = payload["old"]["id"] as String;
        posts.removeWhere((post) => post.id == deletedMessageId);
      },
    );
    _channel.subscribe();
  }

  @override
  Future<void> onInit() async {
    client = Supabase.instance.client;

    await DBService.fetchPosts().then(
      (res) {
        res.fold(
          (l) {},
          (r) {
            if (r.isNotEmpty) {
              posts.value = r;
            }
          },
        );
      },
    );
    setupRealtimeSubscription();

    listenPostChange();
    super.onInit();
  }

  listenPostChange() {
    SupabaseService.client.channel('public:posts').on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(event: 'INSERT', schema: 'public', table: 'posts'),
      (payload, [ref]) async {
        final PostModel post = PostModel.fromJson(payload["new"]);
        await DBService.updateFeed(post).then((res) {
          res.fold((l) {}, (r) {
            post.likes = [];
            post.user = UserModel.fromJson(r);
            posts.insert(0, post);
          });
        });
      },
    ).on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(event: 'DELETE', schema: 'public', table: 'posts'),
      (payload, [ref]) {
        posts.removeWhere((element) => element.id == payload["old"]["id"]);
      },
    ).subscribe();
  }
}
