import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../utils/utility.dart';
import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                confirmBox("Are you sure?", "Do you want to logout ?", () {
                  controller.logout();
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
