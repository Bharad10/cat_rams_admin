import 'package:cat_rams_admin/constant/constant.dart';
import 'package:cat_rams_admin/screens/bottom_bar/bottomtab.dart';
import 'package:cat_rams_admin/services/post_auth_service.dart';
import 'package:cat_rams_admin/utils/app_validator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => EditProfileState();
}

class EditProfileState extends State<EditProfile> {
  bool isUpdating = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController DOJController = TextEditingController();
  TextEditingController userroleController = TextEditingController();

  FocusNode fullNameFocusNode = FocusNode();
  FocusNode mobileFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();

  late Map<String, dynamic> custdetails = {};

  @override
  void initState() {
    super.initState();
    init();
    getAdminProfileDetails();
  }

  Future<void> init() async {}

  getAdminProfileDetails() async {
    await getprofiledetails()
        .then((value) => {
              print(value),
              if (value['ret_data'] == "success")
                {
                  setState(() {
                    custdetails = value['us_details'];
                    fullNameController.text =
                        custdetails['us_firstname'] != null
                            ? custdetails['us_firstname']
                            : "";
                    mobileController.text = custdetails['us_phone'] != null
                        ? custdetails['us_phone']
                        : "";
                    emailController.text = custdetails['us_email'] != null
                        ? custdetails['us_email']
                        : "";
                    DOJController.text =
                        custdetails['us_date_of_joining'] != null
                            ? DateFormat('dd-MM-yyyy').format(DateTime.tryParse(
                                custdetails['us_date_of_joining'])!)
                            : "";
                    userroleController.text = custdetails['us_role_id'] != null
                        ? custdetails['us_role_id'] == "1"
                            ? "ADMIN"
                            : "User"
                        : "";
                  })
                }
            })
        .catchError((e) {});
  }

  UpdateProfile() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      Map user_data = {
        "dateofjoining": custdetails['us_date_of_joining'],
        "email": emailController.text.toString(),
        "mobilenumber": mobileController.text.toString(),
        "username": fullNameController.text.toString(),
        "userrole": custdetails['us_role_id']
      };
      Map req = {"us_id": prefs.getString("us_id"), "user_data": user_data};
      print("==============");
      print(req);
      await adminProfileUpdate(req).then((value) async {
        if (value['ret_data'] == "success") {
          Fluttertoast.showToast(
              msg: "Profile Details Updated",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BottomNavBarScreen(
                index: 4,
              ),
            ),
            (route) => false,
          );
        } else {
          setState(() => isUpdating = false);
        }
      });
    } catch (e) {
      setState(() => isUpdating = false);
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
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
              "Edit Profile",
              style: boldTextStyle(color: white),
            ),
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
            )),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Full Name*",
                    style: boldTextStyle(size: 14),
                    textAlign: TextAlign.left,
                  ),
                  8.height,
                  AppTextField(
                    decoration: ramsInputDecoration(
                        hint: 'Enter Full Name', prefixIcon: Icons.person),
                    textFieldType: TextFieldType.NAME,
                    keyboardType: TextInputType.text,
                    controller: fullNameController,
                    focus: fullNameFocusNode,
                    nextFocus: mobileFocusNode,
                    validator: (value) {
                      return fullNameValidation(value, context);
                    },
                  ),
                  SizedBox(height: 15),
                  Text("Mobile Number*", style: boldTextStyle(size: 14)),
                  8.height,
                  AppTextField(
                    decoration: ramsInputDecoration(
                      hint: 'Enter Mobile',
                      prefixIcon: Icons.phone,
                      readOnly: false,
                    ),
                    textFieldType: TextFieldType.NUMBER,
                    keyboardType: TextInputType.number,
                    controller: mobileController,
                    focus: mobileFocusNode,
                    nextFocus: emailFocusNode,
                    readOnly: false,
                    validator: (value) {
                      return mobileNumberValidation(value, context);
                    },
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Email Id*",
                    style: boldTextStyle(size: 14),
                  ),
                  8.height,
                  AppTextField(
                    decoration: ramsInputDecoration(
                        hint: 'Enter Email Id',
                        prefixIcon: Icons.email_outlined),
                    textFieldType: TextFieldType.EMAIL,
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    focus: emailFocusNode,
                    validator: (value) {
                      return emailValidation(value, context);
                    },
                  ),
                  SizedBox(height: 15),
                  Text(
                    "User Role",
                    style: boldTextStyle(size: 14),
                  ),
                  8.height,
                  AppTextField(
                    decoration: ramsInputDecoration(
                      hint: 'User Role',
                      prefixIcon: Icons.person,
                      readOnly: true,
                    ),
                    textFieldType: TextFieldType.NAME,
                    keyboardType: TextInputType.text,
                    controller: userroleController,
                    readOnly: true,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Date of Joining",
                    style: boldTextStyle(size: 14),
                  ),
                  8.height,
                  AppTextField(
                    decoration: ramsInputDecoration(
                      hint: 'Date of Joining',
                      prefixIcon: Icons.calendar_today_rounded,
                      readOnly: true,
                    ),
                    textFieldType: TextFieldType.NAME,
                    keyboardType: TextInputType.text,
                    controller: DOJController,
                    readOnly: true,
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          UpdateProfile();
                        }
                      },
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
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
                                  HexColor('#1d5ace'),
                                  HexColor('#04b7f9'),
                                ],
                              ),
                            ),
                            child: !isUpdating
                                ? Text(
                                    "UPDATE",
                                    style: boldTextStyle(color: white),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Transform.scale(
                                        scale: 0.7,
                                        child: CircularProgressIndicator(
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
                  SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
