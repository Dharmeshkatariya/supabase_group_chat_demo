import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:intl/intl.dart';
import 'package:supabase_app_demo/app/modules/chat/controllers/chat_controller.dart';
import 'package:supabase_app_demo/app/modules/chat/widget/painter_widget.dart';
import 'package:supabase_app_demo/models/user_model.dart';
import 'package:supabase_app_demo/services/chat/chat_services.dart';
import 'package:supabase_app_demo/services/chat/media_service.dart';
import 'package:supabase_app_demo/services/supabase_service.dart';
import 'package:swipe_to/swipe_to.dart';
import 'dart:math' as math; //
import '../../../../models/Message.dart';
import '../../../../utils/export.dart';
import '../widget/pdf/pdf_overlay_widget.dart';
import '../widget/video_player/cache_video.dart';
import '../widget/message_status.dart';
import '../widget/reply/reply_widget.dart';
import '../widget/reaction/stack_reaction.dart';
import '../widget/forward/forward_message_header_widget.dart';

class MessageWidget extends StatefulWidget {
  final Message message;
  final bool showSenderInfo;
  final UserModel? senderInfo;
  final ValueChanged<Message> onSwipedMessage;

  const MessageWidget({
    super.key,
    required this.message,
    this.senderInfo,
    required this.showSenderInfo,
    required this.onSwipedMessage,
  });

  @override
  State<MessageWidget> createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  String get loggedUid => Get.find<SupabaseService>().loggedUid!;
  final chatServices = Get.put(ChatServices());
  final chatController = Get.put(ChatController());

  bool get receiverUser => widget.message.userId != loggedUid;

  bool get isMe => widget.message.userId == loggedUid;

  @override
  Widget build(BuildContext context) {
    final replyMessage = widget.message.replyMessage;
    final isReplying = replyMessage != null;
    return GestureDetector(
      onLongPress: () {
        chatController.onMessageLongPress(
            message: widget.message,
            context: context,
            receiverUser: receiverUser,
            isMe: isMe);
      },
      onTap: () {
        MediaService().showMessageBottomSheet(
            isMe: isMe, context: context, message: widget.message);
      },
      child: receiverUser
          ? SwipeTo(
              onRightSwipe: (details) => widget.onSwipedMessage(widget.message),
              child: receivedMessage(
                context: context,
                message: widget.message,
              ),
            )
          : sendMessage(
              context: context,
              message: widget.message,
            ),
    );
  }

  Widget sendMessage({
    required BuildContext context,
    required Message message,
  }) {
    final replyMessage = widget.message.replyMessage;

    final isReplying = replyMessage != null;
    return Padding(
      padding: const EdgeInsets.only(right: 18.0, left: 50, top: 5, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isReplying) buildReplyMessage(),
                if (message.forwardedFrom != null &&
                    message.chatRoomId != message.forwardedFrom &&
                    message.isForwarded) ...[
                  ForwardedMessageHeader(
                    originalMessageId: message.originalMessageId!,
                    forwardedFrom: message.forwardedFrom!,
                  ),
                  const SizedBox(height: 5),
                ],
                if (message.mtype == MessageType.image) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: InstaImageViewer(
                      child: CachedNetworkImage(
                        imageUrl: getS3Url(message.message!),
                        height: 200.h,
                        width: 200.w,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Utility.imageLoader(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
                if (message.mtype == MessageType.file) ...[
                  PDFMessageWidget(
                    pdfThumbnailUrl: message.message,
                    fileName: message.message!.split('/').last,
                  ),
                  const SizedBox(height: 5),
                ],
                if (message.mtype == MessageType.text) ...[
                  Text(
                    message.message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
                if (message.mtype == MessageType.video) ...[
                  CustomVideoPlayer(
                    message: message,
                  ),
                  const SizedBox(height: 5),
                ],
                if (message.hasPendingWrites) const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (message.iAmNotTheSender ||
                        !message.hasPendingWrites) ...[
                      Text(
                        DateFormat('HH:mm').format(message.createdAt),
                        style: TextStyle(
                          color: receiverUser
                              ? Colors.grey[500]
                              : Colors.green[50],
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 2),
                    ],
                    if (!receiverUser)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: messageStatus(message: message),
                      ),
                  ],
                ),
              ],
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              buildReactions(isMe),
            ],
          )
        ],
      ),
    );
  }

  Widget buildReactions(bool isMe) {
    return StackedReactions(
      reactions: widget.message.messageReaction,
    );
  }

  Widget buildReplyMessage({Color? backGroundColor, Color? textColor}) {
    final replyMessage = widget.message.replyMessage;
    final isReplying = replyMessage != null;

    if (!isReplying) {
      return Container();
    } else {
      return Container(
        clipBehavior: Clip.none,
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.only(bottom: 8),
        color: backGroundColor ?? Colors.transparent,
        child: ReplyMessageWidget(textColor: textColor, message: replyMessage),
      );
    }
  }

  Widget receivedMessage({
    required BuildContext context,
    required Message message,
  }) {
    final replyMessage = widget.message.replyMessage;
    final isReplying = replyMessage != null;
    return FadeIn(
      duration: const Duration(milliseconds: 300),
      child: Padding(
        padding: const EdgeInsets.only(right: 50.0, left: 8, top: 5, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(math.pi),
                  child: CustomPaint(
                    painter: Triangle(Colors.grey[300]!),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isReplying)
                          buildReplyMessage(textColor: AppColors.black54),
                        if (message.forwardedFrom != null &&
                            message.chatRoomId != message.forwardedFrom &&
                            message.isForwarded) ...[
                          ForwardedMessageHeader(
                            originalMessageId: message.originalMessageId!,
                            forwardedFrom: message.forwardedFrom!,
                          ),
                          const SizedBox(height: 5),
                        ],
                        if (message.userSendInfoModel != null && receiverUser)
                          Text(
                            message.userSendInfoModel!.name!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              color: AppColors.black54,
                            ),
                          ),
                        if (message.mtype == MessageType.image)
                          FadeIn(
                            duration: const Duration(milliseconds: 300),
                            child: GestureDetector(
                              onTap: () {},
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: InstaImageViewer(
                                  child: CachedNetworkImage(
                                    imageUrl: getS3Url(message.message!),
                                    placeholder: (context, url) =>
                                        Utility.imageLoader(),
                                    height: 200.h,
                                    width: 200.w,
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (message.mtype == MessageType.text)
                          Text(
                            message.message,
                            style: const TextStyle(
                              color: Colors.black,
                              fontFamily: 'Monstserrat',
                              fontSize: 14,
                            ),
                          ),
                        const SizedBox(height: 5),
                        if (message.mtype == MessageType.video) ...[
                          CustomVideoPlayer(
                            message: message,
                          ),
                          const SizedBox(height: 5),
                        ],
                        if (message.mtype == MessageType.file) ...[
                          PDFMessageWidget(
                            pdfThumbnailUrl: message.message,
                            fileName: message.message!.split('/').last,
                          ),
                          const SizedBox(height: 5),
                        ],
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (message.iAmNotTheSender ||
                                !message.hasPendingWrites)
                              Text(
                                DateFormat('HH:mm').format(message.sentAt!),
                                style: TextStyle(
                                  color: receiverUser
                                      ? Colors.grey[500]
                                      : Colors.green[50],
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            buildReactions(isMe),
          ],
        ),
      ),
    );
  }
}
