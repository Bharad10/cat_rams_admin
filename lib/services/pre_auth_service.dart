import 'package:cat_rams_admin/services/network_service.dart';

Future customerLoginService(Map req) async {
  return handleResponse(await postRequest("send_signin_otp", req));
}
