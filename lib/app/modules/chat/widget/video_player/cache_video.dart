import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

import '../../../../../models/Message.dart';
import '../../../../../utils/export.dart';

class CustomVideoPlayer extends StatefulWidget {
  final Message message;

  const CustomVideoPlayer({super.key, required this.message});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    if (widget.message.mtype == MessageType.video) {
      _initializeVideoPlayer();
    }
  }

  void _initializeVideoPlayer() async {
    _videoController = VideoPlayerController.network(widget.message.message);
    try {
      await _videoController.initialize();
      setState(() {});
    } catch (e) {
      print("Error initializing video: $e");
    }
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      aspectRatio: _videoController.value.aspectRatio,
      autoPlay: false,
      looping: false,
      autoInitialize: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  Widget buildVideoPlayer() {
    if (_videoController.value.isInitialized) {
      return SizedBox(
        height: 200.h,
        width: 200.w,
        child: Chewie(
          controller: _chewieController!,
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  void dispose() {
    _videoController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return buildVideoPlayer();
  }
}
