import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_app_demo/app/routes/app_pages.dart';
import '../models/post_model.dart';
import '../utils/type_def.dart';
import '../utils/utility.dart';

class PostCardTopBar extends StatelessWidget {
  final PostModel post;
  final bool isAuthPost;
  final DeleteCallbackString? callback;

  const PostCardTopBar({
    required this.post,
    this.isAuthPost = false,
    this.callback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Get.toNamed(Routes.SHOWPROFILE, arguments: post.userId!),
          child: Text(
            post.user!.name!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formateDateFromNow(post.createdAt!)),
            const SizedBox(width: 10),
            isAuthPost
                ? GestureDetector(
                    onTap: () {
                      confirmBox("Are you sure ?",
                          "Once it;s deleted then you won't recover it.", () {
                        callback!(post.id!);
                      });
                    },
                    child: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  )
                : const Icon(Icons.more_horiz),
          ],
        )
      ],
    );
  }
}
