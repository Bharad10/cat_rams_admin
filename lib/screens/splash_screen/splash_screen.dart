import 'dart:async';

import 'package:cat_rams_admin/constant/constant.dart';
import 'package:cat_rams_admin/constant/image_const.dart';
import 'package:cat_rams_admin/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    nextScreen();
    super.initState();
  }

  nextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? repeat = prefs.getBool('islogged');
    if (repeat == true) {
      Timer(const Duration(milliseconds: 1500), () {
        Navigator.pushReplacementNamed(context, Routes.bottombar);
      });
    } else {
      Timer(const Duration(milliseconds: 1500), () {
        Navigator.pushReplacementNamed(context, Routes.loginPage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return AnnotatedRegion(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.black,
        systemNavigationBarColor: Colors.black,
      ),
      child: Scaffold(
        backgroundColor: black,
        body: Center(
          child: Image.asset(
            ImageConst.splashImage,
            fit: BoxFit.contain,
            width: width * 0.6,
          ),
        ),
      ),
    );
  }
}
