import 'package:get/get.dart';
import 'package:supabase_app_demo/app/routes/app_pages.dart';
import 'package:supabase_app_demo/services/auth_services.dart';
import 'package:supabase_app_demo/services/chat/chat_services.dart';
import 'package:supabase_app_demo/services/chat/user_status.dart';

import '../../../../services/supabase_service.dart';
import '../../../../utils/storage/storage.dart';
import '../../../../utils/storage/storage_key.dart';

class SettingController extends GetxController {
  final auth = Get.put(AuthServices());
  final supabase = Get.put(SupabaseService());
  final chat = Get.put(UserStatusServices());

  void logout() async {
    var id = supabase.currentUser.value!.id;
    await chat.userOffline(id);
    Storage.session.remove(StorageKey.session);

    SupabaseService.client.auth.signOut();
    await auth.signOut().then((res) {
      res.fold((l) {}, (r) {});
    });

    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
