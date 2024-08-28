import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app/modules/threads/controllers/threads_controller.dart';
import '../services/navigation_service.dart';
import '../services/supabase_service.dart';

class AddThreadAppBar extends StatelessWidget {
  const AddThreadAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xff242424)),
        ),
      ),
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.find<NavigationService>().backToPrevIndex();
                },
                icon: const Icon(Icons.close),
              ),
              const SizedBox(width: 10),
              const Text(
                "New thread",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          Obx(
            () => TextButton(
              onPressed: () => {
                Get.find<ThreadsController>()
                    .store(Get.find<SupabaseService>().currentUser.value!.id),
              },
              child: Get.find<ThreadsController>().loading.value
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : Text(
                      "Post",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            Get.find<ThreadsController>().content.value.length >
                                    1
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }
}
