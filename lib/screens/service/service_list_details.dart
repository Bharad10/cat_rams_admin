import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cat_rams_admin/constant/constant.dart';
import 'package:cat_rams_admin/constant/image_const.dart';
import 'package:cat_rams_admin/main.dart';
import 'package:cat_rams_admin/model/model.dart';
import 'package:cat_rams_admin/screens/service/attchment_zoom_screen.dart';
import 'package:cat_rams_admin/screens/service/audiofile.dart';
import 'package:cat_rams_admin/services/post_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceDetailsPage extends StatefulWidget {
  final String servicerqstid;
  final String make;
  final String vehname;
  const ServiceDetailsPage(
      {required this.servicerqstid,
      required this.make,
      required this.vehname,
      super.key});

  @override
  State<ServiceDetailsPage> createState() => ServiceDetailsPageState();
}

class ServiceDetailsPageState extends State<ServiceDetailsPage> {
  late Map<String, dynamic> servicerequestdetails = {};
  List<AttachmentModel> list = [];
  List<String> imageUrls = [];
  bool isaccept = false;
  bool issubmitted = false;
  final _formKey = GlobalKey<FormState>();
  FocusNode rejectFocus = FocusNode();
  var reject = "";
  var packdataaudio;

  @override
  void initState() {
    print("==============>");
    print(base64.encode(utf8.encode(widget.servicerqstid)));
    print(widget.servicerqstid);
    super.initState();
    Future.delayed(Duration.zero, () {
      init();
      CustomerServiceRequestDetails();
    });
  }

