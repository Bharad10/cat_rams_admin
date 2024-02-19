import 'package:flutter/material.dart';

class ToolListModel {
  var toolrqst_id;
  var toolrqst_number;
  var toolrqst_image;
  var toolrqst_tool_name;
  var toolrqst_sm_name;
  var toolrqst_date;
  var sm_code;

  ToolListModel(
      {this.toolrqst_id,
      this.toolrqst_number,
      this.toolrqst_image,
      this.toolrqst_tool_name,
      this.toolrqst_sm_name,
      this.toolrqst_date,
      this.sm_code});
}

class ServiceListModel {
  var servicerqst_id;
  var servicerqst_number;
  var servicerqst_make_name;
  var servicerqst_model_name;
  var servicerqst_variant_name;
  var servicerqst_vinnumber;
  var servicerqst_sm_name;
  var servicerqst_date;
  var sm_code;
  ServiceListModel(
      {this.servicerqst_id,
      this.servicerqst_number,
      this.servicerqst_make_name,
      this.servicerqst_model_name,
      this.servicerqst_variant_name,
      this.servicerqst_vinnumber,
      this.servicerqst_sm_name,
      this.servicerqst_date,
      this.sm_code});
}

class RAMSProfileCardData {
  String? img;
  String? name;
  Color? color;

  RAMSProfileCardData({this.img, this.name, this.color});
}

class MediaItem {
  final String url;
  final String type;
  final String additionaltype;

  MediaItem(
      {required this.url, required this.type, required this.additionaltype});
}

class AttachmentModel {
  String? image;
  Widget? widget;

  AttachmentModel({
    this.image,
    this.widget,
  });
}
