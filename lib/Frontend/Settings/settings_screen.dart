import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Legal/legal_screen.dart';
import '../PrivacyPolicy/privacyPolicy_screen.dart';
import '../Profile/myProfile_screen.dart';
import '../Terms&Conditions/termsConditions_screen.dart';
import 'ChangeEmail/changeEmail_screen.dart';
import 'ChangePhoneNumber/changePhoneNumber_screen.dart';
import 'SetPassword/setPassword_screen.dart';

class Settings extends StatefulWidget {
  late String? firstName;
  late String? lastName;
  late String? email;
  late String? newEmail;
  late String? unverifiedEmail;
  late String? image;
  late String? phoneNumber;
  late String? newPhoneNumber;
  late String? lat;
  late String? lng;
  late String? zipCode;
  late String? address;
  late String? emailVerifiedAt;
  Settings({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.newEmail,
    required this.unverifiedEmail,
    required this.image,
    required this.phoneNumber,
    required this.newPhoneNumber,
    required this.lat,
    required this.lng,
    required this.zipCode,
    required this.address,
    required this.emailVerifiedAt,
  });

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Map<String, dynamic>? userMap;
  Future<void> getUserDataFromLocal() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? user = localStorage.getString('user');
    userMap = jsonDecode(user!) as Map<String, dynamic>;
    widget.firstName = userMap!["first_name"];
    widget.lastName = userMap!["last_name"];
    widget.email = userMap!["email"];
    widget.newEmail = userMap!["new_email"];
    widget.unverifiedEmail = userMap!["unverified_email"];
    widget.image = userMap!["image"];
    widget.phoneNumber = userMap!["phone_number"];
    widget.newPhoneNumber = userMap!["new_phone_number"];
    widget.lat = userMap!["lat"];
    widget.lng = userMap!["lng"];
    widget.zipCode = userMap!["zip_code"];
    widget.address = userMap!["address"];
    widget.emailVerifiedAt = userMap!["email_verified_at"];
    if (mounted) {
      setState(() {});
    }
  }

  FutureOr onGoBack(dynamic value) {
    getUserDataFromLocal();
  }

  @override
  void initState() {
    getUserDataFromLocal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  // 3
                  child: MyProfile(
                    firstName: widget.firstName,
                    lastName: widget.lastName,
                    image: widget.image,
                    lat: widget.lat,
                    lng: widget.lng,
                    zipCode: widget.zipCode,
                    address: widget.address,
                  ),
                ),
              ).then(onGoBack);
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: const [
                  ImageIcon(
                    AssetImage("images/edit.png"),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey[300],
            height: 1,
            thickness: 1,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  // 3
                  child: const SetPassword(),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: const [
                  ImageIcon(
                    AssetImage("images/lock.png"),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Set Password",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey[300],
            height: 1,
            thickness: 1,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  // 3
                  child: ChangeEmail(
                    email: widget.email,
                    emailVerifiedAt: widget.emailVerifiedAt,
                    newEmail: widget.newEmail,
                    unverifiedEmail: widget.unverifiedEmail,
                  ),
                ),
              ).then(onGoBack);
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const ImageIcon(
                    AssetImage("images/email.png"),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    widget.emailVerifiedAt == null
                        ? "Verify Email"
                        : "Change Email",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey[300],
            height: 1,
            thickness: 1,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  // 3
                  child: ChangePhoneNumber(
                    phoneNumber: widget.phoneNumber!,
                  ),
                ),
              ).then(onGoBack);
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: const [
                  ImageIcon(
                    AssetImage("images/change.png"),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    "Change Phone Number",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey[300],
            height: 1,
            thickness: 3,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  // 3
                  child: const PrivacyPolicy(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Privacy Policy",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey[300],
            height: 1,
            thickness: 3,
          ),
          // InkWell(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       PageTransition(
          //         type: PageTransitionType.rightToLeftWithFade,
          //         // 3
          //         child: const Legal(),
          //       ),
          //     );
          //   },
          //   child: const Padding(
          //     padding: EdgeInsets.all(20),
          //     child: Align(
          //       alignment: Alignment.centerLeft,
          //       child: Text(
          //         "Legal",
          //         style: TextStyle(fontSize: 16),
          //       ),
          //     ),
          //   ),
          // ),
          Divider(
            color: Colors.grey[300],
            height: 1,
            thickness: 3,
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  // 3
                  child: const TermsConditions(),
                ),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Terms and Conditions",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey[300],
            height: 1,
            thickness: 3,
          ),
        ],
      ),
    );
  }
}
