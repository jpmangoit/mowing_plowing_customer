import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../../Backend/base_client.dart';
import '../../Login/logIn_screen.dart';
import 'changeEmailOTP_screen.dart';

class ChangeEmail extends StatefulWidget {
  final String? email;
  final String? newEmail;
  final String? unverifiedEmail;
  final String? emailVerifiedAt;

  const ChangeEmail({
    super.key,
    required this.email,
    required this.newEmail,
    required this.unverifiedEmail,
    required this.emailVerifiedAt,
  });

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final GlobalKey<FormState> _form = GlobalKey();
  TextEditingController unverifiedEmailController = TextEditingController();
  TextEditingController newEmailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    unverifiedEmailController =
        TextEditingController(text: widget.unverifiedEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.emailVerifiedAt == null ? "Verify Email" : "Change Email",
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: widget.emailVerifiedAt == null
          ? Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text("Verify your email"),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "We will send a passcode to verify your email",
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Material(
                    elevation: 5.0,
                    shadowColor: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                    child: TextFormField(
                      controller: unverifiedEmailController,
                      // readOnly: true,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                        labelText: 'Your unverified email',
                        suffixIcon: Icon(
                          Icons.email,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
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
                          var response = await BaseClient().verifyEmail(
                            "/verify-email-index",
                            unverifiedEmailController.text,
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
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    // 3
                                    child: ChangeEmailOTP(
                                      email: unverifiedEmailController.text,
                                      currentEmail: null,
                                    ),
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
                          }
                        },
                        child: const Text('Verify Email'),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                const Text("Change your email"),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "We will send a passcode to verify your email",
                  style: TextStyle(fontSize: 12),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: _form,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Material(
                          elevation: 5.0,
                          shadowColor: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                          child: TextFormField(
                            readOnly: true,
                            initialValue: "${widget.email}",
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(10),
                              border: InputBorder.none,
                              labelText: 'Your current email',
                              suffixIcon: Icon(
                                Icons.email,
                              ),
                            ),
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
                            controller: newEmailController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.all(10),
                              border: InputBorder.none,
                              labelText: 'Enter new email',
                              suffixIcon: IconButton(
                                icon: const Icon(
                                  Icons.email,
                                ),
                                onPressed: () {},
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value == "") {
                                return "Please enter new email";
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
                          var response = await BaseClient().editEmail(
                            "/edit-email",
                            widget.email!,
                            newEmailController.text,
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
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    // 3
                                    child: ChangeEmailOTP(
                                      email: newEmailController.text,
                                      currentEmail: widget.email,
                                    ),
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
                          }
                        },
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
