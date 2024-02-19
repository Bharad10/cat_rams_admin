import 'package:cat_rams_admin/constant/constant.dart';
import 'package:cat_rams_admin/constant/image_const.dart';
import 'package:cat_rams_admin/model/model.dart';
import 'package:cat_rams_admin/screens/home/service_history_from_home.dart';
import 'package:cat_rams_admin/screens/home/service_list_from_home.dart';
import 'package:cat_rams_admin/screens/home/tool_history_from_home.dart';
import 'package:cat_rams_admin/screens/home/tool_list_from_home.dart';
import 'package:cat_rams_admin/screens/notification/notificationpage.dart';
import 'package:cat_rams_admin/services/post_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nb_utils/nb_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late List<ServiceListModel> servicerequestpendinglist = [];
  late List<ServiceListModel> servicerequesttcompletedlist = [];
  late List<ToolListModel> toolrequestpendinglist = [];
  late List<ToolListModel> toolrequestcompletedlist = [];
  String cut_name = "";
  var servicependinglength = "";
  var servicecompletelength = "";
  var toolpendinglength = "";
  var toolcompletelength = "";

  @override
  void initState() {
    super.initState();
    init();
    Future.delayed(Duration.zero, () {
      _getservicerequestList();
      _gettoolrequestList();
    });
  }

  _getservicerequestList() async {
    await getAllServiceRequestList().then((value) {
      if (value['ret_data'] == "success") {
        setState(() {
          for (var servicerqst in value['result']) {
            ServiceListModel servicerqsttemp = new ServiceListModel();
            servicerqsttemp.sm_code = servicerqst['sm_code'];
            if (servicerqsttemp.sm_code != "SRCP" &&
                servicerqsttemp.sm_code != "SRR") {
              servicerequestpendinglist.add(servicerqsttemp);
              servicependinglength =
                  servicerequestpendinglist.length.toString();
            } else {
              servicerequesttcompletedlist.add(servicerqsttemp);
              servicecompletelength =
                  servicerequesttcompletedlist.length.toString();
            }
          }
        });
      }
    }).catchError((e) {
      print(e.toString());
    });
  }

  _gettoolrequestList() async {
    toolrequestpendinglist = [];
    toolrequestcompletedlist = [];
    await getAllToolRequestList().then((value) {
      if (value['ret_data'] == "success") {
        setState(() {
          for (var toolrqst in value['result']) {
            ToolListModel toolrqsttemp = new ToolListModel();
            toolrqsttemp.sm_code = toolrqst['sm_code'];
            if (toolrqsttemp.sm_code != "TRC" &&
                toolrqsttemp.sm_code != "TRR") {
              toolrequestpendinglist.add(toolrqsttemp);
              toolpendinglength = toolrequestpendinglist.length.toString();
            } else {
              toolrequestcompletedlist.add(toolrqsttemp);
              toolcompletelength = toolrequestcompletedlist.length.toString();
            }
          }
        });
      }
    }).catchError((e) {
      print(e.toString());
    });
  }

  Future<void> init() async {
    setStatusBarColor(Colors.transparent);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cut_name = prefs.getString('us_name')!;
    });
  }

  Future<bool> showExitPopup(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Do you want to exit the App?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future refresh() async {
    setState(() {
      _getservicerequestList();
      _gettoolrequestList();
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
      child: WillPopScope(
        onWillPop: () async {
          bool exit = await showExitPopup(context);
          if (exit) {
            SystemNavigator.pop();
          }
          return Future.value(false);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: RefreshIndicator(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding:
                      EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 78),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome',
                                style:
                                    secondaryTextStyle(color: black, size: 14),
                              ),
                              Text(cut_name, style: boldTextStyle(size: 16)),
                            ],
                          ).expand(),
                          GestureDetector(
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
                            child: RadiantGradientMask(
                              child: Image.asset(
                                ImageConst.notification_bell,
                                height: 25,
                                width: 25,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 120,
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ServiceListFromHome()));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: boxDecorationWithRoundedCorners(
                                    backgroundColor: Colors.pinkAccent,
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            ImageConst.serviceicon,
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.cover,
                                            color: white,
                                          ).cornerRadiusWithClipRRect(12.0),
                                          SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Service Request",
                                                  style: secondaryTextStyle(
                                                      color: white),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              Icon(Icons.arrow_forward_ios,
                                                  color: white, size: 12),
                                            ],
                                          )
                                        ],
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          child: Text(
                                            servicependinglength != ""
                                                ? servicependinglength
                                                : "0",
                                            style: boldTextStyle(
                                                color: Colors.white, size: 20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ServiceDetailsPageFromHome()));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: boxDecorationWithRoundedCorners(
                                      backgroundColor: Colors.cyan),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            ImageConst.serviceicon,
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.cover,
                                            color: white,
                                          ).cornerRadiusWithClipRRect(12.0),
                                          SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Service History",
                                                  style: secondaryTextStyle(
                                                      color: white),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              Icon(Icons.arrow_forward_ios,
                                                  color: white, size: 12),
                                            ],
                                          )
                                        ],
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          child: Text(
                                            servicecompletelength != ""
                                                ? servicecompletelength
                                                : "0",
                                            style: boldTextStyle(
                                                color: Colors.white, size: 20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 120,
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ToolListFromHome()));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: boxDecorationWithRoundedCorners(
                                    backgroundColor: Colors.blueAccent,
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            ImageConst.toolicon,
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.cover,
                                            color: white,
                                          ).cornerRadiusWithClipRRect(12.0),
                                          SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Tool Request",
                                                  style: secondaryTextStyle(
                                                      color: white),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              Icon(Icons.arrow_forward_ios,
                                                  color: white, size: 12),
                                            ],
                                          )
                                        ],
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          child: Text(
                                            toolpendinglength != ""
                                                ? toolpendinglength
                                                : "0",
                                            style: boldTextStyle(
                                                color: Colors.white, size: 20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ToolRequestFromHome()));
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: boxDecorationWithRoundedCorners(
                                      backgroundColor: Colors.orangeAccent),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            ImageConst.toolicon,
                                            height: 40,
                                            width: 40,
                                            fit: BoxFit.cover,
                                            color: white,
                                          ).cornerRadiusWithClipRRect(12.0),
                                          SizedBox(height: 16),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Tool History",
                                                  style: secondaryTextStyle(
                                                      color: white),
                                                  textAlign: TextAlign.start,
                                                ),
                                              ),
                                              Icon(Icons.arrow_forward_ios,
                                                  color: white, size: 12),
                                            ],
                                          )
                                        ],
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: Container(
                                          padding: EdgeInsets.all(4),
                                          child: Text(
                                            toolcompletelength != ""
                                                ? toolcompletelength
                                                : "0",
                                            style: boldTextStyle(
                                                color: Colors.white, size: 20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              onRefresh: refresh),
        ),
      ),
    );
  }
}
