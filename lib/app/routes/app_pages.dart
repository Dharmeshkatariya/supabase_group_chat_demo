import 'package:get/get.dart';

import '../modules/call/bindings/call_binding.dart';
import '../modules/call/views/call_view.dart';
import '../modules/comment/bindings/comment_binding.dart';
import '../modules/comment/views/comment_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/dashboard.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/login/views/register_view.dart';
import '../modules/notification/bindings/notification_binding.dart';
import '../modules/notification/views/notification_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/edit_profile.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/show_profile.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';
import '../modules/setting/bindings/setting_binding.dart';
import '../modules/setting/views/setting_view.dart';
import '../modules/threads/bindings/threads_binding.dart';
import '../modules/threads/views/add_threads_view.dart';
import '../modules/threads/views/show_images.dart';
import '../modules/threads/views/show_threads.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.DashboardView;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.DashboardView,
      page: () => const DashboardView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const Login(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const Register(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.COMMENT,
      page: () => const CommentView(),
      binding: CommentBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDITPROFILE,
      page: () => const EditProfile(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.SHOWPROFILE,
      page: () => const ShowProfile(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => const SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.SETTING,
      page: () => const SettingView(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: _Paths.ADDTHREADS,
      page: () => const AddThreadsView(),
      binding: ThreadsBinding(),
    ),
    GetPage(
      name: _Paths.SHOWTHREADS,
      page: () => const ShowThreadsView(),
      binding: ThreadsBinding(),
    ),
    GetPage(
      name: _Paths.SHOWIMAGES,
      page: () => const ShowImagesView(),
      binding: ThreadsBinding(),
    ),
    // GetPage(
    //   name: _Paths.CHAT,
    //   page: () => const ChatView(),
    //   binding: ChatBinding(),
    // ),
    GetPage(
      name: _Paths.CALL,
      page: () => const CallView(),
      binding: CallBinding(),
    ),
  ];
}
