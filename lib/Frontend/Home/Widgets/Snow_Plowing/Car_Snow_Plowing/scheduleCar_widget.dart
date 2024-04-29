import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../Backend/base_client.dart';
import '../../../../Login/logIn_screen.dart';

class ScheduleCar extends StatefulWidget {
  const ScheduleCar({super.key});

  @override
  State<ScheduleCar> createState() => _ScheduleCarState();
}

class _ScheduleCarState extends State<ScheduleCar> {
  DateTime now = DateTime.now();
  DateTime? selectedDate;
  final myController = TextEditingController();
  bool loading = true;
  List<int> items = [];
  List<Color> colors = [
    HexColor("#D7E5F1"),
    Colors.white,
    Colors.white,
  ];
  List name = [];

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
    var decode = localStorage.getString('snowPlowingSchedulesC');
    var decodeColor = localStorage.getString('snowPlowingScheduleSelectedC');
    name = jsonDecode(decode!);
    if (decodeColor != null) {
      var dec = jsonDecode(decodeColor);
      var selected = name.indexWhere((element) => element["id"] == dec["id"]);
      changeColorW(selected);
    } else {
      await localStorage.setString(
        'snowPlowingScheduleSelectedC',
        jsonEncode(name[0]),
      );
    }
    items = List.generate(3, (ind) => ind).toList();
  }

  void completeFunct() {
    schedules().then((value) async {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      await localStorage.setBool("nextOn4", true);
      loading = false;
      if (mounted) {
        setState(() {});
      }
    });
  }

  void remove() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.remove("nextOn4");
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
      child: Column(
        children: [
          Stack(
            alignment: Alignment.centerRight,
            children: [
              InkWell(
                onTap: () {
                  if (_visible) {
                    if (mounted) {
                      if (mounted) {
                        setState(() {
                          _visible = false;
                        });
                      }
                    }
                  } else {
                    if (mounted) {
                      setState(() {
                        _visible = true;
                      });
                    }
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 15,
                      child: CircleAvatar(
                        radius: 13,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.question_mark_outlined,
                      size: 18,
                      color: HexColor("#0275D8"),
                    ),
                  ],
                ),
              ),
              const Align(
                child: Text(
                  "Schedule",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
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
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: HexColor("#D6ECFF"),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: Column(
                              children: [
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: items.length,
                                  itemBuilder: (con, ind) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 10),
                                      child: InkWell(
                                        onTap: () async {
                                          SharedPreferences localStorage =
                                              await SharedPreferences
                                                  .getInstance();
                                          changeColorW(ind);
                                          await localStorage.setString(
                                            'snowPlowingScheduleSelectedC',
                                            jsonEncode(name[ind]),
                                          );
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(30),
                                            ),
                                            color: colors[ind],
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child:
                                                      Text(name[ind]["name"]),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(20),
                                                    ),
                                                    border: Border.all(
                                                      color:
                                                          HexColor("#E8E8E8"),
                                                    ),
                                                    color: colors[ind],
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      name[ind]["time"],
                                                      style: TextStyle(
                                                        color:
                                                            HexColor("#0275D8"),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: _visible,
                            child: Container(
                              decoration: BoxDecoration(
                                color: HexColor("#D6ECFF"),
                                border: Border.all(
                                  color: HexColor("#7CC0FB"),
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Column(
                                children: const [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                        "Our providers try hard to complete all their jobs within the time window listed. During big storms some times may vary due to traffic, longer times on each job, and conditions."),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text(
                                        "Once you order you will have eyes on your provider to see how far he is from your location. You will also be able to text your provider once your job is ordered."),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
