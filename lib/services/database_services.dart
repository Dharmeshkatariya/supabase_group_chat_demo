import 'dart:async';
import 'dart:io';
import 'package:supabase_app_demo/models/user_model.dart';
import 'package:supabase_app_demo/services/supabase_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_app_demo/sql/table.dart';
import 'package:supabase_app_demo/sql/table_column/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/comment_model.dart';
import '../models/notification_model.dart';
import '../models/post_model.dart';
import '../utils/env.dart';

class DBService {
  static final client = SupabaseService.client;

  static Future<Either<String, List<PostModel>>> fetchPosts() async {
    try {
      final response = await client.from(TableName.posts).select('''
      ${UsersTable.id}, content, image, created_at, comment_count, like_count, user_id,
      user:users!inner(id, name, image ,metadata , email),
      likes:likes(user_id, post_id)
    ''').order("id", ascending: false).execute();
      var posts = [for (var item in response.data!) PostModel.fromJson(item)];
      return Right(posts);
    } catch (e) {
      return const Left("Something went wrong!");
    }
  }

  static Future<Either<String, dynamic>> updateFeed(PostModel post) async {
    try {
      var user = await SupabaseService.client
          .from("users")
          .select("*")
          .eq("id", post.userId)
          .single();
      return Right(user);
    } catch (e) {
      var e = "error";
      return Left(e);
    }
  }

  static Future<Either<String, dynamic>> addReply(String userId, String postId,
      String postUserId, String reply, UserModel user) async {
    try {
      await client.rpc("increment_comment",
          params: {"count": 1, "row_id": postId}).execute();
      const uuid = Uuid();
      final notificationId = uuid.v4();
      final replyId = uuid.v4();
      await client.from("notifications").insert({
        "user_id": userId,
        "id": notificationId,
        "notification": "commented on your post.",
        "to_user_id": postUserId,
        "post_id": postId,
      }).execute();
      var aclient = await client.from("comments").insert({
        "id": replyId,
        "post_id": postId,
        "user_id": userId,
        "reply": reply,
        "user": user
      }).execute();
      return Right(aclient);
    } catch (e) {
      print(e);
      return const Left("Something went wrong.please try again!");
    }
  }

  static Future<Either<String, List<NotificationModel>>> fetchNotifications(
      String userId) async {
    try {
      final List<dynamic> data =
          await SupabaseService.client.from("notifications").select('''
  id, post_id, notification,created_at , user_id ,user:user_id (email ,metadata , image ,id, name)
''').eq("to_user_id", userId).order("id", ascending: false);
      var notifications = [
        for (var item in data) NotificationModel.fromJson(item)
      ];
      return Right(notifications);
    } catch (e) {
      print(e);
      return const Left("not available ");
    }
  }

  static Future<bool> doesUserExist(String userId) async {
    final response = await SupabaseService.client
        .from("users")
        .select("id")
        .eq("id", userId)
        .single();
    return response.error == null;
  }

  static Future<Either<String, dynamic>> store(
      String userId, File? image, String content, UserModel userModel) async {
    try {
      const uuid = Uuid();
      final dir = "$userId/${uuid.v6()}";
      var imgPath = "";
      if (image != null && image.existsSync()) {
        imgPath = await SupabaseService.client.storage
            .from(Env.s3Bucket)
            .upload(dir, image);
      }
      final postId = uuid.v4();
      var res = await client.from("posts").insert({
        "id": postId,
        "user_id": userId,
        "content": content,
        "created_at": DateTime.now().toUtc().toIso8601String(),
        "comment_count": 0,
        "like_count": 0,
        "user": userModel,
        "image": imgPath.isNotEmpty ? imgPath : null,
      }).execute();
      return Right(res);
    } on StorageException catch (error) {
      print(error.message);
      return Left(error.message);
    } catch (error) {
      print(error);
      return const Left("Something went wrong!");
    }
  }

  static Future<Either<String, PostModel>> show(String postId) async {
    try {
      final data = await client.from("posts").select('''
    id ,content , image ,created_at ,comment_count , like_count,user_id,
    user:user_id (email , id, image , metadata ,name) , likes:likes (user_id ,post_id)
''').eq("id", postId).single();
      var post = PostModel.fromJson(data);
      return Right(post);
    } catch (e) {
      print(e);
      return const Left("Something went wrong!");
    }
  }

  static Future<Either<String, List<CommentModel>>> postComments(
      String postId) async {
    try {
      final List<dynamic> data = await client.from("comments").select('''
    id ,reply ,created_at ,user_id,
    user:user_id (email , image ,id, metadata , name)
''').eq("post_id", postId);
      var comments = [for (var item in data) CommentModel.fromJson(item)];
      return Right(comments);
    } catch (e) {
      return const Left("Somethign went wrong!");
    }
  }

  static Future<void> likeDislike(String status, String postId,
      String postUserId, String userId, UserModel user) async {
    final client = Supabase.instance.client;
    const uuid = Uuid();
    final newLikeId = uuid.v4();
    final notificationId = uuid.v4();
    try {
      if (status == "1") {
        await client.from("likes").insert({
          "id": newLikeId,
          "user_id": userId,
          "post_id": postId,
        }).execute();
        await client.from("notifications").insert({
          "id": notificationId,
          "user_id": userId,
          "notification": "liked on your post.",
          "to_user_id": postUserId,
          "post_id": postId,
          "user": user.toJson(),
        }).execute();
        // final userres = await client
        //     .from("users")
        //     .select("fcm_token")
        //     .eq("id", userId)
        //     .single()
        //     .execute();
        // final fcmToken = userres.data['fcm_token'];
        // if (fcmToken != null) {
        //   final body = {
        //     "to": fcmToken,
        //     "notification": {
        //       "title": "New Like",
        //       "body": "${user.name} liked your post."
        //     },
        //     "data": {"post_id": postId},
        //   };
        //   await AppNotification().sendPushNotification(body);
        // }
        final response = await client
            .from("posts")
            .select("like_count")
            .eq("id", postId)
            .single();
        final currentLikeCount = response["like_count"] ?? 0;
        await client
            .from("posts")
            .update({"like_count": currentLikeCount + 1}).eq("id", postId);
      } else if (status == "0") {
        await client.from("likes").delete().match({
          "user_id": userId,
          "id": newLikeId,
          "post_id": postId,
        });
        final response = await client
            .from("posts")
            .select("like_count")
            .eq("id", postId)
            .single();
        int currentLikeCount = response["like_count"] ?? 0;
        var res = await client
            .from("posts")
            .update({"like_count": currentLikeCount - 1})
            .eq("id", postId)
            .execute();
      }
    } catch (e) {
      print("Error updating like status: $e");
    }
  }
}
