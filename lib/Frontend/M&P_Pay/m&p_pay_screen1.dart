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
import '../Payment/payment_screen3.dart';
import 'm&p_pay_screen2.dart';

class MPPayScreen1 extends StatefulWidget {
  const MPPayScreen1({super.key});

  @override
  State<MPPayScreen1> createState() => _MPPayScreen1State();
}

class _MPPayScreen1State extends State<MPPayScreen1> {
  late Future<List<Data>> futureData;
  Map<String, dynamic>? walletMap;
  List<dynamic>? cardsMap;
  List defaultCard = [];

  showMsg(msg) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Alert!',
        message: '$msg',
        contentType: ContentType.failure,
      ),
    );
    if (mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  Future<List<Data>> getCardWalletFunction(int? id, bool delete) async {
    List jsonResponse = [];
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? wallet = localStorage.getString('wallet');
    walletMap = jsonDecode(wallet!) as Map<String, dynamic>;
    String? cards = localStorage.getString('cards');
    cardsMap = jsonDecode(cards!) as List<dynamic>?;
    jsonResponse = cardsMap!;
    if (id == null && !delete) {
      defaultCard = jsonResponse
          .where((element) => element["is_default"] == "1")
          .toList();
      if (mounted) {
        setState(() {});
      }
    } else if (id != null && !delete) {
      var defaulted = jsonResponse
          .where((element) => element["is_default"] == "1")
          .toList();

      defaulted[0]["is_default"] = "0";

      defaultCard =
          jsonResponse.where((element) => element["id"] == id).toList();

      defaultCard[0]["is_default"] = "1";

      jsonResponse
          .removeWhere((element) => element["id"] == defaulted[0]["id"]);

      jsonResponse
          .removeWhere((element) => element["id"] == defaultCard[0]["id"]);

      jsonResponse.insert(0, defaultCard[0]);

      jsonResponse.insert(1, defaulted[0]);

      await localStorage.remove('cards');

      await localStorage.setString(
        'cards',
        jsonEncode(jsonResponse),
      );

      if (mounted) {
        setState(() {});
      }
    } else {
      var toDelete =
          jsonResponse.where((element) => element["id"] == id).toList();
      if (toDelete[0]["is_default"] == "1") {
        jsonResponse
            .removeWhere((element) => element["id"] == toDelete[0]["id"]);
        jsonResponse[0]["is_default"] == "1";
        await localStorage.remove('cards');
        await localStorage.setString(
          'cards',
          jsonEncode(jsonResponse),
        );
        if (mounted) {
          setState(() {});
        }
      } else {
        jsonResponse
            .removeWhere((element) => element["id"] == toDelete[0]["id"]);
        await localStorage.remove('cards');
        await localStorage.setString(
          'cards',
          jsonEncode(jsonResponse),
        );
        if (mounted) {
          setState(() {});
        }
      }
    }

    return jsonResponse.map((data) => Data.fromJson(data)).toList();
  }

  FutureOr onGoBackPayment(dynamic value) {
    futureData = getCardWalletFunction(null, false);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    futureData = getCardWalletFunction(null, false);
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    // 3
                    child: const MPPayScreen2(),
                  ),
                ).then(onGoBackPayment);
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text("Add  "),
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
                          const Text("  Cash"),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: HexColor("#0275D8"),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Row(
                    children: [
                      const Text(
                        "Payment Method",
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        "images/stripe.png",
                        width: 60,
                      )
                    ],
                  ),
                ),
                FutureBuilder<List<Data>>(
                  future: futureData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Data>? data = snapshot.data;
                      return data!.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                "No payment method added",
                                style: TextStyle(
                                  color: HexColor("#0275D8"),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: data.length,
                              // itemCount: _properties.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(30, 0, 30, 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "Visa",
                                            style: TextStyle(
                                              color: HexColor("#0275D8"),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            "    **** **** **** ${data[index].last4}",
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        child: data[index].is_default == "1"
                                            ? IconButton(
                                                onPressed: () {},
                                                icon: Icon(
                                                  Icons.done,
                                                  color: HexColor("#0275D8"),
                                                ),
                                              )
                                            : PopupMenuButton(
                                                icon: const Icon(
                                                  Icons.more_horiz,
                                                ),
                                                onSelected: (value) {
                                                  // your logic
                                                },
                                                itemBuilder: (BuildContext bc) {
                                                  return [
                                                    PopupMenuItem(
                                                      child: const Text(
                                                        "Make it as default",
                                                      ),
                                                      onTap: () async {
                                                        var response =
                                                            await BaseClient()
                                                                .setDefaultCard(
                                                          "/card-default/${data[index].id}",
                                                        );

                                                        if (response[
                                                                "message"] ==
                                                            "Unauthenticated.") {
                                                          if (mounted) {
                                                            Navigator
                                                                .pushAndRemoveUntil(
                                                              context,
                                                              PageTransition(
                                                                type: PageTransitionType
                                                                    .rightToLeftWithFade,
                                                                // 3
                                                                child:
                                                                    const LogIn(),
                                                              ),
                                                              (route) => false,
                                                            );
                                                            final snackBar =
                                                                SnackBar(
                                                              elevation: 0,
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              content:
                                                                  AwesomeSnackbarContent(
                                                                title: 'Alert!',
                                                                message:
                                                                    'To continue, kindly log in again',
                                                                contentType:
                                                                    ContentType
                                                                        .help,
                                                              ),
                                                            );
                                                            ScaffoldMessenger
                                                                .of(context)
                                                              ..hideCurrentSnackBar()
                                                              ..showSnackBar(
                                                                  snackBar);
                                                          }
                                                        } else {
                                                          if (response[
                                                              "success"]) {
                                                            if (mounted) {
                                                              futureData =
                                                                  getCardWalletFunction(
                                                                      int.parse(
                                                                          data[index]
                                                                              .id),
                                                                      false);

                                                              if (mounted) {
                                                                setState(() {});
                                                              }
                                                            }
                                                          } else {
                                                            final snackBar =
                                                                SnackBar(
                                                              elevation: 0,
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              content:
                                                                  AwesomeSnackbarContent(
                                                                title: 'Alert!',
                                                                message:
                                                                    '${response["message"]}',
                                                                contentType:
                                                                    ContentType
                                                                        .failure,
                                                              ),
                                                            );
                                                            if (mounted) {
                                                              ScaffoldMessenger
                                                                  .of(context)
                                                                ..hideCurrentSnackBar()
                                                                ..showSnackBar(
                                                                    snackBar);
                                                            }
                                                          }
                                                        }
                                                      },
                                                    ),
                                                    PopupMenuItem(
                                                      child:
                                                          const Text("Delete"),
                                                      onTap: () async {
                                                        var response =
                                                            await BaseClient()
                                                                .deleteCard(
                                                          "/delete-card/${data[index].id}",
                                                        );

                                                        if (response[
                                                                "message"] ==
                                                            "Unauthenticated.") {
                                                          if (mounted) {
                                                            Navigator
                                                                .pushAndRemoveUntil(
                                                              context,
                                                              PageTransition(
                                                                type: PageTransitionType
                                                                    .rightToLeftWithFade,
                                                                // 3
                                                                child:
                                                                    const LogIn(),
                                                              ),
                                                              (route) => false,
                                                            );
                                                            final snackBar =
                                                                SnackBar(
                                                              elevation: 0,
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              content:
                                                                  AwesomeSnackbarContent(
                                                                title: 'Alert!',
                                                                message:
                                                                    'To continue, kindly log in again',
                                                                contentType:
                                                                    ContentType
                                                                        .help,
                                                              ),
                                                            );
                                                            ScaffoldMessenger
                                                                .of(context)
                                                              ..hideCurrentSnackBar()
                                                              ..showSnackBar(
                                                                  snackBar);
                                                          }
                                                        } else {
                                                          if (response[
                                                              "success"]) {
                                                            if (mounted) {
                                                              futureData =
                                                                  getCardWalletFunction(
                                                                      int.parse(
                                                                          data[index]
                                                                              .id),
                                                                      true);

                                                              if (mounted) {
                                                                setState(() {});
                                                              }
                                                            }
                                                          } else {
                                                            final snackBar =
                                                                SnackBar(
                                                              elevation: 0,
                                                              behavior:
                                                                  SnackBarBehavior
                                                                      .floating,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              content:
                                                                  AwesomeSnackbarContent(
                                                                title: 'Alert!',
                                                                message:
                                                                    '${response["message"]}',
                                                                contentType:
                                                                    ContentType
                                                                        .failure,
                                                              ),
                                                            );
                                                            if (mounted) {
                                                              ScaffoldMessenger
                                                                  .of(context)
                                                                ..hideCurrentSnackBar()
                                                                ..showSnackBar(
                                                                    snackBar);
                                                            }
                                                          }
                                                        }
                                                      },
                                                    ),
                                                  ];
                                                },
                                              ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                    } else if (snapshot.hasError) {
                      return showMsg(snapshot.error);
                    }
                    // By default show a loading spinner.
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: LoadingAnimationWidget.fourRotatingDots(
                        color: HexColor("#0275D8"),
                        size: 40,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    // 3
                    child: const Payment3(),
                  ),
                ).then(onGoBackPayment);
              },
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.add,
                      ),
                      Text(" Add payment method"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Data {
  final String id;
  final String card_id;
  final String last4;
  final String is_default;

  Data({
    required this.id,
    required this.card_id,
    required this.last4,
    required this.is_default,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'].toString(),
      card_id: json['card_id'],
      last4: json['last4'].toString(),
      is_default: json['is_default'],
    );
  }
}
