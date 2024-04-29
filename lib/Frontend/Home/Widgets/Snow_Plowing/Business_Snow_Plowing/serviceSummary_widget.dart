import 'dart:async';
import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../Backend/base_client.dart';
import '../../../../Login/logIn_screen.dart';
import '../../../../Payment/payment_screen3.dart';

class ServiceSummaryBusiness extends StatefulWidget {
  const ServiceSummaryBusiness({super.key});

  @override
  State<ServiceSummaryBusiness> createState() => _ServiceSummaryBusinessState();
}

class _ServiceSummaryBusinessState extends State<ServiceSummaryBusiness> {
  bool loading = true;
  var tenPerc;
  var fifteenPerc;
  var twentyPerc;
  var twentyFivePerc;
  String initialPercVal = 'Enter tip amount';
  List percentage = [];
  var snowDepth;
  var scheduleTime;
  var drivewayAmount;
  var sidewalkAmount;
  var walkwayAmount;
  var adminFees;
  var taxFees;
  var tipAmount;
  var discountAmount;
  var tipPercentage;
  var grandTotal;
  var orderId;
  var data;
  String? tip;
  String? tipPerc;
  final promoCodeController = TextEditingController();
  bool error = false;
  String errorText = "";
  String applyRemove = "Apply";
  Map<String, dynamic>? walletMap;
  List<dynamic>? cardsMap;
  List defaultCard = [];
  String? walletAmount;

