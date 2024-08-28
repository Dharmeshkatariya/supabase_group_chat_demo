import 'package:get/get.dart';

import '../controllers/threads_controller.dart';

class ThreadsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ThreadsController>(
      () => ThreadsController(),
    );
  }
}
