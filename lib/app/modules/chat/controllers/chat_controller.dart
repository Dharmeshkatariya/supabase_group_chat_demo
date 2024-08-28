import 'dart:io';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter_chat_reactions/flutter_chat_reactions.dart';
import 'package:flutter_chat_reactions/utilities/hero_dialog_route.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:supabase_app_demo/models/Message.dart';
import 'package:supabase_app_demo/app/modules/chat/views/chat_room_list.dart';
import 'package:supabase_app_demo/models/chat%20model.dart';
import 'package:supabase_app_demo/models/message_reaction.dart';
import 'package:supabase_app_demo/services/message_notification.dart';
import 'package:supabase_app_demo/services/user_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../../../models/user_model.dart';
import '../../../../services/chat/chat_services.dart';
import '../../../../services/network_services.dart';
import '../../../../services/supabase_service.dart';
import '../../../../services/chat/typing_services.dart';
import '../../../../utils/chat_date.dart';
import '../../../../utils/export.dart';
import '../../../../utils/no intenret.dart';
import '../widget/type/chat_list.dart';
import '../widget/recever_widget.dart';

class ChatController extends GetxController {
  bool get isGroup => true;
  RxBool isLoading = true.obs;
  int? firstEventEmittedAtTimestamp;
  ChatServices chatServices = Get.put(ChatServices());
  Future<void> updateReadStatus(chatRoomId) async {
    final loggedUid = Get.find<SupabaseService>().loggedUid;

    for (final item in messages) {
      if (item is MessageChatListItemEntity) {
        final pendingReadMessage = item;
        if (pendingReadMessage.message.userId != loggedUid &&
            !pendingReadMessage.message.iRead) {
          if (_isReadingLatestMessages) {
            await chatServices.updateMessageToRead(
                chatRoomId: chatRoomId,
                userId: loggedUid!,
                messageId: pendingReadMessage.message.id);
          } else {
            userWillReadSoonMessages.add(pendingReadMessage.message.id);
          }
        }
      }
    }
  }

  final List<String> userWillReadSoonMessages = [];

  void updateMessageForType() {
    final List<ChatListItemEntity> result = [];
    Message? previousMessage;
    for (final currentItem in messages) {
      if (currentItem is MessageChatListItemEntity) {
        final currentMessage = currentItem.message;
        final isNewDay = previousMessage == null ||
            isDifferentDay(currentMessage.sentAt!, previousMessage.sentAt!);
        if (isNewDay) {
          result.add(SeparatorDateForMessages(date: currentMessage.sentAt!));
        }
        result.add(currentItem);
        previousMessage = currentMessage;

        if (currentMessage is TypingIndicatorChatListItemEntity) {
          result.add(TypingIndicatorChatListItemEntity(
              user: currentMessage.userSendInfoModel!));
        }
        // for (final typingUser in currentMessage.typingUsers) {
        //   if (typingUser.id != currentMessage.userId) {
        //     print(typingUser.id);
        //     result.add(TypingIndicatorChatListItemEntity(user: typingUser));
        //   }
        // }
      }
    }

    messages.value = result;

    if (_isReadingLatestMessages ||
        (firstEventEmittedAtTimestamp == null ||
            DateTime.now().millisecondsSinceEpoch -
                    firstEventEmittedAtTimestamp! <
                1000)) {
      firstEventEmittedAtTimestamp = DateTime.now().millisecondsSinceEpoch;
      notifyUnreadMessagesAtTheBottom.value = false;
      scrollToBottom();
    } else {
      notifyUnreadMessagesAtTheBottom.value =
          userWillReadSoonMessages.isNotEmpty;
    }
    firstEventEmittedAtTimestamp = firstEventEmittedAtTimestamp! + 1;
  }

  bool get _scrollIsCloseToTheBottom {
    if (!scrollController.hasClients) {
      return false;
    }
    return scrollController.position.maxScrollExtent == 0 ||
        (scrollController.position.pixels > 0 &&
            (scrollController.position.maxScrollExtent -
                    scrollController.position.pixels <
                (Get.height * .1)));
  }

