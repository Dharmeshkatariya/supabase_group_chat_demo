import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_app_demo/utils/export.dart';
import '../models/comment_model.dart';
import '../utils/type_def.dart';
import 'circle_image.dart';
import 'comment_card_topbar.dart';

class CommentCard extends StatelessWidget {
  final CommentModel comment;
  final bool isAuthCard;
  final DeleteCallbackString? callback;
  const CommentCard({
    required this.comment,
    this.isAuthCard = false,
    this.callback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: context.width * 0.12,
              child: CircleImage(
                url: comment.user!.image,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommentCardTopbar(
                    comment: comment,
                    isAuthCard: isAuthCard,
                    callback: callback,
                  ),
                  Text(comment.reply!),
                ],
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
}
