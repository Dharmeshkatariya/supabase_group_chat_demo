import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_app_demo/app/modules/profile/controllers/profile_controller.dart';
import 'package:supabase_app_demo/app/routes/app_pages.dart';
import 'package:supabase_app_demo/services/database_services.dart';
import '../app/modules/threads/controllers/threads_controller.dart';
import '../models/post_model.dart';
import '../services/supabase_service.dart';

class PostCardBottombar extends StatefulWidget {
  final PostModel post;

  const PostCardBottombar({required this.post, super.key});

  @override
  State<PostCardBottombar> createState() => _PostCardBottombarState();
}

class _PostCardBottombarState extends State<PostCardBottombar> {
  final ThreadsController controller = Get.put(ThreadsController());
  final SupabaseService supabaseService = Get.find<SupabaseService>();
  String likeStatus = "";

  void likeDislike(String status) async {
    setState(() {
      likeStatus = status;
    });
    if (likeStatus == "0") {
      widget.post.likes = [];
    }
    await DBService.likeDislike(status, widget.post.id!, widget.post.userId!,
        supabaseService.currentUser.value!.id, controller.user.value!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            likeStatus == "1" || widget.post.likes!.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      likeDislike("0");
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red[700]!,
                    ),
                  )
                : IconButton(
                    onPressed: () {
                      likeDislike("1");
                    },
                    icon: const Icon(Icons.favorite_outline),
                  ),
            IconButton(
              onPressed: () {
                Get.toNamed(Routes.COMMENT, arguments: widget.post);
              },
              icon: const Icon(Icons.chat_bubble_outline),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.send_outlined),
            )
          ],
        ),
        Row(
          children: [
            Text("${widget.post.commentCount!} replies"),
            const SizedBox(
              width: 10,
            ),
            Text("${widget.post.likeCount} likes")
          ],
        )
      ],
    );
  }
}
