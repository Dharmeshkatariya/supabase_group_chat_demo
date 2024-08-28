import 'package:get/get.dart';
import 'package:supabase_app_demo/app/modules/chat/controllers/chat_controller.dart';
import 'package:supabase_app_demo/utils/export.dart';

import '../../../../../models/Message.dart';

class ReplyMessageWidget extends StatefulWidget {
  final Message message;
  VoidCallback? onCancelReply;
  bool? isMe;
  Color? textColor;

  ReplyMessageWidget({
    required this.message,
    this.onCancelReply,
    this.isMe,
    this.textColor,
    super.key,
  });

  @override
  State<ReplyMessageWidget> createState() => _ReplyMessageWidgetState();
}

class _ReplyMessageWidgetState extends State<ReplyMessageWidget> {
  final chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.green,
              width: 4,
            ),
            4.horizontalSpace,
            Flexible(child: buildReplyMessage()),
          ],
        ),
      );

  Widget buildReplyMessage() => GestureDetector(
        onTap: () {
          print(widget.message.id);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.message.userSendInfoModel?.name ?? 'Unknown User',
                    maxLines: 1,
                    style: TextStyle(
                        color: widget.textColor ?? AppColors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  if (widget.onCancelReply != null)
                    GestureDetector(
                      onTap: widget.onCancelReply,
                      child: Icon(Icons.close, size: 16.h),
                    )
                ],
              ),
              3.verticalSpace,
              if (widget.message.mtype == MessageType.text)
                Text(
                  widget.message.message,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  maxLines: 3,
                  style: TextStyle(
                    color: widget.textColor ?? AppColors.white,
                  ),
                ),
              // if (widget.message.mtype == MessageType.image)
              //   Image.network(
              //     getS3Url(widget.message.message),
              //     height: 50.h,
              //     width: 50.w,
              //     fit: BoxFit.cover,
              //   ),
            ],
          ),
        ),
      );
}
