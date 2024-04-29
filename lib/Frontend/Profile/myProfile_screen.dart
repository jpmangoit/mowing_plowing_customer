import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mowing_plowing/Backend/base_client.dart';
import 'package:mowing_plowing/Frontend/Profile/searchAddressUpdate_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Login/logIn_screen.dart';

class MyProfile extends StatefulWidget {
  final String? firstName;
  final String? lastName;
  final String? image;
  final String? lat;
  final String? lng;
  final String? zipCode;
  final String? address;
  const MyProfile({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.image,
    required this.lat,
    required this.lng,
    required this.zipCode,
    required this.address,
  });

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final GlobalKey<FormState> _form = GlobalKey();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  bool error = false;
  final ImagePicker imagePicker = ImagePicker();
  File? imageFileList;

  void selectImages() async {
    final XFile? selectedImages =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImages != null) {
      imageFileList = File(selectedImages.path);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.firstName);
    lastNameController = TextEditingController(text: widget.lastName);
    zipCodeController = TextEditingController(text: widget.zipCode);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "My Profile",
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
              Form(
                key: _form,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 20,
                    ),
                    const Text("Edit you personal info"),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Material(
                              elevation: 5.0,
                              shadowColor: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                              child: TextFormField(
                                controller: firstNameController,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  border: InputBorder.none,
                                  labelText: 'First Name',
                                  suffixIcon: Icon(Icons.badge),
                                ),
                                validator: (value) {
                                  if (value == null || value == "") {
                                    return "Please enter first name";
                                  } else if (value.contains(RegExp(r'[0-9]'))) {
                                    return "Please enter valid name";
                                  }

                                  return null;
                                },
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
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Material(
                              elevation: 5.0,
                              shadowColor: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                              child: TextFormField(
                                controller: lastNameController,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.all(10),
                                  border: InputBorder.none,
                                  labelText: 'Last Name',
                                  suffixIcon: Icon(Icons.badge),
                                ),
                                validator: (value) {
                                  if (value == null || value == "") {
                                    return "Please enter last name";
                                  } else if (value.contains(RegExp(r'[0-9]'))) {
                                    return "Please enter valid name";
                                  }

                                  return null;
                                },
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
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Material(
                        elevation: 5.0,
                        shadowColor: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        child: TextFormField(
                          controller: zipCodeController,
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            border: InputBorder.none,
                            labelText: 'Zip Code',
                          ),
                          validator: (value) {
                            if (value == null || value == "") {
                              return "Please enter Zip Code";
                            }

                            return null;
                          },
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
                    Visibility(
                      visible: error,
                      child: const SizedBox(
                        height: 10,
                      ),
                    ),
                    Visibility(
                      visible: error,
                      child: const Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Please provide your address",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
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
                                child: SearchAddressUpdate(
                                  firstName: widget.firstName,
                                  lastName: widget.lastName,
                                  image: widget.image,
                                  lat: widget.lat,
                                  lng: widget.lng,
                                  zipCode: widget.zipCode,
                                  address: widget.address,
                                ),
                              ),
                            );
                          },
                          child: TextFormField(
                            enabled: false,
                            initialValue:
                                widget.address ?? 'Search your address',
                            decoration: const InputDecoration(
                              // isDense: true,
                              contentPadding: EdgeInsets.fromLTRB(15, 13, 0, 0),
                              border: InputBorder.none,
                              suffixIcon: Icon(
                                Icons.search,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: SizedBox(
                        child: imageFileList == null && widget.image == null
                            ? null
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ClipOval(
                                    child: imageFileList != null
                                        ? Image.file(
                                            File(imageFileList!.path),
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.fill,
                                          )
                                        : Image.network(
                                            imageUrl + widget.image!,
                                            height: 100,
                                            width: 100,
                                            fit: BoxFit.fill,
                                          ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      // minimumSize: const Size.fromHeight(50),
                                    ),
                                    onPressed: () {
                                      selectImages();
                                    },
                                    child: const Text('Change Profile Picture'),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    Visibility(
                      visible: imageFileList == null && widget.image == null
                          ? true
                          : false,
                      child: Container(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Material(
                          elevation: 5.0,
                          shadowColor: Colors.grey,
                          borderRadius: BorderRadius.circular(10),
                          child: TextFormField(
                            readOnly: true,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.all(10),
                              border: InputBorder.none,
                              enabled: true,
                              labelText: "Upload Profile Picture",
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: ElevatedButton(
                                  onPressed: () {
                                    selectImages();
                                  },
                                  // icon: const Icon(
                                  //   Icons.download,
                                  // ),
                                  child: const Text('Upload Picture'),
                                ),
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
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () async {
                          if (!(_form.currentState?.validate() ?? true)) {
                            return;
                          } else if (widget.address == null) {
                            if (mounted) {
                              setState(() {
                                error = true;
                              });
                            }
                            return;
                          }

                          var response = await BaseClient().editProfileDetail(
                            "/edit-profile-detail",
                            firstNameController.text,
                            lastNameController.text,
                            imageFileList,
                            widget.address!,
                            widget.lat!,
                            widget.lng!,
                            zipCodeController.text,
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
                              SharedPreferences localStorage =
                                  await SharedPreferences.getInstance();
                              await localStorage.remove('user');
                              Map<String, dynamic> user = response["data"];
                              await localStorage.setString(
                                  'user', jsonEncode(user));
                              final snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: 'Updated!',
                                  message: '${response["message"]}',
                                  contentType: ContentType.success,
                                ),
                              );
                              if (mounted) {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBar);
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
                        child: const Text('Update Profile'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
