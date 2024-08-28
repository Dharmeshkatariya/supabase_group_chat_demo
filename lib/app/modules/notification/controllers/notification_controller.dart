import 'package:get/get.dart';
import 'package:supabase_app_demo/services/database_services.dart';

import '../../../../models/notification_model.dart';

class NotificationController extends GetxController {
  RxList<NotificationModel?> notifications = RxList<NotificationModel?>();
  var loading = false.obs;

  Future<void> fetchNotifications(String userId) async {
    loading.value = true;
    await DBService.fetchNotifications(userId).then((res) {
      res.fold((l) {
        loading.value = false;
      }, (r) {
        notifications.value = r;
        loading.value = false;
      });
    });
  }
}
