import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:supabase_app_demo/models/user_model.dart';
import 'package:supabase_app_demo/services/chat/user_status.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../utils/constant.dart';
import '../utils/env.dart';
import '../utils/storage/storage.dart';

class SupabaseService extends GetxService {
  Rx<User?> currentUser = Rx<User?>(null);

  bool get isAuthenticated {
    return currentUser.value != null;
  }

  String? get loggedUid => client.auth.currentUser!.id;

  @override
  void onInit() async {
    await Supabase.initialize(
        url: Env.supabaseUrl,
        authCallbackUrlHostname: "https://mkwiszognicuzhfajjkq.supabase.co",
        anonKey: Env.supabaseKey,
        authFlowType: AuthFlowType.pkce);
    currentUser.value = client.auth.currentUser;

    listenAuthChange();
    super.onInit();
  }

  // * Create Signle Instance
  static final SupabaseClient client = Supabase.instance.client;

  // * first load the status
  void updateUserfromSession() {
    var session = Session.fromJson(Storage.userSession!);
    currentUser.value = session?.user;
  }

  final userServices = Get.put(UserStatusServices());

  void listenAuthChange() {
    client.auth.onAuthStateChange.listen((data) async {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.userUpdated) {
        currentUser.value = data.session?.user;
      } else if (event == AuthChangeEvent.signedIn) {
        currentUser.value = data.session?.user;
        await userServices.userOnline(currentUser.value!.id);
        initMessaging();
      } else if (event == AuthChangeEvent.signedOut) {
        await userServices.userOffline(currentUser.value!.id);
      }
    });
  }

  Future updateUserDataProfile(UserModel usermodel, String imgepath) async {
    await client.from("users").upsert({
      "id": usermodel.id,
      'email': usermodel.email,
      "metadata": {
        "name": usermodel.name,
        "image": imgepath,
      },
      "image": imgepath
    }).execute();
  }

  Future initMessaging() async {
    await FirebaseMessaging.instance.requestPermission();
    await FirebaseMessaging.instance.getAPNSToken();
    await FirebaseMessaging.instance.getToken().then((token) async {
      if (token != null) {
        Common.fcmToken = token;
        final userid = currentUser.value!.id;
        final email = currentUser.value!.email;
        if (userid != null) {
          await client.from("users").upsert({
            "id": userid,
            'email': email,
            "fcm_token": token,
          }).execute();
        }
      }
    });
    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      if (token != null) {
        Common.fcmToken = token;
        final userid = currentUser.value!.id;
        await client
            .from("users")
            .upsert({"id": userid, "fcm_token": token}).execute();
      }
    });
  }
}
