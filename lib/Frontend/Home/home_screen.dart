import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Drawer/drawer_widget.dart';
import 'Widgets/homeSteps_MainWidget.dart';
import 'search_location.dart';

class Home extends StatefulWidget {
  final bool addNotNull;
  final bool available;
  final String addressNaved;
  final double latNaved;
  final double longNaved;
  const Home({
    super.key,
    required this.addNotNull,
    required this.available,
    required this.addressNaved,
    required this.latNaved,
    required this.longNaved,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? address;
  double? latitude;
  double? longitude;
  bool shouldStop = false;
  late Timer backgroundFunction;
  late Timer backFunctionSnapShot;
  final Completer<GoogleMapController> _controller = Completer();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  final List<Marker> _markers = [];

  static CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(0.00, 0.00),
    zoom: 18,
  );

  Map<String, dynamic>? userMap;
  String firstName = "";
  String lastName = "";
  Future loadCurrentLocation() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? add = localStorage.getString("address");
    double? lat = localStorage.getDouble("lat");
    double? lng = localStorage.getDouble("lng");
    String? user = localStorage.getString('user');
    userMap = jsonDecode(user!) as Map<String, dynamic>;
    firstName = userMap!["first_name"];
    lastName = userMap!["last_name"];
    address = add;
    latitude = lat;
    longitude = lng;
    _markers.clear();
    if (lat != null && lng != null) {
      _markers.add(
        Marker(
          markerId: const MarkerId("1"),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: address,
          ),
        ),
      );
    }
    GoogleMapController controller = await _controller.future;
    if (lat != null && lng != null) {
      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(lat, lng),
            zoom: 18,
          ),
        ),
      );
    }
    if (lat != null && lng != null) {
      initialCameraPosition = CameraPosition(
        target: LatLng(lat, lng),
        zoom: 18,
      );
    }
    if (mounted) {
      setState(() {});
    }
    await Future.delayed(const Duration(seconds: 2), () {
      dismiss();
    });
  }

  void shouldStopTImer() async {
    // SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (widget.addNotNull && mounted && address != null) {
      if (mounted) {
        setState(() {
          shouldStop = true;
        });
      }
      if (shouldStop) {
        backgroundFunction.cancel();
      }
      Future.delayed(const Duration(seconds: 2)).then((_) {
        showMaterialModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          // expand: true,
          context: context,
          backgroundColor: Colors.white,
          builder: (context) => SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: HomeSteps(
              address: address,
              latNaved: latitude!,
              longNaved: longitude!,
            ),
          ),
        );
      });
    }
  }

  Future searchedLocation() async {
    address = widget.addressNaved;
    latitude = widget.latNaved;
    longitude = widget.longNaved;
    _markers.clear();
    _markers.add(
      Marker(
        markerId: const MarkerId("2"),
        position: LatLng(widget.latNaved, widget.longNaved),
        infoWindow: InfoWindow(
          title: address,
        ),
      ),
    );

    GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(widget.latNaved, widget.longNaved),
          zoom: 18,
        ),
      ),
    );
    initialCameraPosition = CameraPosition(
      target: LatLng(widget.latNaved, widget.longNaved),
      zoom: 18,
    );
    if (mounted) {
      setState(() {});
    }
    await Future.delayed(const Duration(seconds: 2), () {
      dismiss();
    });
  }

  void execute() {
    if (widget.addNotNull && mounted) {
      Future.delayed(const Duration(seconds: 2)).then((_) {
        showMaterialModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          // expand: true,
          context: context,
          backgroundColor: Colors.white,
          builder: (context) => SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: HomeSteps(
              address: address,
              latNaved: widget.latNaved,
              longNaved: widget.longNaved,
            ),
          ),
        );
      });
    }
  }

  Future dismiss() async {
    await EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
    // EasyLoading.show(
    //   maskType: EasyLoadingMaskType.black,
    // );
    if (widget.addressNaved == "" &&
        widget.latNaved == 0.00 &&
        widget.longNaved == 0.00) {
      loadCurrentLocation().then((value) {
        backgroundFunction =
            Timer.periodic(const Duration(seconds: 1), (timer) {
          shouldStopTImer();
        });
      });
    } else {
      searchedLocation().then((value) {
        execute();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      drawer: const Drawer(
        child: DrawerWidget(),
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.satellite,
            initialCameraPosition: initialCameraPosition,
            markers: Set<Marker>.of(_markers),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 3,
                    offset: const Offset(0, 0), // changes position of shadow
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  _globalKey.currentState!.openDrawer();
                },
                icon: const Icon(Icons.menu),
                iconSize: 30,
              ),
            ),
          ),
          // Positioned(
          //   top: 50,
          //   right: 20,
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: HexColor("#0275D8"),
          //       borderRadius: const BorderRadius.all(
          //         Radius.circular(30),
          //       ),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.grey.withOpacity(0.5),
          //           spreadRadius: 3,
          //           blurRadius: 3,
          //           offset: const Offset(0, 0), // changes position of shadow
          //         ),
          //       ],
          //     ),
          //     child: IconButton(
          //       onPressed: () {
          //         _globalKey.currentState!.openDrawer();
          //       },
          //       icon: const Icon(
          //         Icons.question_answer_outlined,
          //         color: Colors.white,
          //       ),
          //       iconSize: 30,
          //     ),
          //   ),
          // ),
          Positioned(
            top: 120,
            left: 20,
            right: 20,
            child: widget.addNotNull
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Material(
                      elevation: 5.0,
                      shadowColor: Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                      child: TextFormField(
                        onTap: () {
                          showMaterialModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            // expand: true,
                            context: context,
                            backgroundColor: Colors.white,
                            builder: (context) => SingleChildScrollView(
                              controller: ModalScrollController.of(context),
                              child: SearchLocation(
                                addressNaved: widget.addressNaved,
                                latNaved: widget.latNaved,
                                longNaved: widget.longNaved,
                              ),
                            ),
                          );
                        },
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                        readOnly: true,
                        autofocus: false,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: address,
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                          prefixIcon: const Icon(
                            Icons.location_on,
                            color: Colors.grey,
                          ),
                          suffixIcon: Material(
                            color: HexColor("#0275D8"),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0),
                            ),
                            child: IconButton(
                              onPressed: () => showMaterialModalBottomSheet(
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                // expand: true,
                                context: context,
                                backgroundColor: Colors.white,
                                builder: (context) => SingleChildScrollView(
                                  controller: ModalScrollController.of(context),
                                  child: HomeSteps(
                                    address: address,
                                    latNaved: latitude!,
                                    longNaved: longitude!,
                                  ),
                                ),
                              ),
                              icon: const Icon(Icons.arrow_right_alt),
                              color: Colors.white,
                              iconSize: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
          Positioned(
            bottom: 0,
            child: widget.addNotNull
                ? const SizedBox()
                : widget.available
                    ? ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 230,
                          minHeight: 230,
                          maxWidth: MediaQuery.of(context).size.width,
                          minWidth: MediaQuery.of(context).size.width,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3,
                                spreadRadius: 3,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              const BoxShadow(
                                color: Colors.white,
                                offset: Offset(0, 16),
                              ),
                              const BoxShadow(
                                color: Colors.white,
                                offset: Offset(-16, 16),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: Divider(
                                  color: Colors.grey[850],
                                  thickness: 3,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Hey! $firstName $lastName",
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Material(
                                    elevation: 5.0,
                                    shadowColor: Colors.grey,
                                    borderRadius: BorderRadius.circular(5),
                                    child: TextFormField(
                                      onTap: () {
                                        showMaterialModalBottomSheet(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                          ),
                                          // expand: true,
                                          context: context,
                                          backgroundColor: Colors.white,
                                          builder: (context) =>
                                              SingleChildScrollView(
                                            controller:
                                                ModalScrollController.of(
                                                    context),
                                            child: SearchLocation(
                                              addressNaved: widget.addressNaved,
                                              latNaved: widget.latNaved,
                                              longNaved: widget.longNaved,
                                            ),
                                          ),
                                        );
                                      },
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                      readOnly: true,
                                      autofocus: false,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        hintText:
                                            "Where do you want your service?",
                                        hintStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                        border: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                          borderSide: BorderSide(
                                            width: 0,
                                            style: BorderStyle.none,
                                          ),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.location_on,
                                          color: Colors.grey,
                                        ),
                                        suffixIcon: Material(
                                          color: HexColor("#0275D8"),
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(5.0),
                                            bottomRight: Radius.circular(5.0),
                                          ),
                                          child: IconButton(
                                            onPressed: () async {
                                              showMaterialModalBottomSheet(
                                                shape:
                                                    const RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(20),
                                                    topRight:
                                                        Radius.circular(20),
                                                  ),
                                                ),
                                                // expand: true,
                                                context: context,
                                                backgroundColor: Colors.white,
                                                builder: (context) =>
                                                    SingleChildScrollView(
                                                  controller:
                                                      ModalScrollController.of(
                                                          context),
                                                  child: SearchLocation(
                                                    addressNaved:
                                                        widget.addressNaved,
                                                    latNaved: widget.latNaved,
                                                    longNaved: widget.longNaved,
                                                  ),
                                                ),
                                              );
                                            },
                                            icon: const Icon(Icons.search),
                                            color: Colors.white,
                                            iconSize: 28,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width,
                          minWidth: MediaQuery.of(context).size.width,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 3,
                                spreadRadius: 3,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                              const BoxShadow(
                                color: Colors.white,
                                offset: Offset(0, 16),
                              ),
                              const BoxShadow(
                                color: Colors.white,
                                offset: Offset(-16, 16),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Image.asset(
                                "images/unavailable.png",
                                height: 100,
                              ),
                              Text(
                                "Whoops!",
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Text(
                                  "We are sorry. Submit the following information and we will get back to you when we will be available.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
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
                                    padding: const EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Flexible(
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                  isDense: true,
                                                  contentPadding:
                                                      const EdgeInsets.all(10),
                                                  border:
                                                      const UnderlineInputBorder(),
                                                  labelText:
                                                      '$firstName $lastName',
                                                  labelStyle: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Flexible(
                                              child: TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelText: 'Smith',
                                                  labelStyle:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Flexible(
                                              child: TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelText: 'US',
                                                  labelStyle:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Flexible(
                                              child: TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  isDense: true,
                                                  contentPadding:
                                                      EdgeInsets.all(10),
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelText: 'USA',
                                                  labelStyle:
                                                      TextStyle(fontSize: 12),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TextFormField(
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.all(10),
                                            border: UnderlineInputBorder(),
                                            labelText:
                                                '7700 Floyd Curl Drive, San Antonio, TX, USA',
                                            labelStyle: TextStyle(fontSize: 12),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20, right: 20, left: 20),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    minimumSize: const Size.fromHeight(50),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "Successfull",
                                            textAlign: TextAlign.center,
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: const [
                                              Text(
                                                "Email has been sent successfully.",
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                "We are coming to provide services in your area soon.",
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 70,
                                                right: 70,
                                              ),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      50,
                                                    ),
                                                  ),
                                                  minimumSize:
                                                      const Size.fromHeight(40),
                                                ),
                                                child: const Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 15,
                                                    bottom: 15,
                                                  ),
                                                  child: Text("OK"),
                                                ),
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text('Submit'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(
      //     Icons.location_disabled_outlined,
      //   ),
      //   onPressed: () async {
      //     loadCurrentLocation();
      //   },
      // ),
    );
  }
}
// Future<Position> getUserCurrentLocation() async {
//   await Geolocator.requestPermission()
//       .then((value) {})
//       .onError((error, stackTrace) {
//     // print("error" + error.toString());
//   });
//   return await Geolocator.getCurrentPosition(
//     desiredAccuracy: LocationAccuracy.high,
//   );
// }

// getUserCurrentLocation().then(
// (value) async {
// print("my current location");
// print("${value.latitude} ${value.longitude}");
// Position position = await getUserCurrentLocation();
// print("position");
// print(position);
// List<Placemark> placemarks = await placemarkFromCoordinates(
//     position.latitude, position.longitude);
// print("placemarks");
// print(placemarks);
// Placemark place = placemarks[0];
// print("place");
// print(place);
// };
// );