  Future summary() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    List? images = [];
    var image0 = localStorage.getString('image0B');
    var image1 = localStorage.getString('image1B');
    var image2 = localStorage.getString('image2B');
    var image3 = localStorage.getString('image3B');
    images.add(image0 ?? image0);
    images.add(image1 ?? image1);
    images.add(image2 ?? image2);
    images.add(image3 ?? image3);
    var decode =
        jsonDecode(localStorage.getString('snowPlowingScheduleSelectedB')!);
    scheduleTime = decode["name"];
    var response = await BaseClient().orderSummaryHome(
      "/get-order-summary",
      localStorage.getString('orderAddress')!,
      localStorage.getString('orderLat')!,
      localStorage.getString('orderLng')!,
      "2",
      "Business",
      jsonDecode(localStorage.getString('snowPlowingScheduleSelectedB')!)["id"]
          .toString(),
      localStorage.getInt('widthB').toString(),
      localStorage.getInt('lengthB').toString(),
      localStorage.getString(
        'snowDepthInitValueIdB',
      )!,
      localStorage.getString('instructionB'),
      localStorage.getBool('sidewalkB').toString(),
      localStorage.getBool('sidewalkB') == true
          ? localStorage.getString('SidewalkB')
          : null,
      localStorage.getBool('walkawayB').toString(),
      localStorage.getBool('walkawayB') == true
          ? localStorage.getString('WalkwayB')
          : null,
      images,
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
        data = response["data"]["order"];
        await localStorage.setString('orderIdToPay', data["id"].toString());
        grandTotal = data["grand_total"];
        await localStorage.setString(
            'grandTotal', data["grand_total"].toString());
        tenPerc = data["total_amount"] * 10 / 100;
        fifteenPerc = data["total_amount"] * 15 / 100;
        twentyPerc = data["total_amount"] * 20 / 100;
        twentyFivePerc = data["total_amount"] * 25 / 100;
        percentage = [
          'Enter tip amount',
          "10% (\$${tenPerc.toStringAsFixed(2)})",
          "15% (\$${fifteenPerc.toStringAsFixed(2)})",
          "20% (\$${twentyPerc.toStringAsFixed(2)})",
          "25% (\$${twentyFivePerc.toStringAsFixed(2)})",
        ];
        snowDepth = data["snow_depth_amount"];
        snowDepth = data["snow_depth_amount"];
        drivewayAmount = data["driveway_amount"];
        sidewalkAmount = data["sidewalk_amount"] ?? 0;
        walkwayAmount = data["walkway_amount"] ?? 0;
        tipPercentage = data["tip_perc"] ?? 0;
        tipAmount = data["tip"] ?? 0;
        discountAmount = data["discount_amount"] ?? 0;
        adminFees = data["admin_fee"];
        taxFees = data["tax"] ?? 0;
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

  Future reloadSummary(
    String? tip,
    String? tipPerc,
    String? tipType,
  ) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var response = await BaseClient().updateTip(
      "/update-tip",
      data["id"].toString(),
      tip!,
      tipPerc!,
      tipType,
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
        data = response["data"]["order"];
        await localStorage.setString('orderIdToPay', data["id"].toString());
        await localStorage.setString(
            'grandTotal', data["grand_total"].toString());
        grandTotal = data["grand_total"];
        tenPerc = data["total_amount"] * 10 / 100;
        fifteenPerc = data["total_amount"] * 15 / 100;
        twentyPerc = data["total_amount"] * 20 / 100;
        twentyFivePerc = data["total_amount"] * 25 / 100;
        percentage = [
          'Enter tip amount',
          "10% (\$${tenPerc.toStringAsFixed(2)})",
          "15% (\$${fifteenPerc.toStringAsFixed(2)})",
          "20% (\$${twentyPerc.toStringAsFixed(2)})",
          "25% (\$${twentyFivePerc.toStringAsFixed(2)})",
        ];
        snowDepth = data["snow_depth_amount"];
        drivewayAmount = data["driveway_amount"];
        sidewalkAmount = data["sidewalk_amount"] ?? 0;
        walkwayAmount = data["walkway_amount"] ?? 0;
        tipAmount = data["tip"] ?? 0;
        discountAmount = data["discount_amount"] ?? 0;
        tipPercentage = data["tip_perc"] ?? 0;
        adminFees = data["admin_fee"];
        taxFees = data["tax"] ?? 0;
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

  Future couponReloadSummary(
    String? code,
  ) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var response = await BaseClient().couponCode(
      "/apply-coupon-discount",
      data["id"].toString(),
      code,
    );
    if (response[1] != 500) {
      error = false;
      if (response[0]["message"] == "Unauthenticated.") {
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
        if (response[0]["success"]) {
          applyRemove = "Remove";
          error = false;
          data = response[0]["data"]["order"];
          await localStorage.setString('orderIdToPay', data["id"].toString());
          await localStorage.setString(
              'grandTotal', data["grand_total"].toString());
          grandTotal = data["grand_total"];
          tenPerc = data["total_amount"] * 10 / 100;
          fifteenPerc = data["total_amount"] * 15 / 100;
          twentyPerc = data["total_amount"] * 20 / 100;
          twentyFivePerc = data["total_amount"] * 25 / 100;
          percentage = [
            'Enter tip amount',
            "10% (\$${tenPerc.toStringAsFixed(2)})",
            "15% (\$${fifteenPerc.toStringAsFixed(2)})",
            "20% (\$${twentyPerc.toStringAsFixed(2)})",
            "25% (\$${twentyFivePerc.toStringAsFixed(2)})",
          ];
          snowDepth = data["snow_depth_amount"];
          drivewayAmount = data["driveway_amount"];
          sidewalkAmount = data["sidewalk_amount"] ?? 0;
          walkwayAmount = data["walkway_amount"] ?? 0;
          tipAmount = data["tip"] ?? 0;
          discountAmount = data["discount_amount"] ?? 0;
          tipPercentage = data["tip_perc"] ?? 0;
          adminFees = data["admin_fee"];
          taxFees = data["tax"] ?? 0;
          if (mounted) {
            setState(() {});
          }
        } else {
          if (mounted) {
            setState(() {
              error = true;
              errorText = response[0]["validationErrors"]["code"][0];
            });
          }
        }
      }
    } else {
      if (mounted) {
        setState(() {
          error = true;
          errorText = response[0].toString();
        });
      }
    }
  }

  Future couponRemoveReloadSummary() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var response = await BaseClient().couponCodeRemove(
      "/remove-coupon-discount",
      data["id"].toString(),
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
        applyRemove = "Apply";
        error = false;
        data = response["data"]["order"];
        await localStorage.setString('orderIdToPay', data["id"].toString());
        await localStorage.setString(
            'grandTotal', data["grand_total"].toString());
        grandTotal = data["grand_total"];
        tenPerc = data["total_amount"] * 10 / 100;
        fifteenPerc = data["total_amount"] * 15 / 100;
        twentyPerc = data["total_amount"] * 20 / 100;
        twentyFivePerc = data["total_amount"] * 25 / 100;
        percentage = [
          'Enter tip amount',
          "10% (\$${tenPerc.toStringAsFixed(2)})",
          "15% (\$${fifteenPerc.toStringAsFixed(2)})",
          "20% (\$${twentyPerc.toStringAsFixed(2)})",
          "25% (\$${twentyFivePerc.toStringAsFixed(2)})",
        ];
        snowDepth = data["snow_depth_amount"];
        drivewayAmount = data["driveway_amount"];
        sidewalkAmount = data["sidewalk_amount"] ?? 0;
        walkwayAmount = data["walkway_amount"] ?? 0;
        tipAmount = data["tip"] ?? 0;
        discountAmount = data["discount_amount"] ?? 0;
        tipPercentage = data["tip_perc"] ?? 0;
        adminFees = data["admin_fee"];
        taxFees = data["tax"] ?? 0;
        if (mounted) {
          setState(() {});
        }
      } else {
        if (mounted) {
          setState(() {
            error = true;
            errorText =
                "Something unexpected happened on server. Kindly try again";
          });
        }
      }
    }
  }

  Future getCardWalletFunction() async {
    List jsonResponse = [];
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? wallet = localStorage.getString('wallet');
    walletMap = jsonDecode(wallet!) as Map<String, dynamic>;
    String? cards = localStorage.getString('cards');
    cardsMap = jsonDecode(cards!) as List<dynamic>?;
    walletAmount = walletMap!["amount"].toString();
    jsonResponse = cardsMap!;

    defaultCard =
        jsonResponse.where((element) => element["is_default"] == "1").toList();
    await localStorage.setString('cardCheckBeforePay', jsonEncode(defaultCard));
    if (mounted) {
      setState(() {});
    }

    return defaultCard;
  }

  FutureOr onGoBackPayment(dynamic value) {
    getCardWalletFunction();
    setState(() {});
  }

  void completeFunc() {
    summary().then((value) async {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      await localStorage.setBool("nextOn5", true);
      loading = false;
      getCardWalletFunction();
      setState(() {});
    });
  }

  void remove() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.remove("nextOn5");
  }

  @override
  void initState() {
    super.initState();
    completeFunc();
  }

  @override
  void dispose() {
    remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              const Text("Service Details"),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: loading
                    ? LoadingAnimationWidget.fourRotatingDots(
                        color: HexColor("#0275D8"),
                        size: 40,
                      )
                    : Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Visibility(
                                    visible: error,
                                    child: Column(
                                      children: [
                                        Text(
                                          errorText,
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Driveway"),
                                      Text(
                                        "\$$drivewayAmount",
                                        style: TextStyle(
                                          color: HexColor("#0275D8"),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Visibility(
                                    visible: sidewalkAmount == 0 ? false : true,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Sidewalk"),
                                        Text(
                                          "\$$sidewalkAmount",
                                          style: TextStyle(
                                            color: HexColor("#0275D8"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: walkwayAmount == 0 ? false : true,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Walkway"),
                                            Text(
                                              "\$$walkwayAmount",
                                              style: TextStyle(
                                                color: HexColor("#0275D8"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Snow Depth"),
                                      Text(
                                        "\$$snowDepth",
                                        style: TextStyle(
                                          color: HexColor("#0275D8"),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Schedule Time"),
                                      Text(
                                        "$scheduleTime",
                                        style: TextStyle(
                                          color: HexColor("#0275D8"),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: tipAmount == 0 ? false : true,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Tip %"),
                                            Text(
                                              "\$$tipPercentage",
                                              style: TextStyle(
                                                color: HexColor("#0275D8"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Tip Amount"),
                                            Text(
                                              "\$$tipAmount",
                                              style: TextStyle(
                                                color: HexColor("#0275D8"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Admin fees"),
                                      Text(
                                        "\$$adminFees",
                                        style: TextStyle(
                                          color: HexColor("#0275D8"),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Tax fees"),
                                      Text(
                                        "\$$taxFees",
                                        style: TextStyle(
                                          color: HexColor("#0275D8"),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Visibility(
                                    visible: discountAmount == 0 ? false : true,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Discount"),
                                            Text(
                                              "\$$discountAmount",
                                              style: TextStyle(
                                                color: HexColor("#0275D8"),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(
                                    color: Colors.grey,
                                    // thickness: 3,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text("Grand total"),
                                      Text(
                                        "\$$grandTotal",
                                        style: TextStyle(
                                          color: HexColor("#0275D8"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Tip your service provider",
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Material(
                            elevation: 5.0,
                            shadowColor: Colors.grey,
                            borderRadius: BorderRadius.circular(30),
                            child: DropdownButtonFormField(
                              menuMaxHeight: 400,
                              borderRadius: BorderRadius.circular(30),
                              elevation: 5,
                              dropdownColor: Colors.grey[100],
                              isExpanded: true,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                isDense: true,
                                prefixIcon: Icon(
                                  Icons.monetization_on_outlined,
                                  color: HexColor("#0275D8"),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                border: InputBorder.none,
                              ),
                              iconEnabledColor: HexColor("#0275D8"),
                              value: initialPercVal,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: percentage.map((items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (newValue) async {
                                initialPercVal = newValue!.toString();
                                if (initialPercVal
                                    .contains(tenPerc.toStringAsFixed(2))) {
                                  tip = tenPerc.toStringAsFixed(2);
                                  tipPerc = "10";
                                } else if (initialPercVal
                                    .contains(fifteenPerc.toStringAsFixed(2))) {
                                  tip = fifteenPerc.toStringAsFixed(2);
                                  tipPerc = "15";
                                } else if (initialPercVal
                                    .contains(twentyPerc.toStringAsFixed(2))) {
                                  tip = twentyPerc.toStringAsFixed(2);
                                  tipPerc = "20";
                                } else if (initialPercVal.contains(
                                    twentyFivePerc.toStringAsFixed(2))) {
                                  tip = twentyFivePerc.toStringAsFixed(2);
                                  tipPerc = "25";
                                }
                                if (initialPercVal != 'Enter tip amount') {
                                  loading = true;
                                  reloadSummary(
                                    tip,
                                    tipPerc,
                                    null,
                                  ).then((value) {
                                    loading = false;
                                  });
                                } else if (initialPercVal ==
                                    'Enter tip amount') {
                                  loading = true;
                                  reloadSummary(
                                    "0.00",
                                    "0",
                                    null,
                                  ).then((value) {
                                    loading = false;
                                  });
                                }
                                setState(() {});
                              },
                            ),
                          ),
                          // Visibility(
                          //   visible: recurrTipVisibilty,
                          //   child: Column(
                          //     children: [
                          //       const SizedBox(
                          //         height: 20,
                          //       ),
                          //       ListTile(
                          //         title: const Text(
                          //           'Add this tip percentage only on first order',
                          //           style: TextStyle(fontSize: 12),
                          //         ),
                          //         leading: Radio(
                          //           value: 1,
                          //           groupValue: groupVal,
                          //           onChanged: (int? value) async {
                          //             groupVal = value!;
                          //             if (value == 1) {
                          //               loading = true;
                          //               reloadSummary(
                          //                 tip,
                          //                 tipPerc,
                          //                 "one-time",
                          //               ).then((value) {
                          //                 loading = false;
                          //               });
                          //             }
                          //             setState(() {});
                          //           },
                          //         ),
                          //       ),
                          //       ListTile(
                          //         title: const Text(
                          //           'Add this tip percentage on every recurring order',
                          //           style: TextStyle(fontSize: 12),
                          //         ),
                          //         leading: Radio(
                          //           value: 2,
                          //           groupValue: groupVal,
                          //           onChanged: (int? value) {
                          //             groupVal = value!;
                          //             if (value == 2) {
                          //               loading = true;
                          //               reloadSummary(
                          //                 tip,
                          //                 tipPerc,
                          //                 "recurring",
                          //               ).then((value) {
                          //                 loading = false;
                          //               });
                          //             }
                          //             setState(() {});
                          //           },
                          //         ),
                          //       ),
                          //       const SizedBox(
                          //         height: 10,
                          //       ),
                          //       const Divider(
                          //         color: Colors.grey,
                          //         // thickness: 3,
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          Material(
                            elevation: 5.0,
                            shadowColor: Colors.grey,
                            borderRadius: BorderRadius.circular(30),
                            child: Stack(
                              alignment: Alignment.centerRight,
                              children: [
                                TextFormField(
                                  controller: promoCodeController,
                                  decoration: InputDecoration(
                                    hintText: "Add promo code",
                                    isDense: true,
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: const EdgeInsets.all(10),
                                    border: InputBorder.none,
                                    focusedBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.percent,
                                      color: Colors.red[800],
                                    ),
                                  ),
                                  autofocus: false,
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: TextFormField(
                                              autofocus: true,
                                              onChanged: (value) {
                                                if (mounted) {
                                                  setState(() {
                                                    promoCodeController.text =
                                                        value;
                                                  });
                                                }
                                              },
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                    Colors.grey,
                                                  ),
                                                ),
                                                child: const Text('CANCEL'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                },
                                                child: const Text('SUBMIT'),
                                              ),
                                            ],
                                          );
                                        });
                                  },
                                ),
                                InkWell(
                                  onTap: () {
                                    if (mounted) {
                                      setState(() {
                                        loading = true;
                                      });
                                    }
                                    if (applyRemove == "Apply") {
                                      couponReloadSummary(
                                              promoCodeController.text)
                                          .then((value) {
                                        if (mounted) {
                                          setState(() {
                                            loading = false;
                                          });
                                        }
                                      });
                                    } else {
                                      couponRemoveReloadSummary().then((value) {
                                        if (mounted) {
                                          setState(() {
                                            loading = false;
                                            promoCodeController.text = "";
                                          });
                                        }
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(right: 15),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: HexColor("#E8E8E8"),
                                        ),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            20, 5, 20, 5),
                                        child: Text(
                                          applyRemove,
                                          style: TextStyle(
                                            color: HexColor("#0275D8"),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Material(
                            elevation: 5.0,
                            shadowColor: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                            child: TextFormField(
                              decoration: InputDecoration(
                                isDense: true,
                                fillColor: HexColor("#D6ECFF"),
                                filled: true,
                                contentPadding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  borderSide: BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                suffix: Text(
                                  "\$$grandTotal",
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              initialValue: 'Total',
                              enabled: false,
                              autofocus: false,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          child: loading
              ? null
              : Column(
                  children: [
                    const Divider(
                      color: Colors.grey,
                      // thickness: 3,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 35, 10),
                      child: Row(
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
                          Text(walletAmount != null
                              ? "\$ $walletAmount"
                              : "\$ 0"),
                        ],
                      ),
                    ),
                    SizedBox(
                        child: defaultCard == [] || defaultCard.isEmpty
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType
                                          .rightToLeftWithFade,
                                      // 3
                                      child: const Payment3(),
                                    ),
                                  ).then(onGoBackPayment);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 20, 20, 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      ImageIcon(
                                        AssetImage("images/payment.png"),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text("Add payment method"),
                                    ],
                                  ),
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 5, 20, 0),
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
                                          "    **** **** **** ${defaultCard[0]["last4"]}",
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.done,
                                          color: HexColor("#0275D8"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                  ],
                ),
        ),
      ],
    );
  }
}
 // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     const Text(
          //       "Service Details",
          //       style: TextStyle(fontSize: 16),
          //     ),
          //     Row(
          //       children: [
          //         ElevatedButton.icon(
          //           onPressed: () {},
          //           icon: Icon(
          //             Icons.download,
          //             color: HexColor("#0275D8"),
          //           ),
          //           label: Text(
          //             "Download",
          //             style: TextStyle(
          //               color: HexColor("#0275D8"),
          //             ),
          //           ),
          //           style: ElevatedButton.styleFrom(
          //             backgroundColor: HexColor("#D6ECFF"),
          //           ),
          //         ),
          //         IconButton(
          //           onPressed: () {},
          //           icon: const Icon(Icons.print),
          //         )
          //       ],
          //     )
          //   ],
          // ),