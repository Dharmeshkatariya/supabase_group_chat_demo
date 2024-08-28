import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_app_demo/app/routes/app_pages.dart';
import '../models/user_model.dart';
import '../utils/utility.dart';
import 'circle_image.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  const UserTile({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: CircleImage(url: user.metadata?.image),
      ),
      title: Text(user.name!),
      titleAlignment: ListTileTitleAlignment.top,
      trailing: OutlinedButton(
        onPressed: () {
          Get.toNamed(Routes.SHOWPROFILE, arguments: user.id!);
        },
        child: const Text("View profile"),
      ),
      subtitle: Text(formateDateFromNow(user.createdAt!)),
    );
  }
}
