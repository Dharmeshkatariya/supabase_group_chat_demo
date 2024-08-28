import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_app_demo/models/user_model.dart';
import 'package:supabase_app_demo/services/supabase_service.dart';
import 'package:supabase_app_demo/services/user_services.dart';
import '../../../../models/Message.dart';
import '../../../../utils/export.dart';
import '../widget/type/chat_list.dart';
import '../widget/typing.dart';
import 'group_user.dart';
import 'message widget.dart';

class ChatItemWidget extends StatefulWidget {
  final ChatListItemEntity chatItem;
  final bool showSenderInfo;
  final bool extraMarginBeforeSenderInfo;
  final bool isGroup;
  final ValueChanged<Message> onSwipedMessage;

  const ChatItemWidget({
    required this.chatItem,
    super.key,
    required this.isGroup,
    required this.showSenderInfo,
    required this.extraMarginBeforeSenderInfo,
    required this.onSwipedMessage,
  });

  @override
  State<ChatItemWidget> createState() => _ChatItemWidgetState();
}

class _ChatItemWidgetState extends State<ChatItemWidget> {
  String get loggedUid => Get.find<SupabaseService>().loggedUid!;

  @override
  Widget build(BuildContext context) {
    if (widget.chatItem is SeparatorDateForMessages) {
      return SeparatorDateForMessagesWidget(
        dateTime: (widget.chatItem as SeparatorDateForMessages).date,
      );
    }

    if (widget.chatItem is TypingIndicatorChatListItemEntity) {
      final typingItem = widget.chatItem as TypingIndicatorChatListItemEntity;
      final senderInfo = widget.isGroup ? typingItem.user : null;

      return Padding(
        padding: widget.extraMarginBeforeSenderInfo
            ? const EdgeInsets.only(top: 8)
            : EdgeInsets.zero,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isGroup && senderInfo != null)
              Padding(
                padding: EdgeInsets.only(top: 0, left: 1.w, right: 1.w),
                child: widget.showSenderInfo
                    ? Common.commonNetworkImage(senderInfo.image!, 18.r)
                    : SizedBox(width: 40.w),
              ),
            Expanded(
              child: TypingIndicatorWidget(
                showUserInfo: widget.showSenderInfo,
                user: senderInfo,
                key: ValueKey(typingItem.user.id),
              ),
            ),
          ],
        ),
      );
    }
    // if (chatItem is TypingIndicatorChatListItemEntity) {
    //   return TypingIndicatorWidget(
    //     margin: showSenderInfo
    //         ? const EdgeInsets.only(top: 7)
    //         : EdgeInsets.zero,
    //     showUserInfo: showSenderInfo
    //         ? (chatItem as TypingIndicatorChatListItemEntity).user
    //         : null,
    //   );
    // }

    if (widget.chatItem is MessageChatListItemEntity) {
      final messageItem = widget.chatItem as MessageChatListItemEntity;
      final senderInfo =
          widget.isGroup ? messageItem.message.userSendInfoModel : null;
      return Padding(
        padding: widget.extraMarginBeforeSenderInfo
            ? const EdgeInsets.only(top: 8)
            : EdgeInsets.zero,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isGroup && senderInfo != null)
              InkWell(
                onTap: () async {
                  await UserServices.getUser(messageItem.message.userId).then(
                    (res) {
                      res.fold(
                        (l) {},
                        (r) {
                          UserModel user = r;
                          if (user != null) {
                            Get.to(GroupUserDetailView(user: user));
                          }
                        },
                      );
                    },
                  );
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 0, left: 1.w, right: 1.w),
                  child: widget.showSenderInfo
                      ? Common.commonNetworkImage(senderInfo.image!, 18.r)
                      : SizedBox(width: 40.w), // Placeholder for alignment
                ),
              ),
            if (widget.chatItem is MessageChatListItemEntity)
              Expanded(
                child: GestureDetector(
                  child: MessageWidget(
                    showSenderInfo: widget.showSenderInfo,
                    onSwipedMessage: widget.onSwipedMessage,
                    message: messageItem.message,
                    senderInfo: senderInfo,
                    key: ValueKey(messageItem.message.id),
                  ),
                ),
              ),
          ],
        ),
      );
    }
    throw Exception("Unknown chat item type: ${widget.chatItem.runtimeType}");
  }
}

class SeparatorDateForMessagesWidget extends StatelessWidget {
  final DateTime dateTime;

  const SeparatorDateForMessagesWidget({required this.dateTime, super.key});

  String get text {
    DateTime now = DateTime.now();
    final int differenceInDays =
        DateTime(dateTime.year, dateTime.month, dateTime.day)
            .difference(DateTime(now.year, now.month, now.day))
            .inDays;
    if (differenceInDays == 0) {
      return 'Today';
    }
    if (differenceInDays == -1) {
      return 'Yesterday';
    }
    if (differenceInDays > -7) {
      return [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ][dateTime.weekday - 1];
    }
    if (differenceInDays > -365) {
      return '${[
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ][dateTime.month - 1]} ${dateTime.day}';
    }
    return DateFormat('yyyy/MM/dd').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.only(top: 17, bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
        decoration: const BoxDecoration(
          color: Color(0xffebf5fc),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: Text(text,
            style: const TextStyle(color: Colors.indigo, fontSize: 14)),
      ),
    );
  }
}
