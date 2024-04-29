import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectService extends StatefulWidget {
  const SelectService({super.key});

  @override
  State<SelectService> createState() => _SelectServiceState();
}

class _SelectServiceState extends State<SelectService> {
  bool service = true;
  Color selectedColor = Colors.grey;
  Color unSelectedColor = Colors.grey;
  bool? lawnMowing;
  bool? snowPlowing;
  void localStorage() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    lawnMowing = localStorage.getBool('lawnMowing');
    snowPlowing = localStorage.getBool('snowPlowing');
    if (lawnMowing == null && snowPlowing == null) {
      await localStorage.setBool('lawnMowing', true);
      await localStorage.setBool('snowPlowing', false);
      if (mounted) {
        setState(() {
          selectedColor = Colors.blue;
          unSelectedColor = Colors.grey;
        });
      }
    } else if (lawnMowing!) {
      if (mounted) {
        setState(() {
          selectedColor = Colors.blue;
          unSelectedColor = Colors.grey;
        });
      }
    } else if (snowPlowing!) {
      if (mounted) {
        setState(() {
          unSelectedColor = Colors.blue;
          selectedColor = Colors.grey;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    localStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Select your service",
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () async {
                SharedPreferences localStorage =
                    await SharedPreferences.getInstance();
                await localStorage.setBool('lawnMowing', true);
                await localStorage.setBool('snowPlowing', false);
                if (mounted) {
                  setState(() {
                    selectedColor = Colors.blue;
                    unSelectedColor = Colors.grey;
                  });
                }
              },
              child: Container(
                height: 110,
                width: 135,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: selectedColor.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      // backgroundColor: HexColor("#7CC0FB"),
                      backgroundColor: Colors.white,
                      radius: 40,
                      child: Image.asset(
                        "images/mowing.png",
                        height: 60,
                        // height: 40,
                      ),
                    ),
                    const Text("Lawn Mowing")
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                SharedPreferences localStorage =
                    await SharedPreferences.getInstance();
                await localStorage.setBool('snowPlowing', true);
                await localStorage.setBool('lawnMowing', false);
                if (mounted) {
                  setState(() {
                    unSelectedColor = Colors.blue;
                    selectedColor = Colors.grey;
                  });
                }
              },
              child: Container(
                height: 110,
                width: 135,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: unSelectedColor.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 3,
                      offset: const Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      // backgroundColor: HexColor("#7CC0FB"),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              "images/background.png",
                              height: 60,
                              // width: 200,
                            ),
                            Image.asset(
                              "images/plowing.png",
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Text("Snow Plowing")
                  ],
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
