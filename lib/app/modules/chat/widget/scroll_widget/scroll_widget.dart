import 'package:get/get.dart';
import 'package:supabase_app_demo/app/modules/chat/controllers/chat_controller.dart';

import '../../../../../utils/export.dart';

class ScrollWidget extends StatefulWidget {
  const ScrollWidget({super.key});

  @override
  State<ScrollWidget> createState() => _ScrollWidgetState();
}

class _ScrollWidgetState extends State<ScrollWidget> {
  final controller = Get.put(ChatController());
  @override
  Widget build(BuildContext context) {
    return scrollWidget();
  }

  Widget scrollWidget() {
    return Obx(
      () {
        if (controller.showScrollIcon.value) {
          return GestureDetector(
            onTap: controller.scrollToBottom,
            child: Container(
              margin: EdgeInsets.only(bottom: 55.h, left: 40.w),
              padding: EdgeInsets.all(5.r),
              decoration: BoxDecoration(
                color: AppColors.grey,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.arrow_downward, color: AppColors.black),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
