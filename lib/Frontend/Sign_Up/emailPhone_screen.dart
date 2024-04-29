import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:mowing_plowing/Backend/base_client.dart';
import 'package:page_transition/page_transition.dart';
import '../Login/logIn_screen.dart';
import 'editProfile_screen.dart';
import 'verifyPhoneNumber_screen.dart';

class EmailPhone extends StatefulWidget {
  const EmailPhone({super.key});

  @override
  State<EmailPhone> createState() => _EmailPhoneState();
}

class _EmailPhoneState extends State<EmailPhone> {
  final GlobalKey<FormState> _form = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumbController = TextEditingController(
      // text: "+92",
      );
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';

  @override
  Widget build(BuildContext context) {
    RegExp regExp = RegExp(pattern);
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
                "Enter your email and number",
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
                  Column(
                    children: const [
                      Text("What's your email and phone number?"),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                  const Text(
                    "We'll text a code to verify your phone number",
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Material(
                      elevation: 5.0,
                      shadowColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          labelText: 'Enter your email',
                          suffixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Please enter email";
                          } else if (!value.contains("@") ||
                              !value.contains(".") ||
                              value.length < 5) {
                            return "Please enter valid email";
                          }

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
                        controller: phoneNumbController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(10),
                          border: InputBorder.none,
                          labelText: 'Enter your phone number',
                          suffixIcon: Icon(Icons.phone),
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
                ],
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
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
                      if (!(_form.currentState?.validate() ?? true)) {
                        return;
                      }

                      var response = await BaseClient().emailPhoneNumber(
                        "/verify-email-and-phone-number",
                        emailController.text,
                        "+1${phoneNumbController.text}",
                      );
                      if (response["success"]) {
                        if (mounted) {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              child: EditProfile(
                                phoneNumber: phoneNumbController.text,
                              ),
                              // VerifyPhoneNumber(
                              //   phoneNumber: phoneNumbController.text,
                              //   email: emailController.text,
                              // ),
                            ),
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
                    },
                    child: const Text('NEXT'),
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
