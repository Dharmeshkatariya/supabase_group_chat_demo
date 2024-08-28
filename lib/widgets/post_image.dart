import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_app_demo/app/routes/app_pages.dart';
import '../utils/utility.dart';

class PostImage extends StatelessWidget {
  final String url;
  const PostImage({required this.url, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.SHOWIMAGES, arguments: url);
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: context.height * 0.60,
          minWidth: context.width * 0.80,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            getS3Url(url),
            fit: BoxFit.contain,
            alignment: Alignment.topCenter,
          ),
        ),
      ),
    );
  }
}
