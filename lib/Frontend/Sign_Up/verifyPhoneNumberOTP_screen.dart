import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

import '../../Backend/base_client.dart';
import '../Login/logIn_screen.dart';
import 'editProfile_screen.dart';

class VerifyPhoneNumberOTP extends StatefulWidget {
  final String email;
  final String phoneNumber;
  const VerifyPhoneNumberOTP({
    super.key,
    required this.email,
    required this.phoneNumber,
  });

  @override
  State<VerifyPhoneNumberOTP> createState() => _VerifyPhoneNumberOTPState();
}

class _VerifyPhoneNumberOTPState extends State<VerifyPhoneNumberOTP> {
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
            const Text(
              "Enter the code",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(
              height: 5,
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
              //runs when a code is typed in
              onCodeChanged: (String code) {
                //handle validation or checks here
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode) async {
                // print(widget.phoneNumber);
                // print(verificationCode);
                var response = await BaseClient().otp(
                  "/verify-phone-number",
                  "+1${widget.phoneNumber}",
                  verificationCode,
                );
                if (response["success"]) {
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        child: EditProfile(
                          phoneNumber: widget.phoneNumber,
                        ),
                      ),
                      (route) => false,
                    );
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
              }, // end onSubmit
            ),
            const SizedBox(
              height: 40,
            ),
            TextButton(
              onPressed: () async {
                var response = await BaseClient().emailPhoneNumber(
                  "/verify-email-and-phone-number",
                  widget.email,
                  "+1${widget.phoneNumber}",
                );
                if (response["success"]) {
                  final snackBar = SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: 'Sent!',
                      message: '${response["message"]}',
                      contentType: ContentType.success,
                    ),
                  );
                  if (mounted) {
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
              },
              child: const Text('Resend Code'),
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
    );
  }
}
