import 'package:get/get.dart';
import 'package:supabase_app_demo/app/modules/call/views/call_view.dart';

import '../../../../utils/export.dart';

class StartCallIcon extends StatelessWidget {
  final String conversationId;
  final IconData iconData;

  const StartCallIcon(
      {super.key, required this.conversationId, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          Routes.CALL,
          arguments: CallViewArgs(
            conversationId: conversationId,
          ),
        );
      },
      child: Ink(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: Icon(iconData, size: 23, color: Colors.black),
        ),
      ),
    );
  }
}
