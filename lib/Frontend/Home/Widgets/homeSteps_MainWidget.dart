import 'dart:async';
import 'dart:convert';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Backend/base_client.dart';
import '../../Appointments/appointments_screen.dart';
import '../../Login/logIn_screen.dart';
import 'Lawn_Mowing/details_widget.dart';
import 'Lawn_Mowing/recurringServices_widget.dart';
import 'Lawn_Mowing/schedule_widget.dart';
import 'Lawn_Mowing/selectService_widget.dart';
import 'Lawn_Mowing/serviceDetail_widget.dart';
import 'Lawn_Mowing/uploadPhotos_widget.dart';
import 'Snow_Plowing/Business_Snow_Plowing/homeDetails_widget.dart';
import 'Snow_Plowing/Business_Snow_Plowing/scheduleBusiness_widget.dart';
import 'Snow_Plowing/Business_Snow_Plowing/serviceSummary_widget.dart';
import 'Snow_Plowing/Business_Snow_Plowing/uploadPhotos_widget.dart';
import 'Snow_Plowing/Car_Snow_Plowing/scheduleCar_widget.dart';
import 'Snow_Plowing/Car_Snow_Plowing/serviceCategory2_widget.dart';
import 'Snow_Plowing/Car_Snow_Plowing/serviceSummary_widget.dart';
import 'Snow_Plowing/Car_Snow_Plowing/uploadPhotos_widget.dart';
import 'Snow_Plowing/Home_Snow_Plowing/homeDetails_widget.dart';
import 'Snow_Plowing/Home_Snow_Plowing/scheduleHome_widget.dart';
import 'Snow_Plowing/Home_Snow_Plowing/serviceSummary_widget.dart';
import 'Snow_Plowing/Home_Snow_Plowing/uploadPhotos_widget.dart';
import 'Snow_Plowing/serviceCategory_widget.dart';

class HomeSteps extends StatefulWidget {
  final String? address;
  final double latNaved;
  final double longNaved;
  const HomeSteps({
    super.key,
    required this.address,
    required this.latNaved,
    required this.longNaved,
  });

  @override
  State<HomeSteps> createState() => _HomeStepsState();
}

class _HomeStepsState extends State<HomeSteps> {
  int _selecIndex = 0;
  bool widgetOptions = true;
  bool loading = true;

  void onBackTap() async {
    if (mounted) {
      setState(() {
        _selecIndex = _selecIndex - 1;
      });
    }
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setInt("_selecIndex", _selecIndex);
  }

  FutureOr onGoBackPayment(dynamic value) async {
    _selecIndex = 0;
    if (mounted) {
      setState(() {});
    }
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.setInt("_selecIndex", _selecIndex);
  }

  late List<Widget> _widgetOptions = <Widget>[
    const SelectService(),
  ];

