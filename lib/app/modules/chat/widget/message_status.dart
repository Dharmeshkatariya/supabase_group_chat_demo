import 'package:get/get.dart';

import '../../../../models/Message.dart';
import '../../../../models/user_model.dart';
import '../../../../services/supabase_service.dart';
import '../../../../utils/export.dart';
import 'delay_animation.dart';

class OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const OptionItem(
      {super.key, required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var mq = Get;

    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(
              left: mq.width * .05,
              top: mq.height * .015,
              bottom: mq.height * .015),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        letterSpacing: 0.5)))
          ]),
        ));
  }
}

class MessageDateTimeUtils {
  static String getFormattedTime(
      {required BuildContext context, required int time}) {
    final date = DateTime.fromMillisecondsSinceEpoch(time);
    return TimeOfDay.fromDateTime(date).format(context);
  }

  static String getMessageTime(
      {required BuildContext context, required int time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(time);
    final DateTime now = DateTime.now();

    final formattedTime = TimeOfDay.fromDateTime(sent).format(context);
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return formattedTime;
    }

    return now.year == sent.year
        ? '$formattedTime - ${sent.day} ${_getMonth(sent)}'
        : '$formattedTime - ${sent.day} ${_getMonth(sent)} ${sent.year}';
  }

  static String getLastMessageTime(
      {required BuildContext context,
      required int time,
      bool showYear = false}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(time);
    final DateTime now = DateTime.now();

    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(context);
    }

    return showYear
        ? '${sent.day} ${_getMonth(sent)} ${sent.year}'
        : '${sent.day} ${_getMonth(sent)}';
  }

  static String getLastActiveTime(
      {required BuildContext context, required int lastActive}) {
    final DateTime time = DateTime.fromMillisecondsSinceEpoch(lastActive);
    final DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == now.year) {
      return 'Last seen today at $formattedTime';
    }

    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'Last seen yesterday at $formattedTime';
    }

    String month = _getMonth(time);

    return 'Last seen on ${time.day} $month at $formattedTime';
  }

  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return 'NA';
    }
  }
}

Widget messageStatus({
  required Message message,
}) {
  String loggedUid = Get.find<SupabaseService>().loggedUid!;
  MessageType messageType = message.mtype;

  Widget checkIcon = Icon(Icons.check,
      size: 16, color: message.read ? Colors.blue[300] : Colors.green[500]);
  bool isLeftSide = message.userId != loggedUid;
  return Row(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      if (!isLeftSide && message.hasPendingWrites)
        Icon(Icons.access_time_outlined, color: Colors.green[50], size: 17),
      if (!isLeftSide &&
          (!message.hasPendingWrites || message.received || message.read))
        SizedBox(
          width: message.received || message.read ? 25 : null,
          child: Stack(
            children: [
              DelayAnimateSwitcher(
                firstChild: Container(
                  width: 18.w,
                ),
                secondChild: checkIcon,
                animate: !message.received
                    ? false
                    : (DateTime.now().millisecondsSinceEpoch - 1000 <
                        message.lastReceivedAt!.millisecondsSinceEpoch),
              ),
              if (message.received || message.read)
                Align(
                  alignment: const Alignment(.85, 0),
                  child: DelayAnimateSwitcher(
                      firstChild: Container(
                        width: 18,
                      ),
                      secondChild: checkIcon,
                      animate: DateTime.now().millisecondsSinceEpoch - 1000 <
                          message.createdAt.millisecondsSinceEpoch,
                      delay: const Duration(milliseconds: 320)),
                )
            ],
          ),
        )
    ],
  );
}

String _formattedTypingMessage(List<UserModel> typingUsers) {
  String names = typingUsers.map((e) => e.name).join(', ');
  bool are = false;
  if (names.contains(', ')) {
    are = true;
    names = names.replaceRange(names.lastIndexOf(','), null, ' and');
  }
  return are ? '$names are typing...' : '$names is typing...';
}