  String _previousText = "";
  final RxBool hasTextToSend = false.obs;
  final typingService = Get.put(TypingServices());
  final TextEditingController textController = TextEditingController();
  void textListenr(String chatRoomId) {
    textController.addListener(() {
      textChanged(chatRoomId: chatRoomId);
    });
  }

  void textChanged({required String chatRoomId}) {
    if (_previousText != textController.text &&
        textController.text.isNotEmpty) {
      _isTyping.value = true;
      // _updateTypingStatus(chatRoomId: chatRoomId);
    } else {
      _isTyping.value = false;
      // _updateTypingStatus(chatRoomId: chatRoomId);
    }
    hasTextToSend.value = textController.text.isNotEmpty;
    _previousText = textController.text;
  }

  final RxBool _isTyping = false.obs;

  void _updateTypingStatus({required String chatRoomId}) async {
    await UserServices.getUser(loggedUid!).then((res) {
      res.fold((l) {}, (r) async {
        if (_isTyping.value) {
          await chatServices.updateTypingUsers(
            chatRoomId: chatRoomId,
            typingUserIds: [r],
          );
        } else {
          await chatServices.updateTypingUsers(
            chatRoomId: chatRoomId,
            typingUserIds: [],
          );
        }
      });
    });
  }

  var notifyUnreadMessagesAtTheBottom = false.obs;

  final disposed = false.obs;

  bool get _isReadingLatestMessages => (!disposed.value &&
      // _scrollIsCloseToTheBottom &&
      (WidgetsBinding.instance.lifecycleState == null ||
          WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed));

  Future<void> checkWhetherUserIsReading(
    chatRoomId,
  ) async {
    if (_isReadingLatestMessages) {
      for (final messageId in userWillReadSoonMessages) {
        await chatServices.updateMessageToRead(
            chatRoomId: chatRoomId, userId: loggedUid!, messageId: messageId);
      }
      userWillReadSoonMessages.clear();
      notifyUnreadMessagesAtTheBottom.value = false;
    } else {
      notifyUnreadMessagesAtTheBottom.value =
          userWillReadSoonMessages.isNotEmpty;
    }
  }

