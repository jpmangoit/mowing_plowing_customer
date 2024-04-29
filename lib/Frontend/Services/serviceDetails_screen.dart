import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mowing_plowing/Frontend/Services/photoHero.dart';
import 'package:mowing_plowing/Frontend/Services/serviceAddress_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Backend/base_client.dart';
import '../Login/logIn_screen.dart';
import '../Proposals/proposal_screen.dart';

class ServiceDetails extends StatefulWidget {
  final String jobType;
  final String jobId;
  final String address;
  final String lat;
  final String lng;
  const ServiceDetails({
    super.key,
    required this.jobType,
    required this.jobId,
    required this.address,
    required this.lat,
    required this.lng,
  });

  @override
  State<ServiceDetails> createState() => _ServiceDetailsState();
}

class _ServiceDetailsState extends State<ServiceDetails>
    with TickerProviderStateMixin {
  late var colorTween;
  late AnimationController controller;
  bool loading = true;
  String orderId = "";
  String serviceProvAssig = "";
  String date = "";
  String serviceFor = "";
  String lawnSize = "";
  String lawnHeight = "";
  String cornerLot = "";
  String fence = "";
  String cleanUp = "";
  String propertyLat = "";
  String propertyLng = "";
  String totalPrice = "";
  List lawnImages = [];
  List lawnImagesBefore = [];
  List lawnImagesAfter = [];
  // ===========================================
  final myController = TextEditingController();
  final _instructions = <Widget>[];

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

  Future getJobDetailById() async {
    // 1 api
    var response = await BaseClient().getJobDetail(
      "/jobs/details/${widget.jobId}",
    );
    // 1 api
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
      // 1 api
      if (response["success"]) {
        // success
        // 1 api
        if (response["data"]["jobDetails"] != null) {
          response["data"]["jobDetails"]["instructions"] != null
              ? _instructions.add(
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Icon(
                            Icons.stop,
                            size: 14,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Text(
                              response["data"]["jobDetails"]["instructions"],
                              style: const TextStyle(
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : null;
          totalPrice = response["data"]["jobDetails"]["grand_total"].toString();
          propertyLat = response["data"]["jobDetails"]["lat"];
          propertyLng = response["data"]["jobDetails"]["lng"];
          orderId = response["data"]["jobDetails"]["order_id"];
          serviceProvAssig =
              response["data"]["jobDetails"]["assigned_to"] == null
                  ? "Not Assigned"
                  : "Assigned";
          date = response["data"]["jobDetails"]["date"];
          serviceFor = response["data"]["jobDetails"]["service_for"] == null
              ? "Lawn Mowing"
              : "Snow Plowing ${response["data"]["jobDetails"]["service_for"]}";
          cornerLot = response["data"]["jobDetails"]["corner_lot_id"] == 1
              ? "Yes"
              : "No";
          lawnImages = response["data"]["jobDetails"]["images"];
          lawnImagesBefore = response["data"]["jobDetails"]["before_images"];
          lawnImagesAfter = response["data"]["jobDetails"]["after_images"];
          // 2 api
          var responseS = await BaseClient().sizesHeightsPrices(
            "/sizes-heights-prices",
          );
          // 2 api
          if (json.decode(responseS.body)["message"] == "Unauthenticated.") {
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
            // 2 api
            if (json.decode(responseS.body)["success"]) {
              // success
              List sizes = json.decode(responseS.body)["data"]["sizes"];
              var size = sizes
                  .where((e) =>
                      e["id"] == response["data"]["jobDetails"]["lawn_size_id"])
                  .toList();
              lawnSize = size.isNotEmpty ? size[0]["name"] : '';
              List heights = json.decode(responseS.body)["data"]["heights"];
              var height = heights
                  .where((e) =>
                      e["id"] ==
                      response["data"]["jobDetails"]["lawn_height_id"])
                  .toList();
              lawnHeight = height.isNotEmpty ? height[0]["name"] : '';
              if (response["data"]["jobDetails"]["fence_id"] != null) {
                List fences = json.decode(responseS.body)["data"]["fences"];
                var fen = fences
                    .where((e) =>
                        e["id"] == response["data"]["jobDetails"]["fence_id"])
                    .toList();
                fence = fen[0]["name"];
              } else {
                fence = "No";
              }

              // 3 api
              if (response["data"]["jobDetails"]["cleanup_id"] == null) {
                cleanUp = "No";
              } else {
                var res = await BaseClient().lawnSizeCleanupPrice(
                  "/lawn-size-cleanup-price",
                  response["data"]["jobDetails"]["lawn_size_id"].toString(),
                );
                // 3 api
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
                  // 3 api
                  if (res["success"]) {
                    // success
                    List cleanUps = res["data"]["cleanUps"];
                    var clean = cleanUps
                        .where((e) =>
                            e["id"] ==
                            response["data"]["jobDetails"]["cleanup_id"])
                        .toList();
                    // print(res["data"]["cleanUps"]);
                    // print(response["data"]["jobDetails"]["cleanup_id"]);
                    // cleanUp = clean[0]["name"];
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
        } else {
          // sizes
          // print("Snow Plowing");
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
    getJobDetailById().then((value) async {
      loading = false;
      if (mounted) {
        if (mounted) {
          setState(() {});
        }
      }
    });
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
    completeFunct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Service Details",
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            child: loading
                ? SizedBox(
                    height: MediaQuery.of(context).size.height / 1.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: LoadingAnimationWidget.fourRotatingDots(
                            color: HexColor("#0275D8"),
                            size: 80,
                          ),
                        ),
                      ],
                    ),
                  )
                : widget.jobType == "Completed"
                    ? Column(
                        children: [
                          Visibility(
                            visible: lawnImagesBefore.isEmpty ? false : true,
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(10, 20, 20, 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Images Before Service",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: lawnImagesBefore.isEmpty
                                ? null
                                : GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      crossAxisCount: 3,
                                    ),
                                    itemCount: lawnImagesBefore.length,
                                    itemBuilder: (context, index) {
                                      // Item rendering
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FullScreenImageViewer(
                                                  imageUrl +
                                                      lawnImagesBefore[index]
                                                          ["image"],
                                                ),
                                              ),
                                            );
                                          },
                                          child: CachedNetworkImage(
                                            imageUrl: imageUrl +
                                                lawnImagesBefore[index]
                                                    ["image"],
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.fill,
                                            placeholder: (context, url) =>
                                                LoadingAnimationWidget
                                                    .fourRotatingDots(
                                              color: HexColor("#0275D8"),
                                              size: 40,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                          Visibility(
                            visible: lawnImagesAfter.isEmpty ? false : true,
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(10, 20, 20, 20),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Images After Service",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: lawnImagesAfter.isEmpty
                                ? null
                                : GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      crossAxisCount: 3,
                                    ),
                                    itemCount: lawnImagesAfter.length,
                                    itemBuilder: (context, index) {
                                      // Item rendering
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    FullScreenImageViewer(
                                                  imageUrl +
                                                      lawnImagesAfter[index]
                                                          ["image"],
                                                ),
                                              ),
                                            );
                                          },
                                          child: CachedNetworkImage(
                                            imageUrl: imageUrl +
                                                lawnImagesAfter[index]["image"],
                                            height: 80,
                                            width: 80,
                                            fit: BoxFit.fill,
                                            placeholder: (context, url) =>
                                                LoadingAnimationWidget
                                                    .fourRotatingDots(
                                              color: HexColor("#0275D8"),
                                              size: 40,
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      )
                    : Material(
                        borderRadius: BorderRadius.circular(10),
                        elevation: 5,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: HexColor("#CBCBCB"), width: 2),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Order ID"),
                                        Text(orderId),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Service Provider"),
                                        Text(serviceProvAssig),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Date"),
                                        Text(date),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Service"),
                                        Text(serviceFor),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Lawn size"),
                                        Text(lawnSize),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Lawn height"),
                                        Text(lawnHeight),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Corner lot"),
                                        Text(cornerLot),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Fence"),
                                        Text(fence),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text("Yard cleanup"),
                                        Text(cleanUp),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Divider(
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: lawnImages.isEmpty ? false : true,
                                child: const Padding(
                                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Lawn Images",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: lawnImages.isEmpty
                                    ? null
                                    : GridView.builder(
                                        shrinkWrap: true,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: 10,
                                          mainAxisSpacing: 10,
                                          crossAxisCount: 3,
                                        ),
                                        itemCount: lawnImages.length,
                                        itemBuilder: (context, index) {
                                          // Item rendering
                                          return ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        FullScreenImageViewer(
                                                      imageUrl +
                                                          lawnImages[index]
                                                              ["image"],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: CachedNetworkImage(
                                                imageUrl: imageUrl +
                                                    lawnImages[index]["image"],
                                                height: 80,
                                                width: 80,
                                                fit: BoxFit.fill,
                                                placeholder: (context, url) =>
                                                    LoadingAnimationWidget
                                                        .fourRotatingDots(
                                                  color: HexColor("#0275D8"),
                                                  size: 40,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                              //
                              //
                              //
                              //
                              // Visibility(
                              //   visible:
                              //       widget.jobType == "Upcoming" ? false : true,
                              //   child: Padding(
                              //     padding:
                              //         const EdgeInsets.fromLTRB(10, 15, 10, 20),
                              //     child: Row(
                              //       crossAxisAlignment: CrossAxisAlignment.end,
                              //       children: [
                              //         Icon(
                              //           Icons.circle,
                              //           color: HexColor("#58D109"),
                              //         ),
                              //         Expanded(
                              //           child: Padding(
                              //             padding: const EdgeInsets.only(bottom: 4),
                              //             child: Column(
                              //               children: [
                              //                 Text(
                              //                   "On his way",
                              //                   style: TextStyle(
                              //                     fontSize: size.width * 0.02,
                              //                   ),
                              //                 ),
                              //                 Divider(
                              //                   color: HexColor("#58D109"),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //         Icon(
                              //           Icons.circle,
                              //           color: HexColor("#58D109"),
                              //         ),
                              //         Flexible(
                              //           child: Padding(
                              //             padding: const EdgeInsets.only(bottom: 4),
                              //             child: Column(
                              //               children: [
                              //                 Text(
                              //                   "Started Job",
                              //                   style: TextStyle(
                              //                     fontSize: size.width * 0.02,
                              //                   ),
                              //                 ),
                              //                 Divider(
                              //                   color: HexColor("#58D109"),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //         Icon(
                              //           Icons.circle,
                              //           color: HexColor("#58D109"),
                              //         ),
                              //         Flexible(
                              //           child: Padding(
                              //             padding: const EdgeInsets.only(bottom: 4),
                              //             child: Column(
                              //               children: [
                              //                 Text(
                              //                   "Finished Job",
                              //                   style: TextStyle(
                              //                     fontSize: size.width * 0.02,
                              //                   ),
                              //                 ),
                              //                 Divider(
                              //                   color: HexColor("#58D109"),
                              //                 ),
                              //               ],
                              //             ),
                              //           ),
                              //         ),
                              //         Icon(
                              //           Icons.circle,
                              //           color: HexColor("#58D109"),
                              //         ),
                              //       ],
                              //     ),
                              //   ),
                              // ),
                              //
                              //
                              //
                              //
                              // Visibility(
                              //   visible:
                              //       widget.jobType == "Upcoming" ? true : false,
                              //   child: const SizedBox(
                              //     height: 20,
                              //   ),
                              // ),
                              const Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Service location",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: HexColor("#CBCBCB"),
                                    ),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 10, 0),
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'images/logo3.png',
                                          height: 80,
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text("Address:"),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        PageTransition(
                                                          type: PageTransitionType
                                                              .rightToLeftWithFade,
                                                          // 1
                                                          child: ServiceAddress(
                                                            addressNaved:
                                                                widget.address,
                                                            latNaved:
                                                                double.parse(
                                                                    widget.lat),
                                                            longNaved:
                                                                double.parse(
                                                                    widget.lng),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.place,
                                                      color:
                                                          HexColor("#0275D8"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Divider(
                                                color: Colors.grey,
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Text(
                                                      widget.address,
                                                      style: TextStyle(
                                                        color:
                                                            HexColor("#24B550"),
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Instructions",
                                        style: TextStyle(
                                          color: HexColor("#0275D8"),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  content: TextFormField(
                                                    autofocus: true,
                                                    onChanged: (value) {
                                                      if (mounted) {
                                                        setState(() {
                                                          myController.text =
                                                              value;
                                                        });
                                                      }
                                                    },
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      style: ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all(
                                                          Colors.grey,
                                                        ),
                                                      ),
                                                      child:
                                                          const Text('CANCEL'),
                                                    ),
                                                    ElevatedButton(
                                                      onPressed: () async {
                                                        var response =
                                                            await BaseClient()
                                                                .updateInstructions(
                                                          "/jobs/${widget.jobId}/update-instructions",
                                                          myController.text,
                                                        );
                                                        //
                                                        if (response[
                                                            "success"]) {
                                                          await EasyLoading
                                                              .dismiss();

                                                          if (mounted) {
                                                            // ignore: use_build_context_synchronously
                                                            Navigator.pop(
                                                                context);
                                                            _instructions.add(
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .fromLTRB(
                                                                        20,
                                                                        0,
                                                                        20,
                                                                        0),
                                                                child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  child: Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: <
                                                                        Widget>[
                                                                      const Icon(
                                                                        Icons
                                                                            .stop,
                                                                        size:
                                                                            14,
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          myController
                                                                              .text,
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                13,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        } else {
                                                          await EasyLoading
                                                              .dismiss();
                                                          // ignore: use_build_context_synchronously
                                                          Navigator.pop(
                                                              context);
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
                                                            ScaffoldMessenger
                                                                .of(context)
                                                              ..hideCurrentSnackBar()
                                                              ..showSnackBar(
                                                                  snackBar);
                                                          }
                                                        }
                                                      },
                                                      child:
                                                          const Text('SUBMIT'),
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        icon: const Icon(
                                          Icons.add,
                                        ),
                                        label: const Text('Instructions'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: _instructions.isEmpty
                                    ? [
                                        const Text("No instructions added"),
                                      ]
                                    : _instructions,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Material(
                                  elevation: 5.0,
                                  shadowColor: Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                      isDense: true,
                                      fillColor: HexColor("#E8E8E8"),
                                      filled: true,
                                      contentPadding: const EdgeInsets.all(10),
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        borderSide: BorderSide(
                                          width: 1,
                                          color: HexColor("#CBCBCB"),
                                        ),
                                      ),
                                      suffix: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: HexColor("#E8E8E8"),
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 5, 10, 5),
                                          child: Text(
                                            "\$$totalPrice",
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    initialValue: 'Total Price',
                                    enabled: false,
                                    autofocus: false,
                                    onTap: () {},
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                child: widget.jobType == "Upcoming"
                                    ? ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: HexColor("#24B550"),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          minimumSize:
                                              const Size.fromHeight(50),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            PageTransition(
                                              type: PageTransitionType
                                                  .rightToLeftWithFade,
                                              child: Proposals(
                                                orderId: widget.jobId,
                                                serviceType: serviceFor,
                                                grandTotal: totalPrice,
                                                date: date,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text('See Proposals'),
                                      )
                                    : widget.jobType == "Ongoing"
                                        ? null
                                        // ElevatedButton(
                                        //     style: ElevatedButton.styleFrom(
                                        //       backgroundColor: HexColor("#24B550"),
                                        //       shape: RoundedRectangleBorder(
                                        //         borderRadius:
                                        //             BorderRadius.circular(5),
                                        //       ),
                                        //       minimumSize:
                                        //           const Size.fromHeight(50),
                                        //     ),
                                        //     onPressed: () {},
                                        //     child: const Text('Reorder'),
                                        //   )
                                        : ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  HexColor("#24B550"),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              minimumSize:
                                                  const Size.fromHeight(50),
                                            ),
                                            onPressed: () {},
                                            child: const Text('Reorder'),
                                          ),
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
        ),
      ),
    );
  }
}
