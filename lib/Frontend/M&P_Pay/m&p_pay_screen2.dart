import 'dart:async';
import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Backend/base_client.dart';
import '../FAQ/faq_screen.dart';
import '../Login/logIn_screen.dart';
import 'm&p_pay_screen3.dart';

class MPPayScreen2 extends StatefulWidget {
  const MPPayScreen2({super.key});
  @override
  State<MPPayScreen2> createState() => _MPPayScreen2State();
}

class _MPPayScreen2State extends State<MPPayScreen2> {
  Map<String, dynamic>? walletMap;
  int? id;
  String refillLimit = "0";
  bool? first;
  bool? second;
  bool? third;
  bool? refill;
  bool loading = true;

  Future<void> getUserPayDataFromLocal() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? wallet = localStorage.getString('wallet');
    String? autoRefillLimit = localStorage.getString('autoRefillLimit');
    walletMap = jsonDecode(wallet!) as Map<String, dynamic>;

    id = walletMap!["id"];
    refillLimit = autoRefillLimit!;
    if (walletMap!["auto_refill_amount"] == null ||
        walletMap!["auto_refill_amount"] == 0) {
      first = false;
      second = false;
      third = false;
    } else if ((walletMap!["auto_refill_amount"].toString()).contains("25")) {
      first = true;
      second = false;
      third = false;
    } else if ((walletMap!["auto_refill_amount"].toString()).contains("50")) {
      first = false;
      second = true;
      third = false;
    } else if ((walletMap!["auto_refill_amount"].toString()).contains("100")) {
      first = false;
      second = false;
      third = true;
    }
    if (walletMap!["auto_refill"] == "0") {
      refill = false;
    } else {
      refill = true;
    }
    setState(() {});
  }

  FutureOr onGoBackPayment(dynamic value) {
    getUserPayDataFromLocal();
  }

  @override
  void initState() {
    getUserPayDataFromLocal().then((value) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  "M&P ",
                  style: TextStyle(
                    color: HexColor("#0275D8"),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: HexColor("#0275D8"),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.fromLTRB(2, 3, 12, 3),
                    child: Text(
                      "Pay",
                      style: TextStyle(
                        fontFamily: "Neometric",
                        fontStyle: FontStyle.italic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    // 3
                    child: const FAQ(),
                  ),
                );
              },
              child: Row(
                children: const [
                  Text(
                    "How it works",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.help),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: loading
          ? Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                color: HexColor("#0275D8"),
                size: 80,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text(
                    "Choose amount",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("USD 25.00"),
                      Checkbox(
                        value: first,
                        onChanged: (bool? value) {
                          if (mounted) {
                            setState(() {
                              first = value!;
                              second = false;
                              third = false;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey[400],
                  height: 1,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("USD 50.00"),
                      Checkbox(
                        value: second,
                        onChanged: (bool? value) {
                          if (mounted) {
                            setState(() {
                              first = false;
                              second = value!;
                              third = false;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey[400],
                  height: 1,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("USD 100.00"),
                      Checkbox(
                        value: third,
                        onChanged: (bool? value) {
                          if (mounted) {
                            setState(() {
                              first = false;
                              second = false;
                              third = value!;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.grey[400],
                  height: 1,
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Auto Refill"),
                      CupertinoSwitch(
                        activeColor: HexColor("#0275D8"),
                        thumbColor: Colors.white,
                        trackColor: Colors.black12,
                        value: refill!,
                        // changes the state of the switch
                        onChanged: !first! && !second! && !third!
                            ? (value) {}
                            : (value) async {
                                if (mounted) {
                                  setState(() {
                                    refill = value;
                                  });
                                }
                                var response =
                                    await BaseClient().updateWalletSetting(
                                  "/update-wallet-setting",
                                  value ? "1" : "0",
                                  first! && value
                                      ? "25"
                                      : second! && value
                                          ? "50"
                                          : third! && value
                                              ? "100"
                                              : "0.00",
                                );
                                if (response["message"] == "Unauthenticated.") {
                                  if (mounted) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType
                                            .rightToLeftWithFade,
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
                                        message:
                                            'To continue, kindly log in again',
                                        contentType: ContentType.help,
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(snackBar);
                                  }
                                } else {
                                  SharedPreferences localStorage =
                                      await SharedPreferences.getInstance();
                                  await localStorage.remove('wallet');
                                  walletMap!["auto_refill"] =
                                      response["data"]["auto_refill"];
                                  walletMap!["auto_refill_amount"] =
                                      response["data"]["auto_refill_amount"];
                                  if (mounted) {
                                    setState(() {});
                                  }
                                  await localStorage.setString(
                                    'wallet',
                                    jsonEncode(walletMap),
                                  );
                                  if (!response["success"]) {
                                    final snackBar = SnackBar(
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'Success!',
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
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Text(
                    "Automatically add cash when your balance is lower than USD $refillLimit",
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !first! && !second! && !third!
                          ? Colors.grey
                          : HexColor("#0275D8"),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      !first! && !second! && !third!
                          ? null
                          : Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                // 3
                                child: MPPayScreen3(
                                  amount: first!
                                      ? '25'
                                      : second!
                                          ? "50"
                                          : "100",
                                ),
                              ),
                            ).then(onGoBackPayment);
                    },
                    child: const Text("Check Out"),
                  ),
                ),
              ],
            ),
    );
  }
}
