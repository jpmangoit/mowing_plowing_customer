import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';

import '../../Backend/base_client.dart';
import '../Login/logIn_screen.dart';

class FAQ extends StatefulWidget {
  const FAQ({super.key});

  @override
  State<FAQ> createState() => _FAQState();
}

class _FAQState extends State<FAQ> with TickerProviderStateMixin {
  late var colorTween;
  late AnimationController controller;
  late Future<List<DataFaq>> futureData;
  List<bool> rowsAdd = [];

  Future<List<DataFaq>> getFaqsFunction() async {
    var response = await BaseClient().getFaqs(
      "/faqs",
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
        rowsAdd = [];
        for (int i = 0; i < json.decode(response.body)["data"].length; i++) {
          rowsAdd.add(false);
        }
        List jsonResponse = json.decode(response.body)["data"];
        if (mounted) {
          setState(() {});
        }
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
          "FAQs",
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
                    void showHide(int i) {
                      setState(() {
                        rowsAdd[i] = !rowsAdd[i];
                      });
                    }

                    return ListView.builder(
                      itemCount: data!.length,
                      // itemCount: _properties.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        String editedString = data[index]
                            .question
                            .replaceAll(RegExp('\\s+'), ' ');
                        String editedString2 =
                            data[index].answer.replaceAll(RegExp('\\s+'), ' ');
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    editedString,
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      rowsAdd[index] ? Icons.remove : Icons.add,
                                      size: 22,
                                    ),
                                    color: Colors.black,
                                    onPressed: () {
                                      showHide(index);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: rowsAdd[index],
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        editedString2,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Divider(
                                color: Colors.grey[400],
                                thickness: 1,
                              ),
                            ),
                          ],
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
  final String question;
  final String answer;

  DataFaq({
    required this.id,
    required this.question,
    required this.answer,
  });

  factory DataFaq.fromJson(Map<String, dynamic> json) {
    return DataFaq(
      question: json['question'],
      answer: json['clean_answer'],
      id: json['id'],
    );
  }
}
