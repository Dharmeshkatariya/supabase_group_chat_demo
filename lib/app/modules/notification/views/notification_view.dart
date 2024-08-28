import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:supabase_app_demo/app/routes/app_pages.dart';

import '../../../../services/navigation_service.dart';
import '../../../../services/supabase_service.dart';
import '../../../../utils/utility.dart';
import '../../../../widgets/circle_image.dart';
import '../../../../widgets/loading.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  final SupabaseService supabaseService = Get.find<SupabaseService>();

  final NotificationController controller = Get.put(NotificationController());

  @override
  void initState() {
    controller.fetchNotifications(supabaseService.currentUser.value!.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.find<NavigationService>().backToPrevIndex();
              },
              icon: const Icon(Icons.close)),
          title: const Text("Notification"),
        ),
        body: SingleChildScrollView(
          child: Obx(() => controller.loading.value
              ? const Loading()
              : Column(
                  children: [
                    if (controller.notifications.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.notifications.length,
                        itemBuilder: (context, index) => ListTile(
                          onTap: () {
                            Get.toNamed(Routes.SHOWTHREADS,
                                arguments:
                                    controller.notifications[index]!.postId!);
                          },
                          titleAlignment: ListTileTitleAlignment.top,
                          isThreeLine: true,
                          leading: CircleImage(
                            url: controller
                                .notifications[index]!.user!.metadata?.image,
                          ),
                          title: Text(
                              controller.notifications[index]!.user!.name!),
                          trailing: Text(formateDateFromNow(
                              controller.notifications[index]!.createdAt!)),
                          subtitle: Text(
                              controller.notifications[index]!.notification!),
                        ),
                      )
                    else
                      const Text("No notifications found"),
                  ],
                )),
        ));
  }
}
