import 'package:get/get.dart';
import 'package:supabase_app_demo/app/modules/chat/views/chat_room_list.dart';
import 'package:supabase_app_demo/utils/export.dart';
import '../../../../services/database_services.dart';
import '../../../../widgets/loading.dart';
import '../../../../widgets/post_card.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/images/logo.png",
            width: 10.w,
            height: 10.h,
            fit: BoxFit.contain,
          ),
        ),
        title: const Text("Chat"),
        toolbarHeight: 50.h,
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(const ChatRoomListPage());
            },
            child: Padding(
              padding: EdgeInsets.only(right: 20.sp),
              child: SvgPicture.asset(
                "assets/images/chat.svg",
                width: 20.w,
                height: 20.h,
                color: Colors.white,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // assets/images/chat.svg
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0.sp),
        child: RefreshIndicator(
          onRefresh: () async {
            await DBService.fetchPosts().then((res) {
              res.fold((l) {}, (r) {
                if (r.isNotEmpty) {
                  controller.posts.value = r;
                }
              });
            });
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Obx(
                  () => controller.loading.value
                      ? const Loading()
                      : ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const BouncingScrollPhysics(),
                          itemCount: controller.posts.length,
                          itemBuilder: (context, index) =>
                              PostCard(post: controller.posts[index]),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
