import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';

import '../../Backend/base_client.dart';
import '../Login/logIn_screen.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy>
    with TickerProviderStateMixin {
  late var colorTween;
  late AnimationController controller;
  late Future<List<DataFaq>> futureData;
  List<bool> rowsAdd = [];

  Future<List<DataFaq>> getFaqsFunction() async {
    var response = await BaseClient().privPolic(
      "/privacy-policy",
    );
    if (json.decode(response.body)["message"] == "Unauthenticated.") {
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
      throw Exception('${json.decode(response.body)["message"]}');
    } else {
      if (json.decode(response.body)["success"]) {
        List jsonResponse = json.decode(response.body)["data"];
        return jsonResponse.map((data) => DataFaq.fromJson(data)).toList();
      } else {
        throw Exception('${json.decode(response.body)["message"]}');
      }
    }
  }

  showMsg(msg) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Alert!',
        message: '$msg',
        contentType: ContentType.failure,
      ),
    );
    if (mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
    );

    colorTween = controller.drive(
      ColorTween(
        begin: HexColor("#0275D8"),
        end: HexColor("#24B550"),
      ),
    );
    futureData = getFaqsFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Privacy Policy",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              FutureBuilder<List<DataFaq>>(
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.hasData && mounted) {
                    List<DataFaq>? data = snapshot.data;

                    return ListView.builder(
                      itemCount: data!.length,
                      // itemCount: _properties.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        String editedString =
                            data[index].answer.replaceAll(RegExp('\\s+'), ' ');
                        return Padding(
                          padding: const EdgeInsets.all(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "$editedString",
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      },
                      //
                    );
                  } else if (snapshot.hasError) {
                    return showMsg(snapshot.error);
                  }
                  // By default show a loading spinner.
                  return Column(
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      LoadingAnimationWidget.fourRotatingDots(
                        color: HexColor("#0275D8"),
                        size: 80,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DataFaq {
  final int id;
  final String answer;

  DataFaq({
    required this.id,
    required this.answer,
  });

  factory DataFaq.fromJson(Map<String, dynamic> json) {
    return DataFaq(
      id: json['id'],
      answer: json['clean_description'],
    );
  }
}
