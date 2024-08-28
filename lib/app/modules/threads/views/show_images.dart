import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/utility.dart';

class ShowImagesView extends StatefulWidget {
  const ShowImagesView({super.key});

  @override
  State<ShowImagesView> createState() => _ShowImagesViewState();
}

class _ShowImagesViewState extends State<ShowImagesView> {
  final String image = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image"),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.network(
          getS3Url(image),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
