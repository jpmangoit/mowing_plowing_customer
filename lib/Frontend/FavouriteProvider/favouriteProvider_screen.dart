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
import '../Login/logIn_screen.dart';

class FavouriteProvider extends StatefulWidget {
  const FavouriteProvider({super.key});

  @override
  State<FavouriteProvider> createState() => _FavouriteProviderState();
}

class _FavouriteProviderState extends State<FavouriteProvider>
    with TickerProviderStateMixin {
  late var colorTween;
  late AnimationController controller;
  Future<List<FavoriteProvider>>? futureDataUp;
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

  Future<List<FavoriteProvider>> getOnGoingJobFunction() async {
    var response = await BaseClient().favProv(
      "/favorite-providers",
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
        return jsonResponse
            .map((data) => FavoriteProvider.fromJson(data))
            .toList();
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
          "Favorite Provider",
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
          child: FutureBuilder<List<FavoriteProvider>>(
            future: futureDataUp,
            builder: (context, snapshot) {
              if (snapshot.hasData && mounted) {
                List<FavoriteProvider>? data = snapshot.data;
                return data!.isEmpty
                    ? Column(
                        children: const [
                          SizedBox(
                            height: 60,
                          ),
                          Text(
                            "No favorite provider's",
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
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Ratings: ${data[index].averageQualityRatings} / 5.0 ",
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: HexColor("#24B550"),
                                                ),
                                              ),
                                            ],
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              var response = await BaseClient()
                                                  .favProvTogg(
                                                "/upcoming-jobs/toggle-favorite-provider/${data[index].id}",
                                              );
                                              if (response["message"] ==
                                                  "Unauthenticated.") {
                                                if (mounted) {
                                                  Navigator.pushAndRemoveUntil(
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
                                                    behavior: SnackBarBehavior
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
                                                  ScaffoldMessenger.of(context)
                                                    ..hideCurrentSnackBar()
                                                    ..showSnackBar(snackBar);
                                                }
                                              } else {
                                                if (response["success"]) {
                                                  data.removeWhere((e) =>
                                                      e.id == data[index].id);
                                                  if (mounted) {
                                                    setState(() {});
                                                  }
                                                  await EasyLoading.dismiss();
                                                } else {
                                                  await EasyLoading.dismiss();
                                                  final snackBar = SnackBar(
                                                    elevation: 0,
                                                    behavior: SnackBarBehavior
                                                        .floating,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    content:
                                                        AwesomeSnackbarContent(
                                                      title: 'Alert!',
                                                      message:
                                                          '${response["message"]}',
                                                      contentType:
                                                          ContentType.failure,
                                                    ),
                                                  );
                                                  if (mounted) {
                                                    ScaffoldMessenger.of(
                                                        context)
                                                      ..hideCurrentSnackBar()
                                                      ..showSnackBar(snackBar);
                                                  }
                                                }
                                              }
                                            },
                                            child: const Icon(
                                              Icons.favorite_rounded,
                                              color: Colors.red,
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

class FavoriteProvider {
  final String id;
  final String first_name;
  final String last_name;
  final String address;
  final String lat;
  final String lng;
  final String? image;
  final String? averageQualityRatings;

  FavoriteProvider({
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.image,
    required this.averageQualityRatings,
  });

  factory FavoriteProvider.fromJson(Map<String, dynamic> json) {
    return FavoriteProvider(
      id: json['user']['id'].toString(),
      first_name: json['user']['first_name'].toString(),
      last_name: json['user']['last_name'].toString(),
      address: json['user']['address'].toString(),
      lat: json['user']['lat'].toString(),
      lng: json['user']['lng'].toString(),
      image: json['user']['image'].toString(),
      averageQualityRatings: json['user']['averageQualityRatings'].toString(),
    );
  }
}
