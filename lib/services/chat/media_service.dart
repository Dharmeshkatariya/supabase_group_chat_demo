import 'dart:io';
import 'package:get/get.dart';
import 'package:supabase_app_demo/app/modules/chat/controllers/chat_controller.dart';
import 'package:supabase_app_demo/services/chat/chat_services.dart';
import 'package:supabase_app_demo/services/supabase_service.dart';
import 'package:uuid/uuid.dart';
import '../../app/modules/chat/widget/message_status.dart';
import '../../models/Message.dart';
import '../../models/user_model.dart';
import '../../utils/env.dart';
import '../../utils/export.dart';

class MediaService {
  final controller = Get.put(ChatController());
  final chatServices = Get.put(ChatServices());

  galleryTap({
    required String chatRoomId,
    required String usersId,
    required List<String> userIds,
    required List<UserModel> typingUser,
  }) async {
    Get.back();
    await pickImageFromGallery().whenComplete(
      () async {
        await imageUpload(
                chatRoomId: chatRoomId,
                typingUser: typingUser,
                usersId: usersId,
                image: controller.image.value!,
                userIds: userIds)
            .then(
          (res) async {
            if (res != null) {
              await controller.sendImg(
                  chatRoomId: chatRoomId,
                  res: res,
                  usersId: usersId,
                  image: controller.image.value!,
                  userIds: userIds,
                  typingUser: typingUser);
            } else {
              Get.back();
            }
          },
        );
      },
    );
  }

  cameraTap({
    required String chatRoomId,
    required String usersId,
    required List<String> userIds,
    required List<UserModel> typingUser,
  }) async {
    Get.back();
    await pickCamera().whenComplete(
      () async {
        await imageUpload(
                chatRoomId: chatRoomId,
                usersId: usersId,
                typingUser: typingUser,
                image: controller.image.value!,
                userIds: userIds)
            .then(
          (res) async {
            print(res);
            if (res != null) {
              await controller.sendImg(
                  chatRoomId: chatRoomId,
                  res: res,
                  usersId: usersId,
                  image: controller.image.value!,
                  userIds: userIds,
                  typingUser: typingUser);
            } else {}
          },
        );
      },
    );
  }

  Future videoTap({
    required String chatRoomId,
    required String usersId,
    required List<String> userIds,
    required List<UserModel> typingUser,
  }) async {
    var context = Get.context!;
    Get.back();
    await pickVideo().whenComplete(
      () async {
        showProgressDialog("Uploading video...");
        await videoUpload(
                chatRoomId: chatRoomId,
                usersId: usersId,
                typingUser: typingUser,
                video: controller.image.value!,
                userIds: userIds)
            .then(
          (res) async {
            if (res != null) {
              await controller
                  .sendVideo(
                      chatRoomId: chatRoomId,
                      res: res,
                      usersId: usersId,
                      image: controller.image.value!,
                      userIds: userIds,
                      typingUser: typingUser)
                  .whenComplete(() {
                Navigator.of(context).pop();
              });
            } else {
              Navigator.of(context).pop();
            }
          },
        );
      },
    );
  }

