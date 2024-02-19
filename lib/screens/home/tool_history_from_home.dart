import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_rams_admin/constant/constant.dart';
import 'package:cat_rams_admin/constant/image_const.dart';
import 'package:cat_rams_admin/model/model.dart';
import 'package:cat_rams_admin/screens/tool/tool_list_details.dart';
import 'package:cat_rams_admin/services/post_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class ToolRequestFromHome extends StatefulWidget {
  const ToolRequestFromHome({super.key});

  @override
  State<ToolRequestFromHome> createState() => ToolRequestFromHomeState();
}

class ToolRequestFromHomeState extends State<ToolRequestFromHome> {
  late List<ToolListModel> toolrequestpendinglist = [];
  late List<ToolListModel> toolrequestcompletedlist = [];
  bool isActive = true;
  @override
  void initState() {
    super.initState();
    init();
    Future.delayed(Duration.zero, () {
      _gettoolrequestList();
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
            } else {
              toolrequestcompletedlist.add(toolrqsttemp);
            }
          }
          isActive = false;
        });
      } else {
        print(value['ret_data']);
        isActive = false;
        setState(() {});
      }
    }).catchError((e) {
      print(e.toString());
      isActive = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> init() async {}

  Future refresh() async {
    setState(() {
      _gettoolrequestList();
    });
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
      child: WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          return Future.value(false);
        },
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
                "Tool History List",
                style: boldTextStyle(color: white),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon:
                    const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              )),
          body: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: toolrequestcompletedlist.length > 0
                      ? RefreshIndicator(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: toolrequestcompletedlist.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(8, 8, 8, 8),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: context
                                                  .scaffoldBackgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
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
                                                          toolrequestcompletedlist[
                                                                          index]
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
                                                                      toolrequestcompletedlist[
                                                                              index]
                                                                          .toolrqst_image,
                                                                  height: 60,
                                                                  width: 60,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              : ClipRRect(
                                                                  child: Image
                                                                      .asset(
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
                                                              padding: EdgeInsets
                                                                  .only(
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
                                                                        toolrequestcompletedlist[index].toolrqst_tool_name !=
                                                                                null
                                                                            ? toolrequestcompletedlist[index].toolrqst_tool_name
                                                                            : "",
                                                                        style:
                                                                            boldTextStyle(),
                                                                      ),
                                                                      Text(
                                                                        toolrequestcompletedlist[index].toolrqst_number !=
                                                                                null
                                                                            ? toolrequestcompletedlist[index].toolrqst_number
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
                                                                    toolrequestcompletedlist[index].toolrqst_date !=
                                                                            null
                                                                        ? DateFormat('dd-MM-yyyy')
                                                                            .format(DateTime.tryParse(toolrequestcompletedlist[index].toolrqst_date)!)
                                                                        : "",
                                                                    style: primaryTextStyle(
                                                                        size:
                                                                            16),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  Text(
                                                                    toolrequestcompletedlist[index].toolrqst_sm_name !=
                                                                            null
                                                                        ? toolrequestcompletedlist[index]
                                                                            .toolrqst_sm_name
                                                                        : "",
                                                                    style: primaryTextStyle(
                                                                        color: toolrequestcompletedlist[index].sm_code ==
                                                                                "TRR"
                                                                            ? Colors
                                                                                .red
                                                                            : Colors
                                                                                .green,
                                                                        size:
                                                                            14),
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
                                                                              toolrequestcompletedlist[index].toolrqst_id)));
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: 4,
                                                  height: 35,
                                                  margin:
                                                      EdgeInsets.only(top: 16),
                                                  color:
                                                      toolrequestcompletedlist[
                                                                      index]
                                                                  .sm_code ==
                                                              "TRC"
                                                          ? Colors.green
                                                          : Colors.red,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          onRefresh: refresh)
                      : Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: height * 0.02,
                                  left: width * 0.04,
                                  right: width * 0.04,
                                  bottom: width * 1.2),
                              decoration: BoxDecoration(
                                  color: white,
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.3)),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            topRight: Radius.circular(8),
                                            bottomLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(8)),
                                      ),
                                      margin:
                                          EdgeInsets.only(left: 0, right: 12),
                                      child: Image.asset(
                                        ImageConst.no_tool,
                                        height: 60,
                                        fit: BoxFit.contain,
                                      ),
                                      padding: EdgeInsets.all(width / 30),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Container(
                                              child: Text("NO TOOL REQUEST",
                                                  style: boldTextStyle()),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}