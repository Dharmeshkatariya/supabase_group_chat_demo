import 'dart:io';

import 'package:get/get.dart';
import 'package:supabase_app_demo/services/user_services.dart';

import '../../../../models/comment_model.dart';
import '../../../../models/post_model.dart';
import '../../../../models/user_model.dart';
import '../../../../utils/utility.dart';

class ProfileController extends GetxController {
  Rx<File?> image = Rx<File?>(null);
  var loading = false.obs;
  RxList<PostModel> posts = RxList<PostModel>();
  var postLoading = false.obs;
  var replyLoading = false.obs;
  RxList<CommentModel?> comments = RxList<CommentModel?>();
  var userLoading = false.obs;
  Rx<UserModel?> user = Rx<UserModel?>(null);

  Future<void> fetchComments(String userId) async {
    replyLoading.value = true;
    await UserServices.fetchComments(userId).then((res) {
      replyLoading.value = false;
      res.fold((l) {}, (r) {
        comments.value = r;
      });
    });
  }

  Future<void> getUser(String userId) async {
    userLoading.value = true;

    await UserServices.getUser(userId).then((res) {
      res.fold((l) {
        userLoading.value = false;
      }, (r) {
        user.value = r;
        fetchComments(userId);
        fetchPosts(userId);
        userLoading.value = false;
      });
    });
  }

  Future<void> fetchPosts(String userId) async {
    postLoading.value = true;
    await UserServices.fetchPosts(userId).then((res) {
      res.fold((l) {
        postLoading.value = false;
      }, (r) {
        posts.value = r;
        postLoading.value = false;
      });
    });
  }

  void pickImage() async {
    File? file = await pickImageFromGallary();
    if (file != null) image.value = file;
  }

  Future<void> updateProfile(String userId, String description) async {
    loading.value = true;
    await UserServices.updateProfile(userId, description, image.value)
        .then((res) {
      res.fold((l) {
        loading.value = false;
        showSnackBar("Error", l);
      }, (r) {
        loading.value = false;

        showSnackBar("Success", "Profile update successfully!");
      });
    });
  }

  Future<void> deleteThread(String postId) async {
    await UserServices.deleteThread(postId).then((res) {
      res.fold((l) {
        showSnackBar("Error", l);
      }, (r) {
        posts.removeWhere((element) => element.id == postId);
        if (Get.isDialogOpen == true) {
          Get.back();
        }
        showSnackBar("Success", r);
      });
    });
  }

  Future<void> deleteReply(String replyId) async {
    await UserServices.deleteReply(replyId).then((res) {
      res.fold((l) {
        showSnackBar("Error", l);
      }, (r) {
        comments.removeWhere((element) => element?.id == replyId);
        if (Get.isDialogOpen == true) {
          Get.back();
        }
        showSnackBar("Success", r);
      });
    });
  }
}
