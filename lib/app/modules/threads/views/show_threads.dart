import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/comment_card.dart';
import '../../../../widgets/loading.dart';
import '../../../../widgets/post_card.dart';
import '../controllers/threads_controller.dart';

class ShowThreadsView extends StatefulWidget {
  const ShowThreadsView({super.key});

  @override
  State<ShowThreadsView> createState() => _ShowThreadsViewState();
}

class _ShowThreadsViewState extends State<ShowThreadsView> {
  final String postId = Get.arguments;
  final ThreadsController controller = Get.put(ThreadsController());

  @override
  void initState() {
    controller.show(postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thread"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Obx(
          () => controller.showPostLoading.value
              ? const Loading()
              : Column(
                  children: [
                    PostCard(post: controller.post.value),
                    const SizedBox(height: 20),
                    if (controller.commentLoading.value)
                      const Loading()
                    else if (controller.comments.isNotEmpty &&
                        controller.commentLoading.value == false)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.comments.length,
                        itemBuilder: (context, index) =>
                            CommentCard(comment: controller.comments[index]!),
                      )
                    else
                      const Text("No replies")
                  ],
                ),
        ),
      ),
    );
  }
}
