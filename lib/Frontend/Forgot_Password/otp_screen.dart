import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';

import '../../Backend/base_client.dart';
import '../Login/logIn_screen.dart';
import 'newEmailPass_screen.dart';

class OtpForgot extends StatefulWidget {
  final String phoneNumber;
  const OtpForgot({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpForgot> createState() => _OtpForgotState();
}

class _OtpForgotState extends State<OtpForgot> {
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
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                const Text("Enter the code"),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  widget.phoneNumber,
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
                    var response = await BaseClient().otp(
                      "/reset-passowrd",
                      "+1${widget.phoneNumber}",
                      verificationCode,
                    );
                    if (response["success"]) {
                      if (mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeftWithFade,
                            child: NewEmailPassword(
                              otp: verificationCode,
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
                    var response = await BaseClient().forgetPassword(
                      "/send-otp-on-phone-number",
                      "+1${widget.phoneNumber}",
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
                    }
                  },
                  child: const Text('Resend Code'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
