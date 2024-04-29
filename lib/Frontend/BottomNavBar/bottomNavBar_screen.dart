import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Backend/api_constants.dart';
import '../Appointments/appointments_screen.dart';
import '../Appointments/noti.dart';
import '../Home/home_screen.dart';
import '../Payment/payment_screen1.dart';
import '../Properties/properties_screen.dart';

// ignore: must_be_immutable
class BottomNavBar extends StatefulWidget {
  final int? index;
  late bool addNotNull;
  final String addressNaved;
  final double latNaved;
  final double longNaved;

  BottomNavBar({
    Key? key,
    required this.index,
    required this.addNotNull,
    required this.addressNaved,
    required this.latNaved,
    required this.longNaved,
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selecIndex = 0;
  bool def = true;
  String? firstName;
  String? lastName;

  late final List<Widget> _widgetOptions = <Widget>[
    Home(
      addressNaved: widget.addressNaved,
      latNaved: widget.latNaved,
      longNaved: widget.longNaved,
      addNotNull: widget.addNotNull,
      available: true,
    ),
    const Properties(),
    const Appointments(),
    const Payment1(),
  ];

  void onTapped(int index) {
    _selecIndex = index;
    if (mounted) {
      setState(() {});
    }
  }

  // pusher
  //
  String token = "";
  Map<String, dynamic>? userMap;
  int? providerId;

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

  // echoSetUp
  //
  void _setUpEcho() {
    // print(111111111111111111);
    pusherClient = getPusherClient(token);
    // print(2222222222222);
    // print("pusherClient");
    // print(pusherClient);
    pusherClient.connect(onConnectionStateChange: onConnectionStateChange);
    // print(33333333333333);
    echo = echoSetup(token, pusherClient);
    // listen
    //
    echo.private("notifications.$providerId").listen('.NewNotification',
        (notification) {
      // Noti.showNotification(jsonResponse[0]);
      print(notification);
      Noti.showNotification(notification["notification"]);
      // QuickAlert.show(
      //   context: context,
      //   type: QuickAlertType.info,
      //   title: "${notification["notification"]["title"]}",
      //   text: '${notification["notification"]["content"]}',
      //   cancelBtnText: "Ok",
      //   confirmBtnColor: Colors.yellow[600]!,
      //   showCancelBtn: false,
      // );
    });
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
    providerId = userMap!["id"];
    firstName = userMap!["first_name"];
    lastName = userMap!["last_name"];
  }

  //
  //

  void completeFunct() {
    localStorageData().then((value) async {
      _setUpEcho();
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // Noti.listenActionStream(context);
    // completeFunct();
    if (widget.index != null) {
      _selecIndex = widget.index!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions[_selecIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            topLeft: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              spreadRadius: 0,
              blurRadius: 10,
            ),
          ],
        ),
        child:
            // ClipRRect(
            //   borderRadius: const BorderRadius.only(
            //     topLeft: Radius.circular(30.0),
            //     topRight: Radius.circular(30.0),
            //   ),
            //   child:
            BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: _selecIndex,
          selectedItemColor: HexColor("#707070"),
          unselectedItemColor: HexColor("#707070"),
          // iconSize: 30,
          onTap: (index) {
            if (mounted) {
              setState(() => _selecIndex = index);
            }
          },
          elevation: 5,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  const ImageIcon(
                    AssetImage("images/home.png"),
                    size: 30,
                  ),
                  SizedBox(
                    height: _selecIndex == 0 ? 10 : null,
                  ),
                  SizedBox(
                    child: _selecIndex == 0
                        ? Icon(
                            Icons.circle,
                            size: 10,
                            color: HexColor("#FFCC00"),
                          )
                        : null,
                  ),
                ],
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  const ImageIcon(
                    AssetImage("images/properties.png"),
                    size: 30,
                  ),
                  SizedBox(
                    height: _selecIndex == 1 ? 10 : null,
                  ),
                  SizedBox(
                    child: _selecIndex == 1
                        ? Icon(
                            Icons.circle,
                            size: 10,
                            color: HexColor("#FFCC00"),
                          )
                        : null,
                  ),
                ],
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  const ImageIcon(
                    AssetImage(
                      "images/appoint.png",
                    ),
                    size: 30,
                  ),
                  SizedBox(
                    height: _selecIndex == 2 ? 10 : null,
                  ),
                  SizedBox(
                    child: _selecIndex == 2
                        ? Icon(
                            Icons.circle,
                            size: 10,
                            color: HexColor("#FFCC00"),
                          )
                        : null,
                  ),
                ],
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Column(
                children: [
                  const ImageIcon(
                    AssetImage("images/wallet.png"),
                    size: 30,
                  ),
                  SizedBox(
                    height: _selecIndex == 3 ? 10 : null,
                  ),
                  SizedBox(
                    child: _selecIndex == 3
                        ? Icon(
                            Icons.circle,
                            size: 10,
                            color: HexColor("#FFCC00"),
                          )
                        : null,
                  ),
                ],
              ),
              label: "",
            ),
          ],
        ),
        // ),
      ),
    );
  }
}
