import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:supabase_app_demo/utils/constant.dart';
import '../app/modules/chat/views/chat_page.dart';
import '../models/chat model.dart';
import '../utils/export.dart';

@pragma("vm:entry-point")
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  if (message.data.isNotEmpty) {
    final Map<String, dynamic> data = message.data;
    if (data.containsKey('chat_room_id') &&
        data.containsKey('chat_room_name') &&
        data.containsKey('chat_room')) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('notification_data', jsonEncode(data));
    } else {
      print('Error: Missing required fields in notification data.');
    }
  } else {
    print('Error: Notification data is empty.');
  }
}

class AppNotification {
  BuildContext? context;
  String? accessToken;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> _onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {}

  Future<void> _selectNotification(
      NotificationResponse? notificationResponse) async {
    if (notificationResponse != null) {
      final data = jsonDecode(notificationResponse.payload!);
      final chatRoomId = data['chat_room_id'];
      final message = data['message'];
      final chatRoomData = data['chat_room'];
      final chatRoomName = data['chat_room_name'];
      final chatRoomMap = jsonDecode(chatRoomData);
      final chatRoom = ChatRoomModel.fromJson(chatRoomMap);
      Get.to(
        () => ChatScreen(
          chatRoomId: chatRoomId,
          groupName: chatRoomName,
          chatRoom: chatRoom,
        ),
      );
    }
  }

  Future<void> configLocalNotification() async {
    if (!kIsWeb && Platform.isIOS) {
      // set iOS Local notification.
      var initializationSettingsAndroid =
          const AndroidInitializationSettings('ic_launcher');
      var initializationSettingsIOS = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
      );
      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: (val) => _selectNotification(val));
    } else {
      // set Android Local notification.
      var initializationSettingsAndroid =
          const AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettingsIOS = DarwinInitializationSettings(
          onDidReceiveLocalNotification: _onDidReceiveLocalNotification);
      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: (val) => _selectNotification(val));
    }
  }

  Future<void> getNotification() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message);
      return;
    });
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  }

  Future<String?> registerNotification() async {
    if (Platform.isIOS) {
      return await firebaseMessaging.getToken();
    } else {
      return await firebaseMessaging.getToken();
    }
  }

  Future<void> showNotification(RemoteMessage message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        Platform.isAndroid ? 'ch.kayosys.steuern59' : 'ch.steuern59',
        'Taxley Notification Service',
        playSound: true,
        enableVibration: true,
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound(Common.androidSound));
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails(
        presentSound: true,
        presentAlert: true,
        presentBadge: true,
        sound: Common.iosSound);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        math.Random().nextInt(1),
        message.notification!.title,
        message.notification!.body,
        platformChannelSpecifics,
        payload: jsonEncode(message.data));
  }

  Future<Map<String, dynamic>> loadJsonData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/service-acc-file.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return jsonData;
    } catch (e) {
      log('Error loading JSON: $e');
      return {};
    }
  }

  Future<void> initMessaging() async {
    log("Called", name: "initMessaging");
    if (!_initialized) {
      await firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      Common.fcmToken = (await registerNotification())!;
      await firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
      getNotification();
      configLocalNotification();
      _initialized = true;
    }
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final String? notificationData = prefs.getString('notification_data');

    if (notificationData != null) {
      final Map<String, dynamic> data = jsonDecode(notificationData);
      handleMessage(RemoteMessage(data: data));
      await prefs.remove('notification_data');
    }

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // handleMessage( message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleMessage(message);
    });

    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  }

  void handleMessage(RemoteMessage message) {
    final String? chatRoomId = message.data['chat_room_id'];
    final String? chatRoomName = message.data['chat_room_name'];
    final Map<String, dynamic>? chatRoomData = message.data['chat_room'] != null
        ? jsonDecode(message.data['chat_room']) as Map<String, dynamic>
        : null;

    if (chatRoomId != null && chatRoomName != null && chatRoomData != null) {
      Get.to(
        () => ChatScreen(
          chatRoomId: chatRoomId,
          groupName: chatRoomName,
          chatRoom: ChatRoomModel.fromJson(chatRoomData),
        ),
      );
    }
  }
}
