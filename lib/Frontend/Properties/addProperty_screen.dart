import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mowing_plowing/Frontend/BottomNavBar/bottomNavBar_screen.dart';
import 'package:mowing_plowing/Frontend/Properties/searchProperty_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../../Backend/base_client.dart';
import '../Login/logIn_screen.dart';

class AddProperty extends StatefulWidget {
  final String category_id;
  final String? address;
  final double? latNaved;
  final double? longNaved;
  const AddProperty({
    super.key,
    required this.category_id,
    required this.address,
    required this.latNaved,
    required this.longNaved,
  });

  @override
  State<AddProperty> createState() => _AddPropertyState();
}

class _AddPropertyState extends State<AddProperty> {
  bool agree = false;
  Color termPolicies = Colors.blue;
  Color checkText = Colors.black;
  final GlobalKey<FormState> _form = GlobalKey();
  bool error = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Property",
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
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 10,
            ),
            Container(
              alignment: Alignment.center,
              child: const Text(
                "Add Property",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Form(
              key: _form,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text("Select your property address from the search"),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Visibility(
                    visible: error,
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Please provide property address",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Material(
                      elevation: 5.0,
                      shadowColor: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          showMaterialModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            // expand: true,
                            context: context,
                            backgroundColor: Colors.white,
                            builder: (context) => SingleChildScrollView(
                              controller: ModalScrollController.of(context),
                              child: SearchProperty(
                                category_id: widget.category_id,
                              ),
                            ),
                          );
                        },
                        child: TextFormField(
                          enabled: false,
                          initialValue:
                              widget.address ?? 'Search property address',
                          minLines: 1,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            // isDense: true,
                            contentPadding: EdgeInsets.fromLTRB(15, 13, 0, 5),
                            border: InputBorder.none,
                            suffixIcon: Icon(
                              Icons.search,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30),
              alignment: Alignment.center,
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () async {
                      if (widget.address == null) {
                        if (mounted) {
                          setState(() {
                            error = true;
                          });
                        }
                        return;
                      }
                      var response = await BaseClient().addProperties(
                        "/add-properties",
                        widget.category_id,
                        widget.address!,
                        widget.latNaved.toString(),
                        widget.longNaved.toString(),
                      );
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
                          if (mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                child: BottomNavBar(
                                  addressNaved: '',
                                  addNotNull: false,
                                  index: 1,
                                  latNaved: 0.00,
                                  longNaved: 0.00,
                                ),
                              ),
                              (route) => false,
                            );
                          }
                        } else {
                          final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Alert!',
                              message: '${response["message"]}',
                              contentType: ContentType.failure,
                            ),
                          );
                          if (mounted) {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          }
                        }
                      }
                    },
                    child: const Text('Add Property'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
