import 'dart:io';

import 'package:get/get.dart';
import 'package:supabase_app_demo/services/database_services.dart';
import '../../../../models/comment_model.dart';
import '../../../../models/post_model.dart';
import '../../../../models/user_model.dart';
import '../../../../services/navigation_service.dart';
import '../../../../services/supabase_service.dart';
import '../../../../services/user_services.dart';
import '../../../../utils/export.dart';

class ThreadsController extends GetxController {
  final TextEditingController contentController =
      TextEditingController(text: "");
  var content = "".obs;
  var loading = false.obs;
  Rx<File?> image = Rx<File?>(null);
  var showPostLoading = false.obs;
  Rx<PostModel> post = Rx<PostModel>(PostModel());
  var commentLoading = false.obs;
  RxList<CommentModel?> comments = RxList<CommentModel?>();

  void pickImage() async {
    File? file = await pickImageFromGallary();
    if (file != null) {
      image.value = file;
    }
  }

  // * Add post
  Future<void> store(String userId) async {
    loading.value = true;
    await DBService.store(userId, image.value, content.value, user.value!)
        .then((res) {
      res.fold((l) {
        loading.value = false;
        showSnackBar("Error", l);
      }, (r) {
        loading.value = false;
        Get.find<NavigationService>().currentIndex.value = 0;
        showSnackBar("Success", "Post Added successfully!");
      });
    });
  }

  Future<void> show(String postId) async {
    comments.value = [];
    showPostLoading.value = true;
    await DBService.show(postId).then((res) {
      res.fold((l) {
        showSnackBar("Error", l);
      }, (r) {
        post.value = r;
        postComments(postId);
        showPostLoading.value = false;
      });
    });
  }

  Future<void> postComments(String postId) async {
    commentLoading.value = true;
    await DBService.postComments(postId).then((res) {
      res.fold((l) {
        showSnackBar("Error", "Somethign went wrong!");
        commentLoading.value = false;
      }, (r) {
        comments.value = r;
        commentLoading.value = false;
      });
    });
  }

  // * Reset the state
  void resetState() {
    content.value = "";
    contentController.text = "";
    image.value = null;
  }

  Rx<UserModel?> user = Rx<UserModel?>(null);

  @override
  Future<void> onInit() async {
    var id = Get.find<SupabaseService>().currentUser.value!.id;
    await UserServices.getUser(id).then((res) {
      res.fold((l) {}, (r) {
        user.value = r;
      });
    });
    super.onInit();
  }
}
