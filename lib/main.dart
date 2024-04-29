import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:mowing_plowing/Frontend/BottomNavBar/bottomNavBar_screen.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'Backend/api_constants.dart';
import 'Backend/base_client.dart';
import 'Frontend/Appointments/noti.dart';
import 'Frontend/Notifications/notification_screen.dart';
import 'Frontend/Splash/splash_screen.dart';

void main() {
  Noti.initializeNotification();

  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance.indicatorType = EasyLoadingIndicatorType.cubeGrid;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mowing Plowing Customer App',
      theme: ThemeData(
        scaffoldBackgroundColor: HexColor("#F1F1F1"),
        colorScheme: ThemeData()
            .colorScheme
            .copyWith(
              primary: HexColor("#0275D8"),
            )
            .copyWith(error: Colors.red),
        // primarySwatch: HexColor("#0275D8"),
      ),
      home: UpgradeAlert(
        upgrader: Upgrader(
          showReleaseNotes: false,
          dialogStyle: UpgradeDialogStyle.cupertino,
          shouldPopScope: () => true,
        ),
        child: CheckAuth(),
      ),
      builder: EasyLoading.init(),
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  Timer? timer;
  String? firstName;
  String? lastName;

  @override
  void initState() {
    _checkIfLoggedIn();
    // getNotifiesFunction();
    completeFunct();
    var contextState = context;
    setState(() {
      Noti.listenActionStream(contextState);
    });
    // timer?.cancel();
    // timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
    //   getNotifiesFunction();
    // });
    super.initState();
  }

  getNotifiesFunction() async {
    var response = await BaseClient().getNotification(
      "/notifications",
    );
    if (json.decode(response.body)["success"]) {
      List jsonResponse =
          json.decode(response.body)["data"]["allNotifications"];
      // Noti.showNotification(jsonResponse[0]);
      for (var data in jsonResponse) {
        if (data['status'] == 0) {
          Noti.showNotification(data);
        }
      }
      await BaseClient().getNotification(
        "/notifications/update-status",
      );
    } else {
      throw Exception('${json.decode(response.body)["message"]}');
    }
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      if (mounted) {
        setState(() {
          isAuth = true;
        });
      }
      // getNotifiesFunction();
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
    pusherClient = getPusherClient(token);
    pusherClient.connect(onConnectionStateChange: onConnectionStateChange);
    echo = echoSetup(token, pusherClient);
    // listen
    //
    echo.private("notifications.$providerId").listen('.NewNotification',
        (notification) {
      // Noti.showNotification(jsonResponse[0]);
      print('new notification...............................');
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
        QuickAlert.show(
          context: context,
          type: QuickAlertType.info,
          title: "Welcome",
          text: "Welcome to Mowing and Plowing $firstName $lastName",
          cancelBtnText: "Ok",
          confirmBtnColor: Colors.yellow[600]!,
          showCancelBtn: false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      child = BottomNavBar(
        addressNaved: "",
        index: null,
        latNaved: 0.00,
        longNaved: 0.00,
        addNotNull: false,
      );
    } else {
      child = const Splash();
    }
    return child;
  }
}
