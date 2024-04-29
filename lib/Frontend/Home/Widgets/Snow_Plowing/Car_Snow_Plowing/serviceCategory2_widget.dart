import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../Backend/base_client.dart';
import '../../../../Login/logIn_screen.dart';

class ServiceCategory2 extends StatefulWidget {
  const ServiceCategory2({super.key});

  @override
  State<ServiceCategory2> createState() => _ServiceCategory2State();
}

class _ServiceCategory2State extends State<ServiceCategory2> {
  TextEditingController plateNumber = TextEditingController();
  String? initialColVal;
  List colorsDrop = [];
  bool loading = true;
  bool error = false;
  String? errorMessage;
  List<int> items = [];
  List<Color> colors = [
    HexColor("#D7E5F1"),
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];
  List name = [];

  // create some values
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

  void changeColorW(index) {
    colors[colors.indexWhere((element) => element == HexColor("#D7E5F1"))] =
        Colors.white;
    changeState(index, HexColor("#D7E5F1"));
  }

  void changeState(index, color) {
    if (mounted) {
      setState(() {
        colors[index] = color;
      });
    }
  }

  bool _visible = false;

  Future schedules() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var response = await BaseClient().snowPlowingCatPrSch(
      "/cars-and-schedule",
      "car",
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
        error = false;
        await localStorage.setString('snowPlowingSchedulesC',
            jsonEncode(response["data"]["snowPlowingSchedules"]));
        var decode = jsonEncode(response["data"]["carTypes"]);
        var decodeCol = jsonEncode(response["data"]["colors"]);
        var decodeCar = localStorage.getString('carSelectedC');
        var decodeColor = localStorage.getString('currentColorC');
        var carPlateNo = localStorage.getString('carPlateNoC');
        name = jsonDecode(decode);
        colorsDrop = jsonDecode(decodeCol);
        if (decodeCar != null) {
          var dec = jsonDecode(decodeCar);
          var selected =
              name.indexWhere((element) => element["id"] == dec["id"]);
          changeColorW(selected);
        } else {
          await localStorage.setString(
            'carSelectedC',
            jsonEncode(name[0]),
          );
        }
        if (decodeColor != null) {
          initialColVal = decodeColor;
        } else {
          initialColVal = colorsDrop[0]["name"];
          await localStorage.setString(
            'currentColorC',
            colorsDrop[0]["name"],
          );
          await localStorage.setString(
              'currentColorIdC', colorsDrop[0]["id"].toString());
        }
        if (carPlateNo == null) {
          plateNumber = TextEditingController();
          await localStorage.setString('carPlateNoC', plateNumber.text);
        } else {
          var plateNumberText = localStorage.getString('carPlateNoC');
          plateNumber = TextEditingController(text: plateNumberText);
        }
        items = List.generate(8, (ind) => ind).toList();
      } else {
        error = true;
        errorMessage = "${response["message"]}";
      }
    }
  }

// ValueChanged<Color> callback
  void changeColor(Color color) {
    if (mounted) {
      setState(() => pickerColor = color);
    }
  }

  void completeFunct() {
    schedules().then((value) async {
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
  void initState() {
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
    return Column(
      children: [
        const Text("Where do you need service?"),
        SizedBox(
          child: loading
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 15),
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: HexColor("#0275D8"),
                    size: 40,
                  ),
                )
              : error
                  ? Text(
                      errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    )
                  : Column(
                      children: [
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: items.length,
                          itemBuilder: (con, ind) {
                            return InkWell(
                              onTap: () async {
                                SharedPreferences localStorage =
                                    await SharedPreferences.getInstance();
                                changeColorW(ind);
                                await localStorage.setString(
                                  'carSelectedC',
                                  jsonEncode(name[ind]),
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                child: Material(
                                  elevation: 5.0,
                                  shadowColor: Colors.grey,
                                  borderRadius: BorderRadius.circular(30),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      isDense: true,
                                      fillColor: colors[ind],
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
                                      prefixIcon: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: ImageIcon(
                                          const AssetImage("images/car.png"),
                                          color: HexColor("#0275D8"),
                                        ),
                                      ),
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                        minWidth: 40,
                                        maxWidth: 40,
                                        minHeight: 40,
                                        maxHeight: 40,
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
                                            "\$${name[ind]["price"]}",
                                            style: TextStyle(
                                              color: HexColor("#0275D8"),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    initialValue: name[ind]["name"],
                                    enabled: false,
                                    autofocus: false,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(
                            children: [
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Choose color"),
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
                                  value: initialColVal,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  items: colorsDrop.map((items) {
                                    return DropdownMenuItem(
                                      value: items["name"],
                                      child: Text(items["name"]),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) async {
                                    initialColVal = newValue!.toString();

                                    SharedPreferences localStorage =
                                        await SharedPreferences.getInstance();
                                    await localStorage.setString(
                                        'currentColorC', newValue.toString());

                                    var newVal = colorsDrop
                                        .where((e) =>
                                            e["name"] == newValue.toString())
                                        .toList();
                                    await localStorage.setString(
                                        'currentColorIdC',
                                        newVal[0]["id"].toString());

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
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Material(
                            elevation: 5.0,
                            shadowColor: Colors.grey,
                            borderRadius: BorderRadius.circular(30),
                            child: TextFormField(
                              controller: plateNumber,
                              decoration: InputDecoration(
                                hintText: "Enter car plate number",
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
                                prefixIcon: ImageIcon(
                                  const AssetImage("images/plateno.png"),
                                  color: HexColor("#0275D8"),
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
                                          onChanged: (value) async {
                                            SharedPreferences localStorage =
                                                await SharedPreferences
                                                    .getInstance();
                                            plateNumber.text = value;
                                            await localStorage.setString(
                                                'carPlateNoC',
                                                plateNumber.text);
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
                                              FocusScope.of(context).unfocus();
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
                      ],
                    ),
        ),
      ],
    );
  }
}