  CustomerServiceRequestDetails() async {
    try {
      await getServiceRequestDetails(widget.servicerqstid).then((value) async {
        if (value['ret_data'] == "success") {
          servicerequestdetails = value['result'];
          for (var val in value['medias']) {
            if (val["smedia_type"] == "0") {
              setState(() {
                imageUrls.add(val["smedia_url"]);
              });
            } else if (val["smedia_type"] == "1") {
              setState(() {
                packdataaudio = val["smedia_url"];
              });
            }
          }
          setState(() {
            list = imageUrls
                .map((imageUrl) => AttachmentModel(image: imageUrl))
                .toList();
          });
        }
      });
    } catch (e) {
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
      Map req = {"serm_id": widget.servicerqstid};
      print("..............");
      print(req);
      await acceptserviceRequest(req).then((value) async {
        setState(() => isaccept = false);
        print("*********");
        print(value);
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
                                                  Map req = {
                                                    "serm_id": base64.encode(
                                                        utf8.encode(widget
                                                            .servicerqstid)),
                                                    "reason": reject,
                                                  };
                                                  print("===========");
                                                  print(req);
                                                  await rejectserviceRequest(
                                                          req)
                                                      .then((value) {
                                                    print("++++++++++++");
                                                    print(value);
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

  Future<void> init() async {}

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
            'Service Request Details',
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
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                      margin: EdgeInsets.all(12.0),
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.transparent,
                            blurRadius: 0.1,
                            spreadRadius: 0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.40)),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.only(left: 0, right: 16),
                              width: width * 0.2,
                              child: (() {
                                if (widget.make == 'Mercedes Benz') {
                                  return Image.asset(
                                    ImageConst.BENZ,
                                    width: width * 0.12,
                                  );
                                } else if (widget.make == 'BMW') {
                                  return Image.asset(
                                    ImageConst.BMW,
                                    width: width * 0.12,
                                  );
                                } else if (widget.make == 'Skoda') {
                                  return Image.asset(
                                    ImageConst.SKODA,
                                    width: width * 0.12,
                                  );
                                } else if (widget.make == 'Audi') {
                                  return Image.asset(
                                    ImageConst.AUDI,
                                    width: width * 0.12,
                                  );
                                } else if (widget.make == 'Porsche') {
                                  return Image.asset(
                                    ImageConst.PORSCHE,
                                    width: width * 0.12,
                                  );
                                } else if (widget.make == 'Volkswagen') {
                                  return Image.asset(
                                    ImageConst.VOLKSWAGEN,
                                    width: width * 0.12,
                                  );
                                } else if (widget.make == 'Jaguar') {
                                  return Image.asset(
                                    ImageConst.JAGUAR,
                                    width: width * 0.12,
                                  );
                                } else if (widget.make == 'Landrover') {
                                  return Image.asset(
                                    ImageConst.LANDROVER,
                                    width: width * 0.12,
                                  );
                                } else {
                                  return Image.asset(
                                    ImageConst.rams_icon,
                                    width: width * 0.12,
                                  );
                                }
                              })(),
                              padding: EdgeInsets.all(width / 30),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Flexible(
                                            child: Container(
                                              child: Text(
                                                servicerequestdetails[
                                                            'serm_number'] !=
                                                        null
                                                    ? servicerequestdetails[
                                                        'serm_number']
                                                    : "",
                                                overflow: TextOverflow.clip,
                                                style: boldTextStyle(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Flexible(
                                            child: Container(
                                              child: Text(
                                                servicerequestdetails[
                                                            'custveh_created_on'] !=
                                                        null
                                                    ? DateFormat('dd-MM-yyyy')
                                                        .format(DateTime.tryParse(
                                                            servicerequestdetails[
                                                                'custveh_created_on'])!)
                                                    : "",
                                                overflow: TextOverflow.clip,
                                                style:
                                                    primaryTextStyle(size: 12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                4.height,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Container(
                                        child: Text(
                                          servicerequestdetails[
                                                      'custveh_vinnumber'] !=
                                                  null
                                              ? servicerequestdetails[
                                                  'custveh_vinnumber']
                                              : "",
                                          overflow: TextOverflow.clip,
                                          style: primaryTextStyle(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                4.height,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Container(
                                        child: Text(
                                          widget.vehname,
                                          overflow: TextOverflow.clip,
                                          style: primaryTextStyle(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                4.height,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: Container(
                                        child: Text(
                                          servicerequestdetails['sm_name'] !=
                                                  null
                                              ? servicerequestdetails['sm_name']
                                              : "",
                                          style: primaryTextStyle(
                                              color: servicerequestdetails[
                                                          'sm_code'] ==
                                                      'SRR'
                                                  ? Colors.red
                                                  : Colors.blue,
                                              size: 14),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              servicerequestdetails['sm_code'] == "SRR"
                  ? Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Text('Reject Reason',
                                style: boldTextStyle(color: redColor)),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
              servicerequestdetails['sm_code'] == "SRR"
                  ? SizedBox(
                      height: 4,
                    )
                  : SizedBox(),
              servicerequestdetails['sm_code'] == "SRR"
                  ? Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Text(
                                servicerequestdetails['qtm_rejected_reason'] !=
                                            "" ||
                                        servicerequestdetails[
                                                'qtm_rejected_reason'] !=
                                            null
                                    ? servicerequestdetails[
                                        'qtm_rejected_reason']
                                    : "No Reason Recorded",
                                style: primaryTextStyle()),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text('Customer Complaint', style: boldTextStyle()),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 12.0),
                      child: Container(
                        child: Text(
                          servicerequestdetails['serm_complaint'] != null
                              ? servicerequestdetails['serm_complaint']
                              : "No Complaint Recorded",
                          style: primaryTextStyle(),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text('Recordings', style: boldTextStyle()),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              packdataaudio != null
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black45),
                              borderRadius: BorderRadius.circular(10)),
                          child: AudioPlayerUI(audio: packdataaudio)),
                    )
                  : Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Text('No Recordings',
                                style: primaryTextStyle()),
                          ),
                        ),
                      ],
                    ),
              SizedBox(
                height: 4,
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      child: Text('Attachment', style: boldTextStyle()),
                    ),
                  ),
                ],
              ),
              list.length.toString() != 0
                  ? Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: list.map(
                        (e) {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: CachedNetworkImage(
                                  imageUrl: dotenv.env['API_URL']! +
                                      'public/' +
                                      e.image.toString(),
                                  fit: BoxFit.cover,
                                  height: 170,
                                  width: context.width() * 0.5 - 24,
                                ),
                              ),
                              Container(
                                height: 170,
                                width: context.width() * 0.5 - 24,
                                decoration: boxDecorationWithRoundedCorners(
                                  borderRadius: BorderRadius.circular(16),
                                  backgroundColor: Colors.black26,
                                ),
                              ),
                            ],
                          ).onTap(() {
                            AttachmentZoomingScreen(img: e.image)
                                .launch(context);
                          }, highlightColor: white, splashColor: white);
                        },
                      ).toList(),
                    ).paddingAll(16)
                  : Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Text('No Attachments Uploaded',
                                style: primaryTextStyle()),
                          ),
                        ),
                      ],
                    ),
              SizedBox(
                height: 16,
              ),
              servicerequestdetails['sm_code'] == "QP"
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
            ],
          ),
        ),
      ),
    );
  }
}
