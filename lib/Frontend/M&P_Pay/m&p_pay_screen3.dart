import 'dart:async';
import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mowing_plowing/Frontend/Payment/payment_screen3.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Backend/base_client.dart';
import '../FAQ/faq_screen.dart';
import '../Login/logIn_screen.dart';

class MPPayScreen3 extends StatefulWidget {
  final String amount;

  const MPPayScreen3({
    super.key,
    required this.amount,
  });

  @override
  State<MPPayScreen3> createState() => _MPPayScreen3State();
}

class _MPPayScreen3State extends State<MPPayScreen3> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController postCodeController = TextEditingController();
  late Future<List<Data>> futureData;
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

  Future<List<Data>> getCards(int? id) async {
    List jsonResponse = [];
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? cards = localStorage.getString('cards');
    cardsMap = jsonDecode(cards!) as List<dynamic>?;
    jsonResponse = cardsMap!;
    if (id == null) {
      defaultCard = jsonResponse
          .where((element) => element["is_default"] == "1")
          .toList();
      if (mounted) {
        setState(() {});
      }
    } else {
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
    }
    return jsonResponse.map((data) => Data.fromJson(data)).toList();
  }

  FutureOr onGoBackPayment(dynamic value) {
    futureData = getCards(null);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: HexColor("#E8E8E8"),
        width: 2.0,
      ),
    );
    futureData = getCards(null);
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
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("M&P Cash"),
                    Text("USD ${widget.amount}"),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Divider(
                  color: Colors.grey[400],
                  height: 1,
                  thickness: 1,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Total"),
                    Text("USD ${widget.amount}"),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () async {
                    showMaterialModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      // expand: true,
                      context: context,
                      backgroundColor: Colors.white,
                      builder: (context) => SingleChildScrollView(
                        controller: ModalScrollController.of(context),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.fromLTRB(25, 20, 20, 0),
                              child: Text("Select payment method"),
                            ),
                            const Padding(
                              padding: EdgeInsets.fromLTRB(25, 10, 20, 0),
                              child: Text(
                                "This payment method will be default to refill M&P Cash",
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                            FutureBuilder<List<Data>>(
                              future: futureData,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<Data>? data = snapshot.data;
                                  return data!.isEmpty
                                      ? Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: Text(
                                              "No payment method added",
                                              style: TextStyle(
                                                color: HexColor("#0275D8"),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: data.length,
                                          // itemCount: _properties.length,
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      30, 0, 30, 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Visa",
                                                        style: TextStyle(
                                                          color: HexColor(
                                                              "#0275D8"),
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        "    **** **** **** ${data[index].last4}",
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    child: data[index]
                                                                .is_default ==
                                                            "1"
                                                        ? IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(
                                                              Icons.done,
                                                              color: HexColor(
                                                                  "#0275D8"),
                                                            ),
                                                          )
                                                        : PopupMenuButton(
                                                            icon: const Icon(
                                                              Icons.more_horiz,
                                                            ),
                                                            onSelected:
                                                                (value) {
                                                              // your logic
                                                            },
                                                            itemBuilder:
                                                                (BuildContext
                                                                    bc) {
                                                              return [
                                                                PopupMenuItem(
                                                                  child:
                                                                      const Text(
                                                                    "Make it as default",
                                                                  ),
                                                                  onTap:
                                                                      () async {
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
                                                                            type:
                                                                                PageTransitionType.rightToLeftWithFade,
                                                                            // 3
                                                                            child:
                                                                                const LogIn(),
                                                                          ),
                                                                          (route) =>
                                                                              false,
                                                                        );
                                                                        final snackBar =
                                                                            SnackBar(
                                                                          elevation:
                                                                              0,
                                                                          behavior:
                                                                              SnackBarBehavior.floating,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          content:
                                                                              AwesomeSnackbarContent(
                                                                            title:
                                                                                'Alert!',
                                                                            message:
                                                                                'To continue, kindly log in again',
                                                                            contentType:
                                                                                ContentType.help,
                                                                          ),
                                                                        );
                                                                        ScaffoldMessenger.of(
                                                                            context)
                                                                          ..hideCurrentSnackBar()
                                                                          ..showSnackBar(
                                                                              snackBar);
                                                                      }
                                                                    } else {
                                                                      if (response[
                                                                          "success"]) {
                                                                        futureData =
                                                                            getCards(
                                                                          int.parse(
                                                                            data[index].id,
                                                                          ),
                                                                        );
                                                                        if (mounted) {
                                                                          Navigator.pop(
                                                                              context);
                                                                        }
                                                                      } else {
                                                                        final snackBar =
                                                                            SnackBar(
                                                                          elevation:
                                                                              0,
                                                                          behavior:
                                                                              SnackBarBehavior.floating,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          content:
                                                                              AwesomeSnackbarContent(
                                                                            title:
                                                                                'Alert!',
                                                                            message:
                                                                                '${response["message"]}',
                                                                            contentType:
                                                                                ContentType.failure,
                                                                          ),
                                                                        );
                                                                        if (mounted) {
                                                                          ScaffoldMessenger.of(
                                                                              context)
                                                                            ..hideCurrentSnackBar()
                                                                            ..showSnackBar(snackBar);
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
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child:
                                        LoadingAnimationWidget.fourRotatingDots(
                                      color: HexColor("#0275D8"),
                                      size: 40,
                                    ),
                                  ),
                                );
                              },
                            ),
                            Divider(
                              color: Colors.grey[400],
                              height: 1,
                              thickness: 1,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    // 3
                                    child: const Payment3(),
                                  ),
                                ).then(onGoBackPayment);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20),
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
                          ],
                        ),
                      ),
                    );
                  },
                  child: Material(
                    elevation: 5.0,
                    shadowColor: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: defaultCard == [] || defaultCard.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text("Choose payment method"),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            child: Image.asset(
                                          "images/payment.png",
                                          width: 30,
                                          height: 30,
                                        )),
                                        const Icon(
                                          Icons.expand_more,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "**** **** **** ${defaultCard[0]["last4"]}",
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Visa",
                                          style: TextStyle(
                                            color: HexColor("#0275D8"),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.expand_more,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: defaultCard == [] || defaultCard.isEmpty
                    ? Colors.grey
                    : HexColor("#0275D8"),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: defaultCard == [] || defaultCard.isEmpty
                  ? () {}
                  : () async {
                      var response = await BaseClient().purchase(
                        "/purchase",
                        defaultCard[0]["card_id"],
                        widget.amount,
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
                          await localStorage.remove('wallet');
                          Map<String, dynamic> wallet =
                              response["data"]["wallet"];
                          await localStorage.setString(
                            'wallet',
                            jsonEncode(wallet),
                          );
                          if (mounted) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
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
              child: const Text("Purchase"),
            ),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    if (mounted) {
      setState(() {
        cardNumber = creditCardModel!.cardNumber;
        expiryDate = creditCardModel.expiryDate;
        cardHolderName = creditCardModel.cardHolderName;
        cvvCode = creditCardModel.cvvCode;
        isCvvFocused = creditCardModel.isCvvFocused;
      });
    }
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
