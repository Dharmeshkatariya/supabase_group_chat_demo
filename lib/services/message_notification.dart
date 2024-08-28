import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_app_demo/models/chat%20model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;

class MessageNotification {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "custom-widget-e85c3",
      "private_key_id": "cd03670c2b816475f5c00d4db6ff922e3a0dffa2",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC9i+ALoxqim0pD\nW1CUMN0EJSaUKV6HpMB762Up5ge3ZUwMf5r2myiCkfP6KLHrH1xdjioM9U5xrQa9\nTT64SZ60Q6N1+LnenPRi7uOv1kmv4cZQQH1Q91eLI/YhHVO1sDpbRUE/loWHvd2e\nL8pn/GdrhOuRvz+ykdfW+iSTky3tCzXmaBwUTuqE4oqSJ/op9WF+yCLD93m8U08j\neVgDFqxm6P4XoKQ0rv8ouJivVstZJTB6OaJWo6CSvZdYtVvqjlVToa9yzuVuW7RU\nS5J+HLll8LriO04KrOL3qL+LZ/vht4sYdvIArXjHjp/4FAgPwR5pq1GoUFJMT0Tz\nnnZ72ZwPAgMBAAECggEAQqIslgq1r1pGJh2w2xe+atmgkU9lwuuhGy8qdis+pTNA\nI9isImtzN0uV6Ghr+4sfzmfO0pVeCUpZZy0DkoeW+ioZCbzxopestibi9gqwBtuo\n+sdhBpidNvXibcvAhMu6CCH1iSQiNxEBGr4UOrAZr0ugALGp892fchynxRVlfMHr\npDK+HRdusg84/TR5Iz59wa77dk7YfNhV83N9VNnGflQYZBwDoVLWvIssOSYUfx/8\nMTnxrKLqyf/n07joT0yAM3+UuVa9zRQWO7NT9PT1KHsILmbT2KGyyeSIPY6uo5B7\nPwZF423A36lZTH02CUL/w6Fy5uZyNA7tW/POyXXq4QKBgQDxB84VlszdOkUwjaBr\nnd1hZZHC/ziZQpsWMHRGZEboVFqG/RbY6bgaoD4qdVU4DpWQ8Rx3drJFT2vZYi++\n6gGVfb3lrhMlEK1sC7/S5myz0bcDynGe10aa+OE8DoR4Pj5jlrxx/dtQZCfmw0Nz\nrIxUv7KChfwiMQWLGyyNtAw9fwKBgQDJUYN0SSe9P8r5rOjS64Y0hWL8S1kY0I8F\n3yW6bITynifxEsciDGPL+OUup1GSWDCJqmca6X4Al+HFvscr3JKTz7bUA6c3NNjQ\nZxuO9wxYxEI91qEc+myh5H8yqT8/1TfxRsxHkUOxUq0EDkkDKjQN2Us3x3oCuKNH\n4A32ojcJcQKBgQC9yMqBf0ryCta+A1ZERnoxHXunUbSsIKDi2OZFIuIeP4VEcvXR\neD5JYNFyNw8R45HrHZ6vhhuarY2bDk/QAIucvPSQa/+RGM+kmp/BHUSMVl3Hs1jB\nnHpwvfUDh97Qmxoe6mqZSyyr4SD199wdsciRVpvlYECGX5kgzhXHwfQ9WwKBgGn7\nLI3aOT5qx+sauNLYxKT/l3WkIPpsSO7ZY545pN+onPRPY1+sUBlAJT6jPNEi9iJy\n/6ZuRzP+wQ99+JJBozSHRANnDO+GNaG4tgxUSD6uywSM6fI8b1Xm2YOND8wF7lZp\nY/9FHPLLyGN7NbqhzBeCThPGQpgOJX8gF5nAGeMxAoGAHZ9RDrZ2zrtuEbCmhuCO\n3NG9mmGWp1feIs9eb/agGV/TEd3EylncMrMQxR2Oe5oVWIq6gnY9aNFUMEL35pNZ\nyPWePhPgH9T2qfo+fHzEMxP1wDN+5XFQfE8SdhXbJJY3NByj6PB+0TuIPiecgDT5\n3fP/GpBUBnYtrBYppo0RjwI=\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-ilgb8@custom-widget-e85c3.iam.gserviceaccount.com",
      "client_id": "114713371122162375979",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-ilgb8%40custom-widget-e85c3.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );
    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);
    client.close();
    return credentials.accessToken.data;
  }

  static Future<void> notifyParticipants(
    String chatRoomId,
    String chatRoomName,
    String userId,
    String message,
    ChatRoomModel chatroom,
  ) async {
    final supabase = Supabase.instance.client;

    final chatRoomResponse = await supabase
        .from('chat_rooms')
        .select('user_id')
        .eq('id', chatRoomId)
        .single()
        .execute();
    if (chatRoomResponse.data != null &&
        chatRoomResponse.data['user_id'] is List) {
      final List<String> userIds =
          List<String>.from(chatRoomResponse.data['user_id']);
      userIds.remove(userId);
      if (userIds.isEmpty) {
        print('No other users to notify');
        return;
      }
      final usersResponse = await supabase
          .from('users')
          .select('fcm_token')
          .in_('id', userIds)
          .execute();
      if (usersResponse.data != null && usersResponse.data is List) {
        final tokens = (usersResponse.data as List)
            .map<String>((user) => user['fcm_token'] as String)
            .toList();
        for (final token in tokens) {
          await _sendPushNotification(
              token, chatRoomId, message, chatRoomName, chatroom);
        }
      } else {
        print('No data received or data format is unexpected');
      }
    } else {
      print('No chat room data found or data format is unexpected');
    }
  }

  static Future<void> _sendPushNotification(
    String token,
    String chatRoomId,
    String message,
    String chatRoomName,
    ChatRoomModel chatroom,
  ) async {
    final String serverKey = await getAccessToken();
    const String fcmEndpoint =
        'https://fcm.googleapis.com/v1/projects/custom-widget-e85c3/messages:send';

    final chatroomJson = chatroom.toJson();

    final Map<String, dynamic> messageData = {
      'message': {
        'token': token,
        'notification': {
          'title': chatRoomName,
          'body': message,
        },
        'data': {
          'chat_room_id': chatRoomId,
          'message': message,
          'chat_room': jsonEncode(chatroomJson),
          'chat_room_name': chatRoomName,
        },
      }
    };
    final response = await http.post(
      Uri.parse(fcmEndpoint),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      },
      body: jsonEncode(messageData),
    );
    if (response.statusCode != 200) {
      print('Error sending push notification: ${response.body}');
    } else {
      print('Failed to send FCM message: ${response.statusCode}');
    }
  }
}
