import 'package:cat_rams_admin/constant/constant.dart';
import 'package:cat_rams_admin/main.dart';
import 'package:cat_rams_admin/screens/notification/notificationpage.dart';
import 'package:cat_rams_admin/screens/settings/edit_profile.dart';
import 'package:cat_rams_admin/services/post_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../constant/image_const.dart';

class ProfilePage extends StatefulWidget {
  final String click_root;
  const ProfilePage({required this.click_root, super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  late Map<String, dynamic> custdetails = {};

  @override
  void initState() {
    super.initState();
    init();
    getAdminProfileDetails();
  }

  Future<void> init() async {}

  getAdminProfileDetails() async {
    await getprofiledetails()
        .then((value) => {
              if (value['ret_data'] == "success")
                {
                  setState(() {
                    custdetails = value['us_details'];
                  })
                }
            })
        .catchError((e) {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  logout_user() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, Routes.loginPage);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.white,
        systemNavigationBarColor: Colors.white,
      ),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          flexibleSpace: Container(
            alignment: Alignment.bottomCenter,
            width: width,
            height: height * 0.31,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  HexColor('#1d5ace'),
                  HexColor('#04b7f9'),
                ],
              ),
            ),
          ),
          title: Text(
            'Settings',
            style: boldTextStyle(color: white),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, Routes.bottombar);
            },
            icon: Icon(Icons.arrow_back,
                color: Colors.white, size: width * 0.054),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 16),
          child: WillPopScope(
            onWillPop: () {
              Navigator.pushReplacementNamed(context, Routes.bottombar);
              return Future.value(false);
            },
            child: Column(
              children: [
                SizedBox(height: 16),
                Stack(
                  children: [
                    Image.asset(ImageConst.rams_icon,
                            height: 100, width: 100, fit: BoxFit.cover)
                        .cornerRadiusWithClipRRect(60),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border:
                              Border.all(color: Colors.black.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.edit, color: white, size: 16),
                      ).onTap(() {
                        EditProfile().launch(context);
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                    custdetails['us_firstname'] != null
                        ? custdetails['us_firstname']
                        : "",
                    style: boldTextStyle(size: 18)),
                SizedBox(height: 8),
                Text(
                    custdetails['us_phone'] != null
                        ? custdetails['us_phone']
                        : "",
                    style: secondaryTextStyle()),
                SizedBox(height: 16),
                Divider(height: 0),
                SizedBox(height: 16),
                SettingItemWidget(
                  leading: Icon(Icons.person_outline, color: context.iconColor),
                  title: "Edit Profile",
                  titleTextStyle: boldTextStyle(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EditProfile();
                        },
                      ),
                    );
                  },
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      size: 18, color: context.iconColor),
                ),
                SettingItemWidget(
                  leading: Icon(Icons.notifications_active_outlined,
                      color: context.iconColor),
                  title: "Notification",
                  titleTextStyle: boldTextStyle(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return NotificationPage();
                        },
                      ),
                    );
                  },
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      size: 18, color: context.iconColor),
                ),
                SettingItemWidget(
                  leading: Icon(Icons.assignment_turned_in_outlined,
                      color: context.iconColor),
                  title: "Terms and Conditions",
                  titleTextStyle: boldTextStyle(),
                  onTap: () {},
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      size: 18, color: context.iconColor),
                ),
                SettingItemWidget(
                  leading: Icon(Icons.lock_outline, color: context.iconColor),
                  title: "Privacy Policy",
                  titleTextStyle: boldTextStyle(),
                  onTap: () {},
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      size: 18, color: context.iconColor),
                ),
                SettingItemWidget(
                  leading:
                      Icon(Icons.delete_outlined, color: context.iconColor),
                  title: "Delete Account",
                  titleTextStyle: boldTextStyle(),
                  onTap: () {},
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      size: 18, color: context.iconColor),
                ),
                SettingItemWidget(
                  leading: Icon(Icons.login, color: context.iconColor),
                  title: "Logout",
                  titleTextStyle: boldTextStyle(),
                  onTap: () {
                    showConfirmDialogCustom(
                      context,
                      primaryColor: Color(0xff1d5ace),
                      title: "Do you want to logout from the app?",
                      onAccept: (v) {
                        logout_user();
                      },
                    );
                  },
                  trailing: Icon(Icons.arrow_forward_ios_rounded,
                      size: 18, color: context.iconColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
