import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../Backend/base_client.dart';
import '../../../../Login/logIn_screen.dart';

class HomeDetails extends StatefulWidget {
  const HomeDetails({super.key});

  @override
  State<HomeDetails> createState() => _HomeDetailsState();
}

class _HomeDetailsState extends State<HomeDetails> {
  // ------------------------
  String groupVal = "small";
  String groupValW = "small";
  int? width;
  int? length;
  inc() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (width == 50) {
      if (mounted) {
        setState(() {
          width = 50;
        });
      }
      await localStorage.setInt('widthH', width!);
    } else {
      if (mounted) {
        setState(() {
          width = width! + 1;
        });
      }
      await localStorage.setInt('widthH', width!);
    }
  }

  dec() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (width == 1) {
      if (mounted) {
        setState(() {
          width = 1;
        });
      }
      await localStorage.setInt('widthH', width!);
    } else {
      if (mounted) {
        setState(() {
          width = width! - 1;
        });
      }
      await localStorage.setInt('widthH', width!);
    }
  }

  incL() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (length == 50) {
      if (mounted) {
        setState(() {
          length = 50;
        });
      }
      await localStorage.setInt('lengthH', length!);
    } else {
      if (mounted) {
        if (mounted) {
          setState(() {
            length = length! + 1;
          });
        }
      }
      await localStorage.setInt('lengthH', length!);
    }
  }

  decL() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (length == 1) {
      if (mounted) {
        setState(() {
          length = 1;
        });
      }
      await localStorage.setInt('lengthH', length!);
    } else {
      if (mounted) {
        setState(() {
          length = length! - 1;
        });
      }
      await localStorage.setInt('lengthH', length!);
    }
  }

  bool? sidewalk;
  bool? walkaway;

  bool loading = true;
  bool error = false;
  String? errorMessage;

  // String? smallSidewalk;
  // int? smallWalkway;

  // int? mediumSidewalk;
  // int? mediumWalkway;

  // int? largeSidewalk;
  // int? largeWalkway;

  String? snowDepthInitValue;
  List snowDepthValues = [
    // '0 - 6 Inches',
    // '6 - 12 Inches',
    // 'More than 12 (Inches)',
  ];
  // ------------------------

  Future getSnowPlowingCatPrSch() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var response = await BaseClient().snowPlowingCatPrSch(
      "/cars-and-schedule",
      "home",
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
        List jsonResponse = response["data"]["snowDepths"];
        snowDepthValues = jsonResponse;
        error = false;

        await localStorage.setString('snowPlowingSchedulesH',
            jsonEncode(response["data"]["snowPlowingSchedules"]));

        int? w = localStorage.getInt('widthH');
        int? l = localStorage.getInt('lengthH');
        bool? side = localStorage.getBool('sidewalkH');
        bool? walk = localStorage.getBool('walkawayH');
        String? Side = localStorage.getString('SidewalkH');
        String? Walk = localStorage.getString('WalkwayH');
        String? snowDepInVal = localStorage.getString('snowDepthInitValueH');

        w == null ? width = 1 : width = w;
        w == null ? await localStorage.setInt('widthH', 1) : null;
        l == null ? length = 1 : length = l;
        l == null ? await localStorage.setInt('lengthH', 1) : null;

        side == null ? sidewalk = false : sidewalk = side;
        side == null ? await localStorage.setBool('sidewalkH', false) : null;
        walk == null ? walkaway = false : walkaway = walk;
        walk == null ? await localStorage.setBool('walkawayH', false) : null;

        Side == null ? groupVal = "small" : groupVal = Side;
        Side == null
            ? await localStorage.setString('SidewalkH', "small")
            : null;
        Walk == null ? groupValW = "small" : groupValW = Walk;
        Walk == null ? await localStorage.setString('WalkwayH', "small") : null;
        if (snowDepInVal == null) {
          snowDepthInitValue = jsonResponse[0]["name"].toString();
          await localStorage.setString(
              'snowDepthInitValueIdH', jsonResponse[0]["id"].toString());
        } else {
          snowDepthInitValue = snowDepInVal;
        }
      } else {
        error = true;
        errorMessage = "${response["message"]}";
      }
    }
  }

  void completeFunct() {
    getSnowPlowingCatPrSch().then((value) async {
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
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: SizedBox(
        child: loading
            ? LoadingAnimationWidget.fourRotatingDots(
                color: HexColor("#0275D8"),
                size: 40,
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
                      const SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            const Text(
                              "Driveway (Select number of cars)",
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      CupertinoAlertDialog(
                                    title: Image.asset("images/driveway.png"),
                                  ),
                                );
                              },
                              child: const Icon(Icons.info_outline),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Material(
                            elevation: 5.0,
                            shadowColor: Colors.grey,
                            borderRadius: BorderRadius.circular(30),
                            child: TextFormField(
                              decoration: InputDecoration(
                                label: const Text("Width of Car(s)"),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                isDense: true,
                                fillColor: Colors.white,
                                filled: true,
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
                                prefixIcon: InkWell(
                                  onTap: () {
                                    dec();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: CircleAvatar(
                                      child: Icon(Icons.remove),
                                    ),
                                  ),
                                ),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    inc();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: CircleAvatar(
                                      child: Icon(Icons.add),
                                    ),
                                  ),
                                ),
                              ),
                              textAlign: TextAlign.center,
                              initialValue: " ",
                              enabled: true,
                              autofocus: false,
                              readOnly: true,
                              onTap: () {},
                            ),
                          ),
                          Text(
                            "$width",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Material(
                            elevation: 5.0,
                            shadowColor: Colors.grey,
                            borderRadius: BorderRadius.circular(30),
                            child: TextFormField(
                              decoration: InputDecoration(
                                label: const Text("Length of Car(s)"),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                isDense: true,
                                fillColor: Colors.white,
                                filled: true,
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
                                prefixIcon: InkWell(
                                  onTap: () {
                                    decL();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: CircleAvatar(
                                      child: Icon(Icons.remove),
                                    ),
                                  ),
                                ),
                                suffixIcon: InkWell(
                                  onTap: () {
                                    incL();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.all(5),
                                    child: CircleAvatar(
                                      child: Icon(Icons.add),
                                    ),
                                  ),
                                ),
                              ),
                              textAlign: TextAlign.center,
                              initialValue: " ",
                              enabled: true,
                              autofocus: false,
                              readOnly: true,
                              onTap: () {},
                            ),
                          ),
                          Text(
                            "$length",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Snow Depth"),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
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
                            contentPadding:
                                const EdgeInsets.fromLTRB(20, 10, 10, 10),
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            border: InputBorder.none,
                          ),
                          iconEnabledColor: HexColor("#0275D8"),
                          value: snowDepthInitValue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: snowDepthValues.map((items) {
                            return DropdownMenuItem(
                              value: items["name"],
                              child: Text(items["name"]),
                            );
                          }).toList(),
                          onChanged: (newValue) async {
                            SharedPreferences localStorage =
                                await SharedPreferences.getInstance();
                            snowDepthInitValue = newValue!.toString();

                            await localStorage.setString('snowDepthInitValueH',
                                snowDepthInitValue.toString());
                            var newVal = snowDepthValues
                                .where((e) => e["name"] == newValue.toString())
                                .toList();
                            await localStorage.setString(
                                'snowDepthInitValueIdH',
                                newVal[0]["id"].toString());

                            if (mounted) {
                              setState(() {});
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Sidewalk",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          const CupertinoAlertDialog(
                                        title: Text(
                                          "Select whether your sidewalk is small, medium, or large",
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Icon(Icons.info_outline),
                                ),
                              ],
                            ),
                            Checkbox(
                              value: sidewalk,
                              onChanged: (bool? value) async {
                                SharedPreferences localStorage =
                                    await SharedPreferences.getInstance();
                                if (mounted) {
                                  setState(() {
                                    sidewalk = value!;
                                  });
                                }
                                await localStorage.setBool(
                                    'sidewalkH', sidewalk!);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: sidewalk ?? false ? 10 : null,
                      ),
                      Visibility(
                        visible: sidewalk ?? false,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 0,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text("Small "),
                                        Text(
                                          "(0-100 sq ft)",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: HexColor("#545454"),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Radio(
                                      value: "small",
                                      groupValue: groupVal,
                                      onChanged: (value) async {
                                        groupVal = value!;
                                        if (value == "small") {
                                          SharedPreferences localStorage =
                                              await SharedPreferences
                                                  .getInstance();
                                          await localStorage.setString(
                                              'SidewalkH', "small");
                                        }
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text("Medium "),
                                        Text(
                                          "(100-200 sq ft)",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: HexColor("#545454"),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Radio(
                                      value: "medium",
                                      groupValue: groupVal,
                                      onChanged: (value) async {
                                        groupVal = value!;
                                        if (value == "medium") {
                                          SharedPreferences localStorage =
                                              await SharedPreferences
                                                  .getInstance();
                                          await localStorage.setString(
                                              'SidewalkH', "medium");
                                        }
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text("Large "),
                                        Text(
                                          "(200-300 sq ft)",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: HexColor("#545454"),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Radio(
                                      value: "large",
                                      groupValue: groupVal,
                                      onChanged: (value) async {
                                        groupVal = value!;
                                        if (value == "large") {
                                          SharedPreferences localStorage =
                                              await SharedPreferences
                                                  .getInstance();
                                          await localStorage.setString(
                                              'SidewalkH', "large");
                                        }
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sidewalk ?? false ? 10 : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Walkway",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          const CupertinoAlertDialog(
                                        title: Text(
                                          "Select weather your walkway is small, medium, or large",
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Icon(Icons.info_outline),
                                ),
                              ],
                            ),
                            Checkbox(
                              value: walkaway,
                              onChanged: (bool? value) async {
                                SharedPreferences localStorage =
                                    await SharedPreferences.getInstance();
                                if (mounted) {
                                  setState(() {
                                    walkaway = value!;
                                  });
                                }
                                await localStorage.setBool(
                                    'walkawayH', walkaway!);
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: walkaway ?? false ? 10 : null,
                      ),
                      Visibility(
                        visible: walkaway ?? false,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                spreadRadius: 0,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text("Small "),
                                        Text(
                                          "(0-100 sq ft)",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: HexColor("#545454"),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Radio(
                                      value: "small",
                                      groupValue: groupValW,
                                      onChanged: (value) async {
                                        groupValW = value!;
                                        if (value == "small") {
                                          SharedPreferences localStorage =
                                              await SharedPreferences
                                                  .getInstance();
                                          await localStorage.setString(
                                              'WalkwayH', "small");
                                        }
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text("Medium "),
                                        Text(
                                          "(100-200 sq ft)",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: HexColor("#545454"),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Radio(
                                      value: "medium",
                                      groupValue: groupValW,
                                      onChanged: (value) async {
                                        groupValW = value!;
                                        if (value == "medium") {
                                          SharedPreferences localStorage =
                                              await SharedPreferences
                                                  .getInstance();
                                          await localStorage.setString(
                                              'WalkwayH', "medium");
                                        }
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Text("Large "),
                                        Text(
                                          "(200-300 sq ft)",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: HexColor("#545454"),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Radio(
                                      value: "large",
                                      groupValue: groupValW,
                                      onChanged: (value) async {
                                        groupValW = value!;
                                        if (value == "large") {
                                          SharedPreferences localStorage =
                                              await SharedPreferences
                                                  .getInstance();
                                          await localStorage.setString(
                                              'WalkwayH', "large");
                                        }
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: walkaway ?? false ? 20 : null,
                      ),
                    ],
                  ),
      ),
    );
  }
}
// snowPlowingSchedules
// sidewalk
// walkaway
// smallSidewalk
// smallWalkway
// mediumSidewalk
// mediumWalkway
// largeSidewalk
// largeWalkway
// snowDepthInitValue
// snowDepthInitValueId