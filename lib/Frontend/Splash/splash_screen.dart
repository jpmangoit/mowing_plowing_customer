import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../Sign_Up/emailPhone_screen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Future check() async {
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: const EmailPhone(),
        ),
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 4),
      check,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/splash.png"),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
