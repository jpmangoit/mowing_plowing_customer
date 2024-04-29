import 'dart:convert';
import 'dart:typed_data';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mowing_plowing/Frontend/Properties/addProperty_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../../Backend/base_client.dart';
import '../BottomNavBar/bottomNavBar_screen.dart';
import '../Login/logIn_screen.dart';

class Properties extends StatefulWidget {
  const Properties({super.key});

  @override
  State<Properties> createState() => _PropertiesState();
}

class _PropertiesState extends State<Properties> with TickerProviderStateMixin {
  late var colorTween;
  late AnimationController controller;
  late Future<List<Data>> futureData;

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

  Future<List<Data>> getPropertiesFunction() async {
    var response = await BaseClient().getProperties(
      "/properties",
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
        List jsonResponse = json.decode(response.body)["data"];
        return jsonResponse.map((data) => Data.fromJson(data)).toList();
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
    colorTween = controller.drive(
      ColorTween(
        begin: HexColor("#0275D8"),
        end: HexColor("#24B550"),
      ),
    );
    // controller.repeat(reverse: true);
    futureData = getPropertiesFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          backgroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Properties',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Divider(
                  color: HexColor('#A8A8A8'),
                ),
              ),
            ],
          ),
          bottom: const TabBar(
            labelColor: Colors.black,
            tabs: [
              Tab(
                text: 'Lawn Mowing',
                height: 60,
              ),
              Tab(
                text: 'Snow Plowing',
                height: 60,
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              child: const AddProperty(
                                address: null,
                                latNaved: 0.00,
                                longNaved: 0.00,
                                category_id: '1',
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.add,
                          color: HexColor("#0275D8"),
                        ),
                        label: Text(
                          "Add Property",
                          style: TextStyle(
                            color: HexColor("#0275D8"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: FutureBuilder<List<Data>>(
                      future: futureData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Data>? data = snapshot.data;
                          return ListView.builder(
                            itemCount: data!.length,
                            // itemCount: _properties.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, index) {
                              return data[index].category_id == 1
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 3,
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 5, 0, 0),
                                              child: Image.asset(
                                                // _image!,
                                                "images/logo3.png",
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                      0,
                                                      0,
                                                      10,
                                                      0,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            data[index].address,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                      0,
                                                      0,
                                                      10,
                                                      0,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Visibility(
                                                          visible: data[index]
                                                                      .orders_count ==
                                                                  0
                                                              ? true
                                                              : false,
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              backgroundColor:
                                                                  Colors.red,
                                                            ),
                                                            onPressed: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    CupertinoAlertDialog(
                                                                  title:
                                                                      const Text(
                                                                    "Are you sure you want to delete",
                                                                  ),
                                                                  actions: [
                                                                    CupertinoDialogAction(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      isDefaultAction:
                                                                          true,
                                                                      child: const Text(
                                                                          "No"),
                                                                    ),
                                                                    CupertinoDialogAction(
                                                                      onPressed:
                                                                          () async {
                                                                        var response =
                                                                            await BaseClient().deleteProperties(
                                                                          "/delete-properties/${data[index].id}",
                                                                        );

                                                                        if (response["message"] ==
                                                                            "Unauthenticated.") {
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
                                                                            final snackBar =
                                                                                SnackBar(
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
                                                                          if (response[
                                                                              "success"]) {
                                                                            if (mounted) {
                                                                              Navigator.pop(context);
                                                                              futureData = getPropertiesFunction();

                                                                              if (mounted) {
                                                                                setState(() {});
                                                                              }
                                                                            }
                                                                          } else {
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
                                                                      },
                                                                      isDefaultAction:
                                                                          true,
                                                                      child: const Text(
                                                                          "Yes"),
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                            child: const Text(
                                                              'Delete',
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                type: PageTransitionType
                                                                    .rightToLeftWithFade,
                                                                child:
                                                                    BottomNavBar(
                                                                  addressNaved:
                                                                      data[index]
                                                                          .address,
                                                                  index: null,
                                                                  latNaved: double
                                                                      .parse(data[
                                                                              index]
                                                                          .lat),
                                                                  longNaved: double
                                                                      .parse(data[
                                                                              index]
                                                                          .lng),
                                                                  addNotNull:
                                                                      true,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: const Text(
                                                            'Order',
                                                            style: TextStyle(
                                                              fontSize: 12,
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
                                    )
                                  : const SizedBox();
                            },
                          );
                        } else if (snapshot.hasError) {
                          return showMsg(snapshot.error);
                        }
                        // By default show a loading spinner.
                        return CircularProgressIndicator(
                          backgroundColor: Colors.grey,
                          valueColor: colorTween,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              child: const AddProperty(
                                address: null,
                                latNaved: 0.00,
                                longNaved: 0.00,
                                category_id: '2',
                              ),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.add,
                          color: HexColor("#0275D8"),
                        ),
                        label: Text(
                          "Add Property",
                          style: TextStyle(
                            color: HexColor("#0275D8"),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: FutureBuilder<List<Data>>(
                      future: futureData,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Data>? data = snapshot.data;
                          return ListView.builder(
                            itemCount: data!.length,
                            // itemCount: _properties.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, index) {
                              return data[index].category_id == 2
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              spreadRadius: 3,
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 5, 0, 0),
                                              child: Image.asset(
                                                // _image!,
                                                "images/logo3.png",
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                      0,
                                                      0,
                                                      10,
                                                      0,
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                            data[index].address,
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                            maxLines: 2,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                      0,
                                                      0,
                                                      10,
                                                      0,
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Visibility(
                                                          visible: data[index]
                                                                      .orders_count ==
                                                                  0
                                                              ? true
                                                              : false,
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                              ),
                                                              backgroundColor:
                                                                  Colors.red,
                                                            ),
                                                            onPressed: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    CupertinoAlertDialog(
                                                                  title:
                                                                      const Text(
                                                                    "Are you sure you want to delete",
                                                                  ),
                                                                  actions: [
                                                                    CupertinoDialogAction(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      isDefaultAction:
                                                                          true,
                                                                      child: const Text(
                                                                          "No"),
                                                                    ),
                                                                    CupertinoDialogAction(
                                                                      onPressed:
                                                                          () async {
                                                                        var response =
                                                                            await BaseClient().deleteProperties(
                                                                          "/delete-properties/${data[index].id}",
                                                                        );
                                                                        if (response["message"] ==
                                                                            "Unauthenticated.") {
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
                                                                            final snackBar =
                                                                                SnackBar(
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
                                                                          if (response[
                                                                              "success"]) {
                                                                            if (mounted) {
                                                                              Navigator.pop(context);
                                                                              futureData = getPropertiesFunction();

                                                                              if (mounted) {
                                                                                setState(() {});
                                                                              }
                                                                            }
                                                                          } else {
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
                                                                      },
                                                                      isDefaultAction:
                                                                          true,
                                                                      child: const Text(
                                                                          "Yes"),
                                                                    )
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                            child: const Text(
                                                              'Delete',
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                type: PageTransitionType
                                                                    .rightToLeftWithFade,
                                                                child:
                                                                    BottomNavBar(
                                                                  addressNaved:
                                                                      data[index]
                                                                          .address,
                                                                  index: null,
                                                                  latNaved: double
                                                                      .parse(data[
                                                                              index]
                                                                          .lat),
                                                                  longNaved: double
                                                                      .parse(data[
                                                                              index]
                                                                          .lng),
                                                                  addNotNull:
                                                                      true,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          child: const Text(
                                                            'Order',
                                                            style: TextStyle(
                                                                fontSize: 12),
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
                                    )
                                  : const SizedBox();
                            },
                          );
                        } else if (snapshot.hasError) {
                          return showMsg(snapshot.error);
                        }
                        // By default show a loading spinner.
                        return CircularProgressIndicator(
                          backgroundColor: Colors.grey,
                          valueColor: colorTween,
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Data {
  final int id;
  final String address;
  final String lat;
  final String lng;
  final int category_id;
  final int user_id;
  final int orders_count;

  Data({
    required this.id,
    required this.address,
    required this.lat,
    required this.lng,
    required this.category_id,
    required this.user_id,
    required this.orders_count,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      category_id: json['category_id'],
      address: json['address'],
      user_id: json['user_id'],
      lat: json['lat'],
      lng: json['lng'],
      id: json['id'],
      orders_count: json['orders_count'],
    );
  }
}
