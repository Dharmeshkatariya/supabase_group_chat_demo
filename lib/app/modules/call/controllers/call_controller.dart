import 'package:agora_uikit/agora_uikit.dart';
import 'package:get/get.dart';
import '../../../../services/chat/call_services.dart';
import '../../../../utils/export.dart';
import '../views/call_view.dart';

class CallController extends GetxController {
  final callService = Get.put(CallServices());
  late CallViewArgs args;
  RxBool isInit = false.obs;
  bool disposed = false;
  AgoraClient? agoraClient;

  Future<void> init(BuildContext context) async {
    if (isInit.value) return;
    isInit.value = true;
    assert(ModalRoute.of(context)!.settings.arguments != null,
        "Please, inform the arguments. More info on https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments#4-navigate-to-the-widget");
    args = ModalRoute.of(context)!.settings.arguments as CallViewArgs;

    if (agoraClient == null) {
      await callService
          .getCallCredentials(chatRoomId: args.conversationId)
          .then(
        (res) {
          if (!res.success) {
            Navigator.of(context).pop();
            showSnackBarWarning(
                message: "An error occurred, please try again later");
            return;
          }
          agoraClient = getClient(
              rtcToken: res.data!.rtcToken,
              agoraUid: res.data!.agoraUid,
              channelName: args.conversationId);
          agoraClient!.engine.setParameters("{\"rtc.log_filter\": 65535}");
          agoraClient!.initialize();
        },
      );
    }
  }

  AgoraClient getClient(
          {required String rtcToken,
          required int agoraUid,
          required String channelName}) =>
      AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: agoraAppId,
          channelName: channelName,
          tempToken: rtcToken,
          uid: agoraUid,
        ),
        enabledPermission: [
          Permission.camera,
          Permission.microphone,
        ],
      );
}
