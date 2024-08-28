// // import 'package:cached_video_player_plus/cached_video_player_plus.dart';
// // import 'package:flutter/material.dart';
// // import '../../../../../models/Message.dart';
// //
// // class CustomVideoPlayer extends StatefulWidget {
// //   final Message? message;
// //   const CustomVideoPlayer({super.key, this.message});
// //
// //   @override
// //   State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
// // }
// //
// // class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
// //   late CachedVideoPlayerPlusController controller;
// //   bool isInitialized = false;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _initializePlayer();
// //   }
// //
// //   Future<void> _initializePlayer() async {
// //     if (widget.message == null || widget.message!.message == null) {
// //       return;
// //     }
// //
// //     controller = CachedVideoPlayerPlusController.networkUrl(
// //       Uri.parse(widget.message!.message),
// //       invalidateCacheIfOlderThan: const Duration(days: 30),
// //     );
// //
// //     try {
// //       await controller.initialize();
// //       setState(() {
// //         isInitialized = true;
// //       });
// //       controller.play();
// //     } catch (e) {
// //       print('Error initializing video player: $e');
// //       setState(() {
// //         isInitialized = false;
// //       });
// //     }
// //   }
// //
// //   @override
// //   void dispose() {
// //     controller.dispose();
// //     super.dispose();
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return isInitialized
// //         ? AspectRatio(
// //       aspectRatio: controller.value.aspectRatio,
// //       child: CachedVideoPlayerPlus(controller),
// //     )
// //         : const Center(child: CircularProgressIndicator());
// //   }
// // }
// import 'dart:async';
//
// import 'package:cached_video_player_plus/cached_video_player_plus.dart';
// import 'package:flutter/material.dart';
// import '../../../../../models/Message.dart';
//
// class CustomVideoPlayer extends StatefulWidget {
//   final Message? message;
//   const CustomVideoPlayer({super.key, this.message});
//
//   @override
//   State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
// }
//
// class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
//   late CachedVideoPlayerPlusController controller;
//   bool isInitialized = false;
//   bool isPlaying = false;
//   Duration? videoDuration;
//   Duration? videoPosition;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializePlayer();
//     _startProgressUpdater();
//   }
//
//   Future<void> _initializePlayer() async {
//     if (widget.message == null || widget.message!.message == null) {
//       return;
//     }
//
//     controller = CachedVideoPlayerPlusController.networkUrl(
//       Uri.parse(widget.message!.message!),
//       invalidateCacheIfOlderThan: const Duration(days: 30),
//     );
//
//     try {
//       await controller.initialize();
//       setState(() {
//         isInitialized = true;
//         isPlaying = controller.value.isPlaying;
//         videoDuration = controller.value.duration;
//       });
//       controller.play();
//     } catch (e) {
//       print('Error initializing video player: $e');
//       setState(() {
//         isInitialized = false;
//       });
//     }
//   }
//
//   void _togglePlayPause() {
//     if (isPlaying) {
//       controller.pause();
//     } else {
//       controller.play();
//     }
//     setState(() {
//       isPlaying = !isPlaying;
//     });
//   }
//
//   void _startProgressUpdater() {
//     Future.delayed(Duration.zero, () {
//       Timer.periodic(const Duration(seconds: 1), (timer) {
//         if (!isInitialized || controller.value.isPlaying) {
//           setState(() {
//             videoPosition = controller.value.position;
//           });
//         } else {
//           timer.cancel();
//         }
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final progress = videoDuration != null && videoPosition != null
//         ? videoPosition!.inMilliseconds / videoDuration!.inMilliseconds
//         : 0.0;
//
//     return isInitialized
//         ? Stack(
//       children: [
//         AspectRatio(
//           aspectRatio: controller.value.aspectRatio,
//           child: CachedVideoPlayerPlus(controller),
//         ),
//         Positioned(
//           bottom: 10,
//           left: 10,
//           child: Row(
//             children: [
//               IconButton(
//                 icon: Icon(
//                   isPlaying ? Icons.pause : Icons.play_arrow,
//                   color: Colors.white,
//                 ),
//                 onPressed: _togglePlayPause,
//               ),
//               SizedBox(
//                 width: 200,
//                 child: LinearProgressIndicator(
//                   value: progress,
//                   backgroundColor: Colors.black.withOpacity(0.5),
//                   valueColor: AlwaysStoppedAnimation(Colors.white),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     )
//         : const Center(child: CircularProgressIndicator());
//   }
// }
