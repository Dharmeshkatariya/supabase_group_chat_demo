import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:supabase_app_demo/app/modules/chat/controllers/chat_controller.dart';
import 'package:supabase_app_demo/app/modules/chat/views/message_list.dart';
import 'package:supabase_app_demo/app/modules/chat/widget/reply/reply_text_filled_widget.dart';
import 'package:supabase_app_demo/models/chat%20model.dart';
import 'package:supabase_app_demo/services/chat/chat_services.dart';
import 'package:supabase_app_demo/services/chat/media_service.dart';
import 'package:supabase_app_demo/services/supabase_service.dart';
import 'package:supabase_app_demo/utils/asset.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../services/user_services.dart';
import '../../../../utils/app_colors.dart';
import '../widget/forward/forwed_message_room.dart';
import '../widget/scroll_widget/scroll_widget.dart';

class ChatScreen extends StatefulWidget {
  final ChatRoomModel chatRoom;
  final String chatRoomId;
  final String groupName;

  const ChatScreen(
      {super.key,
      required this.chatRoomId,
      required this.groupName,
      required this.chatRoom});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  ChatServices chatServices = Get.put(ChatServices());

  RxString currentUserid = "".obs;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.checkWhetherUserIsReading(widget.chatRoomId);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    currentUserid.value = SupabaseService.client.auth.currentUser!.id;
    controller.client = Supabase.instance.client;
    controller.getChats(widget.chatRoomId);
    controller.setupRealtimeSubscription(widget.chatRoomId);
    _getUser();
    controller.textListenr(widget.chatRoomId);
    WidgetsBinding.instance.addObserver(this);
    controller.messageScrollWidgetListener();
    super.initState();
  }

  _getUser() async {
    await UserServices.getUser(currentUserid.value).then(
      (res) {
        res.fold(
          (l) {},
          (r) {
            controller.user.value = r;
          },
        );
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller.checkWhetherUserIsReading(widget.chatRoomId);
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    controller.disposed.value = true;
  }

  final controller = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: const ScrollWidget(),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(4.0),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: AppColors.white,
              size: 16,
            ),
          ),
        ),
        centerTitle: true,
        title: Obx(
          () {
            return controller.isSearching.value
                ? TextField(
                    autofocus: true,
                    onChanged: (value) {
                      controller.searchQuery.value = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: AppColors.white),
                    ),
                    style: const TextStyle(color: AppColors.white),
                  )
                : Text(
                    widget.groupName,
                    style: const TextStyle(fontSize: 17),
                  );
          },
        ),
        actions: [
          Obx(
            () {
              if (controller.selectedMessages.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.forward_30),
                  onPressed: () {
                    Get.to(
                      ForwardMessageScreen(
                        selectedMessages: controller.selectedMessages.first,
                        forwardedChatRoomId: widget.chatRoomId,
                      ),
                    );
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),

          Obx(
            () {
              return IconButton(
                icon: Icon(
                    controller.isSearching.value ? Icons.close : Icons.search),
                onPressed: () {
                  controller.onSearchQuery(context);
                },
              );
            },
          ),

          // StartCallIcon(
          //   conversationId: widget.chatRoomId,
          //   iconData: Icons.video_call_rounded,
          // )
        ],
      ),
      body: Obx(
        () {
          final filteredMessages = controller.searchFilter();
          return Container(
            decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage(bg1))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: controller.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : MessagesList(filteredMessages: filteredMessages),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _messageInput(
                    chatRoomId: widget.chatRoomId,
                    usersId: currentUserid.value,
                    onSend: (message) {
                      setState(
                        () {
                          controller.messages.insert(0, message);
                        },
                      );
                    },
                  ),
                ),
                if (controller.showEmoji) controller.emojiPickerWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _messageInput({
    required String chatRoomId,
    required String usersId,
    required Function onSend,
  }) {
    final isReplying = controller.replyMessage.value != null;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isReplying) buildReply(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  color: AppColors.grey,
                ),
                child: Row(
                  children: [
                    6.horizontalSpace,
                    InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        controller.setShowEmoji();
                      },
                      child: Icon(Icons.emoji_emotions,
                          color: AppColors.black, size: 25.h),
                    ),
                    6.horizontalSpace,
                    Expanded(
                      child: TextField(
                        focusNode: controller.focusNode,
                        controller: controller.textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onTap: () {
                          if (controller.showEmoji) {
                            controller.setShowEmoji();
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'Message',
                            fillColor: AppColors.red,
                            hintStyle: const TextStyle(color: AppColors.black),
                            border: InputBorder.none),
                      ),
                    ),
                    5.horizontalSpace,
                    InkWell(
                      onTap: () async {
                        MediaService().showAttachmentOptions(
                            context: context,
                            chatRoomId: chatRoomId,
                            typingUser: widget.chatRoom.typingUsers,
                            currentUserid: currentUserid.value,
                            userIds: widget.chatRoom.userIds);
                      },
                      child: Icon(Icons.attach_file,
                          color: AppColors.black, size: 25.h),
                    ),
                    10.horizontalSpace,
                  ],
                ),
              ),
            ],
          ),
        ),
        ZoomIn(
          duration: const Duration(milliseconds: 300),
          child: Container(
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.only(right: 9.w),
            child: MaterialButton(
              onPressed: () async {
                await controller.sendMessage(
                    chatRoomId: chatRoomId,
                    chatRoomName: widget.chatRoom.name,
                    typingUser: widget.chatRoom.typingUsers,
                    usersId: usersId,
                    userIds: widget.chatRoom.userIds,
                    chatroom: widget.chatRoom);
              },
              minWidth: 0,
              padding: EdgeInsets.only(
                  top: 10.h, bottom: 10.h, right: 5.w, left: 10.w),
              shape: const CircleBorder(),
              color: AppColors.grey,
              child: const Icon(Icons.send, color: Colors.black, size: 28),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildReply() => Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: ReplyMessageTextInputWidget(
          message: controller.replyMessage.value!,
          onCancelReply: controller.cancelReply,
        ),
      );
}
