import 'package:get/get.dart';
import 'package:supabase_app_demo/models/user_model.dart';
import 'package:supabase_app_demo/services/chat/user_status.dart';
import '../../../../utils/export.dart';
import 'package:flutter/cupertino.dart';

class GroupUserDetailView extends StatefulWidget {
  final UserModel user;

  const GroupUserDetailView({super.key, required this.user});

  @override
  State<GroupUserDetailView> createState() => _GroupUserDetailViewState();
}

class _GroupUserDetailViewState extends State<GroupUserDetailView> {
  late final Stream<List<Map<String, dynamic>>> userStatusStream;

  final chat = Get.put(UserStatusServices());

  @override
  void initState() {
    super.initState();
    userStatusStream =
        chat.getUserStatusUpdates().fold((l) => const Stream.empty(), (r) => r);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(centerTitle: true, title: Text(widget.user.name!)),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 35.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  00.verticalSpace,
                  SizedBox(width: Get.width, height: Get.height * .03),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Get.height * .1),
                    child: CachedNetworkImage(
                      width: Get.height * .2,
                      height: Get.height * .2,
                      fit: BoxFit.cover,
                      imageUrl: getS3Url(widget.user.image!),
                      placeholder: (context, url) => Utility.imageLoader(),
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),
                  SizedBox(height: Get.height * .03),
                  Text(widget.user.name!,
                      style:
                          const TextStyle(color: Colors.black87, fontSize: 16)),
                  SizedBox(height: Get.height * .02),
                  StreamBuilder<List<Map<String, dynamic>>>(
                    stream: userStatusStream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        var userStatus = snapshot.data?.firstWhere(
                          (element) => element['user_id'] == widget.user.id,
                          orElse: () => {'is_online': false, 'last_seen': null},
                        );

                        bool isOnline = userStatus?['is_online'] ?? false;
                        String lastSeen = userStatus?['last_seen'] ?? '';

                        return Card(
                          color: AppColors.white,
                          elevation: 2,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15.w, vertical: 15.h),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Email      : ',
                                      style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                    Text(widget.user.email!,
                                        style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 15)),
                                  ],
                                ),
                                SizedBox(height: Get.height * .02),
                                Text(
                                  isOnline ? 'Online' : 'Offline',
                                  style: TextStyle(
                                      color:
                                          isOnline ? Colors.green : Colors.red,
                                      fontSize: 15),
                                ),
                                Text(
                                  'Last seen: ${getLastMessageTime(context: context, time: lastSeen)}',
                                  style: TextStyle(
                                      color:
                                          isOnline ? Colors.green : Colors.red,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const Text('No status available');
                      }
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }

  static String getLastMessageTime(
      {required BuildContext context,
      required String time,
      bool showYear = false}) {
    final DateTime sent = DateTime.parse(time);
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
    }
    return 'NA';
  }
}
