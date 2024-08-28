import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_app_demo/app/modules/login/bindings/login_binding.dart';
import 'package:supabase_app_demo/services/network_services.dart';
import 'package:supabase_app_demo/services/notification_service.dart';
import 'package:supabase_app_demo/services/supabase_service.dart';
import 'package:supabase_app_demo/services/chat/user_status.dart';
import 'package:supabase_app_demo/utils/app_theme.dart';
import 'package:supabase_app_demo/utils/storage/storage.dart';
import 'app/routes/app_pages.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ScreenUtil.ensureScreenSize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  Get.put(
    SupabaseService(),
    permanent: true,
  );
  Get.put<GetXNetworkManager>(GetXNetworkManager(), permanent: true);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale? locale = const Locale('en');

  init() async {
    await AppNotification().initMessaging();
    await AppNotification().setupInteractMessage(context);
  }

  final uServices = Get.put(UserStatusServices());

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    var currentUser = SupabaseService.client.auth.currentUser;
    if (currentUser != null) {
      if (state == AppLifecycleState.resumed) {
        await uServices.userOnline(currentUser.id);
      } else if (state == AppLifecycleState.paused ||
          state == AppLifecycleState.inactive ||
          state == AppLifecycleState.detached ||
          state == AppLifecycleState.hidden) {
        await uServices.userOffline(currentUser.id);
      }
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    init();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GestureDetector(
          onTap: () =>
              WidgetsBinding.instance.focusManager.primaryFocus!.unfocus(),
          child: GetMaterialApp(
            getPages: AppPages.routes,
            initialRoute:
                Storage.userSession != null ? AppPages.INITIAL : Routes.LOGIN,
            locale: locale,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            defaultTransition: Transition.noTransition,
            initialBinding: LoginBinding(),
            scrollBehavior: WebDragScrollBehavior(),
          ),
        );
      },
    );
  }
}

class WebDragScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
