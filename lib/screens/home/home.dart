import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_rams_admin/constant/constant.dart';
import 'package:cat_rams_admin/constant/image_const.dart';
import 'package:cat_rams_admin/model/model.dart';
import 'package:cat_rams_admin/screens/home/service_history_from_home.dart';
import 'package:cat_rams_admin/screens/home/service_list_from_home.dart';
import 'package:cat_rams_admin/screens/home/tool_history_from_home.dart';
import 'package:cat_rams_admin/screens/home/tool_list_from_home.dart';
import 'package:cat_rams_admin/screens/notification/notificationpage.dart';
import 'package:cat_rams_admin/screens/service/service_list_details.dart';
import 'package:cat_rams_admin/screens/tool/tool_list_details.dart';
import 'package:cat_rams_admin/services/post_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late List<ServiceListModel> servicerequestpendinglist = [];
  late List<ServiceListModel> servicerequesttcompletedlist = [];
  late List<ServiceListModel> newservicerequest = [];
  late List<ToolListModel> toolrequestpendinglist = [];
  late List<ToolListModel> toolrequestcompletedlist = [];
  late List<ToolListModel> newtoolrequest = [];

  late AnimationController _animationController;
  late Animation _animation;
  String cut_name = "";
  var servicependinglength = "";
  var servicecompletelength = "";
  var toolpendinglength = "";
  var toolcompletelength = "";

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation = Tween(begin: 2.0, end: 5.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
    init();
    Future.delayed(Duration.zero, () {
      _getservicerequestList();
      _gettoolrequestList();
    });
  }

  _getservicerequestList() async {
    servicerequestpendinglist = [];
    servicerequesttcompletedlist = [];
    newservicerequest = [];
    await getAllServiceRequestList().then((value) {
      if (value['ret_data'] == "success") {
        setState(() {
          for (var servicerqst in value['result']) {
            ServiceListModel servicerqsttemp = new ServiceListModel();
            servicerqsttemp.servicerqst_id = servicerqst['serm_id'];
            servicerqsttemp.servicerqst_number = servicerqst['serm_number'];
            servicerqsttemp.servicerqst_make_name = servicerqst['make_name'];
            servicerqsttemp.servicerqst_model_name = servicerqst['model_name'];
            servicerqsttemp.servicerqst_variant_name =
                servicerqst['variant_name'];
            servicerqsttemp.servicerqst_vinnumber =
                servicerqst['custveh_vinnumber'];
            servicerqsttemp.servicerqst_sm_name = servicerqst['sm_name'];
            servicerqsttemp.servicerqst_date = servicerqst['serm_createdon'];
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
            if (servicerqsttemp.sm_code == "QP") {
              newservicerequest.add(servicerqsttemp);
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
    newtoolrequest = [];
    await getAllToolRequestList().then((value) {
      if (value['ret_data'] == "success") {
        setState(() {
          for (var toolrqst in value['result']) {
            ToolListModel toolrqsttemp = new ToolListModel();
            toolrqsttemp.sm_code = toolrqst['sm_code'];
            toolrqsttemp.toolrqst_id = toolrqst['tldet_id'];
            toolrqsttemp.toolrqst_number = toolrqst['tldt_number'];
            toolrqsttemp.toolrqst_image = toolrqst['tool_images'];
            toolrqsttemp.toolrqst_tool_name = toolrqst['tool_name'];
            toolrqsttemp.toolrqst_sm_name = toolrqst['sm_name'];
            toolrqsttemp.toolrqst_date = toolrqst['tldt_created_on'];
            toolrqsttemp.sm_code = toolrqst['sm_code'];
            if (toolrqsttemp.sm_code != "TRC" &&
                toolrqsttemp.sm_code != "TRR") {
              toolrequestpendinglist.add(toolrqsttemp);
              toolpendinglength = toolrequestpendinglist.length.toString();
            } else {
              toolrequestcompletedlist.add(toolrqsttemp);
              toolcompletelength = toolrequestcompletedlist.length.toString();
            }
            if (toolrqsttemp.sm_code == "TRP") {
              newtoolrequest.add(toolrqsttemp);
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
          body: SafeArea(
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
                            style: secondaryTextStyle(color: black, size: 14),
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
                  SizedBox(
                    height: 10,
                  ),
                  newtoolrequest.length > 0
                      ? Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "New Tool Request",
                                style: boldTextStyle(
                                  size: 18,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                  newtoolrequest.length > 0
                      ? ListView.builder(
                          padding: EdgeInsets.only(top: 0),
                          itemCount: newtoolrequest.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 16, 0, 16),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    Colors.red.withOpacity(0.4),
                                                spreadRadius: _animation.value,
                                                blurRadius: _animation.value,
                                              ),
                                            ],
                                          ),
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.all(16),
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        newtoolrequest[index]
                                                                    .toolrqst_image !=
                                                                null
                                                            ? CachedNetworkImage(
                                                                placeholder: (context,
                                                                        url) =>
                                                                    Transform
                                                                        .scale(
                                                                  scale: 0.5,
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    color:
                                                                        white,
                                                                  ),
                                                                ),
                                                                imageUrl: dotenv
                                                                            .env[
                                                                        'API_URL']! +
                                                                    'public/' +
                                                                    newtoolrequest[
                                                                            index]
                                                                        .toolrqst_image,
                                                                height: 60,
                                                                width: 60,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : ClipRRect(
                                                                child:
                                                                    Image.asset(
                                                                  ImageConst
                                                                      .rams_icon,
                                                                  height: 60,
                                                                  width: 60,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                              ),
                                                        Expanded(
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 16),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        newtoolrequest[index].toolrqst_tool_name !=
                                                                                null
                                                                            ? newtoolrequest[index].toolrqst_tool_name
                                                                            : "",
                                                                        style:
                                                                            boldTextStyle(),
                                                                        overflow:
                                                                            TextOverflow.clip,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                                Text(
                                                                  newtoolrequest[index]
                                                                              .toolrqst_number !=
                                                                          null
                                                                      ? newtoolrequest[
                                                                              index]
                                                                          .toolrqst_number
                                                                      : "",
                                                                  style:
                                                                      primaryTextStyle(
                                                                          size:
                                                                              16),
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                                Text(
                                                                  newtoolrequest[index]
                                                                              .toolrqst_date !=
                                                                          null
                                                                      ? DateFormat(
                                                                              'dd-MM-yyyy')
                                                                          .format(
                                                                              DateTime.tryParse(newtoolrequest[index].toolrqst_date)!)
                                                                      : "",
                                                                  style:
                                                                      primaryTextStyle(
                                                                          size:
                                                                              16),
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                                Text(
                                                                  newtoolrequest[index]
                                                                              .toolrqst_sm_name !=
                                                                          null
                                                                      ? newtoolrequest[
                                                                              index]
                                                                          .toolrqst_sm_name
                                                                      : "",
                                                                  style: primaryTextStyle(
                                                                      color: Colors
                                                                          .blue,
                                                                      size: 14),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                    ).onTap(
                                                      () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ToolDetailsPage(
                                                                        toolrstid:
                                                                            newtoolrequest[index].toolrqst_id)));
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          })
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  newservicerequest.length > 0
                      ? Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "New Service Request",
                                style: boldTextStyle(
                                  size: 18,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
                  newservicerequest.length > 0
                      ? ListView.builder(
                          padding: EdgeInsets.only(top: 0),
                          itemCount: newservicerequest.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Container(
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 16, 0, 16),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color:
                                                    Colors.red.withOpacity(0.4),
                                                spreadRadius: _animation.value,
                                                blurRadius: _animation.value,
                                              ),
                                            ],
                                          ),
                                          child: Stack(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.all(16),
                                                child: Column(
                                                  children: <Widget>[
                                                    Row(
                                                      children: <Widget>[
                                                        ClipRRect(
                                                          child: Image.asset(
                                                            newservicerequest[
                                                                            index]
                                                                        .servicerqst_make_name ==
                                                                    'Mercedes Benz'
                                                                ? ImageConst
                                                                    .BENZ
                                                                : newservicerequest[index]
                                                                            .servicerqst_make_name ==
                                                                        'BMW'
                                                                    ? ImageConst
                                                                        .BMW
                                                                    : newservicerequest[index].servicerqst_make_name ==
                                                                            'Skoda'
                                                                        ? ImageConst
                                                                            .SKODA
                                                                        : newservicerequest[index].servicerqst_make_name ==
                                                                                'Audi'
                                                                            ? ImageConst.AUDI
                                                                            : newservicerequest[index].servicerqst_make_name == 'Porsche'
                                                                                ? ImageConst.PORSCHE
                                                                                : newservicerequest[index].servicerqst_make_name == 'Volkswagen'
                                                                                    ? ImageConst.VOLKSWAGEN
                                                                                    : newservicerequest[index].servicerqst_make_name == 'Jaguar'
                                                                                        ? ImageConst.JAGUAR
                                                                                        : newservicerequest[index].servicerqst_make_name == 'Landrover'
                                                                                            ? ImageConst.LANDROVER
                                                                                            : ImageConst.rams_icon,
                                                            height: 60,
                                                            width: 60,
                                                            fit: BoxFit.cover,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 16),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      newservicerequest[index].servicerqst_number !=
                                                                              null
                                                                          ? newservicerequest[index]
                                                                              .servicerqst_number
                                                                          : "",
                                                                      style:
                                                                          boldTextStyle(),
                                                                    ),
                                                                    Text(
                                                                      newservicerequest[index].servicerqst_date !=
                                                                              null
                                                                          ? DateFormat('dd-MM-yyyy')
                                                                              .format(DateTime.tryParse(newservicerequest[index].servicerqst_date)!)
                                                                          : "",
                                                                      style: primaryTextStyle(
                                                                          size:
                                                                              12),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                                Text(
                                                                  newservicerequest[index]
                                                                              .servicerqst_make_name !=
                                                                          null
                                                                      ? newservicerequest[index].servicerqst_variant_name !=
                                                                              null
                                                                          ? newservicerequest[index].servicerqst_make_name +
                                                                              " " +
                                                                              newservicerequest[index]
                                                                                  .servicerqst_model_name +
                                                                              " " +
                                                                              newservicerequest[index]
                                                                                  .servicerqst_variant_name
                                                                          : ": " +
                                                                              newservicerequest[index].servicerqst_make_name +
                                                                              " " +
                                                                              newservicerequest[index].servicerqst_model_name
                                                                      : "",
                                                                  style:
                                                                      primaryTextStyle(
                                                                          size:
                                                                              14),
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                                Text(
                                                                  newservicerequest[index]
                                                                              .servicerqst_vinnumber !=
                                                                          null
                                                                      ? newservicerequest[
                                                                              index]
                                                                          .servicerqst_vinnumber
                                                                      : "",
                                                                  style:
                                                                      primaryTextStyle(
                                                                          size:
                                                                              14),
                                                                ),
                                                                SizedBox(
                                                                  height: 4,
                                                                ),
                                                                Text(
                                                                  newservicerequest[index]
                                                                              .servicerqst_sm_name !=
                                                                          null
                                                                      ? newservicerequest[
                                                                              index]
                                                                          .servicerqst_sm_name
                                                                      : "",
                                                                  style: primaryTextStyle(
                                                                      color: Colors
                                                                          .blue,
                                                                      size: 14),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                    ).onTap(
                                                      () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ServiceDetailsPage(
                                                                          servicerqstid:
                                                                              newservicerequest[index].servicerqst_id,
                                                                          make:
                                                                              newservicerequest[index].servicerqst_make_name,
                                                                          vehname: newservicerequest[index].servicerqst_make_name +
                                                                              newservicerequest[index].servicerqst_model_name +
                                                                              newservicerequest[index].servicerqst_variant_name,
                                                                        )));
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          })
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
