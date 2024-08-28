import 'package:flutter/material.dart';
import '../models/comment_model.dart';
import '../utils/type_def.dart';
import '../utils/utility.dart';

class CommentCardTopbar extends StatelessWidget {
  final CommentModel comment;
  final bool isAuthCard;
  final DeleteCallbackString? callback;
  const CommentCardTopbar({
    required this.comment,
    this.isAuthCard = false,
    this.callback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          comment.user!.name!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(formateDateFromNow(comment.createdAt!)),
            const SizedBox(width: 10),
            isAuthCard
                ? GestureDetector(
                    onTap: () {
                      confirmBox(
                          "Are you sure ?", "This action can't be undone.", () {
                        callback!(comment.id!);
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
