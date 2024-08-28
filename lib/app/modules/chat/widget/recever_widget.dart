import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_app_demo/app/modules/chat/widget/painter_widget.dart';
import 'dart:math' as math; //

import '../../../../models/Message.dart';
import '../../../../models/user_model.dart';
import '../../../../services/chat/chat_services.dart';
import '../../../../services/supabase_service.dart';
import '../../../../utils/export.dart';
import 'message_status.dart';

class ReceiverWidget extends StatefulWidget {
  final Message message;
  final UserModel? senderInfo;

  const ReceiverWidget({super.key, required this.message, this.senderInfo});

  @override
  State<ReceiverWidget> createState() => _ReceiverWidgetState();
}

class _ReceiverWidgetState extends State<ReceiverWidget> {
  String get loggedUid => Get.find<SupabaseService>().loggedUid!;
  final chatServices = Get.put(ChatServices());

  bool get receiverUser => widget.message.userId != loggedUid;

  bool get isMe => widget.message.userId == loggedUid;

  @override
  Widget build(BuildContext context) {
    return receivedMessage(context: context, message: widget.message);
  }

  Widget receivedMessage(
      {required BuildContext context, required Message message}) {
    final messageTextGroup = Flexible(
      child: Row(
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.message.mtype == MessageType.image)
                        GestureDetector(
                          onTap: () {},
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: getS3Url(message.message!),
                              placeholder: (context, url) =>
                                  Utility.imageLoader(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      if (widget.message.mtype == MessageType.text)
                        Text(
                          message.message,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 12),
                        ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      2.verticalSpace,
                      if (widget.message.iAmNotTheSender ||
                          !widget.message.hasPendingWrites) ...[
                        Text(
                          DateFormat('HH:mm').format(widget.message.sentAt!),
                          style: TextStyle(
                            color: receiverUser
                                ? Colors.grey[500]
                                : Colors.green[50],
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(right: 50.0, left: 8, top: 5, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const SizedBox(height: 30),
              messageTextGroup,
            ],
          ),
        ],
      ),
    );
  }
}

class SendWidget extends StatefulWidget {
  final Message message;

  const SendWidget({
    super.key,
    required this.message,
  });

  @override
  State<SendWidget> createState() => _SendWidgetState();
}

class _SendWidgetState extends State<SendWidget> {
  String get loggedUid => Get.find<SupabaseService>().loggedUid!;
  final chatServices = Get.put(ChatServices());

  bool get receiverUser => widget.message.userId != loggedUid;

  bool get isMe => widget.message.userId == loggedUid;

  @override
  Widget build(BuildContext context) {
    return sendMessage(context: context, message: widget.message);
  }

  Widget sendMessage(
      {required BuildContext context, required Message message}) {
    final messageTextGroup = Flexible(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.message.mtype == MessageType.image)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: getS3Url(message.message!),
                            placeholder: (context, url) =>
                                Utility.imageLoader(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      if (widget.message.mtype == MessageType.text)
                        Text(
                          message.message,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      if (widget.message.hasPendingWrites)
                        const SizedBox(height: 2),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      2.verticalSpace,
                      if (widget.message.iAmNotTheSender ||
                          !widget.message.hasPendingWrites) ...[
                        Text(
                          DateFormat('HH:mm').format(widget.message.createdAt),
                          style: TextStyle(
                            color: receiverUser
                                ? Colors.grey[500]
                                : Colors.green[50],
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                      2.horizontalSpace,
                      if (!receiverUser)
                        Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: messageStatus(message: widget.message),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          CustomPaint(painter: Triangle(Colors.grey[900]!)),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(right: 18.0, left: 50, top: 5, bottom: 5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const SizedBox(height: 30),
              messageTextGroup,
            ],
          ),
        ],
      ),
    );
  }
}
