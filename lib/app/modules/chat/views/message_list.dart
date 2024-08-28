import 'package:get/get.dart';
import '../../../../utils/export.dart';
import '../controllers/chat_controller.dart';
import '../widget/type/chat_list.dart';
import 'chat_item_widget.dart';

class MessagesList extends StatefulWidget {
  final List<ChatListItemEntity> filteredMessages;

  const MessagesList({
    super.key,
    required this.filteredMessages,
  });

  @override
  _MessagesListState createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  final controller = Get.put(ChatController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller.scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      reverse: false,
      itemBuilder: (_, index) {
        final item = widget.filteredMessages[index];
        if (item is MessageChatListItemEntity) {
          return ChatItemWidget(
            key: ValueKey(item.message.id),
            onSwipedMessage: (message) {
              controller.replyToMessage(message);
            },
            chatItem: item,
            showSenderInfo:
                controller.showSenderInfo(controller.messages, index),
            extraMarginBeforeSenderInfo: controller.extraMarginBeforeSenderInfo(
                controller.messages, index),
            isGroup: controller.isGroup,
          );
        } else if (item is SeparatorDateForMessages) {
          return SeparatorDateForMessagesWidget(
            dateTime: item.date,
          );
        }
        // Uncomment this block if you handle typing indicators
        // else if (item is TypingIndicatorChatListItemEntity) {
        //   return TypingIndicatorWidget(
        //     user: item.user,
        //   );
        // }

        return const SizedBox.shrink();
      },
      itemCount: widget.filteredMessages.length,
    );
  }
}
