import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:launch_review/launch_review.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Backend/base_client.dart';
import '../BottomNavBar/bottomNavBar_screen.dart';
import '../Forgot_Password/forgotPass_screen.dart';
import '../Sign_Up/emailPhone_screen.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool showvalue = false;
  bool _isObscureCp = true;
  final GlobalKey<FormState> _form = GlobalKey();
  TextEditingController phoneNumbController = TextEditingController(
      // text: "+92",
      );
  TextEditingController passwordController = TextEditingController();
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';

  @override
  Widget build(BuildContext context) {
    RegExp regExp = RegExp(pattern);
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
            ),
            Image.asset(
              'images/logo.png',
              width: 300,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Form(
              key: _form,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Material(
                      elevation: 5.0,
                      shadowColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      child: TextFormField(
                        controller: phoneNumbController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          labelText: 'Enter your phone number',
                          suffixIcon: Icon(
                            Icons.phone,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Please enter phone number";
                          } else if (value.length != 10) {
                            return "Please enter valid phone number";
                          }
                          // else if (!regExp.hasMatch(value)) {
                          //   return "Please enter valid phone number";
                          // }

                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Material(
                      elevation: 5.0,
                      shadowColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: _isObscureCp,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.all(10),
                          border: InputBorder.none,
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscureCp
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              if (mounted) {
                                setState(() {
                                  _isObscureCp = !_isObscureCp;
                                });
                              }
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Please enter password";
                          }

                          return null;
                        },
                        onChanged: (value) {
                          if (mounted) {
                            setState(() {
                              // email = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: [
                            Checkbox(
                              value: showvalue,
                              onChanged: (value) {
                                if (mounted) {
                                  setState(() {
                                    showvalue = value!;
                                  });
                                }
                              },
                            ),
                            const Text(
                              "Remember me",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(right: 30),
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                child: const ForgotPassword(),
                              ),
                            );
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              alignment: Alignment.center,
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () async {
                      SharedPreferences localStorage =
                          await SharedPreferences.getInstance();
                      await localStorage.clear();
                      if (!(_form.currentState?.validate() ?? true)) {
                        return;
                      }
                      var response = await BaseClient().login(
                        "/login",
                        "+1${phoneNumbController.text}",
                        passwordController.text,
                        "customer",
                      );
                      print('res of login $response');
                      if (response["success"]) {
                        Map<String, dynamic> user = response["data"]["user"];
                        Map<String, dynamic> wallet =
                            response["data"]["wallet"];
                        List<dynamic> cards = response["data"]["cards"];
                        await localStorage.setString(
                          'referLink',
                          response["data"]["user"]["referral_link"],
                        );
                        await localStorage.setString(
                          'token',
                          response["data"]["token"]["plainTextToken"],
                        );
                        await localStorage.setString('user', jsonEncode(user));
                        await localStorage.setString(
                          'wallet',
                          jsonEncode(wallet),
                        );
                        await localStorage.setString(
                          'cards',
                          jsonEncode(cards),
                        );
                        await localStorage.setString(
                          'autoRefillLimit',
                          response["data"]["autoRefillLimit"],
                        );
                        await localStorage.setString(
                          'address',
                          response["data"]["user"]["address"],
                        );
                        await localStorage.setDouble(
                          'lat',
                          double.parse(response["data"]["user"]["lat"]),
                        );
                        await localStorage.setDouble(
                          'lng',
                          double.parse(response["data"]["user"]["lng"]),
                        );
                        await EasyLoading.dismiss();
                        if (mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              child: BottomNavBar(
                                addressNaved: "",
                                index: null,
                                latNaved: 0.00,
                                longNaved: 0.00,
                                addNotNull: false,
                              ),
                            ),
                            (route) => false,
                          );
                        }
                      } else {
                        await EasyLoading.dismiss();
                        final snackBar = SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'Alert!',
                            message: '${response["message"]}',
                            contentType: ContentType.failure,
                          ),
                        );
                        if (mounted) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        }
                      }
                    },
                    child: const Text('LOG IN'),
                  ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.white,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     minimumSize: const Size.fromHeight(50),
                  //   ),
                  //   onPressed: () {},
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       Image.asset(
                  //         "images/google.png",
                  //         height: 25,
                  //       ),
                  //       const SizedBox(
                  //         width: 10,
                  //       ),
                  //       const Text(
                  //         'Sign in with Google',
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.white,
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     minimumSize: const Size.fromHeight(50),
                  //   ),
                  //   onPressed: () {},
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       Image.asset(
                  //         "images/apple.png",
                  //         height: 25,
                  //       ),
                  //       const SizedBox(
                  //         width: 10,
                  //       ),
                  //       const Text(
                  //         'Sign in with Google',
                  //         style: TextStyle(
                  //           color: Colors.black,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 12),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              child: const EmailPhone(),
                            ),
                          );
                        },
                        child: const Text(
                          "  Register here",
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Looking for work? Download",
                        style: TextStyle(fontSize: 13),
                      ),
                      InkWell(
                        onTap: () {
                          LaunchReview.launch(
                            writeReview: false,
                            // androidAppId: "com.mowingandplowing.vendorapp",
                            iOSAppId: "6446679201",
                          );
                        },
                        child: const Text(
                          "  Provider app",
                          style: TextStyle(fontSize: 13, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Data {
  final int? id;
  final String? first_name;
  final String? last_name;
  final String? email;
  final String? new_email;
  final String? unverified_email;
  final String? referral_link;
  final String? image;
  final String? phone_number;
  final String? new_phone_number;
  final String? type;
  final String? lat;
  final String? lng;
  final String? zip_code;
  final String? customer_id;
  final String? status;

  Data({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.new_email,
    required this.unverified_email,
    required this.referral_link,
    required this.image,
    required this.phone_number,
    required this.new_phone_number,
    required this.type,
    required this.lat,
    required this.lng,
    required this.zip_code,
    required this.customer_id,
    required this.status,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      new_email: json['new_email'],
      unverified_email: json['unverified_email'],
      referral_link: json['referral_link'],
      image: json['image'],
      phone_number: json['phone_number'],
      new_phone_number: json['new_phone_number'],
      type: json['type'],
      lat: json['lat'],
      lng: json['lng'],
      zip_code: json['zip_code'],
      customer_id: json['customer_id'],
      status: json['status'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "first_name": first_name,
      "last_name": last_name,
      "email": email,
      "new_email": new_email,
      "unverified_email": unverified_email,
      "referral_link": referral_link,
      "image": image,
      "phone_number": phone_number,
      "new_phone_number": new_phone_number,
      "type": type,
      "lat": lat,
      "lng": lng,
      "zip_code": zip_code,
      "customer_id": customer_id,
      "status": status,
    };
  }
}