  Future pay(bool lawn, String? cat) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? orderId = localStorage.getString('orderIdToPay');
    String? grandTotal = localStorage.getString('grandTotal');
    var response = await BaseClient().payOrder(
      "/pay",
      orderId!,
      grandTotal!,
    );
    if (response == "Payment has already done for this order") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "images/warning.png",
                  // height: 150,
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  '$response',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: const Text("OK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        },
      );
    } else {
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
          _selecIndex = 0;
          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          Map<String, dynamic> wallet = response["0"];
          await localStorage.remove("wallet");
          await localStorage.setString(
            'wallet',
            jsonEncode(wallet),
          );
          await localStorage.setInt("_selecIndex", _selecIndex);
          if (lawn && cat == null) {
            await localStorage.remove('lawnMowing');
            await localStorage.remove('snowPlowing');
            await localStorage.remove('todayChargesL');
            await localStorage.remove('sizeL');
            await localStorage.remove('heightL');
            await localStorage.remove('sizeIdL');
            await localStorage.remove('heightIdL');
            await localStorage.remove('cornerLotL');
            await localStorage.remove('fenceL');
            await localStorage.remove('over52L');
            await localStorage.remove('under52L');
            await localStorage.remove('gateCodeL');
            await localStorage.remove('yardBeforeMowL');
            await localStorage.remove('lightL');
            await localStorage.remove('heavyL');
            await localStorage.remove('cleanUpIdL');
            await localStorage.remove('fenceIdL');
            await localStorage.remove('sevenDaysL');
            await localStorage.remove('tenDaysL');
            await localStorage.remove('fourteenDaysL');
            await localStorage.remove('oneTimeL');
            await localStorage.remove('image0L');
            await localStorage.remove('image1L');
            await localStorage.remove('image2L');
            await localStorage.remove('image3L');
            await localStorage.remove('dateControllerL');
            await localStorage.remove('todayChargesL');
            await localStorage.remove('sameDayL');
            await localStorage.remove('selectDateL');
            await localStorage.remove('instructionL');
            await localStorage.remove('orderIdToPay');
            await localStorage.remove('grandTotal');
            await localStorage.remove('nextOn1');
            await localStorage.remove('nextOn2');
            await localStorage.remove('nextOn3');
            await localStorage.remove('nextOn4');
          } else {
            if (cat == "Home") {
              await localStorage.remove('lawnMowing');
              await localStorage.remove('snowPlowing');
              await localStorage.remove('category');
              await localStorage.remove('widthH');
              await localStorage.remove('lengthH');
              await localStorage.remove('snowPlowingSchedulesH');
              await localStorage.remove('sidewalkH');
              await localStorage.remove('walkawayH');
              await localStorage.remove('SidewalkH');
              await localStorage.remove('WalkwayH');
              await localStorage.remove('snowDepthInitValueH');
              await localStorage.remove('snowDepthInitValueIdH');
              await localStorage.remove('image0H');
              await localStorage.remove('image1H');
              await localStorage.remove('image2H');
              await localStorage.remove('image3H');
              await localStorage.remove('nextOn1');
              await localStorage.remove('nextOn2');
              await localStorage.remove('nextOn3');
              await localStorage.remove('nextOn4');
              await localStorage.remove('instructionH');
              await localStorage.remove('snowPlowingScheduleSelectedH');
              await localStorage.remove('orderIdToPay');
              await localStorage.remove('grandTotal');
            } else if (cat == "Business") {
              //
              await localStorage.remove('lawnMowing');
              await localStorage.remove('snowPlowing');
              await localStorage.remove('category');
              await localStorage.remove('widthB');
              await localStorage.remove('lengthB');
              await localStorage.remove('snowPlowingSchedulesB');
              await localStorage.remove('sidewalkB');
              await localStorage.remove('walkawayB');
              await localStorage.remove('smallSidewalkB');
              await localStorage.remove('smallWalkwayB');
              await localStorage.remove('mediumSidewalkB');
              await localStorage.remove('mediumWalkwayB');
              await localStorage.remove('largeSidewalkB');
              await localStorage.remove('largeWalkwayB');
              await localStorage.remove('snowDepthInitValueB');
              await localStorage.remove('snowDepthInitValueIdB');
              await localStorage.remove('instructionB');
              await localStorage.remove('nextOn1');
              await localStorage.remove('nextOn2');
              await localStorage.remove('nextOn3');
              await localStorage.remove('nextOn4');
              await localStorage.remove('image0B');
              await localStorage.remove('image1B');
              await localStorage.remove('image2B');
              await localStorage.remove('image3B');
              await localStorage.remove('snowPlowingScheduleSelectedB');
              await localStorage.remove('orderIdToPay');
              await localStorage.remove('grandTotal');
            } else {
              //
              await localStorage.remove('lawnMowing');
              await localStorage.remove('snowPlowing');
              await localStorage.remove('category');
              await localStorage.remove('snowPlowingSchedulesC');
              await localStorage.remove('carSelectedC');
              await localStorage.remove('currentColorC');
              await localStorage.remove('currentColorIdC');
              await localStorage.remove('carPlateNoC');
              await localStorage.remove('instructionC');
              await localStorage.remove('nextOn1');
              await localStorage.remove('nextOn2');
              await localStorage.remove('nextOn3');
              await localStorage.remove('nextOn4');
              await localStorage.remove('image0C');
              await localStorage.remove('image1C');
              await localStorage.remove('image2C');
              await localStorage.remove('image3C');
              await localStorage.remove('snowPlowingScheduleSelectedC');
              await localStorage.remove('orderIdToPay');
              await localStorage.remove('grandTotal');
            }
          }
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "images/congrats.png",
                      height: 150,
                    ),
                    const Text("Congratulations!"),
                  ],
                ),
                content: const Text(
                  "Your order has been placed successfully.",
                  textAlign: TextAlign.center,
                ),
                actions: [
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil<void>(
                          context,
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const Appointments()),
                          ModalRoute.withName('/'),
                        ).then(onGoBackPayment);
                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   PageTransition(
                        //     type: PageTransitionType.rightToLeftWithFade,
                        //     child: const Appointments(),
                        //   ),
                        // ).then(onGoBackPayment);
                      },
                    ),
                  ),
                ],
              );
            },
          );
          if (mounted) {
            setState(() {});
          }
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "images/warning.png",
                      // height: 150,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      '${response["message"]}',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actions: [
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        }
      }
    }
  }

  Future onNextTap() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    bool? widgetOpt = localStorage.getBool('lawnMowing');
    String? catg = localStorage.getString('category');
    widgetOptions = widgetOpt!;
    if (widgetOptions) {
      _widgetOptions = <Widget>[
        const SelectService(),
        const Details(),
        const RecurringServices(),
        const UploadPhotos(),
        const Schedule(),
        const ServiceDetail(),
      ];
      //  else {
      if (_selecIndex == 1) {
        bool? check = localStorage.getBool("nextOn1");
        _selecIndex = check != null && check
            ? _selecIndex + 1
            : _selecIndex = _selecIndex;
        if (mounted) {
          setState(() {});
        }
        await localStorage.setInt("_selecIndex", _selecIndex);
      } else if (_selecIndex == 2) {
        bool? check = localStorage.getBool("nextOn2");
        _selecIndex = check != null && check
            ? _selecIndex + 1
            : _selecIndex = _selecIndex;
        if (mounted) {
          setState(() {});
        }
        await localStorage.setInt("_selecIndex", _selecIndex);
      } else if (_selecIndex == 3) {
        bool? check = localStorage.getBool("nextOn3");
        _selecIndex = check != null && check
            ? _selecIndex + 1
            : _selecIndex = _selecIndex;
        if (mounted) {
          setState(() {});
        }
        await localStorage.setInt("_selecIndex", _selecIndex);
      } else if (_selecIndex == 4) {
        bool? check = localStorage.getBool("nextOn4");
        _selecIndex = check != null && check
            ? _selecIndex + 1
            : _selecIndex = _selecIndex;
        if (mounted) {
          setState(() {});
        }
        await localStorage.setInt("_selecIndex", _selecIndex);
      } else if (_selecIndex == 5) {
        String? cardCheck = localStorage.getString('cardCheckBeforePay');
        _selecIndex = _selecIndex;
        await localStorage.setInt("_selecIndex", _selecIndex);
        if (cardCheck == "[]" || cardCheck == null) {
          // _selecIndex = _selecIndex;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "images/warning.png",
                      // height: 150,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Kindly select payment method to proceed!",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actions: [
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          bool? check = localStorage.getBool("nextOn5");
          if (check != null && check) {
            // _selecIndex = _selecIndex;
            pay(true, null);
          }
        }
        if (mounted) {
          setState(() {});
        }
      } else {
        _selecIndex = _selecIndex + 1;
        if (mounted) {
          setState(() {});
        }
        await localStorage.setInt("_selecIndex", _selecIndex);
      }
      // }
    } else {
      _widgetOptions = <Widget>[
        const SelectService(),
        const ServiceCategory(),
        catg == "Home"
            ? const HomeDetails()
            : catg == "Business"
                ? const HomeDetailsBusiness()
                : const ServiceCategory2(),
        catg == "Home"
            ? const UploadPhotosHome()
            : catg == "Business"
                ? const UploadPhotosBusiness()
                : const UploadPhotosCar(),
        catg == "Home"
            ? const ScheduleHome()
            : catg == "Business"
                ? const ScheduleBusiness()
                : const ScheduleCar(),
        catg == "Home"
            ? const ServiceSummaryHome()
            : catg == "Business"
                ? const ServiceSummaryBusiness()
                : const ServiceSummary(),
      ];
      if (_selecIndex == 5) {
        String? cardCheck = localStorage.getString('cardCheckBeforePay');
        if (cardCheck == "[]" || cardCheck == null) {
          _selecIndex = _selecIndex;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      "images/warning.png",
                      // height: 150,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      "Kindly select payment method to proceed!",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                actions: [
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          _selecIndex = _selecIndex;
          pay(false, catg);
        }
      } else {
        if (_selecIndex == 1) {
          bool? check = localStorage.getBool("nextOn1");
          _selecIndex = check != null && check
              ? _selecIndex + 1
              : _selecIndex = _selecIndex;
          if (mounted) {
            setState(() {});
          }
          await localStorage.setInt("_selecIndex", _selecIndex);
        } else if (_selecIndex == 2 && catg == "Car") {
          bool? check = localStorage.getBool("nextOn2");
          String? check2 = localStorage.getString("carPlateNoC");
          _selecIndex = check != null && check && check2 != null && check2 != ""
              ? _selecIndex + 1
              : _selecIndex = _selecIndex;
          if (mounted) {
            setState(() {});
          }
          await localStorage.setInt("_selecIndex", _selecIndex);
        } else if (_selecIndex == 2 && catg != "Car") {
          bool? check = localStorage.getBool("nextOn2");
          _selecIndex = check != null && check
              ? _selecIndex + 1
              : _selecIndex = _selecIndex;
          if (mounted) {
            setState(() {});
          }
          await localStorage.setInt("_selecIndex", _selecIndex);
        } else if (_selecIndex == 3) {
          bool? check = localStorage.getBool("nextOn3");
          _selecIndex = check != null && check
              ? _selecIndex + 1
              : _selecIndex = _selecIndex;
          if (mounted) {
            setState(() {});
          }
          await localStorage.setInt("_selecIndex", _selecIndex);
        } else if (_selecIndex == 4) {
          bool? check = localStorage.getBool("nextOn4");
          _selecIndex = check != null && check
              ? _selecIndex + 1
              : _selecIndex = _selecIndex;
          if (mounted) {
            setState(() {});
          }
          await localStorage.setInt("_selecIndex", _selecIndex);
        } else {
          _selecIndex = _selecIndex + 1;
          if (mounted) {
            setState(() {});
          }
          await localStorage.setInt("_selecIndex", _selecIndex);
        }
      }
    }
  }

  Future addLatLng() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? addr = localStorage.getString('orderAddress');
    String? lt = localStorage.getString('orderLat');
    String? ln = localStorage.getString('orderLng');
    if (addr == null && lt == null && ln == null) {
      //
      // print("null");
      // print(addr);
      // print(lt);
      // print(ln);
      await localStorage.setString('orderAddress', widget.address!);
      await localStorage.setString('orderLat', widget.latNaved.toString());
      await localStorage.setString('orderLng', widget.longNaved.toString());
      _selecIndex = 0;
      _widgetOptions = <Widget>[
        const SelectService(),
        const Details(),
        const RecurringServices(),
        const UploadPhotos(),
        const Schedule(),
        const ServiceDetail(),
      ];
      await localStorage.setInt("_selecIndex", _selecIndex);
    } else {
      //
      if (addr == widget.address &&
          double.parse(lt!) == widget.latNaved &&
          double.parse(ln!) == widget.longNaved) {
        //
        //
        bool widgetOptions = true;
        bool? widgetOpt = localStorage.getBool('lawnMowing');
        String? catg = localStorage.getString('category');
        widgetOptions = widgetOpt!;
        _selecIndex = localStorage.getInt('_selecIndex')!;
        await localStorage.setString('orderAddress', widget.address!);
        await localStorage.setString('orderLat', widget.latNaved.toString());
        await localStorage.setString('orderLng', widget.longNaved.toString());
        if (widgetOptions) {
          _widgetOptions = <Widget>[
            const SelectService(),
            const Details(),
            const RecurringServices(),
            const UploadPhotos(),
            const Schedule(),
            const ServiceDetail(),
          ];
        } else {
          _widgetOptions = <Widget>[
            const SelectService(),
            const ServiceCategory(),
            catg == "Home"
                ? const HomeDetails()
                : catg == "Business"
                    ? const HomeDetailsBusiness()
                    : const ServiceCategory2(),
            catg == "Home"
                ? const UploadPhotosHome()
                : catg == "Business"
                    ? const UploadPhotosBusiness()
                    : const UploadPhotosCar(),
            catg == "Home"
                ? const ScheduleHome()
                : catg == "Business"
                    ? const ScheduleBusiness()
                    : const ScheduleCar(),
            catg == "Home"
                ? const ServiceSummaryHome()
                : catg == "Business"
                    ? const ServiceSummaryBusiness()
                    : const ServiceSummary(),
          ];
        }
      } else {
        //
        //
        await localStorage.remove('lawnMowing');
        await localStorage.remove('snowPlowing');
        await localStorage.remove('todayChargesL');
        await localStorage.remove('sizeL');
        await localStorage.remove('heightL');
        await localStorage.remove('sizeIdL');
        await localStorage.remove('heightIdL');
        await localStorage.remove('cornerLotL');
        await localStorage.remove('fenceL');
        await localStorage.remove('over52L');
        await localStorage.remove('under52L');
        await localStorage.remove('gateCodeL');
        await localStorage.remove('yardBeforeMowL');
        await localStorage.remove('lightL');
        await localStorage.remove('heavyL');
        await localStorage.remove('cleanUpIdL');
        await localStorage.remove('fenceIdL');
        await localStorage.remove('sevenDaysL');
        await localStorage.remove('tenDaysL');
        await localStorage.remove('fourteenDaysL');
        await localStorage.remove('oneTimeL');
        await localStorage.remove('image0L');
        await localStorage.remove('image1L');
        await localStorage.remove('image2L');
        await localStorage.remove('image3L');
        await localStorage.remove('dateControllerL');
        await localStorage.remove('todayChargesL');
        await localStorage.remove('sameDayL');
        await localStorage.remove('selectDateL');
        await localStorage.remove('instructionL');
        await localStorage.remove('orderIdToPay');
        await localStorage.remove('grandTotal');
        await localStorage.remove('nextOn1');
        await localStorage.remove('nextOn2');
        await localStorage.remove('nextOn3');
        await localStorage.remove('nextOn4');
        await localStorage.remove('category');
        await localStorage.remove('widthH');
        await localStorage.remove('lengthH');
        await localStorage.remove('snowPlowingSchedulesH');
        await localStorage.remove('sidewalkH');
        await localStorage.remove('walkawayH');
        await localStorage.remove('SidewalkH');
        await localStorage.remove('WalkwayH');
        await localStorage.remove('snowDepthInitValueH');
        await localStorage.remove('snowDepthInitValueIdH');
        await localStorage.remove('image0H');
        await localStorage.remove('image1H');
        await localStorage.remove('image2H');
        await localStorage.remove('image3H');
        await localStorage.remove('instructionH');
        await localStorage.remove('snowPlowingScheduleSelectedH');
        await localStorage.remove('widthB');
        await localStorage.remove('lengthB');
        await localStorage.remove('snowPlowingSchedulesB');
        await localStorage.remove('sidewalkB');
        await localStorage.remove('walkawayB');
        await localStorage.remove('smallSidewalkB');
        await localStorage.remove('smallWalkwayB');
        await localStorage.remove('mediumSidewalkB');
        await localStorage.remove('mediumWalkwayB');
        await localStorage.remove('largeSidewalkB');
        await localStorage.remove('largeWalkwayB');
        await localStorage.remove('snowDepthInitValueB');
        await localStorage.remove('snowDepthInitValueIdB');
        await localStorage.remove('instructionB');
        await localStorage.remove('image0B');
        await localStorage.remove('image1B');
        await localStorage.remove('image2B');
        await localStorage.remove('image3B');
        await localStorage.remove('snowPlowingScheduleSelectedB');
        await localStorage.remove('snowPlowingSchedulesC');
        await localStorage.remove('carSelectedC');
        await localStorage.remove('currentColorC');
        await localStorage.remove('currentColorIdC');
        await localStorage.remove('carPlateNoC');
        await localStorage.remove('instructionB');
        await localStorage.remove('image0C');
        await localStorage.remove('image1C');
        await localStorage.remove('image2C');
        await localStorage.remove('image3C');
        await localStorage.remove('snowPlowingScheduleSelectedC');
        await localStorage.setString('orderAddress', widget.address!);
        await localStorage.setString('orderLat', widget.latNaved.toString());
        await localStorage.setString('orderLng', widget.longNaved.toString());
        // setState(() {
        _selecIndex = 0;
        // });
        await localStorage.setInt("_selecIndex", _selecIndex);
      }
    }
    // localStorage.getInt('_selecIndex') == null
    //     ? _selecIndex = 0
    //     : _selecIndex = localStorage.getInt('_selecIndex')!;
  }

  void completeFunc() {
    addLatLng().then((value) async {
      loading = false;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    completeFunc();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 700,
      ),
      child: SingleChildScrollView(
        child: SizedBox(
          child: loading
              ? LoadingAnimationWidget.fourRotatingDots(
                  color: HexColor("#0275D8"),
                  size: 40,
                )
              : Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Divider(
                        color: Colors.grey[850],
                        thickness: 3,
                      ),
                    ),
                    SizedBox(
                      child: _selecIndex == 0
                          ? null
                          : Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  onPressed: () {
                                    onBackTap();
                                  },
                                  icon: const Icon(Icons.arrow_back),
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: _selecIndex == 0 ? 20 : 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 40),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Your property",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Icon(
                            Icons.location_on_sharp,
                            size: 15,
                            color: HexColor("#FFCC00"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 350),
                              child: Text(
                                widget.address ?? "",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      color: Colors.grey,
                      // thickness: 3,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // const SelectService(),
                    _widgetOptions[_selecIndex],
                    const Divider(
                      color: Colors.grey,
                      // thickness: 3,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                          onNextTap();
                        },
                        child: Text(_selecIndex <= 4 ? 'Next' : "Pay"),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
