import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Backend/base_client.dart';
import '../Chat/chat_screen.dart';
import '../Login/logIn_screen.dart';
import '../Review/review_screen.dart';
import '../Services/serviceDetails_screen.dart';
import '../Services/trackService_screen.dart';

class Appointments extends StatefulWidget {
  const Appointments({super.key});

  @override
  State<Appointments> createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments>
    with TickerProviderStateMixin {
  late var colorTween;
  late AnimationController controller;
  Future<List<DataUp>>? futureDataUp;
  Future<List<DataOn>>? futureDataOn;
  Future<List<DataCompl>>? futureDataOnCompl;
  Future<List<DataOnCanc>>? futureDataOnCanc;
  late TabController _controller;

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

  Future<List<DataOn>> getOnGoingJobFunction() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var response = await BaseClient().getJobs(
      "/jobs/ongoing-jobs",
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
      throw Exception('${json.decode(response.body)["message"]}');
    } else {
      if (json.decode(response.body)["success"]) {
        await localStorage.setString("cancelJobFeeOn",
            json.decode(response.body)["data"]["cancelJobFee"]);
        List jsonResponse = json.decode(response.body)["data"]["jobs"];
        return jsonResponse.map((data) => DataOn.fromJson(data)).toList();
      } else {
        throw Exception('${json.decode(response.body)["message"]}');
      }
    }
  }

