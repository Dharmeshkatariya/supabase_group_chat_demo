import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_app_demo/app/routes/app_pages.dart';
import 'package:supabase_app_demo/utils/export.dart';
import 'package:supabase_app_demo/widgets/post_card_bottom_bar.dart';
import 'package:supabase_app_demo/widgets/post_card_top_bar.dart';
import 'package:supabase_app_demo/widgets/post_image.dart';
import '../models/post_model.dart';
import '../utils/type_def.dart';
import 'circle_image.dart';

class PostCard extends StatelessWidget {
  final PostModel post;
  final bool isAuthPost;
  final DeleteCallbackString? callback;

  const PostCard(
      {required this.post, this.isAuthPost = false, this.callback, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 50.w,
              child: Column(
                children: [
                  CircleImage(url: post.user?.metadata?.image),
                ],
              ),
            ),
            10.horizontalSpace,
            Flexible(
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PostCardTopBar(
                      post: post,
                      isAuthPost: isAuthPost,
                      callback: callback,
                    ),
                    InkWell(
                      onTap: () =>
                          Get.toNamed(Routes.SHOWTHREADS, arguments: post.id),
                      child: Text(post.content!),
                    ),
                    10.verticalSpace,
                    if (post.image != null) PostImage(url: post.image!),
                    PostCardBottombar(post: post),
                  ],
                ),
              ),
            )
          ],
        ),
        const Divider(
          color: Color(0xff242424),
        )
      ],
    );
  }

  int? _getString(String idString) {
    if (RegExp(r'^\d+$').hasMatch(idString)) {
      try {
        return int.parse(idString);
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }
}
