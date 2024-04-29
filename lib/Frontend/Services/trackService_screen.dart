import 'dart:async';
import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:custom_marker/marker_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:location/location.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Backend/api_constants.dart';
import '../../Backend/base_client.dart';
import '../Appointments/noti.dart';
import '../Chat/chat_screen.dart';
import '../Globals/constants.dart';
import '../Login/logIn_screen.dart';
import '../ProviderDetails/providerDetails_screen.dart';
import 'serviceDetails_screen.dart';

// const double CAMERA_ZOOM = 18;
// const double CAMERA_TILT = 80;
// const double CAMERA_BEARING = 30;
// const LatLng SOURCE_LOCATION = LatLng(0.0, 0.0);
// const LatLng DEST_LOCATION = LatLng(32.18354342813462, 74.19977172045913);

class TrackService extends StatefulWidget {
  final String provId;
  final String orderId;
  final String service;
  final String granTotal;
  final String address;
  final String date;
  final String provStatus;

  const TrackService({
    super.key,
    required this.provId,
    required this.orderId,
    required this.service,
    required this.granTotal,
    required this.address,
    required this.date,
    required this.provStatus,
  });

  @override
  State<TrackService> createState() => _TrackServiceState();
}

class _TrackServiceState extends State<TrackService> {
  bool accepted = false;
  bool onWay = false;
  bool startedJob = false;
  bool finishedJob = false;
  Map<String, dynamic>? userMap;
  String? orderNo;
  String? providerImage = "";
  int? providerId;
  String? customerId = "";

  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = Set<Marker>();

  // Set<Polyline> _polylines = Set<Polyline>();

  // List<LatLng> polylineCoordinates = [];

  // PolylinePoints? polylinePoints;

  String googleAPIKey = googleApiKey;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;

  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;

  // LocationData? currentLocation;

  LocationData? destinationLocation;

  // Location? location;

  // StreamSubscription<LocationData>? locationSubscription;

  String? img = "images/upload.jpg";

  LatLng provLoc = LatLng(0.0, 0.0);