  Future<List<DataUp>> getUpComingJobFunction() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var response = await BaseClient().getJobs(
      "/jobs/upcoming-jobs",
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
      throw Exception('${json.decode(response.body)["message"]}');
    } else {
      if (json.decode(response.body)["success"]) {
        await localStorage.setString("cancelJobFeeUp",
            json.decode(response.body)["data"]["cancelJobFee"]);
        List jsonResponse = json.decode(response.body)["data"]["jobs"];
        return jsonResponse.map((data) => DataUp.fromJson(data)).toList();
      } else {
        throw Exception('${json.decode(response.body)["message"]}');
      }
    }
  }

  Future<List<DataCompl>> getCompletedJobFunction() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var response = await BaseClient().getJobs(
      "/jobs/completed-jobs",
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
      throw Exception('${json.decode(response.body)["message"]}');
    } else {
      if (json.decode(response.body)["success"]) {
        await localStorage.setString("cancelJobFeeCo",
            json.decode(response.body)["data"]["cancelJobFee"]);
        List jsonResponse = json.decode(response.body)["data"]["jobs"];
        return jsonResponse.map((data) => DataCompl.fromJson(data)).toList();
      } else {
        throw Exception('${json.decode(response.body)["message"]}');
      }
    }
  }

  Future<List<DataOnCanc>> getCancelledJobFunction() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var response = await BaseClient().getJobs(
      "/jobs/canceled-jobs",
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
      throw Exception('${json.decode(response.body)["message"]}');
    } else {
      if (json.decode(response.body)["success"]) {
        await localStorage.setString("cancelJobFeeCa",
            json.decode(response.body)["data"]["cancelJobFee"]);
        List jsonResponse = json.decode(response.body)["data"]["jobs"];
        return jsonResponse.map((data) => DataOnCanc.fromJson(data)).toList();
      } else {
        throw Exception('${json.decode(response.body)["message"]}');
      }
    }
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
    );
    _controller = TabController(length: 4, vsync: this);
    _controller.addListener(() {
      if (_controller.index == 0) {
        futureDataUp = getUpComingJobFunction();
        if (mounted) {
          setState(() {});
        }
      } else if (_controller.index == 1) {
        futureDataOn = getOnGoingJobFunction();
        if (mounted) {
          setState(() {});
        }
      } else if (_controller.index == 2) {
        futureDataOnCompl = getCompletedJobFunction();
        if (mounted) {
          setState(() {});
        }
      } else if (_controller.index == 3) {
        futureDataOnCanc = getCancelledJobFunction();
        if (mounted) {
          setState(() {});
        }
      }
    });
    colorTween = controller.drive(
      ColorTween(
        begin: HexColor("#0275D8"),
        end: HexColor("#24B550"),
      ),
    );
    futureDataUp = getUpComingJobFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Appointments",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          bottom: TabBar(
            labelColor: Colors.black,
            controller: _controller,
            tabs: [
              SizedBox(
                child: Tab(
                  height: 60,
                  child: Text(
                    "Upcoming",
                    style: TextStyle(
                      fontSize: size.width * 0.03,
                    ),
                  ),
                ),
              ),
              Tab(
                height: 60,
                child: Text(
                  "Ongoing",
                  style: TextStyle(
                    fontSize: size.width * 0.03,
                  ),
                ),
              ),
              Tab(
                height: 60,
                child: Text(
                  "Completed",
                  style: TextStyle(
                    fontSize: size.width * 0.03,
                  ),
                ),
              ),
              Tab(
                height: 60,
                child: Text(
                  "Cancelled",
                  style: TextStyle(
                    fontSize: size.width * 0.03,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _controller,
          children: [
            // 1
            SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    child: FutureBuilder<List<DataUp>>(
                      future: futureDataUp,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && mounted) {
                          List<DataUp>? data = snapshot.data;
                          return data!.isEmpty
                              ? Column(
                                  children: const [
                                    SizedBox(
                                      height: 60,
                                    ),
                                    Text(
                                      "No Upcoming jobs yet",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  itemCount: data.length,
                                  // itemCount: _properties.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Material(
                                              elevation: 5,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: HexColor("#ECECEC"),
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        // data[index]
                                                        //         .images
                                                        //         .isEmpty
                                                        //     ?
                                                        Image.asset(
                                                          'images/logo3.png',
                                                          height: 80,
                                                          width: 80,
                                                          fit: BoxFit.fill,
                                                        )
                                                        // : Padding(
                                                        //     padding:
                                                        //         const EdgeInsets
                                                        //             .all(5),
                                                        //     child: Image
                                                        //         .network(
                                                        //       imageUrl +
                                                        //           data[index]
                                                        //                   .images[0]
                                                        //               [
                                                        //               "image"],
                                                        //       height: 80,
                                                        //       width: 80,
                                                        //       fit: BoxFit
                                                        //           .fill,
                                                        //     ),
                                                        //   )
                                                        ,
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                              5,
                                                              10,
                                                              10,
                                                              10,
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      data[index].service_for ==
                                                                              null
                                                                          ? "Lawn Mowing"
                                                                          : "Snow Plowing ${data[index].service_for}",
                                                                    ),
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              HexColor("#24B550"),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(5),
                                                                        child:
                                                                            Text(
                                                                          "\$${data[index].grand_total}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                HexColor("#24B550"),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        data[index]
                                                                            .address,
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Service Provider : ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                    Text(
                                                                      data[index]
                                                                              .assigned_to ??
                                                                          "Not assigned",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: HexColor(
                                                                            "#24B550"),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Recurring Status : ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                    Text(
                                                                      data[index].period ==
                                                                              null
                                                                          ? "One time"
                                                                          : data[index]
                                                                              .period!,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: HexColor(
                                                                            "#24B550"),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      color: Colors.grey[400],
                                                      height: 1,
                                                      thickness: 1,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                        10,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Due date: ${data[index].date}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        10),
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    SharedPreferences
                                                                        localStorage =
                                                                        await SharedPreferences
                                                                            .getInstance();
                                                                    String?
                                                                        fee =
                                                                        localStorage
                                                                            .getString("cancelJobFeeUp");
                                                                    // ignore: use_build_context_synchronously
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder: (BuildContext
                                                                              context) =>
                                                                          CupertinoAlertDialog(
                                                                        title: Text(data[index].period ==
                                                                                null
                                                                            ? "Are you sure you want to cancel the service?"
                                                                            : "Are you sure you want to cancel the service? You will be charged \$$fee service fee to cancel this job"),
                                                                        actions: [
                                                                          CupertinoDialogAction(
                                                                            onPressed:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            isDefaultAction:
                                                                                true,
                                                                            child:
                                                                                const Text("No"),
                                                                          ),
                                                                          CupertinoDialogAction(
                                                                            onPressed:
                                                                                () async {
                                                                              var response = await BaseClient().deleteJob(
                                                                                "/jobs/cancel/${data[index].id}",
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
                                                                                  if (mounted) {
                                                                                    data.removeWhere((e) => e.id == data[index].id);
                                                                                    if (mounted) {
                                                                                      setState(() {});
                                                                                    }
                                                                                    Navigator.pop(context);
                                                                                    QuickAlert.show(
                                                                                      context: context,
                                                                                      type: QuickAlertType.info,
                                                                                      title: "Job Cancelled",
                                                                                      text: 'Job has been cancelled',
                                                                                      cancelBtnText: "Ok",
                                                                                      confirmBtnColor: Colors.yellow[600]!,
                                                                                      showCancelBtn: false,
                                                                                    );
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
                                                                            isDefaultAction:
                                                                                true,
                                                                            child:
                                                                                const Text("Yes"),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                    "Cancel",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .red,
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      PageTransition(
                                                                        type: PageTransitionType
                                                                            .rightToLeftWithFade,
                                                                        // 1
                                                                        child:
                                                                            ServiceDetails(
                                                                          jobType:
                                                                              'Upcoming',
                                                                          jobId: data[index]
                                                                              .id
                                                                              .toString(),
                                                                          address:
                                                                              data[index].address,
                                                                          lat: data[index]
                                                                              .lat,
                                                                          lng: data[index]
                                                                              .lng,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: Colors
                                                                            .blue,
                                                                        width:
                                                                            0.5,
                                                                      ),
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                        5,
                                                                      ),
                                                                    ),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(5),
                                                                    child: Text(
                                                                      "See Details",
                                                                      style:
                                                                          TextStyle(
                                                                        color: HexColor(
                                                                            "#0275D8"),
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: data[index].period == null
                                                ? false
                                                : true,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Text(
                                                    'Recurring',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  //
                                );
                        } else if (snapshot.hasError) {
                          return showMsg(snapshot.error);
                        }
                        // By default show a loading spinner.
                        return Column(
                          children: [
                            const SizedBox(
                              height: 60,
                            ),
                            CircularProgressIndicator(
                              backgroundColor: Colors.grey,
                              valueColor: colorTween,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // 2
            SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    child: FutureBuilder<List<DataOn>>(
                      future: futureDataOn,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && mounted) {
                          List<DataOn>? data = snapshot.data;
                          return data!.isEmpty
                              ? Column(
                                  children: const [
                                    SizedBox(
                                      height: 60,
                                    ),
                                    Text(
                                      "No Ongoing jobs yet",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  itemCount: data.length,
                                  // itemCount: _properties.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Material(
                                              elevation: 5,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: HexColor("#ECECEC"),
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          'images/logo3.png',
                                                          height: 80,
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                              5,
                                                              10,
                                                              10,
                                                              10,
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      data[index].service_for ==
                                                                              null
                                                                          ? "Lawn Mowing"
                                                                          : "Snow Plowing ${data[index].service_for}",
                                                                    ),
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              HexColor("#24B550"),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(5),
                                                                        child:
                                                                            Text(
                                                                          "\$${data[index].grand_total}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                HexColor("#24B550"),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        data[index]
                                                                            .address,
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Service Provider : ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                    Text(
                                                                      data[index]
                                                                              .assigned_to ??
                                                                          "Not assigned",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: HexColor(
                                                                            "#24B550"),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Recurring Status : ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                    Text(
                                                                      data[index].period ==
                                                                              null
                                                                          ? "One time"
                                                                          : data[index]
                                                                              .period!,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: HexColor(
                                                                            "#24B550"),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      color: Colors.grey[400],
                                                      height: 1,
                                                      thickness: 1,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                        10,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Due date: ${data[index].date}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        10),
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      PageTransition(
                                                                        type: PageTransitionType
                                                                            .rightToLeftWithFade,
                                                                        // 3
                                                                        child:
                                                                            Chat(
                                                                          orderId: data[index]
                                                                              .id
                                                                              .toString(),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: HexColor(
                                                                          "#DCFFE7"),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              10),
                                                                      child:
                                                                          ImageIcon(
                                                                        const AssetImage(
                                                                          "images/chat.png",
                                                                        ),
                                                                        color: HexColor(
                                                                            "#24B550"),
                                                                        size:
                                                                            20,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      data[index].on_the_way ==
                                                                              "null"
                                                                          ? () {
                                                                              QuickAlert.show(
                                                                                context: context,
                                                                                type: QuickAlertType.info,
                                                                                title: "Unavailable",
                                                                                text: 'When the service provider is in route to you, you can track his location.',
                                                                                cancelBtnText: "Ok",
                                                                                confirmBtnColor: Colors.yellow[600]!,
                                                                                showCancelBtn: false,
                                                                              );
                                                                            }
                                                                          : () {
                                                                              Navigator.push(
                                                                                context,
                                                                                PageTransition(
                                                                                  type: PageTransitionType.rightToLeftWithFade,
                                                                                  child: TrackService(
                                                                                    provId: "${data[index].assigned_to_id}",
                                                                                    orderId: data[index].id.toString(),
                                                                                    address: data[index].address,
                                                                                    date: data[index].date,
                                                                                    granTotal: data[index].grand_total,
                                                                                    service: data[index].service_for == null ? "Lawn Mowing" : "Snow ${data[index].service_for}",
                                                                                    provStatus: data[index].on_the_way == "null" && data[index].at_location_and_started_job == "null" && data[index].finished_job == "null"
                                                                                        ? "null"
                                                                                        : data[index].on_the_way == "1" && data[index].at_location_and_started_job == "null" && data[index].finished_job == "null"
                                                                                            ? "1"
                                                                                            : data[index].on_the_way == "1" && data[index].at_location_and_started_job == "1" && data[index].finished_job == "null"
                                                                                                ? "2"
                                                                                                : "3",
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                  child: Text(
                                                                    "Track Provider",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: HexColor(
                                                                          "#24B550"),
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      PageTransition(
                                                                        type: PageTransitionType
                                                                            .rightToLeftWithFade,
                                                                        // 1
                                                                        child:
                                                                            ServiceDetails(
                                                                          jobType:
                                                                              'Ongoing',
                                                                          jobId: data[index]
                                                                              .id
                                                                              .toString(),
                                                                          address:
                                                                              data[index].address,
                                                                          lat: data[index]
                                                                              .lat,
                                                                          lng: data[index]
                                                                              .lng,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: Colors
                                                                            .blue,
                                                                        width:
                                                                            0.5,
                                                                      ),
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                        5,
                                                                      ),
                                                                    ),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(5),
                                                                    child: Text(
                                                                      "See Details",
                                                                      style:
                                                                          TextStyle(
                                                                        color: HexColor(
                                                                            "#0275D8"),
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: data[index].period == null
                                                ? false
                                                : true,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Text(
                                                    'Recurring',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  //
                                );
                        } else if (snapshot.hasError) {
                          return showMsg(snapshot.error);
                        }
                        // By default show a loading spinner.
                        return Column(
                          children: [
                            const SizedBox(
                              height: 60,
                            ),
                            CircularProgressIndicator(
                              backgroundColor: Colors.grey,
                              valueColor: colorTween,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            //  3
            SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    child: FutureBuilder<List<DataCompl>>(
                      future: futureDataOnCompl,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && mounted) {
                          List<DataCompl>? data = snapshot.data;
                          return data!.isEmpty
                              ? Column(
                                  children: const [
                                    SizedBox(
                                      height: 60,
                                    ),
                                    Text(
                                      "No Completed jobs yet",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  itemCount: data.length,
                                  // itemCount: _properties.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Material(
                                              elevation: 5,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: HexColor("#ECECEC"),
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          'images/logo3.png',
                                                          height: 80,
                                                        ),
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                              5,
                                                              10,
                                                              10,
                                                              10,
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      data[index].service_for ==
                                                                              null
                                                                          ? "Lawn Mowing"
                                                                          : "Snow Plowing ${data[index].service_for}",
                                                                    ),
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              HexColor("#24B550"),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(5),
                                                                        child:
                                                                            Text(
                                                                          "\$${data[index].grand_total}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                HexColor("#24B550"),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        data[index]
                                                                            .address,
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Service Provider : ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                    Text(
                                                                      data[index]
                                                                              .assigned_to ??
                                                                          "Not assigned",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: HexColor(
                                                                            "#24B550"),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    InkWell(
                                                                      onTap: data[index].assigned_to !=
                                                                              null
                                                                          ? () async {
                                                                              var response = await BaseClient().favProvTogg(
                                                                                "/upcoming-jobs/toggle-favorite-provider/${data[index].assigned_id}",
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
                                                                                // print(response);
                                                                                if (response["success"]) {
                                                                                  await EasyLoading.dismiss();
                                                                                  futureDataOnCompl = getCompletedJobFunction();
                                                                                  if (mounted) {
                                                                                    setState(() {});
                                                                                  }
                                                                                  final snackBar = SnackBar(
                                                                                    elevation: 0,
                                                                                    behavior: SnackBarBehavior.floating,
                                                                                    backgroundColor: Colors.transparent,
                                                                                    content: AwesomeSnackbarContent(
                                                                                      title: 'Marked!',
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
                                                                                  await EasyLoading.dismiss();
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
                                                                          : () {},
                                                                      child:
                                                                          Text(
                                                                        data[index].assigned_to !=
                                                                                null
                                                                            ? "Mark as Favorite Provider"
                                                                            : "",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              HexColor("#24B550"),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Recurring Status : ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                    Text(
                                                                      data[index].period ==
                                                                              null
                                                                          ? "One time"
                                                                          : data[index]
                                                                              .period!,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: HexColor(
                                                                            "#24B550"),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                      "Due date: ${data[index].date}",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              10),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      color: Colors.grey[400],
                                                      height: 1,
                                                      thickness: 1,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                        10,
                                                        0,
                                                        0,
                                                        0,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          TextButton(
                                                            onPressed: data[index]
                                                                        .rated ==
                                                                    null
                                                                ? () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      PageTransition(
                                                                        type: PageTransitionType
                                                                            .rightToLeftWithFade,
                                                                        // 1
                                                                        child:
                                                                            Review(
                                                                          jobId: data[index]
                                                                              .id
                                                                              .toString(),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                : null,
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                          .yellow[
                                                                      800]!,
                                                                  width: 0.5,
                                                                ),
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                  5,
                                                                ),
                                                              ),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(5),
                                                              child: Text(
                                                                data[index]
                                                                        .rated ??
                                                                    "Rate Job",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                          .yellow[
                                                                      800]!,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                TextButton(
                                                                  onPressed: data[index]
                                                                              .status_by_customer ==
                                                                          0
                                                                      ? () async {
                                                                          var response =
                                                                              await BaseClient().markJobCompleted(
                                                                            "/mark-job-as-completed/${data[index].id}",
                                                                          );
                                                                          //
                                                                          if (response[
                                                                              "success"]) {
                                                                            await EasyLoading.dismiss();

                                                                            futureDataOnCompl =
                                                                                getCompletedJobFunction();
                                                                            if (mounted) {
                                                                              setState(() {});
                                                                            }
                                                                          } else {
                                                                            await EasyLoading.dismiss();
                                                                            final snackBar =
                                                                                SnackBar(
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
                                                                      : () {},
                                                                  child: Text(
                                                                    data[index].status_by_customer ==
                                                                            0
                                                                        ? "Mark as completed"
                                                                        : "Marked as completed",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          12,
                                                                      color: HexColor(
                                                                          "#24B550"),
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      PageTransition(
                                                                        type: PageTransitionType
                                                                            .rightToLeftWithFade,
                                                                        // 1
                                                                        child:
                                                                            ServiceDetails(
                                                                          jobType:
                                                                              'Completed',
                                                                          jobId: data[index]
                                                                              .id
                                                                              .toString(),
                                                                          address:
                                                                              data[index].address,
                                                                          lat: data[index]
                                                                              .lat,
                                                                          lng: data[index]
                                                                              .lng,
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: Colors
                                                                            .blue,
                                                                        width:
                                                                            0.5,
                                                                      ),
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                        5,
                                                                      ),
                                                                    ),
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(5),
                                                                    child: Text(
                                                                      "See Details",
                                                                      style:
                                                                          TextStyle(
                                                                        color: HexColor(
                                                                            "#0275D8"),
                                                                        fontSize:
                                                                            12,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: data[index].period == null
                                                ? false
                                                : true,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Text(
                                                    'Recurring',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  //
                                );
                        } else if (snapshot.hasError) {
                          return showMsg(snapshot.error);
                        }
                        // By default show a loading spinner.
                        return Column(
                          children: [
                            const SizedBox(
                              height: 60,
                            ),
                            CircularProgressIndicator(
                              backgroundColor: Colors.grey,
                              valueColor: colorTween,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            //  4
            SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(
                    child: FutureBuilder<List<DataOnCanc>>(
                      future: futureDataOnCanc,
                      builder: (context, snapshot) {
                        if (snapshot.hasData && mounted) {
                          List<DataOnCanc>? data = snapshot.data;
                          return data!.isEmpty
                              ? Column(
                                  children: const [
                                    SizedBox(
                                      height: 60,
                                    ),
                                    Text(
                                      "No Cancelled jobs yet",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.builder(
                                  itemCount: data.length,
                                  // itemCount: _properties.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Stack(
                                        alignment: Alignment.topLeft,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Material(
                                              elevation: 5,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                    color: HexColor("#ECECEC"),
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        // data[index]
                                                        //         .images
                                                        //         .isEmpty
                                                        //     ?
                                                        Image.asset(
                                                          'images/logo3.png',
                                                          height: 80,
                                                          width: 80,
                                                          fit: BoxFit.fill,
                                                        )
                                                        // : Padding(
                                                        //     padding:
                                                        //         const EdgeInsets
                                                        //             .all(5),
                                                        //     child: Image
                                                        //         .network(
                                                        //       imageUrl +
                                                        //           data[index]
                                                        //                   .images[0]
                                                        //               [
                                                        //               "image"],
                                                        //       height: 80,
                                                        //       width: 80,
                                                        //       fit: BoxFit
                                                        //           .fill,
                                                        //     ),
                                                        //   )
                                                        ,
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .fromLTRB(
                                                              5,
                                                              10,
                                                              10,
                                                              10,
                                                            ),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      data[index].service_for ==
                                                                              null
                                                                          ? "Lawn Mowing"
                                                                          : "Snow Plowing ${data[index].service_for}",
                                                                    ),
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              HexColor("#24B550"),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(5),
                                                                        child:
                                                                            Text(
                                                                          "\$${data[index].grand_total}",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                HexColor("#24B550"),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Expanded(
                                                                      child:
                                                                          Text(
                                                                        data[index]
                                                                            .address,
                                                                        style:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Service Provider : ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                    Text(
                                                                      data[index]
                                                                              .assigned_to ??
                                                                          "Not assigned",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: HexColor(
                                                                            "#24B550"),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                const SizedBox(
                                                                  height: 5,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    const Text(
                                                                      "Recurring Status : ",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12),
                                                                    ),
                                                                    Text(
                                                                      data[index].period ==
                                                                              null
                                                                          ? "One time"
                                                                          : data[index]
                                                                              .period!,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: HexColor(
                                                                            "#24B550"),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Divider(
                                                      color: Colors.grey[400],
                                                      height: 1,
                                                      thickness: 1,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                        10,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            "Due date: ${data[index].date}",
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        10),
                                                          ),
                                                          Text(
                                                            data[index].is_refunded ==
                                                                    null
                                                                ? "Not Refunded"
                                                                : "Refunded",
                                                            style: TextStyle(
                                                              color: data[index]
                                                                          .is_refunded ==
                                                                      null
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .green,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: data[index].period == null
                                                ? false
                                                : true,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(5),
                                                  child: Text(
                                                    'Recurring',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 8,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  //
                                );
                        } else if (snapshot.hasError) {
                          return showMsg(snapshot.error);
                        }
                        // By default show a loading spinner.
                        return Column(
                          children: [
                            const SizedBox(
                              height: 60,
                            ),
                            CircularProgressIndicator(
                              backgroundColor: Colors.grey,
                              valueColor: colorTween,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DataUp {
  final int id;
  final String address;
  final String lat;
  final String lng;
  final String date;
  final String cancelJobFee;
  String? service_for;
  String? period;
  final String grand_total;
  String? assigned_to;
  final List images;

  DataUp({
    required this.id,
    required this.address,
    required this.lat,
    required this.lng,
    required this.date,
    required this.service_for,
    required this.cancelJobFee,
    required this.grand_total,
    required this.assigned_to,
    required this.period,
    required this.images,
  });

  factory DataUp.fromJson(Map<String, dynamic> json) {
    return DataUp(
      id: json['id'],
      address: json['property']['address'],
      lat: json['property']['lat'],
      lng: json['property']['lng'],
      date: json['date'],
      service_for: json['service_for'],
      grand_total: json['grand_total'].toString(),
      cancelJobFee: json['cancelJobFee'].toString(),
      assigned_to: json['provider'] == null
          ? null
          : "${json['provider']['first_name'] + " " + json['provider']['last_name']}",
      period: json['period'] == null
          ? null
          : "${json['period']['duration']} ${json['period']['duration_type']}",
      images: json['images'],
    );
  }
}

class DataOn {
  final int id;
  final String address;
  final String lat;
  final String lng;
  final String date;
  final String cancelJobFee;
  String? service_for;
  String? period;
  final String grand_total;
  String? assigned_to;
  final List images;
  String? on_the_way;
  String? at_location_and_started_job;
  String? finished_job;
  int assigned_to_id;
  DataOn({
    required this.id,
    required this.address,
    required this.lat,
    required this.lng,
    required this.date,
    required this.service_for,
    required this.cancelJobFee,
    required this.grand_total,
    required this.assigned_to,
    required this.period,
    required this.images,
    required this.on_the_way,
    required this.at_location_and_started_job,
    required this.finished_job,
    required this.assigned_to_id,
  });

  factory DataOn.fromJson(Map<String, dynamic> json) {
    return DataOn(
      id: json['id'],
      address: json['property']['address'],
      lat: json['property']['lat'],
      lng: json['property']['lng'],
      date: json['date'],
      service_for: json['service_for'],
      grand_total: json['grand_total'].toString(),
      cancelJobFee: json['cancelJobFee'].toString(),
      assigned_to: json['provider'] == null
          ? null
          : "${json['provider']['first_name'] + " " + json['provider']['last_name']}",
      period: json['period'] == null
          ? null
          : "${json['period']['duration']} ${json['period']['duration_type']}",
      images: json['images'],
      on_the_way: json['on_the_way'].toString(),
      at_location_and_started_job:
          json['at_location_and_started_job'].toString(),
      finished_job: json['finished_job'].toString(),
      assigned_to_id: json['provider']['id'],
    );
  }
}

class DataCompl {
  final int id;
  final int status_by_customer;
  final String address;
  final String lat;
  final String lng;
  final String date;
  final String cancelJobFee;
  String? service_for;
  String? period;
  final String grand_total;
  String? assigned_to;
  String? assigned_id;
  String? rated;
  final List images;
  int assigned_to_id;
  DataCompl({
    required this.id,
    required this.status_by_customer,
    required this.address,
    required this.lat,
    required this.lng,
    required this.date,
    required this.service_for,
    required this.cancelJobFee,
    required this.grand_total,
    required this.assigned_to,
    required this.assigned_id,
    required this.rated,
    required this.period,
    required this.images,
    required this.assigned_to_id,
  });

  factory DataCompl.fromJson(Map<String, dynamic> json) {
    return DataCompl(
      id: json['id'],
      status_by_customer: json['status_by_customer'],
      address: json['property']['address'],
      lat: json['property']['lat'],
      lng: json['property']['lng'],
      date: json['date'],
      service_for: json['service_for'],
      grand_total: json['grand_total'].toString(),
      cancelJobFee: json['cancelJobFee'].toString(),
      assigned_to: json['provider'] == null
          ? null
          : "${json['provider']['first_name'] + " " + json['provider']['last_name']}",
      assigned_id:
          json['assigned_to'] == null ? null : "${json['assigned_to']}",
      rated: json['rating'] == null ? null : "Already Rated",
      period: json['period'] == null
          ? null
          : "${json['period']['duration']} ${json['period']['duration_type']}",
      images: json['images'],
      assigned_to_id: json['provider']['id'],
    );
  }
}

class DataOnCanc {
  final int id;
  final String address;
  final String lat;
  final String lng;
  final String date;
  final String cancelJobFee;
  String? service_for;
  String? period;
  final String grand_total;
  String? assigned_to;
  final List images;
  String? is_refunded;
  DataOnCanc({
    required this.id,
    required this.address,
    required this.lat,
    required this.lng,
    required this.date,
    required this.service_for,
    required this.cancelJobFee,
    required this.grand_total,
    required this.assigned_to,
    required this.period,
    required this.images,
    required this.is_refunded,
  });

  factory DataOnCanc.fromJson(Map<String, dynamic> json) {
    return DataOnCanc(
      id: json['id'],
      address: json['property']['address'],
      lat: json['property']['lat'],
      lng: json['property']['lng'],
      date: json['date'],
      service_for: json['service_for'],
      grand_total: json['grand_total'].toString(),
      cancelJobFee: json['cancelJobFee'].toString(),
      assigned_to: json['provider'] == null
          ? null
          : "${json['provider']['first_name'] + " " + json['provider']['last_name']}",
      period: json['period'] == null
          ? null
          : "${json['period']['duration']} ${json['period']['duration_type']}",
      images: json['images'],
      is_refunded:
          json['is_refunded'] == null ? null : "${json['is_refunded']}",
    );
  }
}
