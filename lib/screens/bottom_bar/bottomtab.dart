import 'dart:async';
import 'package:cat_rams_admin/constant/constant.dart';
import 'package:cat_rams_admin/provider/provider.dart';
import 'package:cat_rams_admin/screens/bottom_bar/common_BottomTab.dart';
import 'package:cat_rams_admin/screens/home/home.dart';
import 'package:cat_rams_admin/screens/service/service_list.dart';
import 'package:cat_rams_admin/screens/settings/profile_page.dart';
import 'package:cat_rams_admin/screens/support/support_page.dart';
import 'package:cat_rams_admin/screens/tool/toollist.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavBarScreen extends StatefulWidget {
  final int index;
  const BottomNavBarScreen({
    Key? key,
    required this.index,
  }) : super(key: key);
  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  // int currentIndex = 1;

  @override
  void initState() {
    index();
    super.initState();
  }

  index() {
    Timer(const Duration(milliseconds: 100), () {
      final tabNotifier = Provider.of<TabNotifier>(context, listen: false);
      tabNotifier.setindex = widget.index;
    });
  }

  ///------- tab screen  ----------
  final List<Widget> viewContainer = [
    Support(click_id: 1),
    HomePage(),
    ServiceList(click_id: 1),
    ToolList(click_id: 1),
    ProfilePage(click_root: "bottomtab"),
  ];

  @override
  Widget build(BuildContext context) {
    var tabNotifier = context.watch<TabNotifier>();
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: PersistanceBottomTab(
          index: tabNotifier.currentIndex,
          onSuccess: (val) {
            tabNotifier.currentIndex = val;
          }),

      ///------- tab screen view ----------
      body: viewContainer[tabNotifier.currentIndex],
    );
  }
}
