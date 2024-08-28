import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../models/post_model.dart';
import '../../../../services/supabase_service.dart';
import '../../../../widgets/circle_image.dart';
import '../../../../widgets/post_image.dart';
import '../controllers/comment_controller.dart';

class CommentView extends StatefulWidget {
  const CommentView({Key? key}) : super(key: key);

  @override
  State<CommentView> createState() => _CommentViewState();
}

class _CommentViewState extends State<CommentView> {
  final PostModel post = Get.arguments;
  final CommentController controller = Get.put(CommentController());
  final SupabaseService supabaseService = Get.find<SupabaseService>();

  void addReply() {
    if (controller.replyController.text.isNotEmpty) {
      controller.addReply(
        supabaseService.currentUser.value!.id,
        post.id!,
        post.userId!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(), icon: const Icon(Icons.close)),
        title: const Text(
          "Reply",
        ),
        actions: [
          TextButton(
            onPressed: addReply,
            child: Obx(
              () => controller.loading.value
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(),
                    )
                  : Text(
                      "Reply",
                      style: TextStyle(
                        fontWeight: controller.reply.value.isNotEmpty
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: context.width * 0.12,
              child: CircleImage(url: post.user?.metadata?.image),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: context.width * 0.80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.user!.name!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(post.content!),
                  // Display the post image if has any
                  if (post.image != null) PostImage(url: post.image!),
                  TextField(
                    autofocus: true,
                    controller: controller.replyController,
                    onChanged: (value) => controller.reply.value = value,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 10,
                    minLines: 1,
                    maxLength: 1000,
                    decoration: InputDecoration(
                      hintText: "Reply to ${post.user!.name!}",
                      border: InputBorder.none, // Remove border
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
