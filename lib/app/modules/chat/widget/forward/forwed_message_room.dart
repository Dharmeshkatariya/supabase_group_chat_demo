import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:supabase_app_demo/app/modules/chat/controllers/chat_controller.dart';
import 'package:supabase_app_demo/services/chat/chat_room_services.dart';
import 'package:supabase_app_demo/services/chat/chat_services.dart';
import '../../../../../models/Message.dart';
import '../../../../../models/chat model.dart';
import '../../../../../utils/app_colors.dart';

class ForwardMessageScreen extends StatefulWidget {
  final Message selectedMessages;
  final String forwardedChatRoomId;

  const ForwardMessageScreen(
      {super.key,
      required this.selectedMessages,
      required this.forwardedChatRoomId});

  @override
  State<ForwardMessageScreen> createState() => _ForwardMessageScreenState();
}

class _ForwardMessageScreenState extends State<ForwardMessageScreen> {
  final chatServices = Get.put(ChatRoomServices());
  final controller = Get.put(ChatController());

  RxBool loading = false.obs;
  List<ChatRoomModel> _chatRoomsFuture = [];

  @override
  void initState() {
    chatServices.getChatRooms().then((res) {
      res.fold((l) {
        loading.value = false;
      }, (r) {
        _chatRoomsFuture = r;
        loading.value = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forward to '),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(
        () {
          return loading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  child: ListView.builder(
                    itemCount: _chatRoomsFuture.length,
                    itemBuilder: (context, index) {
                      final chatRoom = _chatRoomsFuture[index];
                      return GestureDetector(
                        onTap: () async {
                          await controller.forwardMessage(
                              chatroom: chatRoom,
                              originalMessageId: widget.selectedMessages.id,
                              forwardedChatRoomId: widget.forwardedChatRoomId,
                              message: widget.selectedMessages);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: AppColors.greenButtonColor,
                              borderRadius: BorderRadius.circular(10.r)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                chatRoom.name,
                                style: const TextStyle(
                                  color: AppColors.black,
                                ),
                              ),
                              const Icon(
                                  color: Colors.black54, Icons.send_rounded)
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
