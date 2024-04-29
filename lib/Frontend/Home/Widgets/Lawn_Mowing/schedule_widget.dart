import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  bool loading = true;
  bool? sameDay;
  bool? selectDate;
  String? sameDayPrice;
  DateTime now = DateTime.now();
  DateTime? selectedDate;
  TextEditingController dateController = TextEditingController();

  Future scheduleData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    sameDayPrice = localStorage.getString('todayChargesL');
    if (localStorage.getBool('sameDayL') == null &&
        localStorage.getBool('selectDateL') == null) {
      sameDay = true;
      await localStorage.setBool('sameDayL', true);
      selectDate = false;
      await localStorage.setBool('selectDateL', false);
      dateController = TextEditingController();
      await localStorage.setString('dateControllerL', dateController.text);
    } else {
      sameDay = localStorage.getBool('sameDayL');
      selectDate = localStorage.getBool('selectDateL');
      var dateControllerText = localStorage.getString('dateControllerL');
      dateController = TextEditingController(text: dateControllerText);
    }
  }

  void completeFunct() {
    scheduleData().then((value) async {
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
          const Text(
            "Schedule",
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
                      Container(
                        decoration: BoxDecoration(
                          color: HexColor("#D6ECFF"),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 15, 10, 20),
                          child: Column(
                            children: [
                              Material(
                                elevation: 5.0,
                                shadowColor: Colors.grey,
                                borderRadius: BorderRadius.circular(30),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    isDense: true,
                                    fillColor: sameDay ?? false
                                        ? HexColor("#D7E5F1")
                                        : Colors.white,
                                    filled: true,
                                    // contentPadding:
                                    //     const EdgeInsets.fromLTRB(20, 10, 10, 10),
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
                                    suffix: Container(
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
                                            10, 0, 10, 0),
                                        child: Text(
                                          "\$$sameDayPrice",
                                          style: TextStyle(
                                            color: HexColor("#0275D8"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  initialValue: 'Same day service',
                                  readOnly: true,
                                  autofocus: false,
                                  onTap: () async {
                                    SharedPreferences localStorage =
                                        await SharedPreferences.getInstance();
                                    if (mounted) {
                                      setState(() {
                                        sameDay = true;
                                        selectDate = false;
                                      });
                                    }
                                    await localStorage.setBool(
                                        'sameDayL', true);
                                    await localStorage.setBool(
                                        'selectDateL', false);
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "You will be charged extra for same day service.",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Material(
                                elevation: 5.0,
                                shadowColor: Colors.grey,
                                borderRadius: BorderRadius.circular(30),
                                child: TextFormField(
                                  controller: dateController,
                                  decoration: InputDecoration(
                                    hintText: 'Select a date',
                                    isDense: true,
                                    fillColor: selectDate ?? false
                                        ? HexColor("#D7E5F1")
                                        : Colors.white,
                                    filled: true,
                                    // contentPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                                  ),
                                  readOnly: true,
                                  autofocus: false,
                                  onTap: () async {
                                    SharedPreferences localStorage =
                                        await SharedPreferences.getInstance();
                                    sameDay = false;
                                    selectDate = true;
                                    await localStorage.setBool(
                                        'sameDayL', false);
                                    await localStorage.setBool(
                                        'selectDateL', true);
                                    selectedDate = await showDatePicker(
                                      context: context,
                                      initialDate: now,
                                      firstDate: now,
                                      lastDate:
                                          now.add(const Duration(days: 15)),
                                    );
                                    if (selectedDate == null) {
                                      return;
                                    }
                                    dateController.text =
                                        "${selectedDate!.month}/${selectedDate!.day}/${selectedDate!.year}";
                                    await localStorage.setString(
                                        'dateControllerL', dateController.text);
                                    if (mounted) {
                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "You can schedule this job for up to 2 weeks.",
                                  style: TextStyle(fontSize: 12),
                                ),
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
                          "Note:",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Material(
                        elevation: 5.0,
                        shadowColor: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        child: TextFormField(
                          minLines: 3,
                          maxLines: 3,
                          // controller: myController,
                          decoration: const InputDecoration(
                            hintText:
                                'Same day service may not be available in some areas.',
                            hintStyle:
                                TextStyle(fontSize: 13, color: Colors.black),
                            isDense: true,
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
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
                          ),
                          readOnly: true,
                          autofocus: false,
                          onTap: () async {},
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
    );
  }
}