  late ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    // scrollController.dispose();
    super.dispose();
  }

  void scrollToBottom() {
    for (int i = 0; i <= 14; i++) {
      Future.delayed(Duration(milliseconds: i * 50), () {
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
    }
  }

  late SupabaseClient client;
  late RealtimeChannel _channel;
  RxList<ChatListItemEntity> messages = <ChatListItemEntity>[].obs;

  Future<void> getChats(chatRoomId) async {
    await chatServices.getChats(chatRoomId).then(
      (res) {
        res.fold(
          (l) {
            isLoading.value = false;
          },
          (r) {
            messages.value = r
                .map((msg) => MessageChatListItemEntity(message: msg))
                .toList();
            updateMessageForType();
            scrollToBottom();
            updateReadStatus(chatRoomId);
            isLoading.value = false;
          },
        );
      },
    );
  }

  void setupRealtimeSubscription(chatRoomId) {
    _channel = client.channel('public:messages');
    _channel.on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: 'INSERT',
        schema: 'public',
        table: 'messages',
      ),
      (payload, [ref]) {
        final newMessage =
            Message.fromJson(payload["new"] as Map<String, dynamic>);
        final chatListItemEntity = MessageChatListItemEntity(
          message: newMessage,
        );
        messages.add(chatListItemEntity);
        updateMessageForType();
        updateReadStatus(chatRoomId);
        scrollToBottom();
      },
    );
    _channel.on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: 'UPDATE',
        schema: 'public',
        table: 'messages',
      ),
      (payload, [ref]) {
        final updatedMessage =
            Message.fromJson(payload["new"] as Map<String, dynamic>);
        messages.value = messages.value.map((msg) {
          if (msg is MessageChatListItemEntity &&
              msg.message.id == updatedMessage.id) {
            return MessageChatListItemEntity(message: updatedMessage);
          }
          return msg;
        }).toList();

        for (final typingUser in updatedMessage.typingUsers) {
          if (typingUser.id != updatedMessage.userId) {
            messages.value
                .add(TypingIndicatorChatListItemEntity(user: typingUser));
          }
        }
      },
    );

    _channel.on(
      RealtimeListenTypes.postgresChanges,
      ChannelFilter(
        event: 'DELETE',
        schema: 'public',
        table: 'messages',
      ),
      (payload, [ref]) {
        final deletedMessageId = payload["old"]["id"] as String;
        messages.removeWhere((msg) =>
            msg is MessageChatListItemEntity &&
            msg.message.id == deletedMessageId);
      },
    );
    _channel.subscribe();
  }

  RxBool showScrollIcon = false.obs;

  messageScrollWidgetListener() {
    scrollController.addListener(
      () {
        if (scrollController.offset <
            scrollController.position.maxScrollExtent - 100) {
          showScrollIcon.value = true;
        } else {
          showScrollIcon.value = false;
        }
      },
    );
  }

  Future sendMessage({
    required String chatRoomId,
    required String chatRoomName,
    required String usersId,
    required List<UserModel> typingUser,
    required List<String> userIds,
    required ChatRoomModel chatroom,
  }) async {
    var message = textController.text;

    if (!await _checkNetworkConnection()) return;
    if (_isMessageValid()) {
      await _sendChatMessage(
        chatRoomId: chatRoomId,
        usersId: usersId,
        message: message,
        typingUser: typingUser,
        userIds: userIds,
      );
      _resetMessageInput();
      await MessageNotification.notifyParticipants(
          chatRoomId, chatRoomName, usersId, message, chatroom);
    }
  }

  void _resetMessageInput() {
    textController.clear();
    cancelReply();
  }

  Future<void> _sendChatMessage({
    required String chatRoomId,
    required String message,
    required String usersId,
    required List<UserModel> typingUser,
    required List<String> userIds,
  }) async {
    await chatServices
        .sendMessage(
          message: message,
          chatRoomId: chatRoomId,
          userId: usersId,
          typingUser: typingUser,
          type: MessageType.text,
          participants: userIds,
          user: user.value!,
          replyMessage: replyMessage.value,
        )
        .then((_) {});
  }

  Future forwardMessage({
    required ChatRoomModel chatroom,
    required String originalMessageId,
    required String forwardedChatRoomId,
    required Message message,
  }) async {
    selectedMessages.clear();
    if (!await _checkNetworkConnection()) return;
    await chatServices
        .forwardMessage(
            message: message.message,
            chatRoomId: chatroom.chat_room_id,
            userId: loggedUid!,
            typingUser: message.typingUsers,
            type: message.mtype,
            participants: message.participants,
            user: user.value!,
            originalMessageId: originalMessageId,
            forwardedChatRoomId: forwardedChatRoomId)
        .then((res) {
      res.fold((l) {}, (r) {
        Get.offAll(const ChatRoomListPage());
      });
    });
  }

  Rx<UserModel?> user = Rx<UserModel?>(null);

  Rx<File?> image = Rx<File?>(null);

  Widget emojiPickerWidget() {
    return SizedBox(
      height: Get.height * .35,
      child: EmojiPicker(
        textEditingController: textController,
        config: Config(
          bgColor: const Color.fromARGB(255, 234, 248, 255),
          columns: 8,
          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
        ),
      ),
    );
  }

  bool extraMarginBeforeSenderInfo(List<ChatListItemEntity> list, int index) {
    if (!showSenderInfo(list, index)) {
      return false;
    }
    return index > 0 && list[index - 1] is MessageChatListItemEntity;
  }

  String? get loggedUid => Get.find<SupabaseService>().loggedUid;

  bool showSenderInfo(List<ChatListItemEntity> list, int index) {
    if (!isGroup) {
      return false;
    }
    if (list[index] is! MessageChatListItemEntity &&
        list[index] is! TypingIndicatorChatListItemEntity) {
      return false;
    }
    if (list[index] is MessageChatListItemEntity &&
        (list[index] as MessageChatListItemEntity).message.userId ==
            loggedUid) {
      return false;
    }
    if (index == 0) {
      return true;
    }
    if (list[index - 1] is! MessageChatListItemEntity) {
      return true;
    }
    if (list[index] is TypingIndicatorChatListItemEntity) {
      return (list[index - 1] as MessageChatListItemEntity).message.userId !=
          (list[index] as TypingIndicatorChatListItemEntity).user.id;
    }
    if (list[index] is MessageChatListItemEntity &&
        (list[index] as MessageChatListItemEntity).message.userId ==
            loggedUid) {
      return false;
    }
    return (list[index - 1] as MessageChatListItemEntity).message.userId !=
        (list[index] as MessageChatListItemEntity).message.userId;
  }

  Future sendVideo({
    required String chatRoomId,
    required String res,
    required String usersId,
    required File image,
    required List<String> userIds,
    required List<UserModel> typingUser,
  }) async {
    var imgPath = res;
    await _sendVideoMessage(
      chatRoomId: chatRoomId,
      typingUser: typingUser,
      imageUrl: imgPath,
      usersId: usersId,
      userIds: userIds,
    );
  }

  Future sendPdf({
    required String chatRoomId,
    required String res,
    required String usersId,
    required File pdf,
    required List<String> userIds,
    required List<UserModel> typingUser,
  }) async {
    var imgPath = res;
    await _sendPdfMessage(
      chatRoomId: chatRoomId,
      typingUser: typingUser,
      pdf: imgPath,
      usersId: usersId,
      userIds: userIds,
    );
  }

  Future sendImg({
    required String chatRoomId,
    required String res,
    required String usersId,
    required File image,
    required List<String> userIds,
    required List<UserModel> typingUser,
  }) async {
    var imgPath = res;
    await _sendImgMessage(
      chatRoomId: chatRoomId,
      typingUser: typingUser,
      imageUrl: imgPath,
      usersId: usersId,
      userIds: userIds,
    );
  }

  final RxBool _showEmoji = false.obs;

  bool get showEmoji => _showEmoji.value;

  setShowEmoji() {
    _showEmoji.value = !_showEmoji.value;
  }

  RxString chatPdf = "".obs;

  Future<void> _sendPdfMessage({
    required String chatRoomId,
    required String pdf,
    required String usersId,
    required List<UserModel> typingUser,
    required List<String> userIds,
  }) async {
    if (!await _checkNetworkConnection()) return;
    await chatServices
        .sendImageMessage(
            imageUrl: pdf,
            participants: userIds,
            chatRoomId: chatRoomId,
            typingUser: typingUser,
            userId: usersId,
            user: user.value!,
            type: MessageType.file)
        .then((res) {});
    Fluttertoast.showToast(msg: 'Uploaded Pdf!');
  }

  Future<void> _sendVideoMessage({
    required String chatRoomId,
    required String imageUrl,
    required String usersId,
    required List<UserModel> typingUser,
    required List<String> userIds,
  }) async {
    if (!await _checkNetworkConnection()) return;
    await chatServices
        .sendImageMessage(
            imageUrl: imageUrl,
            participants: userIds,
            chatRoomId: chatRoomId,
            typingUser: typingUser,
            userId: usersId,
            user: user.value!,
            type: MessageType.video)
        .then((res) {});
    Fluttertoast.showToast(msg: 'Uploaded Video!');
  }

  Future<void> _sendImgMessage({
    required String chatRoomId,
    required String imageUrl,
    required String usersId,
    required List<UserModel> typingUser,
    required List<String> userIds,
  }) async {
    if (!await _checkNetworkConnection()) return;
    await chatServices
        .sendImageMessage(
            imageUrl: imageUrl,
            participants: userIds,
            chatRoomId: chatRoomId,
            typingUser: typingUser,
            userId: usersId,
            user: user.value!,
            type: MessageType.image)
        .then((res) {});
    Fluttertoast.showToast(msg: 'Uploaded Image!');
  }

  void toggleMessageSelection(Message message) {
    if (selectedMessages.contains(message)) {
      selectedMessages.remove(message);
    } else {
      selectedMessages.add(message);
    }
  }

  var selectedMessages = <Message>[].obs;

  final GetXNetworkManager isNetwork = Get.find();

  @override
  void onInit() {
    isNetwork.isConnected.listenAndPump((val) {
      if (val) {
        Get.back();
      } else {
        Get.to(const NoInternetScreen());
      }
    });
    super.onInit();
  }

  // Future<void> searchMessages(String chatRoomId, String query) async {
  //   try {
  //     final searchResults = await chatServices.searchMessages(
  //       chatRoomId: chatRoomId,
  //       query: query,
  //     );
  //     messages.value = searchResults
  //         .map((msg) => MessageChatListItemEntity(message: msg))
  //         .toList();
  //     updateMessageForType();
  //   } catch (e) {}
  // }

  RxString searchQuery = "".obs;
  RxBool isSearching = false.obs;

  onSearchQuery(BuildContext context) {
    if (isSearching.value) {
      searchQuery.value = "";
      isSearching.value = false;
      FocusScope.of(context).unfocus();
      scrollToBottom();
    } else {
      isSearching.value = true;
    }
  }

  List<ChatListItemEntity> searchFilter() {
    final filteredMessages = messages.where((item) {
      if (item is MessageChatListItemEntity) {
        return item.message.message.contains(searchQuery.value);
      }
      return true;
    }).toList();
    return filteredMessages;
  }

  final focusNode = FocusNode();
  Rx<Message?> replyMessage = Rx<Message?>(null);

  void replyToMessage(Message message) {
    replyMessage.value = message;
    focusNode.requestFocus();
  }

  void cancelReply() {
    replyMessage.value = null;
  }

  onMessageLongPress({
    required Message message,
    required BuildContext context,
    required bool receiverUser,
    required bool isMe,
  }) {
    toggleMessageSelection(message);
    Navigator.of(context).push(
      HeroDialogRoute(
        builder: (context) {
          return ReactionsDialogWidget(
            id: message.id,
            messageWidget: receiverUser
                ? ReceiverWidget(
                    message: message,
                  )
                : SendWidget(
                    message: message,
                  ),
            onReactionTap: (reaction) async {
              if (reaction == '➕') {
                await showEmojiBottomSheet(
                    message: message, context: context, userId: loggedUid!);
              } else {
                final newReaction = MessageReaction(
                  id: const Uuid().v4().toString(),
                  messageId: message.id,
                  userId: loggedUid!,
                  reaction: reaction,
                  createdAt: DateTime.now().toIso8601String(),
                );
                await updateReactionToMessage(
                  message: message,
                  reaction: newReaction,
                );
              }
            },
            onContextMenuTap: (menuItem) async {
              if (menuItem.label == "Delete") {
                await deleteReaction(
                  message: message,
                );
              } else if (menuItem.label == "Copy") {
                final currentUserReactions = message.messageReaction
                    .map((reaction) => reaction.reaction)
                    .join(", ");

                await Clipboard.setData(
                  ClipboardData(text: currentUserReactions),
                ).then((_) =>
                    Fluttertoast.showToast(msg: "Message copied to clipboard"));
              }
            },
            widgetAlignment:
                isMe ? Alignment.centerRight : Alignment.centerLeft,
          );
        },
      ),
    );
  }

  showEmojiBottomSheet({
    required Message message,
    required BuildContext context,
    required String userId,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 310,
          child: EmojiPicker(
            onEmojiSelected: ((category, emoji) {
              Navigator.pop(context);
              final newReaction = MessageReaction(
                id: const Uuid().v4().toString(),
                messageId: message.id,
                userId: userId,
                reaction: emoji.emoji,
                createdAt: DateTime.now().toIso8601String(),
              );
              updateReactionToMessage(
                message: message,
                reaction: newReaction,
              );
            }),
          ),
        );
      },
    );
  }

  Future<void> updateReactionToMessage({
    required Message message,
    required MessageReaction reaction,
  }) async {
    message.messageReaction.add(reaction);
    await chatServices.addOrUpdateReactions(
        messageId: message.id,
        reactions: message.messageReaction,
        replyMessage: message.replyMessage);
  }

  Future<void> deleteReaction({
    required Message message,
  }) async {
    await chatServices.deleteReaction(
        messageId: message.id, userId: loggedUid!);
  }

  Future<bool> _checkNetworkConnection() async {
    if (!isNetwork.isConnected.value) {
      Fluttertoast.showToast(
        msg: "No internet connection",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return false;
    }
    return true;
  }

  bool _isMessageValid() {
    return textController.text.isNotEmpty;
  }
}
