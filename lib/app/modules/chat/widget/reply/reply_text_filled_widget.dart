import '../../../../../models/Message.dart';
import '../../../../../utils/export.dart';

class ReplyMessageTextInputWidget extends StatefulWidget {
  final Message message;
  VoidCallback? onCancelReply;
  bool? isMe;
  Color? textColor;
  ReplyMessageTextInputWidget({
    required this.message,
    this.onCancelReply,
    this.isMe,
    this.textColor,
    super.key,
  });

  @override
  State<ReplyMessageTextInputWidget> createState() =>
      _ReplyMessageTextInputWidgetState();
}

class _ReplyMessageTextInputWidgetState
    extends State<ReplyMessageTextInputWidget> {
  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.green,
              width: 4,
            ),
            4.horizontalSpace,
            Expanded(child: buildReplyMessage()),
          ],
        ),
      );

  Widget buildReplyMessage() => Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.message.userSendInfoModel?.name ?? 'Unknown User',
                    maxLines: 1,
                    style: TextStyle(
                        color: widget.textColor ?? AppColors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  ),
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
          ],
        ),
      );
}
