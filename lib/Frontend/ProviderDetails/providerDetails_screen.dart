import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../Pricing/packages_screen.dart';
import '../Services/serviceDetails_screen.dart';

class ProviderDetails extends StatefulWidget {
  final bool details;
  const ProviderDetails({
    super.key,
    required this.details,
  });

  @override
  State<ProviderDetails> createState() => _ProviderDetailsState();
}

class _ProviderDetailsState extends State<ProviderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Service Provider Details",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: HexColor("#ECECEC"),
                          ),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 70,
                            bottom: 20,
                            left: 20,
                            right: 20,
                          ),
                          child: Column(
                            children: [
                              Text(
                                "John Smith",
                                style: TextStyle(
                                  color: HexColor("#0275D8"),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total Score",
                                      style: TextStyle(
                                        color: HexColor("#24B550"),
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      "89 %",
                                      style: TextStyle(
                                        color: HexColor("#0275D8"),
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 0, 10, 20),
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: HexColor("#D6ECFF"), width: 2),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          20,
                                          20,
                                          20,
                                          0,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      color:
                                                          HexColor("#0275D8"),
                                                      size: 15,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    const Text("Rating"),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          3 -
                                                      20,
                                                  child: LinearPercentIndicator(
                                                    animation: true,
                                                    lineHeight: 20.0,
                                                    animationDuration: 1000,
                                                    percent: 0.8,
                                                    // center: const Text("80.0%"),
                                                    barRadius:
                                                        const Radius.circular(
                                                            10),
                                                    progressColor:
                                                        HexColor("#0275D8"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: HexColor("#998FA2"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          20,
                                          20,
                                          20,
                                          0,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      color:
                                                          HexColor("#7CC0FB"),
                                                      size: 15,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    const Text("Rating"),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          3 -
                                                      20,
                                                  child: LinearPercentIndicator(
                                                    animation: true,
                                                    lineHeight: 20.0,
                                                    animationDuration: 1000,
                                                    percent: 0.8,
                                                    // center: const Text("80.0%"),
                                                    barRadius:
                                                        const Radius.circular(
                                                            10),
                                                    progressColor:
                                                        HexColor("#7CC0FB"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: HexColor("#998FA2"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          20,
                                          20,
                                          20,
                                          0,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      color:
                                                          HexColor("#24B550"),
                                                      size: 15,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    const Text("Rating"),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          3 -
                                                      20,
                                                  child: LinearPercentIndicator(
                                                    animation: true,
                                                    lineHeight: 20.0,
                                                    animationDuration: 1000,
                                                    percent: 0.8,
                                                    // center: const Text("80.0%"),
                                                    barRadius:
                                                        const Radius.circular(
                                                            10),
                                                    progressColor:
                                                        HexColor("#24B550"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: HexColor("#998FA2"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          20,
                                          20,
                                          20,
                                          20,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.circle,
                                                      color:
                                                          HexColor("#9599B3"),
                                                      size: 15,
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    const Text("Rating"),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          3 -
                                                      20,
                                                  child: LinearPercentIndicator(
                                                    animation: true,
                                                    lineHeight: 20.0,
                                                    animationDuration: 1000,
                                                    percent: 0.8,
                                                    // center: const Text("80.0%"),
                                                    barRadius:
                                                        const Radius.circular(
                                                            10),
                                                    progressColor:
                                                        HexColor("#9599B3"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: HexColor("#998FA2"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  ClipOval(
                    child: Image.asset(
                      'images/person.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 20,
                    top: 70,
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              // 3
                              child: const Packages(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            // border: Border.all(
                            // color: HexColor("#ECECEC"),
                            // ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Image.asset(
                              "images/arrowstars.png",
                              height: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: widget.details ? false : true,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: HexColor("#24B550"),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              child: const ServiceDetails(
                                jobType: 'Upcoming',
                                jobId: '2',
                                address: 'fgjgh',
                                lat: "0.0",
                                lng: "0.00",
                              ),
                            ),
                          );
                        },
                        child: const Text('Accept'),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          minimumSize: const Size.fromHeight(50),
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   PageTransition(
                          //     type: PageTransitionType.rightToLeftWithFade,
                          //     child:,
                          //   ),
                          // );
                        },
                        child: const Text('Decline'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
