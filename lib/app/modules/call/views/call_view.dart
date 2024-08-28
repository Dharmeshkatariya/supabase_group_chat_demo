import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_app_demo/app/modules/call/controllers/call_controller.dart';

class CallViewArgs {
  final String conversationId;

  CallViewArgs({required this.conversationId});
}

class CallView extends StatefulWidget {
  const CallView({super.key});

  @override
  State<CallView> createState() => _CallViewState();
}

class _CallViewState extends State<CallView> {
  @override
  void initState() {
    controller.init(context);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final controller = Get.put(CallController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !controller.isInit.value
          ? Container()
          : Stack(
              children: [
                if (controller.agoraClient == null)
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .25,
                        ),
                        const Text(
                          'Almost there!\nIt will take only a few seconds',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                if (controller.agoraClient != null)
                  Expanded(
                    child: Stack(
                      children: [
                        AgoraVideoViewer(
                          client: controller.agoraClient!,
                          layoutType: Layout.grid,
                          showNumberOfUsers: true,
                        ),
                        AgoraVideoButtons(client: controller.agoraClient!),
                      ],
                    ),
                  )
              ],
            ),
    );
  }

  @override
  void dispose() {
    controller.disposed = true;
    super.dispose();
  }
}
