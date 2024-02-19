import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_rams_admin/constant/constant.dart';
import 'package:cat_rams_admin/constant/image_const.dart';
import 'package:cat_rams_admin/main.dart';
import 'package:cat_rams_admin/services/post_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nb_utils/nb_utils.dart';

class ToolDetailsPage extends StatefulWidget {
  final String toolrstid;
  const ToolDetailsPage({required this.toolrstid, super.key});

  @override
  State<ToolDetailsPage> createState() => ToolDetailsPageState();
}

class ToolDetailsPageState extends State<ToolDetailsPage> {
  late Map<String, dynamic> toolrequestdetails = {};
  var rejectreason = "";
  bool isaccept = false;
  bool issubmitted = false;
  final _formKey = GlobalKey<FormState>();
  FocusNode rejectFocus = FocusNode();
  var reject = "";
  double depositamount = 0.0;
  double advanceamount = 0.0;

  @override
  void initState() {
    print("==============>");
    print(base64.encode(utf8.encode(widget.toolrstid)));
    super.initState();
    Future.delayed(Duration.zero, () {
      init();
    });
  }

  Future<void> init() async {
    CustomerToolRequestDetails();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  CustomerToolRequestDetails() async {
    try {
      await getToolRequestDetails(widget.toolrstid).then((value) async {
        if (value['ret_data'] == "success") {
          setState(() {
            toolrequestdetails = value['req_list'];
            depositamount = (double.parse(value['req_list']['tldt_cost']) *
                    double.parse(value['req_list']['tool_deposit_price'])) /
                100;
            advanceamount = (double.parse(value['req_list']['tldt_cost']) *
                    double.parse(value['req_list']['tool_adv_price'])) /
                100;
          });
          if (value['track_data'] != 0) {
            rejectreason = value['track_data']['trt_notes'];
          }
        }
      });
    } catch (e) {
      print(e.toString());
      Fluttertoast.showToast(
          msg: "Application Error. Contact Support",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 86, 84, 84),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  acceptClick() async {
    try {
      Map data = {
        "tldt_cstm_id": toolrequestdetails['tldt_cstm_id'],
        "tldet_id": toolrequestdetails['tldet_id'],
        "tool_deposit_id": toolrequestdetails['tool_deposit_id'],
        "deposit_price": depositamount != 0 ? depositamount : 0,
        "tool_adv_payment": toolrequestdetails['tool_adv_payment'],
        "advance_price": advanceamount != 0 ? advanceamount : 0,
      };
      Map req = {
        "data": data,
      };
      await acceptorrejecttoolRequest(req).then((value) async {
        setState(() => isaccept = false);
        if (value['ret_data'] == "success") {
          Navigator.pushReplacementNamed(context, Routes.bottombar);
          Fluttertoast.showToast(
              msg: "Request Accepted",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: const Color.fromARGB(255, 86, 84, 84),
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          setState(() => isaccept = false);
        }
      });
    } catch (e) {
      setState(() => isaccept = false);
      print(e.toString());
      Fluttertoast.showToast(
          msg: "Application Error. Contact Support",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 86, 84, 84),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  rejectbottomsheet() async {
    showModalBottomSheet(
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (builder) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setBottomState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.6,
            minChildSize: 0.2,
            maxChildSize: 1,
            builder: (context, scrollController) {
              return Container(
                color: white,
                padding: EdgeInsets.symmetric(vertical: 16),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          margin: const EdgeInsets.all(8),
                          padding: EdgeInsets.all(8),
                          width: context.width() * 1.85,
                          decoration: BoxDecoration(
                            color: context.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: defaultBoxShadow(),
                          ),
                          duration: 1000.milliseconds,
                          curve: Curves.linearToEaseOut,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                child: Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(8),
                                      height: 950,
                                      decoration: BoxDecoration(
                                          color:
                                              context.scaffoldBackgroundColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Column(
                                        children: [
                                          8.height,
                                          Column(
                                            children: <Widget>[
                                              SizedBox(
                                                width: double.infinity,
                                                child: Container(
                                                  child: Text(
                                                    "Reject Reason*",
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          8.height,
                                          Padding(
                                            padding: EdgeInsets.all(2),
                                            child: Container(
                                              width: context.width() * 0.85,
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(16)),
                                                  color: white),
                                              child: TextField(
                                                  keyboardType: TextInputType
                                                      .streetAddress,
                                                  minLines: 1,
                                                  maxLines: 5,
                                                  maxLength: 80,
                                                  onChanged: (value) {
                                                    setBottomState(() {
                                                      reject = value;
                                                    });
                                                  },
                                                  focusNode: rejectFocus,
                                                  textCapitalization:
                                                      TextCapitalization
                                                          .sentences,
                                                  decoration: InputDecoration(
                                                      counterText: "",
                                                      hintText: "Enter Reason",
                                                      hintStyle:
                                                          primaryTextStyle(),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: black,
                                                                width: 0.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide:
                                                            const BorderSide(
                                                                color: black,
                                                                width: 0.5),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ))),
                                              alignment: Alignment.center,
                                            ),
                                          ),
                                          16.height,
                                          GestureDetector(
                                            onTap: () async {
                                              if (reject == "") {
                                                setBottomState(
                                                    () => issubmitted = false);
                                                Fluttertoast.showToast(
                                                    msg: "Enter Reason",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 86, 84, 84),
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);
                                              } else {
                                                try {
                                                  setBottomState(
                                                      () => issubmitted = true);
                                                  Map data = {
                                                    "tldet_id":
                                                        toolrequestdetails[
                                                            'tldet_id'],
                                                    "tool_id":
                                                        toolrequestdetails[
                                                            'tool_id'],
                                                    "tool_rent_quantity":
                                                        toolrequestdetails[
                                                            'tool_rent_quantity'],
                                                  };
                                                  Map req = {
                                                    "data": data,
                                                    "flag": 1,
                                                    "rejectreason": reject,
                                                  };
                                                  await acceptorrejecttoolRequest(
                                                          req)
                                                      .then((value) {
                                                    if (value['ret_data'] ==
                                                        "success") {
                                                      setBottomState((() {
                                                        Fluttertoast.showToast(
                                                          msg:
                                                              "Request rejected successfully",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  86,
                                                                  84,
                                                                  84),
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0,
                                                        );
                                                        Navigator
                                                            .pushReplacementNamed(
                                                                context,
                                                                Routes
                                                                    .bottombar);
                                                      }));
                                                    } else {
                                                      setBottomState(() =>
                                                          issubmitted = false);
                                                    }
                                                  });
                                                } catch (e) {
                                                  setState(() =>
                                                      issubmitted = false);
                                                  print(e.toString());
                                                }
                                                finish(context);
                                              }
                                            },
                                            child: Stack(
                                              alignment: Alignment.bottomCenter,
                                              children: [
                                                Container(
                                                  height: height * 0.075,
                                                  width: height * 0.4,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30)),
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        HexColor('#1d5ace'),
                                                        HexColor('#04b7f9'),
                                                      ],
                                                    ),
                                                  ),
                                                  child: !issubmitted
                                                      ? Text(
                                                          "SUBMIT",
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
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
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
            'Tool Request Details',
            style: boldTextStyle(color: white),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back,
                color: Colors.white, size: width * 0.054),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: context.width(),
                height: context.width() * 0.55,
                child: toolrequestdetails['tool_images'] != null
                    ? CachedNetworkImage(
                        placeholder: (context, url) => Transform.scale(
                          scale: 0.2,
                          child: CircularProgressIndicator(),
                        ),
                        imageUrl: dotenv.env['API_URL']! +
                            'public/' +
                            toolrequestdetails['tool_images'],
                        fit: BoxFit.fill,
                      )
                    : ClipRRect(
                        child: Image.asset(
                          ImageConst.rams_icon,
                          height: 60,
                          width: 60,
                          fit: BoxFit.fill,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
              ),
              SizedBox(height: 30),
              rejectreason != ""
                  ? Container(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Request Rejected",
                            style: boldTextStyle(size: 18, color: redColor),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              rejectreason != ""
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 2,
                            child: Text(
                              "Rejected Reason",
                              textAlign: TextAlign.start,
                              style: boldTextStyle(color: redColor),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              rejectreason,
                              textAlign: TextAlign.start,
                              style: primaryTextStyle(color: redColor),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
              rejectreason != "" ? Divider() : SizedBox(),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Customer Details",
                      style: boldTextStyle(size: 18),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Customer name",
                        textAlign: TextAlign.start,
                        style: boldTextStyle(),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        toolrequestdetails['cstm_name'] != null
                            ? ": " + toolrequestdetails['cstm_name']
                            : "",
                        textAlign: TextAlign.start,
                        style: primaryTextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Mobile Number",
                        textAlign: TextAlign.start,
                        style: boldTextStyle(),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        toolrequestdetails['cstm_phone'] != null
                            ? ": " + toolrequestdetails['cstm_phone']
                            : "",
                        textAlign: TextAlign.start,
                        style: primaryTextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Divider(),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Request Details",
                      style: boldTextStyle(size: 18),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Request Number",
                        textAlign: TextAlign.start,
                        style: boldTextStyle(),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        toolrequestdetails['tldt_number'] != null
                            ? ": " + toolrequestdetails['tldt_number']
                            : "",
                        textAlign: TextAlign.start,
                        style: primaryTextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Tool name",
                        textAlign: TextAlign.start,
                        style: boldTextStyle(),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        toolrequestdetails['tool_name'] != null
                            ? ": " + toolrequestdetails['tool_name']
                            : "",
                        textAlign: TextAlign.start,
                        style: primaryTextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              if (toolrequestdetails['tool_deposit_id'] == "1") ...[
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Required",
                          textAlign: TextAlign.start,
                          style: boldTextStyle(),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: toolrequestdetails['tool_deposit_price'] != null
                            ? Text(
                                ": Deposit Requires (" +
                                    toolrequestdetails['tool_deposit_price'] +
                                    "%)",
                                textAlign: TextAlign.start,
                                style: boldTextStyle(),
                              )
                            : Text(
                                ": Deposit Requires (0%)",
                                textAlign: TextAlign.start,
                                style: primaryTextStyle(),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
              if (toolrequestdetails['tool_adv_payment'] == "1") ...[
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Required",
                          textAlign: TextAlign.start,
                          style: boldTextStyle(),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: toolrequestdetails['tool_adv_price'] != null
                            ? Text(
                                ": Advance Payment (" +
                                    toolrequestdetails['tool_adv_price'] +
                                    "%)",
                                textAlign: TextAlign.start,
                                style: boldTextStyle(),
                              )
                            : Text(
                                ": Advance Payment (₹0)",
                                textAlign: TextAlign.start,
                                style: primaryTextStyle(),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Tool Description",
                        textAlign: TextAlign.start,
                        style: boldTextStyle(),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        toolrequestdetails['tool_description'] != null
                            ? ": " + toolrequestdetails['tool_description']
                            : "",
                        textAlign: TextAlign.justify,
                        style: primaryTextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),

              Divider(),
              Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Payment Details",
                      style: boldTextStyle(size: 18),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Rent Cost",
                        textAlign: TextAlign.start,
                        style: boldTextStyle(),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        toolrequestdetails['tool_rent_cost'] != null
                            ? ": ₹" + toolrequestdetails['tool_rent_cost']
                            : "",
                        textAlign: TextAlign.justify,
                        style: primaryTextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Quantity Requested",
                        textAlign: TextAlign.start,
                        style: boldTextStyle(),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        toolrequestdetails['tldt_tool_quant'] != null
                            ? ": " + toolrequestdetails['tldt_tool_quant']
                            : "",
                        textAlign: TextAlign.justify,
                        style: primaryTextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Rent Days",
                        textAlign: TextAlign.start,
                        style: boldTextStyle(),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        toolrequestdetails['tldt_tool_duration'] != null
                            ? ": " + toolrequestdetails['tldt_tool_duration']
                            : "",
                        textAlign: TextAlign.justify,
                        style: primaryTextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
              //   child: Row(
              //     children: <Widget>[
              //       Expanded(
              //         flex: 2,
              //         child: Text(
              //           "Discount",
              //           textAlign: TextAlign.start,
              //           style: boldTextStyle(),
              //         ),
              //       ),
              //       Expanded(
              //         flex: 3,
              //         child: Text(
              //           toolrequestdetails['tool_rent_quantity'] != null
              //               ? ": " + toolrequestdetails['tool_rent_quantity']
              //               : "",
              //           textAlign: TextAlign.justify,
              //           style: primaryTextStyle(),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Total Rent Cost",
                        textAlign: TextAlign.start,
                        style: boldTextStyle(),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        toolrequestdetails['tldt_cost'] != null
                            ? ": ₹" + toolrequestdetails['tldt_cost']
                            : "",
                        textAlign: TextAlign.justify,
                        style: primaryTextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
              if (toolrequestdetails['tool_deposit_id'] == "1") ...[
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Deposit Amount",
                          textAlign: TextAlign.start,
                          style: boldTextStyle(),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          ": ₹" + depositamount.toStringAsFixed(2),
                          textAlign: TextAlign.justify,
                          style: primaryTextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (toolrequestdetails['tool_adv_payment'] == "1") ...[
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Advance Amount",
                          textAlign: TextAlign.start,
                          style: boldTextStyle(),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          ": ₹" + advanceamount.toStringAsFixed(2),
                          textAlign: TextAlign.justify,
                          style: primaryTextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              Divider(),
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Grand Total",
                        textAlign: TextAlign.start,
                        style: boldTextStyle(),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        toolrequestdetails['tldt_cost'] != null
                            ? ": ₹" + toolrequestdetails['tldt_cost']
                            : "",
                        textAlign: TextAlign.justify,
                        style: primaryTextStyle(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              toolrequestdetails['sm_code'] == "TRP"
                  ? Center(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                rejectbottomsheet();
                              },
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 16, right: 16),
                                    height: height * 0.065,
                                    width: height * 0.325,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(color: redColor),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.red,
                                          Colors.red,
                                        ],
                                      ),
                                    ),
                                    child: Text(
                                      "REJECT",
                                      style: boldTextStyle(color: white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                acceptClick();
                                setState(() {
                                  isaccept = true;
                                });
                              },
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Container(
                                    margin:
                                        EdgeInsets.only(left: 16, right: 16),
                                    height: height * 0.065,
                                    width: height * 0.325,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.green,
                                          Colors.green,
                                        ],
                                      ),
                                    ),
                                    child: !isaccept
                                        ? Text(
                                            "ACCEPT",
                                            style: boldTextStyle(color: white),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                        ],
                      ),
                    )
                  : SizedBox(),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
