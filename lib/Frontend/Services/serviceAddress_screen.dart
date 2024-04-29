import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Drawer/drawer_widget.dart';

class ServiceAddress extends StatefulWidget {
  final String addressNaved;
  final double latNaved;
  final double longNaved;
  const ServiceAddress({
    super.key,
    required this.addressNaved,
    required this.latNaved,
    required this.longNaved,
  });

  @override
  State<ServiceAddress> createState() => _ServiceAddressState();
}

class _ServiceAddressState extends State<ServiceAddress> {
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
          zoom: 20,
        ),
      ),
    );
    initialCameraPosition = CameraPosition(
      target: LatLng(widget.latNaved, widget.longNaved),
      zoom: 20,
    );
    if (mounted) {
      setState(() {});
    }
    await Future.delayed(const Duration(seconds: 2), () {
      dismiss();
    });
  }

  Future dismiss() async {
    await EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.show(
      maskType: EasyLoadingMaskType.black,
    );
    searchedLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: const Text(
          "Service Location",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
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
        ],
      ),
    );
  }
}
