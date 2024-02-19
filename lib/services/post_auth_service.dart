import 'dart:convert';

import 'package:cat_rams_admin/services/network_service.dart';
import 'package:nb_utils/nb_utils.dart';

Future adminLogin(Map req) async {
  return handleResponse(await securedPostRequest("admin_login", req));
}

Future getAllToolRequestList() async {
  return handleResponse(
      await securedGetRequest('ToolRequest/ToolRequestMasterController'));
}

Future getAllServiceRequestList() async {
  return handleResponse(await securedGetRequest('serv_hist'));
}

Future getServiceRequestDetails(req) async {
  return handleResponse(await securedGetRequest(
      'ServiceRequest/ServiceRequestMasterController/' +
          base64.encode(utf8.encode(req))));
}

Future getprofiledetails() async {
  final prefs = await SharedPreferences.getInstance();
  return handleResponse(await securedGetRequest('System/UserMasterController/' +
      base64.encode(utf8.encode(prefs.getString("us_id").toString()))));
}

Future acceptserviceRequest(Map req) async {
  return handleResponse(await securedPostRequest("accept_request", req));
}

Future rejectserviceRequest(Map req) async {
  return handleResponse(await securedPostRequest("reject_request", req));
}

Future getToolRequestDetails(req) async {
  return handleResponse(await securedGetRequest(
      "ToolRequest/ToolRequestMasterController/" +
          base64.encode(utf8.encode(req))));
}

Future acceptorrejecttoolRequest(Map req) async {
  return handleResponse(await securedPostRequest("tool_req_accept", req));
}

Future adminProfileUpdate(Map req) async {
  return handleResponse(await securedPostRequest('update_admin', req));
}
