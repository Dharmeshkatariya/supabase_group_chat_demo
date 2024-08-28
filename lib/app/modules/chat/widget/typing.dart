import 'package:get/get.dart';
import 'package:supabase_app_demo/models/user_model.dart';
import 'package:supabase_app_demo/services/supabase_service.dart';

import '../../../../utils/export.dart';
import 'painter_widget.dart';
import 'dart:math' as math;

class TypingIndicatorWidget extends StatelessWidget {
  final bool showUserInfo;
  final UserModel? user;

  const TypingIndicatorWidget({
    super.key,
    required this.showUserInfo,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = user?.id == Get.find<SupabaseService>().loggedUid;

    return isMe
        ? _buildSenderTypingIndicator()
        : _buildReceiverTypingIndicator();
  }

  Widget _buildSenderTypingIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.r),
              bottomLeft: Radius.circular(18.r),
              bottomRight: Radius.circular(18.r),
            ),
          ),
          child: const Text(
            "Typing...",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        CustomPaint(painter: Triangle(Colors.grey[900]!)),
      ],
    );
  }

  Widget _buildReceiverTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(right: 50.0, left: 8, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: CustomPaint(painter: Triangle(Colors.grey[300]!)),
          ),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(18.r),
                bottomLeft: Radius.circular(18.r),
                bottomRight: Radius.circular(18.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showUserInfo && user != null)
                  Text(
                    user!.name!,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Typing",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    6.horizontalSpace,
                    const _DotWidget(
                      delayToStart: Duration.zero,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const _DotWidget(
                      delayToStart: Duration(milliseconds: 250),
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const _DotWidget(
                      delayToStart: Duration(milliseconds: 500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DotWidget extends StatefulWidget {
  final Duration delayToStart;

  const _DotWidget({super.key, required this.delayToStart});

  @override
  State<_DotWidget> createState() => _DotWidgetState();
}

class _DotWidgetState extends State<_DotWidget> {
  final Duration duration = const Duration(milliseconds: 350);
  bool running = true;
  final double circleSize = 4.0;
  final double totalHeight = 10;
  bool isBottom = true;

  @override
  void initState() {
    super.initState();

    late void Function() func;
    func = () => Future.delayed(duration, () {
          if (running) {
            setState(() {
              isBottom = !isBottom;
              Future.delayed(
                  isBottom ? const Duration(milliseconds: 800) : Duration.zero,
                  func);
            });
          }
        });
    Future.delayed(widget.delayToStart, func);
  }

  @override
  void dispose() {
    running = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: totalHeight,
      width: circleSize,
      child: Stack(
        children: [
          AnimatedPositioned(
            bottom: isBottom ? 0 : (totalHeight - circleSize),
            duration: duration,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.circular(50),
              ),
              width: circleSize,
              height: circleSize,
            ),
          ),
        ],
      ),
    );
  }
}
