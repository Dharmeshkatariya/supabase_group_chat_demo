import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../services/supabase_service.dart';
import '../../../../widgets/add_thread_appbar.dart';
import '../../../../widgets/thread_image_preview.dart';
import '../controllers/threads_controller.dart';

class AddThreadsView extends StatefulWidget {
  const AddThreadsView({super.key});

  @override
  State<AddThreadsView> createState() => _AddThreadsViewState();
}

class _AddThreadsViewState extends State<AddThreadsView> {
  final ThreadsController controller = Get.put(ThreadsController());

  final SupabaseService supabaseService = Get.find<SupabaseService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const AddThreadAppBar(),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/avatar.png",
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: context.width - 80,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Text(
                              supabaseService
                                  .currentUser.value!.userMetadata?["name"],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextField(
                            autofocus: true,
                            controller: controller.contentController,
                            onChanged: (value) =>
                                controller.content.value = value,
                            style: const TextStyle(fontSize: 14),
                            maxLines: 10,
                            minLines: 1,
                            maxLength: 1000,
                            decoration: const InputDecoration(
                              hintText: 'type a thread',
                              border: InputBorder.none, // Remove border
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              controller.pickImage();
                            },
                            child: const Icon(Icons.attach_file),
                          ),
                          Obx(
                            () => Column(
                              children: [
                                if (controller.image.value != null)
                                  ThreadImagePreview()
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
