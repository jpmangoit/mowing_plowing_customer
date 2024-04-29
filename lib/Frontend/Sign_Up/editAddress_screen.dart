import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Backend/base_client.dart';
import '../BottomNavBar/bottomNavBar_screen.dart';
import '../Login/logIn_screen.dart';
import 'searchAddress_screen.dart';

class EditAddress extends StatefulWidget {
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String password;
  final String confirmPassword;
  final String? referralLink;
  final File? image;
  final String? address;
  final double? latNaved;
  final double? longNaved;
  const EditAddress({
    super.key,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.confirmPassword,
    required this.referralLink,
    required this.image,
    required this.address,
    required this.latNaved,
    required this.longNaved,
  });

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  bool agree = false;
  Color termPolicies = Colors.blue;
  Color checkText = Colors.black;
  TextEditingController zipCodeController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey();
  bool error = false;
  bool error2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
            ),
            Image.asset(
              'images/logo.png',
              width: 300,
            ),
            const SizedBox(
              height: 60,
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "Edit Address",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _form,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text("Select your address from the search"),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Visibility(
                    visible: error,
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Please provide your address",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Material(
                      elevation: 5.0,
                      shadowColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          showMaterialModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            // expand: true,
                            context: context,
                            backgroundColor: Colors.white,
                            builder: (context) => SingleChildScrollView(
                              controller: ModalScrollController.of(context),
                              child: SearchAddress(
                                phoneNumber: widget.phoneNumber,
                                firstName: widget.firstName,
                                lastName: widget.lastName,
                                password: widget.password,
                                confirmPassword: widget.confirmPassword,
                                referralLink: widget.referralLink,
                                image: widget.image,
                              ),
                            ),
                          );
                        },
                        child: TextFormField(
                          enabled: false,
                          initialValue: widget.address ?? 'Search your address',
                          decoration: const InputDecoration(
                            // isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(15, 13, 0, 0),
                            border: InputBorder.none,
                            suffixIcon: Icon(
                              Icons.search,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: error2,
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Please provide zip code",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Material(
                      elevation: 5.0,
                      shadowColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      child: TextFormField(
                        controller: zipCodeController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          labelText: 'Zip Code',
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Please enter zip code";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 5),
                    child: Row(
                      children: [
                        Checkbox(
                          value: agree,
                          onChanged: (value) {
                            if (mounted) {
                              setState(() {
                                agree = value!;
                              });
                            }
                          },
                        ),
                        Text(
                          "I agree with ",
                          style: TextStyle(fontSize: 11, color: checkText),
                        ),
                        Text(
                          "Terms & Condition ",
                          style: TextStyle(fontSize: 12, color: termPolicies),
                        ),
                        Text(
                          "and ",
                          style: TextStyle(fontSize: 11, color: checkText),
                        ),
                        Text(
                          "Privacy policies.",
                          style: TextStyle(fontSize: 12, color: termPolicies),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 80,
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
                      if (widget.address == null) {
                        if (mounted) {
                          setState(() {
                            error = true;
                          });
                        }
                        return;
                      } else if (zipCodeController.text == "") {
                        if (mounted) {
                          setState(() {
                            error2 = true;
                          });
                        }
                        return;
                      } else if (!agree) {
                        if (mounted) {
                          setState(() {
                            checkText = Colors.red;
                            termPolicies = Colors.red;
                          });
                        }
                        return;
                      } else if (agree) {
                        if (mounted) {
                          setState(() {
                            checkText = Colors.black;
                            termPolicies = Colors.blue;
                          });
                        }
                      }
                      var response = await BaseClient().addProfileDetail(
                        "/signup",
                        "+1${widget.phoneNumber}",
                        widget.firstName,
                        widget.lastName,
                        widget.password,
                        widget.confirmPassword,
                        widget.referralLink,
                        widget.image,
                        widget.address!,
                        widget.latNaved.toString(),
                        widget.longNaved.toString(),
                        zipCodeController.text,
                      );
                      //
                      print('res$response');
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
                        final snackBar = SnackBar(
                          /// need to set following properties for best effect of awesome_snackbar_content
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'Alert!',
                            message: '${response["message"]}',

                            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
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
                    child: const Text('SIGN UP'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(fontSize: 12),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              child: const LogIn(),
                            ),
                          );
                        },
                        child: const Text(
                          "  Log in",
                          style: TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