  void showAttachmentOptions(
      {required BuildContext context,
      required String chatRoomId,
      required String currentUserid,
      required List<UserModel> typingUser,
      required List<String> userIds}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 220.h,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: () async {
                  await galleryTap(
                      chatRoomId: chatRoomId,
                      usersId: currentUserid,
                      typingUser: typingUser,
                      userIds: userIds);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  await cameraTap(
                      chatRoomId: chatRoomId,
                      typingUser: typingUser,
                      usersId: currentUserid,
                      userIds: userIds);
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_camera_front_outlined),
                title: const Text('Video'),
                onTap: () async {
                  await videoTap(
                      chatRoomId: chatRoomId,
                      typingUser: typingUser,
                      usersId: currentUserid,
                      userIds: userIds);
                },
              ),
              ListTile(
                leading: const Icon(Icons.attach_file),
                title: const Text('File'),
                onTap: () async {
                  await pdfTap(
                      chatRoomId: chatRoomId,
                      typingUser: typingUser,
                      usersId: currentUserid,
                      userIds: userIds);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future pdfTap({
    required String chatRoomId,
    required String usersId,
    required List<String> userIds,
    required List<UserModel> typingUser,
  }) async {
    var context = Get.context!;
    Get.back();
    await pickPdf().whenComplete(
      () async {
        if (controller.image.value != null) {
          showProgressDialog("Uploading pdf...");
          await pdfUpload(
            chatRoomId: chatRoomId,
            usersId: usersId,
            pdf: controller.image.value!,
            userIds: userIds,
            typingUser: typingUser,
          ).then(
            (res) async {
              if (res != null) {
                await controller
                    .sendPdf(
                  chatRoomId: chatRoomId,
                  res: res,
                  usersId: usersId,
                  pdf: controller.image.value!,
                  userIds: userIds,
                  typingUser: typingUser,
                )
                    .whenComplete(() {
                  Navigator.of(context).pop();
                });
              } else {
                Navigator.of(context).pop();
              }
            },
          );
        }
      },
    );
  }

  Future pickImageFromGallery() async {
    File? file = await pickImageFromGallary();
    if (file != null) controller.image.value = file;
  }

  Future pickCamera() async {
    File? file = await pickImageFromCamera();
    if (file != null) controller.image.value = file;
  }

  Future pickVideo() async {
    File? file = await pickVideoFromGallery();
    if (file != null) controller.image.value = file;
  }

  Future pickPdf() async {
    File? file = await pickPdfFromFile();
    if (file != null) controller.image.value = file;
  }

  static Future<String?> pdfUpload({
    required String chatRoomId,
    required String usersId,
    required File pdf,
    required List<String> userIds,
    required List<UserModel> typingUser,
  }) async {
    if (pdf.existsSync()) {
      try {
        const uuid = Uuid();
        final fileName =
            '$chatRoomId/${uuid.v4()}_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final response = await SupabaseService.client.storage
            .from(Env.s3Bucket)
            .upload(fileName, pdf);

        final pdfUrl = SupabaseService.client.storage
            .from(Env.s3Bucket)
            .getPublicUrl(fileName);

        return pdfUrl;
      } catch (e) {
        print('Exception during PDF upload: $e');
        return null;
      }
    } else {
      print('PDF file does not exist');
      return null;
    }
  }

  static Future<String?> videoUpload({
    required String chatRoomId,
    required String usersId,
    required File video,
    required List<String> userIds,
    required List<UserModel> typingUser,
  }) async {
    if (video.existsSync()) {
      try {
        const uuid = Uuid();
        final fileName =
            '$chatRoomId/${uuid.v4()}_${DateTime.now().millisecondsSinceEpoch}.mp4';
        final response = await SupabaseService.client.storage
            .from(Env.s3Bucket)
            .upload(fileName, video);

        final videoUrl = SupabaseService.client.storage
            .from(Env.s3Bucket)
            .getPublicUrl(fileName);

        return videoUrl;
      } catch (e) {
        print('Exception during video upload: $e');
        return null;
      }
    } else {
      print('Video file does not exist');
      return null;
    }
  }

  static Future imageUpload({
    required String chatRoomId,
    required String usersId,
    required File image,
    required List<String> userIds,
    required List<UserModel> typingUser,
  }) async {
    if (image.existsSync()) {
      const uuid = Uuid();
      final fileName =
          '$chatRoomId/${uuid.v4()}_${DateTime.now().millisecondsSinceEpoch}';
      var resturnValue = await SupabaseService.client.storage
          .from(Env.s3Bucket)
          .upload(fileName, image);
      return resturnValue;
    }
  }

  Future<void> showMessageBottomSheet({
    required bool isMe,
    required BuildContext context,
    required Message message,
  }) async {
    return await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 4,
              margin: EdgeInsets.symmetric(
                vertical: Get.height * .015,
                horizontal: Get.width * .4,
              ),
              decoration: BoxDecoration(
                color: AppColors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            message.mtype == MessageType.text
                ? OptionItem(
                    icon: const Icon(Icons.copy_all_rounded,
                        color: Colors.blue, size: 26),
                    name: 'Copy Text',
                    onTap: () async {
                      await Clipboard.setData(
                              ClipboardData(text: message.message))
                          .then(
                        (value) {
                          Get.back();
                          Utility.showSnackbar('Text Copied!');
                        },
                      );
                    },
                  )
                : OptionItem(
                    icon: const Icon(Icons.download_rounded,
                        color: Colors.blue, size: 26),
                    name: 'Save Image',
                    onTap: () async {},
                  ),
            if (isMe)
              Divider(
                color: Colors.black54,
                endIndent: Get.width * .04,
                indent: Get.width * .04,
              ),
            if (message.mtype == MessageType.text && isMe)
              OptionItem(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                name: 'Edit Message',
                onTap: () {
                  Get.back();
                  showMessageUpdateDialog(message);
                },
              ),
            if (isMe)
              OptionItem(
                icon: const Icon(Icons.delete_forever,
                    color: Colors.red, size: 26),
                name: 'Delete Message',
                onTap: () async {
                  await chatServices
                      .deleteMessage(
                    message.id,
                  )
                      .then((res) {
                    Get.back();
                  });
                },
              ),
            Divider(
              color: Colors.black54,
              endIndent: Get.width * .04,
              indent: Get.width * .04,
            ),
            OptionItem(
                icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                name: 'Sent At:'
                    ' ${MessageDateTimeUtils.getMessageTime(context: context, time: message.sentAt!.microsecondsSinceEpoch)}',
                onTap: () {}),
          ],
        );
      },
    );
  }

  Future<void> showMessageUpdateDialog(Message message) async {
    var context = Get.context!;
    final TextEditingController controller =
        TextEditingController(text: message.message);
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(
                Icons.message,
                color: Colors.blue,
                size: 28,
              ),
              Text(
                ' Update Message',
                style: Get.textTheme.titleMedium,
              )
            ],
          ),
          content: TextFormField(
            controller: controller,
            maxLines: null,
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),
          actions: [
            MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                )),
            MaterialButton(
              onPressed: () async {
                Navigator.pop(context);
                final updatedMsg = controller.text.trim();
                if (updatedMsg.isNotEmpty) {
                  await chatServices.updateMessage(
                      messageId: message.id,
                      newContent: updatedMsg,
                      replyMessage: message.replyMessage);
                }
              },
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
            )
          ],
        );
      },
    );
  }
}
