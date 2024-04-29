import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:geocoding/geocoding.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uuid/uuid.dart';

import 'myProfile_screen.dart';

class SearchAddressUpdate extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? image;
  final String? lat;
  final String? lng;
  final String? zipCode;
  final String? address;
  const SearchAddressUpdate({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.lat,
    required this.lng,
    required this.zipCode,
    required this.address,
  });

  @override
  State<SearchAddressUpdate> createState() => _SearchAddressUpdateState();
}

class _SearchAddressUpdateState extends State<SearchAddressUpdate> {
  final TextEditingController _controller = TextEditingController();
  var uuid = const Uuid();
  String _sessionToken = "122344";
  List<dynamic> _placesList = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      onChanged();
    });
  }

  void onChanged() {
    if (_sessionToken == null) {
      if (mounted) {
        setState(() {
          _sessionToken = uuid.v4();
        });
      }
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input) async {
    String kPLACESAPIKEY = "AIzaSyC5qN37hurCFwbFsZt2nzzwzGcbSt08R5E";
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACESAPIKEY&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    // var data = response.body.toString();

    if (response.statusCode == 200) {
      if (mounted) {
        if (mounted) {
          setState(() {
            _placesList = jsonDecode(response.body.toString())["predictions"];
          });
        }
      }
    } else {
      throw Exception("Failed to load data");
    }
  }

  void _navigate(String addressNaved, double latNaved, double longNaved) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        // 3
        child: MyProfile(
          lat: latNaved.toString(),
          lng: longNaved.toString(),
          address: addressNaved,
          firstName: widget.firstName,
          lastName: widget.lastName,
          image: widget.image,
          zipCode: widget.zipCode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height - 50,
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
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Material(
              elevation: 5.0,
              shadowColor: Colors.grey,
              borderRadius: BorderRadius.circular(5),
              child: TextFormField(
                controller: _controller,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                autofocus: true,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: "Search places with name",
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
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                      color: Colors.white,
                      iconSize: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ListView.builder(
                itemCount: _placesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () async {
                      List<Location> locations = await locationFromAddress(
                        _placesList[index]["description"],
                      );
                      // print(locations.last.longitude);
                      // print(locations.last.latitude);
                      _navigate(
                        _placesList[index]["description"],
                        locations.last.latitude,
                        locations.last.longitude,
                      );
                    },
                    title: Text(_placesList[index]["description"]),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
