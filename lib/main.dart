import 'dart:io' show Platform;

import 'package:cat_rams_admin/provider/provider.dart';
import 'package:cat_rams_admin/screens/auth_screens/login_screen.dart';
import 'package:cat_rams_admin/screens/bottom_bar/bottomtab.dart';
import 'package:cat_rams_admin/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  if (Platform.isIOS || Platform.isAndroid) {
    try {
      await OneSignal.shared.setAppId("71ff99b0-6b7f-4bbc-9596-deaf534dc8aa");
      OneSignal.shared.setNotificationWillShowInForegroundHandler(
          (OSNotificationReceivedEvent? event) {
        return event?.complete(event.notification);
      });
    } catch (e) {
      print('${e.toString()}');
    }
  }
  SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then(
    (_) => runApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TabNotifier()),
      ],
      child: Builder(
        builder: (context) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          routes: routes,
        ),
      ),
    );
  }
}

var routes = <String, WidgetBuilder>{
  Routes.SPLASH: (BuildContext context) => SplashScreen(),
  Routes.bottombar: (BuildContext context) => BottomNavBarScreen(
        index: 1,
      ),
  Routes.loginPage: (BuildContext context) => LoginScreen(),
};

class Routes {
  static const SPLASH = "/";
  static const bottombar = "screens/bottom_tab/bottomtab.dart";
  static const loginPage = "screens/auth_screens/login_page.dart";
}
