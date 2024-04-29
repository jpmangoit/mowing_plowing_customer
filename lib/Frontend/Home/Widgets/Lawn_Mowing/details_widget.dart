import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Backend/base_client.dart';
import '../../../Login/logIn_screen.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> with TickerProviderStateMixin {
  late var colorTween;
  TextEditingController gateCode = TextEditingController();
  late AnimationController controller;
  List sizes = [];
  List height = [];
  bool? cornerLot;
  bool? fence;
  List overUnder52 = [];
  bool? over52;
  bool? under52;
  bool? yardBeforeMow;
  List cleanUp = [];
  bool? light;
  bool? heavy;
  bool loading = true;
  String? initialSizeVal;
  String? initialHeightVal;

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

  Future getsizesHeightsPrices() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var response = await BaseClient().sizesHeightsPrices(
      "/sizes-heights-prices",
    );
    if (json.decode(response.body)["message"] == "Unauthenticated.") {
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
      if (json.decode(response.body)["success"]) {
        List jsonResponseS = json.decode(response.body)["data"]["sizes"];
        sizes = jsonResponseS;
        List jsonResponseH = json.decode(response.body)["data"]["heights"];
        height = jsonResponseH;
        List jsonResponseF = json.decode(response.body)["data"]["fences"];
        overUnder52 = jsonResponseF;
        String todayCharges =
            json.decode(response.body)["data"]["todayCharges"];
        await localStorage.setString('todayChargesL', todayCharges);
        var res = await BaseClient().lawnSizeCleanupPrice(
          "/lawn-size-cleanup-price",
          jsonResponseS[0]["id"].toString(),
        );
        if (res["message"] == "Unauthenticated.") {
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
          if (res["success"]) {
            cleanUp = res["data"]["cleanUps"];
          } else {
            final snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Alert!',
                message: '${res["message"]}',
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
        if (localStorage.getString('sizeL') == null ||
            localStorage.getString('heightL') == null) {
          initialSizeVal = jsonResponseS[0]["name"];
          await localStorage.setString('sizeL', jsonResponseS[0]["name"]);
          await localStorage.setString(
              'sizeIdL', jsonResponseS[0]["id"].toString());
          initialHeightVal = jsonResponseH[0]["name"];
          await localStorage.setString('heightL', jsonResponseH[0]["name"]);
          await localStorage.setString(
              'heightIdL', jsonResponseH[0]["id"].toString());
          cornerLot = false;
          await localStorage.setBool('cornerLotL', false);
          fence = false;
          await localStorage.setBool('fenceL', false);
          over52 = true;
          await localStorage.setBool('over52L', true);
          await localStorage.setString(
              'fenceIdL', overUnder52[0]["id"].toString());
          under52 = false;
          await localStorage.setBool('under52L', false);
          gateCode = TextEditingController();
          await localStorage.setString('gateCodeL', gateCode.text);
          yardBeforeMow = false;
          await localStorage.setBool('yardBeforeMowL', false);
          light = true;
          await localStorage.setBool('lightL', true);
          await localStorage.setString(
              'cleanUpIdL', cleanUp[0]["id"].toString());
          heavy = false;
          await localStorage.setBool('heavyL', false);
        } else {
          initialSizeVal = localStorage.getString('sizeL');
          initialHeightVal = localStorage.getString('heightL');
          cornerLot = localStorage.getBool('cornerLotL');
          fence = localStorage.getBool('fenceL');
          over52 = localStorage.getBool('over52L');
          under52 = localStorage.getBool('under52L');
          var gateCodeText = localStorage.getString('gateCodeL');
          gateCode = TextEditingController(text: gateCodeText);
          yardBeforeMow = localStorage.getBool('yardBeforeMowL');
          light = localStorage.getBool('lightL');
          heavy = localStorage.getBool('heavyL');
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
            message: '${json.decode(response.body)["message"]}',
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
    getsizesHeightsPrices().then((value) async {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      await localStorage.setBool("nextOn1", true);
      loading = false;
      if (mounted) {
        setState(() {});
      }
    });
  }

  void remove() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.remove("nextOn1");
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
    );
    colorTween = controller.drive(
      ColorTween(
        begin: HexColor("#0275D8"),
        end: HexColor("#24B550"),
      ),
    );
    completeFunct();
  }

  @override
  void dispose() {
    remove();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Details",
          style: TextStyle(fontSize: 16),
        ),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Lawn size (in acres)"),
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
                                  Icons.photo_size_select_small,
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
                              value: initialSizeVal,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: sizes.map((items) {
                                return DropdownMenuItem(
                                  value: items["name"],
                                  child: Text(items["name"]),
                                );
                              }).toList(),
                              onChanged: (newValue) async {
                                initialSizeVal = newValue!.toString();
                                SharedPreferences localStorage =
                                    await SharedPreferences.getInstance();
                                await localStorage.setString(
                                    'sizeL', newValue.toString());
                                var newVal = sizes
                                    .where(
                                        (e) => e["name"] == newValue.toString())
                                    .toList();
                                await localStorage.setString(
                                    'sizeIdL', newVal[0]["id"].toString());
                                var res =
                                    await BaseClient().lawnSizeCleanupPrice(
                                  "/lawn-size-cleanup-price",
                                  newVal[0]["id"].toString(),
                                );
                                if (res["success"]) {
                                  cleanUp = res["data"]["cleanUps"];
                                }
                                if (mounted) {
                                  setState(() {});
                                }
                                await localStorage.setString(
                                    'cleanUpIdL', cleanUp[0]["id"].toString());
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Lawn height (in inches)"),
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
                                  Icons.landscape_outlined,
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
                              value: initialHeightVal,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: height.map((items) {
                                return DropdownMenuItem(
                                  value: items["name"],
                                  child: Text(items["name"]),
                                );
                              }).toList(),
                              onChanged: (newValue) async {
                                SharedPreferences localStorage =
                                    await SharedPreferences.getInstance();
                                initialHeightVal = newValue!.toString();
                                await localStorage.setString(
                                    'heightL', newValue.toString());
                                var newVal = height
                                    .where(
                                        (e) => e["name"] == newValue.toString())
                                    .toList();
                                await localStorage.setString(
                                    'heightIdL', newVal[0]["id"].toString());
                                if (mounted) {
                                  setState(() {});
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Do you have a corner lot?"),
                          Checkbox(
                            value: cornerLot ?? false,
                            onChanged: (bool? value) async {
                              cornerLot = value!;
                              SharedPreferences localStorage =
                                  await SharedPreferences.getInstance();
                              await localStorage.setBool('cornerLotL', value);
                              if (mounted) {
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: Divider(
                        color: Colors.grey,
                        // thickness: 3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Do you have a fence?"),
                          Checkbox(
                            value: fence ?? false,
                            onChanged: (bool? value) async {
                              fence = value!;
                              SharedPreferences localStorage =
                                  await SharedPreferences.getInstance();
                              await localStorage.setBool('fenceL', value);
                              if (mounted) {
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      child: Divider(
                        color: Colors.grey,
                        // thickness: 3,
                      ),
                    ),
                    Visibility(
                      visible: fence == true && fence != null ? true : false,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Material(
                              elevation: 5.0,
                              shadowColor: Colors.grey,
                              borderRadius: BorderRadius.circular(30),
                              child: InkWell(
                                onTap: () async {
                                  over52 = true;
                                  under52 = false;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                  SharedPreferences localStorage =
                                      await SharedPreferences.getInstance();
                                  await localStorage.setBool(
                                      'over52L', over52!);
                                  await localStorage.setBool(
                                      'under52L', under52!);
                                  await localStorage.setString('fenceIdL',
                                      overUnder52[0]["id"].toString());
                                },
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    fillColor: over52 == true && over52 != null
                                        ? HexColor("#D7E5F1")
                                        : Colors.white,
                                    filled: true,
                                    contentPadding: const EdgeInsets.all(10),
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.fence,
                                      color: HexColor("#0275D8"),
                                    ),
                                    suffix: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: HexColor("#E8E8E8")),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 10, 5),
                                        child: Text(
                                          "\$${overUnder52[0]["price"]}",
                                          style: TextStyle(
                                            color: HexColor("#0275D8"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  initialValue: 'Over 52 Inches',
                                  enabled: false,
                                  autofocus: false,
                                  onTap: () {},
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
                              borderRadius: BorderRadius.circular(30),
                              child: InkWell(
                                onTap: () async {
                                  under52 = true;
                                  over52 = false;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                  SharedPreferences localStorage =
                                      await SharedPreferences.getInstance();
                                  await localStorage.setBool(
                                      'over52L', over52!);
                                  await localStorage.setBool(
                                      'under52L', under52!);
                                  await localStorage.setString('fenceIdL',
                                      overUnder52[1]["id"].toString());
                                },
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    fillColor:
                                        under52 == true && under52 != null
                                            ? HexColor("#D7E5F1")
                                            : Colors.white,
                                    filled: true,
                                    contentPadding: const EdgeInsets.all(10),
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.fence,
                                      color: HexColor("#0275D8"),
                                    ),
                                    suffix: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: HexColor("#E8E8E8")),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 10, 5),
                                        child: Text(
                                          "\$${overUnder52[1]["price"]}",
                                          style: TextStyle(
                                            color: HexColor("#0275D8"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  initialValue: 'Under 52 Inches',
                                  enabled: false,
                                  autofocus: false,
                                  onTap: () {},
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
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Material(
                        elevation: 5.0,
                        shadowColor: Colors.grey,
                        borderRadius: BorderRadius.circular(30),
                        child: TextFormField(
                          controller: gateCode,
                          decoration: InputDecoration(
                            hintText: "Enter gate code (if any)",
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
                              Icons.key,
                              color: HexColor("#0275D8"),
                            ),
                          ),
                          autofocus: false,
                          readOnly: true,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: TextFormField(
                                      // controller: gateCode,
                                      autofocus: true,
                                      onChanged: (value) async {
                                        SharedPreferences localStorage =
                                            await SharedPreferences
                                                .getInstance();
                                        gateCode.text = value;
                                        await localStorage.setString(
                                            'gateCodeL', gateCode.text);
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      },
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {},
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
                                        },
                                        child: const Text('SUBMIT'),
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                              "Do you need a yard cleanup before your mow?"),
                          Checkbox(
                            value: yardBeforeMow ?? false,
                            onChanged: (bool? value) async {
                              yardBeforeMow = value!;
                              SharedPreferences localStorage =
                                  await SharedPreferences.getInstance();
                              await localStorage.setBool(
                                  'yardBeforeMowL', value);
                              if (mounted) {
                                setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: yardBeforeMow == true && yardBeforeMow != null
                          ? true
                          : false,
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            child: Divider(
                              color: Colors.grey,
                              // thickness: 3,
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
                              borderRadius: BorderRadius.circular(30),
                              child: InkWell(
                                onTap: () async {
                                  light = true;
                                  heavy = false;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                  SharedPreferences localStorage =
                                      await SharedPreferences.getInstance();
                                  await localStorage.setBool('lightL', light!);
                                  await localStorage.setBool('heavyL', heavy!);
                                  await localStorage.setString('cleanUpIdL',
                                      cleanUp[0]["id"].toString());
                                },
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    fillColor: light == true && light != null
                                        ? HexColor("#D7E5F1")
                                        : Colors.white,
                                    filled: true,
                                    contentPadding: const EdgeInsets.all(10),
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.cleaning_services_sharp,
                                      color: HexColor("#0275D8"),
                                    ),
                                    suffix: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: HexColor("#E8E8E8")),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 10, 5),
                                        child: Text(
                                          "\$${cleanUp[0]["price"]}",
                                          style: TextStyle(
                                            color: HexColor("#0275D8"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  initialValue: 'Light Cleanup',
                                  enabled: false,
                                  autofocus: false,
                                  onTap: () {},
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
                              borderRadius: BorderRadius.circular(30),
                              child: InkWell(
                                onTap: () async {
                                  heavy = true;
                                  light = false;
                                  if (mounted) {
                                    setState(() {});
                                  }
                                  SharedPreferences localStorage =
                                      await SharedPreferences.getInstance();
                                  await localStorage.setBool('lightL', light!);
                                  await localStorage.setBool('heavyL', heavy!);
                                  await localStorage.setString('cleanUpIdL',
                                      cleanUp[1]["id"].toString());
                                },
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    fillColor: heavy == true && heavy != null
                                        ? HexColor("#D7E5F1")
                                        : Colors.white,
                                    filled: true,
                                    contentPadding: const EdgeInsets.all(10),
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(30),
                                      ),
                                      borderSide: BorderSide(
                                        width: 0,
                                        style: BorderStyle.none,
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.cleaning_services_sharp,
                                      color: HexColor("#0275D8"),
                                    ),
                                    suffix: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: HexColor("#E8E8E8")),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 10, 5),
                                        child: Text(
                                          "\$${cleanUp[1]["price"]}",
                                          style: TextStyle(
                                            color: HexColor("#0275D8"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  initialValue: 'Heavy Cleanup',
                                  enabled: false,
                                  autofocus: false,
                                  onTap: () {},
                                ),
                              ),
                            ),
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
      ],
    );
  }
}