  Future getInitialLocation() async {
    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    var response = await BaseClient().getProvLastLoc(
      "/provider-last-known-location/${widget.provId}",
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
        if (widget.provStatus == "null") {
          accepted = true;
          onWay = false;
          startedJob = false;
          finishedJob = false;
        } else if (widget.provStatus == "1") {
          accepted = true;
          onWay = true;
          startedJob = false;
          finishedJob = false;
        } else if (widget.provStatus == "2") {
          accepted = true;
          onWay = true;
          startedJob = true;
          finishedJob = false;
        } else if (widget.provStatus == "3") {
          accepted = true;
          onWay = true;
          startedJob = true;
          finishedJob = true;
        }
        provLoc = LatLng(
            double.parse(response["data"]["provider"]["provider_last_location"]
                ["last_known_lat"]),
            double.parse(response["data"]["provider"]["provider_last_location"]
                ["last_known_lng"]));
        if (response["data"]["provider"]["image"] != null) {
          img = response["data"]["provider"]["image"];
        }
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        token = localStorage.getString('token')!;
      } else {
        if (mounted) {
          Navigator.pop(context);
        }
      }
    }
  }

  String token = "";

  // pusher
  //
  late FlutterPusher pusherClient;
  late Echo echo;

  void onConnectionStateChange(ConnectionStateChange event) {
    print("STATE:${event.currentState}");
    if (event.currentState == 'CONNECTED') {
      print('CONNECTED');
    } else if (event.currentState == 'DISCONNECTED') {
      print('DISCONNECTED');
    }
  }

  //
  //

  // local storage
  //
  Future localStorageData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = localStorage.getString('token')!;
    String? user = localStorage.getString('user');
    userMap = jsonDecode(user!) as Map<String, dynamic>;
    customerId = userMap!["id"].toString();
    providerImage = userMap!["image"];
  }

  // echoSetUp
  //
  void _setUpEcho() {
    // print("echo.private");
    pusherClient = getPusherClient(token);
    echo = echoSetup(token, pusherClient);
    pusherClient.connect(onConnectionStateChange: onConnectionStateChange);
    // listen
    //
    echo.private("notifications.$customerId").stopListening('.NewNotification');
    echo.private("notifications.$customerId").listen('.NewNotification',
        (notification) {
      Noti.showNotification(notification["notification"]);
    });
    echo.private("order-live-chat.${widget.orderId}").listen(
          ".ProviderLiveLocationUpdated",
          (e) => {
            // print(e),
            updatePinOnMap(double.parse(e["location"]["lat"]),
                double.parse(e["location"]["lng"]))
          },
        );
  }

  //
  //

  void completeFunct() async {
    await getInitialLocation().then((value) async {
      localStorageData().then((value) async {
        _setUpEcho();
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    completeFunct();
    // _setUpEcho();
  }

  @override
  void dispose() {
    pusherClient = getPusherClient(token);
    echo = echoSetup(token, pusherClient);
    pusherClient.connect(onConnectionStateChange: onConnectionStateChange);
    echo
        .private("order-live-chat.${widget.orderId}")
        .stopListening(".ProviderLiveLocationUpdated");
    echo.private("notifications.$customerId").listen('.NewNotification',
        (notification) {
      Noti.showNotification(notification["notification"]);
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      zoom: 17,
      // tilt: CAMERA_TILT,
      bearing: 30,
      target: provLoc,
    );
    if (provLoc.latitude != 0.0) {
      EasyLoading.dismiss();
      initialCameraPosition = CameraPosition(
        zoom: 17,
        // tilt: CAMERA_TILT,
        bearing: 30,
        target: LatLng(
          provLoc.latitude,
          provLoc.longitude,
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Track your service",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: provLoc.latitude == 0.0
          ? null
          : Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                GoogleMap(
                  // myLocationEnabled: true,
                  tiltGesturesEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  markers: _markers,
                  // polylines: _polylines,
                  mapType: MapType.satellite,
                  initialCameraPosition: initialCameraPosition,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                    // my map has completed being created;
                    // i'm ready to show the pins on the map
                    showPinsOnMap();
                  },
                ),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 3,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Scrollbar(
                            // thumbVisibility: true,
                            // trackVisibility: true,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Text(
                                    accepted &&
                                            onWay == false &&
                                            startedJob == false &&
                                            finishedJob == false
                                        ? "Provider has accepted your service request"
                                        : accepted &&
                                                onWay &&
                                                startedJob == false &&
                                                finishedJob == false
                                            ? "Provider is on the way"
                                            : accepted &&
                                                    onWay &&
                                                    startedJob &&
                                                    finishedJob == false
                                                ? "Provider has reached your location and started job"
                                                : "Provider has finished the job",
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 15, 20, 20),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Icon(
                                          accepted
                                              ? Icons.circle
                                              : Icons.circle_outlined,
                                          color: HexColor("#58D109"),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4),
                                            child: Divider(
                                              color: HexColor("#58D109"),
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          onWay
                                              ? Icons.circle
                                              : Icons.circle_outlined,
                                          color: HexColor("#58D109"),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4),
                                            child: Divider(
                                              color: HexColor("#58D109"),
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          startedJob
                                              ? Icons.circle
                                              : Icons.circle_outlined,
                                          color: HexColor("#58D109"),
                                        ),
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4),
                                            child: Divider(
                                              color: HexColor("#58D109"),
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          finishedJob
                                              ? Icons.circle
                                              : Icons.circle_outlined,
                                          color: HexColor("#58D109"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 0, 20, 20),
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Material(
                                        elevation: 5,
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey[300],
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                  0,
                                                  5,
                                                  10,
                                                  0,
                                                ),
                                                child: IntrinsicHeight(
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        'images/logo3.png',
                                                        height: 80,
                                                      ),
                                                      Flexible(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Text(
                                                                    widget
                                                                        .service,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                  Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .circular(
                                                                        5,
                                                                      ),
                                                                      border:
                                                                          Border
                                                                              .all(
                                                                        color: HexColor(
                                                                            "#24B550"),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          const EdgeInsets
                                                                              .all(
                                                                        5,
                                                                      ),
                                                                      child:
                                                                          Text(
                                                                        widget
                                                                            .granTotal,
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
                                                                height: 10,
                                                              ),
                                                              Row(
                                                                children: <
                                                                    Widget>[
                                                                  Expanded(
                                                                    child: Text(
                                                                      widget
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
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Divider(
                                                color: Colors.grey[400],
                                                height: 1,
                                                thickness: 1,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                  20,
                                                  0,
                                                  10,
                                                  0,
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Due date: ${widget.date}",
                                                        style: const TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  void updatePinOnMap(double lat, double lng) async {
    CameraPosition cPosition = CameraPosition(
      zoom: 17,
      bearing: 30,
      target: LatLng(lat, lng),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    var pinPosition = LatLng(
      lat,
      lng,
    );
    _markers.removeWhere((m) => m.markerId.value == "sourcePin");
    _markers.add(
      Marker(
        markerId: const MarkerId("sourcePin"),
        position: pinPosition, // updated position
        infoWindow: const InfoWindow(title: "Provider's current location"),
        icon: img == "images/upload.jpg"
            ? await MarkerIcon.pictureAsset(
                assetPath: "images/upload.jpg",
                width: 80,
                height: 80,
              )
            : await MarkerIcon.downloadResizePictureCircle(
                "$imageUrl/$img",
                size: 80,
              ),
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  void showPinsOnMap() async {
    var pinPosition = LatLng(
      provLoc.latitude,
      provLoc.longitude,
    );
    _markers.add(
      Marker(
        markerId: const MarkerId('sourcePin'),
        position: pinPosition,
        infoWindow: const InfoWindow(title: "Provider's current location"),
        icon: img == "images/upload.jpg"
            ? await MarkerIcon.pictureAsset(
                assetPath: "images/upload.jpg",
                width: 80,
                height: 80,
              )
            : await MarkerIcon.downloadResizePictureCircle(
                "$imageUrl/$img",
              ),
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }
}
