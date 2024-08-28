import 'package:get/get.dart';
import 'package:supabase_app_demo/app/modules/threads/controllers/threads_controller.dart';
import 'package:supabase_app_demo/services/database_services.dart';

import '../../../../services/supabase_service.dart';
import '../../../../utils/export.dart';

class CommentController extends GetxController {
  final TextEditingController replyController = TextEditingController(text: '');
  var reply = "".obs;
  var loading = false.obs;

  final thredcontroller = Get.put(ThreadsController());

  void addReply(String userId, String postId, String postUserId) async {
    loading.value = true;
    await DBService.addReply(userId, postId, postUserId, reply.value,
            thredcontroller.user.value!)
        .then((res) {
      res.fold((l) {
        loading.value = false;
        showSnackBar("Error", l);
      }, (r) {
        loading.value = false;
        Get.back();
        showSnackBar("Success", "Replied successfully!");
      });
    });
  }
}
