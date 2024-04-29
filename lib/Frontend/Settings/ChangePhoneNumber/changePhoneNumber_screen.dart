import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Backend/base_client.dart';
import '../../Login/logIn_screen.dart';
import 'changePhOTP_screen.dart';

class ChangePhoneNumber extends StatefulWidget {
  final String phoneNumber;
  const ChangePhoneNumber({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<ChangePhoneNumber> createState() => _ChangePhoneNumberState();
}

class _ChangePhoneNumberState extends State<ChangePhoneNumber> {
  final GlobalKey<FormState> _form = GlobalKey();
  TextEditingController phoneNumbController = TextEditingController();
  TextEditingController newPhoneNumbController = TextEditingController(
      // text: "+92",
      );
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  @override
  void initState() {
    super.initState();
    phoneNumbController = TextEditingController(text: widget.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    RegExp regExp = RegExp(pattern);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Change Phone Number",
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
          const Text("Edit your Phone Number"),
          const SizedBox(
            height: 10,
          ),
          const Text(
            "We will send a passcode to verify your phone number",
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
                      controller: phoneNumbController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                        labelText: 'Enter your current phone number',
                      ),
                      validator: (value) {
                        if (value == null || value == "") {
                          return "Please enter your current phone number";
                        } else if (value.length != 10) {
                          return "Please enter valid phone number";
                        }
                        // else if (!regExp.hasMatch(value)) {
                        //   return "Please enter valid phone number";
                        // }

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
                      controller: newPhoneNumbController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
                        border: InputBorder.none,
                        labelText: 'Enter new phone number',
                        suffixIcon: Icon(Icons.phone),
                      ),
                      validator: (value) {
                        if (value == null || value == "") {
                          return "Please enter new phone number";
                        } else if (value.length != 10) {
                          return "Please enter valid phone number";
                        }
                        // else if (!regExp.hasMatch(value)) {
                        //   return "Please enter valid phone number";
                        // }

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
                    var response = await BaseClient().newPhoneNumber(
                      "/edit-phone-number",
                      "+1${phoneNumbController.text}",
                      "+1${newPhoneNumbController.text}",
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
                              type: PageTransitionType.rightToLeftWithFade,
                              // 3
                              child: ChangePhoneNumberOTP(
                                phoneNumber: newPhoneNumbController.text,
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
