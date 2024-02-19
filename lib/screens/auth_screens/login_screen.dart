import 'package:cat_rams_admin/constant/constant.dart';
import 'package:cat_rams_admin/constant/image_const.dart';
import 'package:cat_rams_admin/main.dart';
import 'package:cat_rams_admin/services/post_auth_service.dart';
import 'package:cat_rams_admin/utils/app_validator.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passWordFocusNode = FocusNode();
  bool isLogging = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  admin_login() async {
    setState(() {});
    final prefs = await SharedPreferences.getInstance();
    final status = await OneSignal.shared.getDeviceState();
    final String? osUserID = status?.userId;
    Map req = {
      "email": emailController.text.toString(),
      "password": passwordController.text.toString(),
      "fcm_token": osUserID,
    };
    print(req);
    await adminLogin(req).then((value) {
      print(value);
      if (value['ret_data'] == "success") {
        prefs.setBool('islogged', true);
        prefs.setString('us_name', value['user_details']['us_firstname']);
        prefs.setString('us_id', value['user_details']['us_id']);
        prefs.setString('email', value['user_details']['us_email']);
        prefs.setString('phone', value['user_details']['us_phone']);
        prefs.setString('token', value['user_details']['us_token']);
        prefs.setString('doj', value['user_details']['us_date_of_joining']);
        prefs.setBool("loginflag", true);
        setState(() {
          Navigator.pushReplacementNamed(context, Routes.bottombar);
        });
      } else {
        print(value);
        Fluttertoast.showToast(
            msg: "Invalid Credentials",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color.fromARGB(255, 86, 84, 84),
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() => isLogging = false);
      }
    }).catchError((e) {
      print(e.toString());
      setState(() => isLogging = false);
      Fluttertoast.showToast(
          msg: "Application Error. Contact Support",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 86, 84, 84),
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: context.width(),
          height: context.height(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                50.height,
                Text("Sign In", style: boldTextStyle(size: 24, color: black)),
                Container(
                  margin: EdgeInsets.all(16),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: <Widget>[
                      Container(
                        width: context.width(),
                        padding:
                            EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        margin: EdgeInsets.only(top: 55.0),
                        decoration: boxDecorationWithShadow(
                            borderRadius: BorderRadius.circular(30),
                            backgroundColor: context.cardColor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Form(
                                key: _formKey,
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      50.height,
                                      Text("Email",
                                          style: boldTextStyle(size: 14)),
                                      8.height,
                                      AppTextField(
                                        decoration: ramsInputDecoration(
                                            hint: 'Enter Email',
                                            prefixIcon: Icons.email_outlined),
                                        textFieldType: TextFieldType.EMAIL,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller: emailController,
                                        focus: emailFocusNode,
                                        nextFocus: passWordFocusNode,
                                        validator: (value) {
                                          return emailValidation(
                                              value, context);
                                        },
                                      ),
                                      16.height,
                                      Text("Password",
                                          style: boldTextStyle(size: 14)),
                                      8.height,
                                      AppTextField(
                                        decoration: ramsInputDecoration(
                                            hint: 'Enter Password ',
                                            prefixIcon: Icons.lock_outline),
                                        suffixIconColor: black,
                                        textFieldType: TextFieldType.PASSWORD,
                                        isPassword: true,
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                        controller: passwordController,
                                        focus: passWordFocusNode,
                                        validator: (value) {
                                          return passwordValidation(
                                              value, context);
                                        },
                                      ),
                                      30.height,
                                      Center(
                                        child: GestureDetector(
                                          onTap: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              if (isLogging) return;
                                              setState(() => isLogging = true);
                                              await Future.delayed(
                                                  Duration(milliseconds: 1000));
                                              admin_login();
                                            }
                                          },
                                          child: Stack(
                                            alignment: Alignment.bottomCenter,
                                            children: [
                                              Container(
                                                height: height * 0.065,
                                                width: height * 0.325,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(30)),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                    colors: [
                                                      HexColor('#1d5ace'),
                                                      HexColor('#04b7f9'),
                                                    ],
                                                  ),
                                                ),
                                                child: !isLogging
                                                    ? Text(
                                                        "SIGN IN",
                                                        style: boldTextStyle(
                                                            color: white),
                                                      )
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Transform.scale(
                                                            scale: 0.7,
                                                            child:
                                                                CircularProgressIndicator(
                                                              color: white,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      30.height,
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 100,
                        width: 100,
                        decoration: boxDecorationRoundedWithShadow(30,
                            backgroundColor: context.cardColor),
                        child: Image.asset(
                          ImageConst.rams_icon,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                ),
                16.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
