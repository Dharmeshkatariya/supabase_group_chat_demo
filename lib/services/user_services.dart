import 'dart:async';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:supabase_app_demo/services/supabase_service.dart';
import 'package:supabase_app_demo/sql/table.dart';
import 'package:supabase_app_demo/sql/table_column/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/comment_model.dart';
import '../models/post_model.dart';
import '../models/user_model.dart';
import '../utils/env.dart';

class UserServices {
  static Future<Either<String, List<UserModel>>> searchUser(
      String name, Timer? debounce) async {
    final Completer<Either<String, List<UserModel>>> completer = Completer();
    try {
      if (debounce?.isActive ?? false) debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 500), () async {
        try {
          if (name.isNotEmpty) {
            final List<dynamic> data = await SupabaseService.client
                .from(TableName.user)
                .select("*")
                .ilike(UsersTable.name, "%$name%");
            final List<UserModel> userList = [
              for (var item in data) UserModel.fromJson(item)
            ];
            completer.complete(Right(userList));
          } else {
            completer.complete(const Right([]));
          }
        } catch (e) {
          completer.complete(Left(e.toString()));
        }
      });
      return completer.future;
    } catch (e) {
      return Future.value(Left(e.toString()));
    }
  }

  static final client = SupabaseService.client;

  static Future<Either<String, List<CommentModel>>> fetchComments(
      String userId) async {
    try {
      final List<dynamic> data =
          await SupabaseService.client.from("comments").select('''
        id , user_id , post_id ,reply ,created_at ,user:user_id (email ,image , id,name,metadata)
''').eq("user_id", userId).order("id", ascending: false);
      var comments = [for (var item in data) CommentModel.fromJson(item)];
      return Right(comments);
    } catch (e) {
      return const Left("value");
    }
  }

  static Future<Either<String, UserModel>> getUser(String userId) async {
    try {
      final response = await SupabaseService.client
          .from(TableName.user)
          .select("*")
          .eq(UsersTable.id, userId)
          .maybeSingle();
      var user = UserModel.fromJson(response);
      return Right(user);
    } catch (e) {
      return const Left("Something went wrong while fetching the user.");
    }
  }

  static Future<Either<String, List<PostModel>>> fetchPosts(
      String userId) async {
    try {
      final List<dynamic> data =
          await SupabaseService.client.from("posts").select('''
    id ,content , image ,created_at ,comment_count,like_count,
    user:user_id (email ,image , id,name,metadata), likes:likes (user_id ,post_id)
''').eq("user_id", userId).order("id", ascending: false);
      var posts = [for (var item in data) PostModel.fromJson(item)];
      return Right(posts);
    } catch (e) {
      return const Left("");
    }
  }

  static Future<Either<String, String>> deleteThread(String postId) async {
    try {
      await SupabaseService.client.from("posts").delete().eq("id", postId);
      return const Right("thread deleted successfully!");
    } catch (e) {
      return const Left("Something went wrong.pls try again.");
    }
  }

  static Future<Either<String, String>> deleteReply(String replyId) async {
    try {
      await SupabaseService.client.from("comments").delete().eq("id", replyId);
      return const Right("Reply deleted successfully!");
    } catch (e) {
      return const Left("Something went wrong.pls try again.");
    }
  }

  static Future<Either<String, UserResponse>> updateProfile(
      String userId, String description, File? image) async {
    try {
      if (image != null && image.existsSync()) {
        final String dir = "$userId/profile.jpg";
        final String path =
            await SupabaseService.client.storage.from(Env.s3Bucket).upload(
                  dir,
                  image,
                  fileOptions: const FileOptions(upsert: true),
                );
        await getUser(userId).then((res) {
          res.fold((l) {}, (r) async {
            await Get.find<SupabaseService>().updateUserDataProfile(r, path);
          });
        });

        await SupabaseService.client.auth.updateUser(
          UserAttributes(
            data: {"image": path},
          ),
        );
      }
      var res = await SupabaseService.client.auth.updateUser(
        UserAttributes(
          data: {
            "description": description,
          },
        ),
      );
      return Right(res);
    } on AuthException catch (error) {
      return Left(error.message);
    } on StorageException catch (error) {
      return Left(error.message);
    }
  }

  static Future<Either<String, List<UserModel>>> getAllUsers() async {
    try {
      final res = await SupabaseService.client
          .from(TableName.user)
          .select("*")
          .execute();
      final List<UserModel> userList = [
        for (var item in res.data) UserModel.fromJson(item)
      ];
      return Right(userList);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
