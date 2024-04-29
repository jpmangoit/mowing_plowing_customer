import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Backend/base_client.dart';
import '../../../Login/logIn_screen.dart';

class RecurringServices extends StatefulWidget {
  const RecurringServices({super.key});

  @override
  State<RecurringServices> createState() => _RecurringServicesState();
}

class _RecurringServicesState extends State<RecurringServices> {
  bool? sevenDays;
  bool? tenDays;
  bool? fourteenDays;
  bool? oneTime;
  bool loading = true;
  String? sevenDaysP;
  String? tenDaysP;
  String? fourteenDaysP;
  String? oneTimeP;

  Future serviceEstimations() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var response = await BaseClient().serviceEstimations(
      "/service-estimations",
      localStorage.getString('sizeIdL').toString(),
      localStorage.getString('heightIdL').toString(),
      localStorage.getBool('cornerLotL').toString(),
      localStorage.getBool('fenceL').toString(),
      localStorage.getString('fenceIdL').toString(),
      localStorage.getBool('yardBeforeMowL').toString(),
      localStorage.getString('cleanUpIdL').toString(),
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
        sevenDaysP = response["data"]["sevenDays"].toStringAsFixed(2);
        tenDaysP = response["data"]["tenDays"].toStringAsFixed(2);
        fourteenDaysP = response["data"]["fourteenDays"].toStringAsFixed(2);
        oneTimeP = response["data"]["oneTime"].toStringAsFixed(2);
        if (localStorage.getBool('sevenDaysL') == null &&
            localStorage.getBool('tenDaysL') == null &&
            localStorage.getBool('fourteenDaysL') == null &&
            localStorage.getBool('oneTimeL') == null) {
          sevenDays = true;
          await localStorage.setBool('sevenDaysL', true);
          tenDays = false;
          await localStorage.setBool('tenDaysL', false);
          fourteenDays = false;
          await localStorage.setBool('fourteenDaysL', false);
          oneTime = false;
          await localStorage.setBool('oneTimeL', false);
          if (mounted) {
            setState(() {});
          }
        } else {
          sevenDays = localStorage.getBool('sevenDaysL');
          tenDays = localStorage.getBool('tenDaysL');
          fourteenDays = localStorage.getBool('fourteenDaysL');
          oneTime = localStorage.getBool('oneTimeL');
          if (mounted) {
            setState(() {});
          }
        }
        if (mounted) {
          setState(() {});
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
  }

  void completeFunct() {
    serviceEstimations().then((value) async {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      await localStorage.setBool("nextOn2", true);
      loading = false;
      if (mounted) {
        setState(() {});
      }
    });
  }

  void remove() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.remove("nextOn2");
  }

  @override
  initState() {
    super.initState();
    completeFunct();
  }

