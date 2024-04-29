import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReferFreind2 extends StatefulWidget {
  const ReferFreind2({super.key});

  @override
  State<ReferFreind2> createState() => _ReferFreind2State();
}

class _ReferFreind2State extends State<ReferFreind2> {
  @override
  String referLink = "";

  void referLinkFunc() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    referLink = localStorage.getString(
      'referLink',
    )!;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    referLinkFunc();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Refer a new friend and get a bonus of up to 50\$ in your Mowing and Plowing Cash Wallet",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "*Terms and Conditions are applied*",
                  style: TextStyle(fontSize: 11.5, color: HexColor("#A8A8A8")),
                ),
              ],
            ),
          ),
          Divider(
            color: HexColor("#CBCBCB"),
            thickness: 3,
          ),
          Column(
            children: const [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Share your referral link:",
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Material(
              elevation: 5.0,
              shadowColor: Colors.grey,
              borderRadius: BorderRadius.circular(10),
              child: TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.all(10),
                  border: InputBorder.none,
                  labelText: 'https://www.mowingandplowing.com$referLink',
                  labelStyle: const TextStyle(
                    fontSize: 10,
                    color: Colors.blue,
                  ),
                ),
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      // email = value;
                    });
                  }
                },
              ),
            ),
          ),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(25, 0, 20, 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "The receiver will add this code while sign up.",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(
                              text:
                                  'https://www.mowingandplowing.com$referLink',
                            ),
                          ).then(
                            (value) {
                              final snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: 'Referral Link!',
                                  message: 'Link copied successfully',
                                  contentType: ContentType.success,
                                ),
                              );
                              if (mounted) {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBar);
                              }
                            },
                          );
                        },
                        icon: Icon(
                          Icons.content_copy_rounded,
                          color: HexColor("#0275D8"),
                          size: 16,
                        ),
                        label: Text(
                          "Copy Link",
                          style: TextStyle(
                            color: HexColor("#0275D8"),
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   width: 20,
                    // ),
                    // Expanded(
                    //   child: ElevatedButton.icon(
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor: HexColor("#0275D8"),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(10),
                    //       ),
                    //     ),
                    //     onPressed: () {},
                    //     icon: const Icon(
                    //       Icons.content_copy_rounded,
                    //       color: Colors.white,
                    //       size: 16,
                    //     ),
                    //     label: const Text(
                    //       "Share Link",
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
