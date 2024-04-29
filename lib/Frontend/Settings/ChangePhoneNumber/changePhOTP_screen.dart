import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Backend/base_client.dart';
import '../../Login/logIn_screen.dart';
import '../settings_screen.dart';

class ChangePhoneNumberOTP extends StatefulWidget {
  final String phoneNumber;
  const ChangePhoneNumberOTP({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<ChangePhoneNumberOTP> createState() => _ChangePhoneNumberOTPState();
}

class _ChangePhoneNumberOTPState extends State<ChangePhoneNumberOTP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Verify",
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
          const SizedBox(
            height: 30,
          ),
          const Text("Verify your phone number"),
          const SizedBox(
            height: 20,
          ),
          const Text("Enter the code"),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Sent to ${widget.phoneNumber}",
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(
            height: 40,
          ),
          OtpTextField(
              numberOfFields: 6,
              borderColor: HexColor("#0275D8"),
              showFieldAsBox: false,
              enabledBorderColor: Colors.black,
              focusedBorderColor: HexColor("#0275D8"),
              onCodeChanged: (String code) {},
              onSubmit: (String verificationCode) async {
                var response = await BaseClient().newPhoneNumberOtp(
                  "/edit-phone-number-verify",
                  verificationCode,
                );

                if (response["message"] == "Unauthenticated.") {
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        // 3
                        child: const LogIn(),
                      ),
                      (route) => false,
                    );
                    final snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Alert!',
                        message: 'To continue, kindly log in again',
                        contentType: ContentType.help,
                      ),
                    );
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                  }
                } else {
                  if (response["success"]) {
                    SharedPreferences localStorage =
                        await SharedPreferences.getInstance();
                    await localStorage.remove('user');
                    Map<String, dynamic> user = response["data"];
                    await localStorage.setString('user', jsonEncode(user));
                    if (mounted) {
                      setState(() {});
                    }
                    if (mounted) {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      final snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Updated!',
                          message: '${response["message"]}',
                          contentType: ContentType.success,
                        ),
                      );
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    }
                  } else {
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
                }
              }),
          const SizedBox(
            height: 40,
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Resend Code'),
          ),
        ],
      ),
    );
  }
}
