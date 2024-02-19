import 'package:cat_rams_admin/constant/constant.dart';
import 'package:cat_rams_admin/constant/image_const.dart';
import 'package:cat_rams_admin/provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

bool isFromEventScreen = false;

class PersistanceBottomTab extends StatefulWidget {
  final int index;

  final Function onSuccess;
  const PersistanceBottomTab({
    Key? key,
    required this.index,
    required this.onSuccess,
  }) : super(key: key);

  @override
  State<PersistanceBottomTab> createState() => _PersistanceBottomTabState();
}

class _PersistanceBottomTabState extends State<PersistanceBottomTab> {
  // int currentIndex = 0;
  @override
  void initState() {
    // index();
    super.initState();
  }

  index() {
    final tabNotifier = Provider.of<TabNotifier>(context, listen: false);
    tabNotifier.setindex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    var tabNotifier = context.watch<TabNotifier>();
    return BottomAppBar(
      child: Container(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration:
            const BoxDecoration(border: Border(top: BorderSide(color: gray))),
        height: height * 0.07,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ///------- Home -------------
                  Expanded(
                    child: GestureDetector(
                        onTap: () {
                          tabNotifier.setindex = 1;

                          widget.onSuccess(tabNotifier.getindex);
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.only(
                              left: width * 0.03,
                              right: width * 0.03,
                              top: height * 0.01,
                              bottom: height * 0.01),
                          child: Image.asset(
                            ImageConst.homeicon,
                            height: height * 0.027,
                            fit: BoxFit.contain,
                            color: tabNotifier.getindex == 1
                                ? blueColor
                                : blackColor,
                          ),
                        )),
                  ),

                  ///------- car -------------

                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        tabNotifier.setindex = 2;
                        widget.onSuccess(tabNotifier.getindex);
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.01,
                            bottom: height * 0.01),
                        child: Image.asset(
                          ImageConst.serviceicon,
                          height: height * 0.027,
                          fit: BoxFit.contain,
                          color: tabNotifier.getindex == 2
                              ? blueColor
                              : blackColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: Container()),

                  ///------- tool -------------
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        tabNotifier.setindex = 3;
                        widget.onSuccess(tabNotifier.getindex);
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.only(
                            left: width * 0.03,
                            right: width * 0.03,
                            top: height * 0.01,
                            bottom: height * 0.01),
                        child: Image.asset(
                          ImageConst.toolicon,
                          height: height * 0.027,
                          fit: BoxFit.contain,
                          color: tabNotifier.getindex == 3
                              ? blueColor
                              : blackColor,
                        ),
                      ),
                    ),
                  ),

                  ///------- setting -------------
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // setState(() {

                        // });
                        tabNotifier.setindex = 4;
                        widget.onSuccess(tabNotifier.getindex);
                      },
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.only(
                            right: width * 0.03,
                            left: width * 0.03,
                            top: height * 0.01,
                            bottom: height * 0.01),
                        child: Image.asset(
                          ImageConst.settingsicon,
                          height: height * 0.027,
                          fit: BoxFit.contain,
                          color: tabNotifier.getindex == 4
                              ? blueColor
                              : blackColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment(0, -20),
              child: GestureDetector(
                onTap: () {
                  setState(() {});
                },
                child: Container(
                  height: height * 0.065,
                  width: height * 0.065,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.white,
                      ],
                    ),
                  ),
                  child: Image.asset(
                    ImageConst.rams_icon,
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
