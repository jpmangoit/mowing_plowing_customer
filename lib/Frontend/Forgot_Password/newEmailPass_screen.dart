import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../Backend/base_client.dart';
import '../Login/logIn_screen.dart';

class NewEmailPassword extends StatefulWidget {
  final String phoneNumber;
  final String otp;
  const NewEmailPassword({
    required this.phoneNumber,
    required this.otp,
    super.key,
  });

  @override
  State<NewEmailPassword> createState() => _NewEmailPasswordState();
}

class _NewEmailPasswordState extends State<NewEmailPassword> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  bool _isObscure = true;
  bool _isObscureCp = true;
  final GlobalKey<FormState> _form = GlobalKey();
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
              height: 40,
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
                        controller: passwordController,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.all(10),
                          border: InputBorder.none,
                          labelText: 'Enter new password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              if (mounted) {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              }
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "Please enter new password";
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
                        controller: confirmPassController,
                        obscureText: _isObscureCp,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.all(10),
                          border: InputBorder.none,
                          labelText: 'Confirm Password',
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
                            return "Please confirm password";
                          } else if (passwordController.text !=
                              confirmPassController.text) {
                            return "Invalid confirm password";
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
                      var response = await BaseClient().newPassword(
                        "/update-password",
                        "+1${widget.phoneNumber}",
                        passwordController.text,
                        confirmPassController.text,
                        widget.otp,
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
                          if (mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                child: const LogIn(),
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
                      }
                    },
                    child: const Text('SAVE'),
                  ),
                  const SizedBox(
                    height: 50,
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
