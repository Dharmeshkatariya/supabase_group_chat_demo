import '../../../../../utils/export.dart';

class ForwardedMessageHeader extends StatelessWidget {
  final String originalMessageId;
  final String forwardedFrom;

  const ForwardedMessageHeader({
    super.key,
    required this.originalMessageId,
    required this.forwardedFrom,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(
          Icons.forward_30_rounded,
          color: Colors.grey,
          size: 16.0,
        ),
        5.horizontalSpace,
        Text(
          'Forwarded',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
