import 'package:get/get.dart';
import 'package:supabase_app_demo/services/auth_services.dart';
import 'package:supabase_app_demo/services/supabase_service.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
    // Get.put(SupabaseService(),permanent: true,) ;
    Get.put(
      AuthServices(),
      permanent: true,
    );
  }
}