  @override
  void dispose() {
    remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Choose a service",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Mowing service includes:",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Basic ',
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Mowing, Trimming,',
                                        style: TextStyle(
                                          color: HexColor("#24B550"),
                                        ),
                                      ),
                                      const TextSpan(text: ' and '),
                                      TextSpan(
                                        text: 'Blowing grass',
                                        style: TextStyle(
                                          color: HexColor("#24B550"),
                                        ),
                                      ),
                                      const TextSpan(
                                          text:
                                              ' clippings from hard surface areas. Overgrown lawns may take more than one service to manicure properly.'),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      });
                },
                child: const Text(
                  "What's included?",
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            child: loading
                ? LoadingAnimationWidget.fourRotatingDots(
                    color: HexColor("#0275D8"),
                    size: 40,
                  )
                : Column(
                    children: [
                      Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                border: Border.all(
                                  color: HexColor("#B2FFCA"),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 15, 10, 20),
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Recurring services",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Please select recurring service period",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        SharedPreferences localStorage =
                                            await SharedPreferences
                                                .getInstance();
                                        if (mounted) {
                                          setState(() {
                                            sevenDays = true;
                                            tenDays = false;
                                            fourteenDays = false;
                                            oneTime = false;
                                          });
                                        }
                                        await localStorage.setBool(
                                            'sevenDaysL', true);
                                        await localStorage.setBool(
                                            'tenDaysL', false);
                                        await localStorage.setBool(
                                            'fourteenDaysL', false);
                                        await localStorage.setBool(
                                            'oneTimeL', false);
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: sevenDays ?? false
                                                ? HexColor("#D7E5F1")
                                                : null,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("Every 7 days"),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "(used by 40% customers)",
                                                      style: TextStyle(
                                                        color:
                                                            HexColor("#24B550"),
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: HexColor("#7CC0FB"),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                    border: Border.all(
                                                      color:
                                                          HexColor("#10AFFF"),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "\$$sevenDaysP",
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      child: Divider(
                                        color: Colors.grey[400],
                                        height: 1,
                                        thickness: 1,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        SharedPreferences localStorage =
                                            await SharedPreferences
                                                .getInstance();
                                        if (mounted) {
                                          setState(() {
                                            sevenDays = false;
                                            tenDays = true;
                                            fourteenDays = false;
                                            oneTime = false;
                                          });
                                        }
                                        await localStorage.setBool(
                                            'sevenDaysL', false);
                                        await localStorage.setBool(
                                            'tenDaysL', true);
                                        await localStorage.setBool(
                                            'fourteenDaysL', false);
                                        await localStorage.setBool(
                                            'oneTimeL', false);
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: tenDays ?? false
                                                ? HexColor("#D7E5F1")
                                                : null,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("Every 10 days"),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "(used by 15% customers)",
                                                      style: TextStyle(
                                                        color:
                                                            HexColor("#24B550"),
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: HexColor("#7CC0FB"),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                    border: Border.all(
                                                      color:
                                                          HexColor("#10AFFF"),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "\$$tenDaysP",
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      child: Divider(
                                        color: Colors.grey[400],
                                        height: 1,
                                        thickness: 1,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        SharedPreferences localStorage =
                                            await SharedPreferences
                                                .getInstance();
                                        if (mounted) {
                                          setState(() {
                                            sevenDays = false;
                                            tenDays = false;
                                            fourteenDays = true;
                                            oneTime = false;
                                          });
                                        }
                                        await localStorage.setBool(
                                            'sevenDaysL', false);
                                        await localStorage.setBool(
                                            'tenDaysL', false);
                                        await localStorage.setBool(
                                            'fourteenDaysL', true);
                                        await localStorage.setBool(
                                            'oneTimeL', false);
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: fourteenDays ?? false
                                                ? HexColor("#D7E5F1")
                                                : null,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("Every 14 days"),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "(used by 10% customers)",
                                                      style: TextStyle(
                                                        color:
                                                            HexColor("#24B550"),
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: HexColor("#7CC0FB"),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                    border: Border.all(
                                                      color:
                                                          HexColor("#10AFFF"),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "\$$fourteenDaysP",
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 0),
                                      child: Divider(
                                        color: Colors.grey[400],
                                        height: 1,
                                        thickness: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                border: Border.all(
                                  color: HexColor("#0275D8"),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: Icon(
                                  Icons.replay,
                                  size: 16,
                                  color: HexColor("#0275D8"),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                                border: Border.all(
                                  color: HexColor("#B2FFCA"),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 15, 10, 20),
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "One time services",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        SharedPreferences localStorage =
                                            await SharedPreferences
                                                .getInstance();
                                        if (mounted) {
                                          setState(() {
                                            sevenDays = false;
                                            tenDays = false;
                                            fourteenDays = false;
                                            oneTime = true;
                                          });
                                        }
                                        await localStorage.setBool(
                                            'sevenDaysL', false);
                                        await localStorage.setBool(
                                            'tenDaysL', false);
                                        await localStorage.setBool(
                                            'fourteenDaysL', false);
                                        await localStorage.setBool(
                                            'oneTimeL', true);
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: oneTime ?? false
                                                ? HexColor("#D7E5F1")
                                                : null,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(5),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text("One Time"),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "(used by 35% customers)",
                                                      style: TextStyle(
                                                        color:
                                                            HexColor("#24B550"),
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: HexColor("#7CC0FB"),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                    border: Border.all(
                                                      color:
                                                          HexColor("#10AFFF"),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "\$$oneTimeP",
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(20),
                                ),
                                border: Border.all(
                                  color: HexColor("#0275D8"),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: Icon(
                                  Icons.repeat_one,
                                  size: 16,
                                  color: HexColor("#0275D8"),
                                ),
                              ),
                            ),
                          )
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
    );
  }
}
