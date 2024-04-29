import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:mowing_plowing/Frontend/Properties/addProperty_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:uuid/uuid.dart';
import "package:http/http.dart" as http;

class SearchProperty extends StatefulWidget {
  final String category_id;
  const SearchProperty({
    super.key,
    required this.category_id,
  });

  @override
  State<SearchProperty> createState() => _SearchPropertyState();
}

class _SearchPropertyState extends State<SearchProperty> {
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
        child: AddProperty(
          latNaved: latNaved,
          longNaved: longNaved,
          address: addressNaved,
          category_id: widget.category_id,
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
                      // print(locations.last.latitude);
                      // print(locations.last.longitude);
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
