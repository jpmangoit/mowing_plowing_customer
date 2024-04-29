import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';

import '../../Backend/base_client.dart';
import '../BottomNavBar/bottomNavBar_screen.dart';
import '../Login/logIn_screen.dart';
import '../ProviderDetails/providerDetails_screen.dart';

class Proposals extends StatefulWidget {
  final String orderId;
  final String serviceType;
  final String grandTotal;
  final String date;

  const Proposals({
    super.key,
    required this.orderId,
    required this.serviceType,
    required this.grandTotal,
    required this.date,
  });

  @override
  State<Proposals> createState() => _ProposalsState();
}

class _ProposalsState extends State<Proposals> with TickerProviderStateMixin {
  late var colorTween;
  late AnimationController controller;
  Future<List<Propose>>? futureDataUp;
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

  Future<List<Propose>> getOnGoingJobFunction() async {
    var response = await BaseClient().proposal(
      "/upcoming-jobs/proposals",
      widget.orderId,
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
        List jsonResponse = json.decode(response.body)["data"]["proposals"];
        return jsonResponse.map((data) => Propose.fromJson(data)).toList();
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
    futureDataUp = getOnGoingJobFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Proposals",
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
        physics: const ScrollPhysics(),
        child: Center(
          child: FutureBuilder<List<Propose>>(
            future: futureDataUp,
            builder: (context, snapshot) {
              if (snapshot.hasData && mounted) {
                List<Propose>? data = snapshot.data;
                return data!.isEmpty
                    ? Column(
                        children: const [
                          SizedBox(
                            height: 60,
                          ),
                          Text(
                            "No proposals",
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
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Material(
                              elevation: 5,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: HexColor("#ECECEC"),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                              child: data[index].image == null
                                                  ? Image.asset(
                                                      'images/upload.jpg',
                                                      height: 80,
                                                    )
                                                  : CachedNetworkImage(
                                                      imageUrl: imageUrl +
                                                          data[index].image!,
                                                      height: 80,
                                                      width: 80,
                                                      placeholder: (context,
                                                              url) =>
                                                          LoadingAnimationWidget
                                                              .inkDrop(
                                                        color:
                                                            HexColor("#0275D8"),
                                                        size: 40,
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    )),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        "Provider Name",
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        "${data[index].first_name} ${data[index].last_name}",
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 7,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        "Service",
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        widget.serviceType,
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 7,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Expanded(
                                                        child: Text(
                                                          data[index].address,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 7,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "\$${widget.grandTotal}",
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Text(
                                                        widget.date,
                                                        style: const TextStyle(
                                                          fontSize: 12,
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
                                    ),
                                    Divider(
                                      color: Colors.grey[400],
                                      height: 1,
                                      thickness: 1,
                                    ),
                                    SizedBox(
                                      height: 40,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                const Text(
                                                  "Ratings: ",
                                                  style:
                                                      TextStyle(fontSize: 10),
                                                ),
                                                Text(
                                                  "Ratings: 4.6 / 5.0 ",
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: HexColor("#24B550"),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              VerticalDivider(
                                                color: Colors.grey[400],
                                              ),
                                              // const ImageIcon(
                                              //   AssetImage(
                                              //     "images/like.png",
                                              //   ),
                                              //   color: Colors.red,
                                              // ),
                                              InkWell(
                                                onTap: () async {
                                                  var response =
                                                      await BaseClient()
                                                          .favProvTogg(
                                                    "/upcoming-jobs/toggle-favorite-provider/${data[index].provider_id}",
                                                  );
                                                  if (response["message"] ==
                                                      "Unauthenticated.") {
                                                    if (mounted) {
                                                      Navigator
                                                          .pushAndRemoveUntil(
                                                        context,
                                                        PageTransition(
                                                          type: PageTransitionType
                                                              .rightToLeftWithFade,
                                                          // 3
                                                          child: const LogIn(),
                                                        ),
                                                        (route) => false,
                                                      );
                                                      final snackBar = SnackBar(
                                                        elevation: 0,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        content:
                                                            AwesomeSnackbarContent(
                                                          title: 'Alert!',
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
                                                    if (response["success"]) {
                                                      await EasyLoading
                                                          .dismiss();
                                                      final snackBar = SnackBar(
                                                        elevation: 0,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        content:
                                                            AwesomeSnackbarContent(
                                                          title:
                                                              'Favorite Provider!',
                                                          message:
                                                              "This provider has been added to your favorite provider's",
                                                          contentType:
                                                              ContentType
                                                                  .success,
                                                        ),
                                                      );
                                                      if (mounted) {
                                                        ScaffoldMessenger.of(
                                                            context)
                                                          ..hideCurrentSnackBar()
                                                          ..showSnackBar(
                                                              snackBar);
                                                      }
                                                    } else {
                                                      await EasyLoading
                                                          .dismiss();
                                                      final snackBar = SnackBar(
                                                        elevation: 0,
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        content:
                                                            AwesomeSnackbarContent(
                                                          title: 'Alert!',
                                                          message:
                                                              '${response["message"]}',
                                                          contentType:
                                                              ContentType
                                                                  .failure,
                                                        ),
                                                      );
                                                      if (mounted) {
                                                        ScaffoldMessenger.of(
                                                            context)
                                                          ..hideCurrentSnackBar()
                                                          ..showSnackBar(
                                                              snackBar);
                                                      }
                                                    }
                                                  }
                                                },
                                                child: const Icon(
                                                  Icons.favorite_rounded,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              // Icon(Icons.favorite_border),
                                              VerticalDivider(
                                                color: Colors.grey[400],
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () async {
                                                    var response =
                                                        await BaseClient()
                                                            .acceptProposal(
                                                      "/accept-proposal/${data[index].id}",
                                                    );
                                                    if (response["message"] ==
                                                        "Unauthenticated.") {
                                                      if (mounted) {
                                                        Navigator
                                                            .pushAndRemoveUntil(
                                                          context,
                                                          PageTransition(
                                                            type: PageTransitionType
                                                                .rightToLeftWithFade,
                                                            // 3
                                                            child:
                                                                const LogIn(),
                                                          ),
                                                          (route) => false,
                                                        );
                                                        final snackBar =
                                                            SnackBar(
                                                          elevation: 0,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          content:
                                                              AwesomeSnackbarContent(
                                                            title: 'Alert!',
                                                            message:
                                                                'To continue, kindly log in again',
                                                            contentType:
                                                                ContentType
                                                                    .help,
                                                          ),
                                                        );
                                                        ScaffoldMessenger.of(
                                                            context)
                                                          ..hideCurrentSnackBar()
                                                          ..showSnackBar(
                                                              snackBar);
                                                      }
                                                    } else {
                                                      if (response["success"]) {
                                                        await EasyLoading
                                                            .dismiss();
                                                        if (mounted) {
                                                          Navigator.push(
                                                              context,
                                                              PageTransition(
                                                                type: PageTransitionType
                                                                    .rightToLeftWithFade,
                                                                child:
                                                                    BottomNavBar(
                                                                  addressNaved:
                                                                      "",
                                                                  index: null,
                                                                  latNaved:
                                                                      0.00,
                                                                  longNaved:
                                                                      0.00,
                                                                  addNotNull:
                                                                      false,
                                                                ),
                                                              ));
                                                          final snackBar =
                                                              SnackBar(
                                                            elevation: 0,
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .fixed,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            content:
                                                                AwesomeSnackbarContent(
                                                              title:
                                                                  'Favorite Provider!',
                                                              message:
                                                                  '${response["message"]}',
                                                              contentType:
                                                                  ContentType
                                                                      .success,
                                                            ),
                                                          );
                                                          ScaffoldMessenger.of(
                                                              context)
                                                            ..hideCurrentSnackBar()
                                                            ..showSnackBar(
                                                                snackBar);
                                                        }
                                                      } else {
                                                        await EasyLoading
                                                            .dismiss();
                                                        final snackBar =
                                                            SnackBar(
                                                          elevation: 0,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          content:
                                                              AwesomeSnackbarContent(
                                                            title: 'Alert!',
                                                            message:
                                                                '${response["message"]}',
                                                            contentType:
                                                                ContentType
                                                                    .failure,
                                                          ),
                                                        );
                                                        if (mounted) {
                                                          ScaffoldMessenger.of(
                                                              context)
                                                            ..hideCurrentSnackBar()
                                                            ..showSnackBar(
                                                                snackBar);
                                                        }
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color: Colors.blue,
                                                        width: 0.5,
                                                      ),
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        5,
                                                      ),
                                                    ),
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Text(
                                                      "Accept",
                                                      style: TextStyle(
                                                        color:
                                                            HexColor("#0275D8"),
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    var response =
                                                        await BaseClient()
                                                            .declineProposals(
                                                      "/decline-proposal/${data[index].id}",
                                                    );
                                                    if (response["message"] ==
                                                        "Unauthenticated.") {
                                                      if (mounted) {
                                                        Navigator
                                                            .pushAndRemoveUntil(
                                                          context,
                                                          PageTransition(
                                                            type: PageTransitionType
                                                                .rightToLeftWithFade,
                                                            // 3
                                                            child:
                                                                const LogIn(),
                                                          ),
                                                          (route) => false,
                                                        );
                                                        final snackBar =
                                                            SnackBar(
                                                          elevation: 0,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          content:
                                                              AwesomeSnackbarContent(
                                                            title: 'Alert!',
                                                            message:
                                                                'To continue, kindly log in again',
                                                            contentType:
                                                                ContentType
                                                                    .help,
                                                          ),
                                                        );
                                                        ScaffoldMessenger.of(
                                                            context)
                                                          ..hideCurrentSnackBar()
                                                          ..showSnackBar(
                                                              snackBar);
                                                      }
                                                    } else {
                                                      if (response["success"]) {
                                                        await EasyLoading
                                                            .dismiss();
                                                        if (mounted) {
                                                          Navigator
                                                              .pushAndRemoveUntil(
                                                            context,
                                                            PageTransition(
                                                              type: PageTransitionType
                                                                  .rightToLeftWithFade,
                                                              child:
                                                                  BottomNavBar(
                                                                addressNaved:
                                                                    "",
                                                                index: null,
                                                                latNaved: 0.00,
                                                                longNaved: 0.00,
                                                                addNotNull:
                                                                    false,
                                                              ),
                                                            ),
                                                            (route) => false,
                                                          );
                                                          final snackBar =
                                                              SnackBar(
                                                            elevation: 0,
                                                            behavior:
                                                                SnackBarBehavior
                                                                    .fixed,
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            content:
                                                                AwesomeSnackbarContent(
                                                              title: 'Accepted',
                                                              message:
                                                                  'Proposal declined successfully..',
                                                              contentType:
                                                                  ContentType
                                                                      .warning,
                                                            ),
                                                          );
                                                          ScaffoldMessenger.of(
                                                              context)
                                                            ..hideCurrentSnackBar()
                                                            ..showSnackBar(
                                                                snackBar);
                                                        }
                                                      } else {
                                                        await EasyLoading
                                                            .dismiss();
                                                        final snackBar =
                                                            SnackBar(
                                                          elevation: 0,
                                                          behavior:
                                                              SnackBarBehavior
                                                                  .floating,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          content:
                                                              AwesomeSnackbarContent(
                                                            title: 'Alert!',
                                                            message:
                                                                '${response["message"]}',
                                                            contentType:
                                                                ContentType
                                                                    .failure,
                                                          ),
                                                        );
                                                        if (mounted) {
                                                          ScaffoldMessenger.of(
                                                              context)
                                                            ..hideCurrentSnackBar()
                                                            ..showSnackBar(
                                                                snackBar);
                                                        }
                                                      }
                                                    }
                                                  },
                                                  child: const Text(
                                                    "Decline",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.red,
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
                          );
                        },
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
      ),
    );
  }
}

class Propose {
  final String id;
  final String order_id;
  final String provider_id;
  final String first_name;
  final String last_name;
  final String address;
  final String lat;
  final String lng;
  final String? image;

  Propose({
    required this.id,
    required this.order_id,
    required this.provider_id,
    required this.first_name,
    required this.last_name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.image,
  });

  factory Propose.fromJson(Map<String, dynamic> json) {
    return Propose(
      id: json['id'].toString(),
      order_id: json['order_id'].toString(),
      provider_id: json['provider_id'].toString(),
      first_name: json['provider']['first_name'].toString(),
      last_name: json['provider']['last_name'].toString(),
      address: json['provider']['address'].toString(),
      lat: json['provider']['lat'].toString(),
      lng: json['provider']['lng'].toString(),
      image: json['provider']['image'].toString(),
    );
  }
}
