import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:supabase_app_demo/app/modules/home/views/home_view.dart';
import 'package:supabase_app_demo/app/modules/notification/views/notification_view.dart';
import 'package:supabase_app_demo/app/modules/search/views/search_view.dart';
import 'package:supabase_app_demo/app/modules/threads/views/add_threads_view.dart';
import '../app/modules/profile/views/profile_view.dart';

class NavigationService extends GetxService {
  RxInt currentIndex = 0.obs;
  RxInt previousIndex = 0.obs;

  void updateIndex(int index) {
    previousIndex.value = currentIndex.value;
    currentIndex.value = index;
  }

  void backToPrevIndex() {
    currentIndex.value = previousIndex.value;
  }

  List<Widget> pages() {
    return [
      const HomeView(),
      const SearchView(),
      const AddThreadsView(),
      const NotificationView(),
      const ProfileView()
    ];
  }
}
