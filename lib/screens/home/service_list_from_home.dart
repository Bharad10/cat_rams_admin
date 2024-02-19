import 'package:cat_rams_admin/constant/constant.dart';
import 'package:cat_rams_admin/constant/image_const.dart';
import 'package:cat_rams_admin/model/model.dart';
import 'package:cat_rams_admin/screens/service/service_list_details.dart';
import 'package:cat_rams_admin/services/post_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class ServiceListFromHome extends StatefulWidget {
  const ServiceListFromHome({super.key});

  @override
  State<ServiceListFromHome> createState() => ServiceListFromHomeState();
}

class ServiceListFromHomeState extends State<ServiceListFromHome> {
  late List<ServiceListModel> servicerequestpendinglist = [];
  late List<ServiceListModel> servicerequesttcompletedlist = [];
  bool isActive = true;
  @override
  void initState() {
    super.initState();
    init();
    Future.delayed(Duration.zero, () {
      _getservicerequestList();
    });
  }

  _getservicerequestList() async {
    servicerequestpendinglist = [];
    servicerequesttcompletedlist = [];
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
            } else {
              servicerequesttcompletedlist.add(servicerqsttemp);
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
      _getservicerequestList();
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
                "Service List",
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
                  child: servicerequestpendinglist.length > 0
                      ? RefreshIndicator(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: servicerequestpendinglist.length,
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
                                                          ClipRRect(
                                                            child: Image.asset(
                                                              servicerequestpendinglist[
                                                                              index]
                                                                          .servicerqst_make_name ==
                                                                      'Mercedes Benz'
                                                                  ? ImageConst
                                                                      .BENZ
                                                                  : servicerequestpendinglist[index]
                                                                              .servicerqst_make_name ==
                                                                          'BMW'
                                                                      ? ImageConst
                                                                          .BMW
                                                                      : servicerequestpendinglist[index].servicerqst_make_name ==
                                                                              'Skoda'
                                                                          ? ImageConst
                                                                              .SKODA
                                                                          : servicerequestpendinglist[index].servicerqst_make_name == 'Audi'
                                                                              ? ImageConst.AUDI
                                                                              : servicerequestpendinglist[index].servicerqst_make_name == 'Porsche'
                                                                                  ? ImageConst.PORSCHE
                                                                                  : servicerequestpendinglist[index].servicerqst_make_name == 'Volkswagen'
                                                                                      ? ImageConst.VOLKSWAGEN
                                                                                      : servicerequestpendinglist[index].servicerqst_make_name == 'Jaguar'
                                                                                          ? ImageConst.JAGUAR
                                                                                          : servicerequestpendinglist[index].servicerqst_make_name == 'Landrover'
                                                                                              ? ImageConst.LANDROVER
                                                                                              : ImageConst.rams_icon,
                                                              height: 60,
                                                              width: 60,
                                                              fit: BoxFit.cover,
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
                                                                        servicerequestpendinglist[index].servicerqst_number !=
                                                                                null
                                                                            ? servicerequestpendinglist[index].servicerqst_number
                                                                            : "",
                                                                        style:
                                                                            boldTextStyle(),
                                                                      ),
                                                                      Text(
                                                                        servicerequestpendinglist[index].servicerqst_date !=
                                                                                null
                                                                            ? DateFormat('dd-MM-yyyy').format(DateTime.tryParse(servicerequestpendinglist[index].servicerqst_date)!)
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
                                                                    servicerequestpendinglist[index].servicerqst_make_name !=
                                                                            null
                                                                        ? servicerequestpendinglist[index].servicerqst_variant_name !=
                                                                                null
                                                                            ? servicerequestpendinglist[index].servicerqst_make_name +
                                                                                " " +
                                                                                servicerequestpendinglist[index].servicerqst_model_name +
                                                                                " " +
                                                                                servicerequestpendinglist[index].servicerqst_variant_name
                                                                            : ": " + servicerequestpendinglist[index].servicerqst_make_name + " " + servicerequestpendinglist[index].servicerqst_model_name
                                                                        : "",
                                                                    style: primaryTextStyle(
                                                                        size:
                                                                            14),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  Text(
                                                                    servicerequestpendinglist[index].servicerqst_vinnumber !=
                                                                            null
                                                                        ? servicerequestpendinglist[index]
                                                                            .servicerqst_vinnumber
                                                                        : "",
                                                                    style: primaryTextStyle(
                                                                        size:
                                                                            14),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 4,
                                                                  ),
                                                                  Text(
                                                                    servicerequestpendinglist[index].servicerqst_sm_name !=
                                                                            null
                                                                        ? servicerequestpendinglist[index]
                                                                            .servicerqst_sm_name
                                                                        : "",
                                                                    style: primaryTextStyle(
                                                                        color: Colors
                                                                            .blue,
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
                                                                  builder:
                                                                      (context) =>
                                                                          ServiceDetailsPage(
                                                                            servicerqstid:
                                                                                servicerequestpendinglist[index].servicerqst_id,
                                                                            make:
                                                                                servicerequestpendinglist[index].servicerqst_make_name,
                                                                            vehname: servicerequestpendinglist[index].servicerqst_make_name +
                                                                                servicerequestpendinglist[index].servicerqst_model_name +
                                                                                servicerequestpendinglist[index].servicerqst_variant_name,
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
                                        ImageConst.no_service,
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
                                              child: Text("NO SERVICE REQUEST",
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
