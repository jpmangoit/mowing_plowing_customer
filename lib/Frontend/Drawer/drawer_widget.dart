import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mowing_plowing/Frontend/Login/logIn_screen.dart';
import 'package:mowing_plowing/Frontend/Profile/myProfile_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Backend/base_client.dart';
import '../BottomNavBar/bottomNavBar_screen.dart';
import '../FAQ/faq_screen.dart';
import '../FavouriteProvider/favouriteProvider_screen.dart';
import '../M&P_Pay/m&p_pay_screen1.dart';
import '../Notifications/notification_screen.dart';
import '../Payment/payment_screen1.dart';
import '../ReferFreind/referFreind_screen1.dart';
import '../Services/services_screen.dart';
import '../Settings/settings_screen.dart';
import '../Support/support_screen.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  Map<String, dynamic>? userMap;
  List<dynamic>? cardsMap;
  Map<String, dynamic>? walletMap;
  String? firstName;
  String? lastName;
  String? email;
  String? newEmail;
  String? unverifiedEmail;
  String? image;
  String? phoneNumber;
  String? newPhoneNumber;
  String? lat;
  String? lng;
  String? zipCode;
  String? address;
  String? emailVerifiedAt;
  String? walletAmount;

  Future<void> getUserDataFromLocal() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? user = localStorage.getString('user');
    userMap = jsonDecode(user!) as Map<String, dynamic>;
    image = userMap!["image"];
    firstName = userMap!["first_name"];
    lastName = userMap!["last_name"];
    email = userMap!["email"];
    newEmail = userMap!["new_email"];
    unverifiedEmail = userMap!["unverified_email"];
    phoneNumber = userMap!["phone_number"];
    newPhoneNumber = userMap!["new_phone_number"];
    lat = userMap!["lat"];
    lng = userMap!["lng"];
    zipCode = userMap!["zip_code"];
    address = userMap!["address"];
    emailVerifiedAt = userMap!["email_verified_at"];
    if (mounted) {
      setState(() {});
    }
  }

  FutureOr onGoBack(dynamic value) {
    getUserDataFromLocal();
  }

  Future<void> getUserPayDataFromLocal() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? wallet = localStorage.getString('wallet');
    walletMap = jsonDecode(wallet!) as Map<String, dynamic>;
    walletAmount = walletMap!["amount"].toString();
    if (mounted) {
      setState(() {});
    }
  }

  void completeFunc() {
    print(imageUrl);
    print(image);
    print(imageFileList);
    getUserDataFromLocal().then((value) {
      getUserPayDataFromLocal();
    });
    if (mounted) {
      setState(() {});
    }
  }

  FutureOr onGoBackPayment(dynamic value) {
    getUserPayDataFromLocal();
  }

  final ImagePicker imagePicker = ImagePicker();
  File? imageFileList;

  void selectImage() async {
    final XFile? selectedImages =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (selectedImages != null) {
      imageFileList = File(selectedImages.path);
      var response = await BaseClient().editProfileDetail(
        "/edit-profile-detail",
        firstName!,
        lastName!,
        imageFileList,
        address!,
        lat!,
        lng!,
        zipCode!,
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
          await localStorage.setString('user', jsonEncode(user));
          final snackBar = SnackBar(
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,
            content: AwesomeSnackbarContent(
              title: 'Updated!',
              message: 'Profile Picture updated successfully',
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
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    completeFunc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      SizedBox(
                        child: 
                        imageFileList == null && image == null 
                            ? 
                            Image.asset(
                                'images/upload.jpg',
                                height: 80,
                              )
                            : imageFileList == null && image != null
                                ? ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: imageUrl + image!,
                                      height: 80,
                                      width: 80,
                                      placeholder: (context, url) =>
                                          LoadingAnimationWidget.inkDrop(
                                        color: HexColor("#0275D8"),
                                        size: 40,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  )
                                : ClipOval(
                                    child: Image.file(
                                      File(imageFileList!.path),
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                      ),
                      InkWell(
                        onTap: () {
                          selectImage();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: HexColor("#0275D8"),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "$firstName $lastName ",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                // 3
                                child: MyProfile(
                                  firstName: firstName,
                                  lastName: lastName,
                                  image: image,
                                  lat: lat,
                                  lng: lng,
                                  zipCode: zipCode,
                                  address: address,
                                ),
                              ),
                            ).then(onGoBack);
                          },
                          child: Text(
                            "Edit Profile",
                            style: TextStyle(
                              color: HexColor("#0275D8"),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      // 3
                      child: const MPPayScreen1(),
                    ),
                  ).then(onGoBackPayment);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "M&P ",
                          style: TextStyle(
                            color: HexColor("#0275D8"),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: HexColor("#0275D8"),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(2, 3, 12, 3),
                            child: Text(
                              "Pay",
                              style: TextStyle(
                                fontFamily: "Neometric",
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            SharedPreferences localStorage =
                                await SharedPreferences.getInstance();
                            var response =
                                await BaseClient().getWalletAmountOfMP(
                              "/get-response-like-login",
                            );
                            //
                            if (json.decode(response.body)["success"]) {
                              Map<String, dynamic> user =
                                  json.decode(response.body)["data"]["user"];
                              Map<String, dynamic> wallet =
                                  json.decode(response.body)["data"]["wallet"];
                              List<dynamic> cards =
                                  json.decode(response.body)["data"]["cards"];
                              await localStorage.setString(
                                'referLink',
                                json.decode(response.body)["data"]["user"]
                                    ["referral_link"],
                              );
                              await localStorage.setString(
                                  'user', jsonEncode(user));
                              await localStorage.setString(
                                'wallet',
                                jsonEncode(wallet),
                              );
                              await localStorage.setString(
                                'cards',
                                jsonEncode(cards),
                              );
                              await localStorage.setString(
                                'autoRefillLimit',
                                json.decode(response.body)["data"]
                                    ["autoRefillLimit"],
                              );
                              await localStorage.setString(
                                'address',
                                json.decode(response.body)["data"]["user"]
                                    ["address"],
                              );
                              await localStorage.setDouble(
                                'lat',
                                double.parse(json.decode(response.body)["data"]
                                    ["user"]["lat"]),
                              );
                              await localStorage.setDouble(
                                'lng',
                                double.parse(json.decode(response.body)["data"]
                                    ["user"]["lng"]),
                              );
                              if (mounted) {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  PageTransition(
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    child: BottomNavBar(
                                      addressNaved: "",
                                      index: null,
                                      latNaved: 0.00,
                                      longNaved: 0.00,
                                      addNotNull: false,
                                    ),
                                  ),
                                  (route) => false,
                                );
                              }
                              await EasyLoading.dismiss();
                            } else {
                              await EasyLoading.dismiss();
                              final snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,
                                content: AwesomeSnackbarContent(
                                  title: 'Alert!',
                                  message:
                                      '${json.decode(response.body)["message"]}',
                                  contentType: ContentType.failure,
                                ),
                              );
                              if (mounted) {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBar);
                              }
                            }
                          },
                          color: HexColor("#0275D8"),
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                    Text(walletAmount != null ? "\$ $walletAmount" : "\$ 0"),
                  ],
                ),
              ),
            ],
          ),
        ),
        Stack(
          children: [
            Image.asset(
              "images/drawer.png",
            ),
            Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        // 3
                        child: const Notifications(),
                      ),
                    );
                  },
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -2,
                  ),
                  leading: const Icon(
                    Icons.notifications_outlined,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Notifications',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        // 3
                        child: const Payment1(),
                      ),
                    );
                  },
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -2,
                  ),
                  leading: const Icon(
                    Icons.credit_card,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Payment Method',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        child: const Services(),
                      ),
                    );
                  },
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -2,
                  ),
                  leading: const Icon(
                    Icons.miscellaneous_services,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Services',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        // 3
                        child: const FavouriteProvider(),
                      ),
                    );
                  },
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -2,
                  ),
                  leading: const Icon(
                    Icons.stars_sharp,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Favorite Provider',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                // ListTile(
                //   onTap: () {},
                //   visualDensity: const VisualDensity(
                //     horizontal: 0,
                //     vertical: -2,
                //   ),
                //   leading: const Icon(
                //     Icons.wallet,
                //     color: Colors.white,
                //   ),
                //   title: const Text(
                //     'My Wallet',
                //     style: TextStyle(
                //       color: Colors.white,
                //     ),
                //   ),
                // ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        // 3
                        child: const ReferFreind1(),
                      ),
                    );
                  },
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -2,
                  ),
                  leading: const Icon(
                    Icons.people_outline_outlined,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Refer a friend',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        // 3
                        child: const FAQ(),
                      ),
                    );
                  },
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -2,
                  ),
                  leading: const Icon(
                    Icons.quiz_outlined,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'FAQs',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        // 3
                        child: const Help(),
                      ),
                    );
                  },
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -2,
                  ),
                  leading: const Icon(
                    Icons.support_agent_outlined,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Support',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        // 3
                        child: Settings(
                          firstName: firstName,
                          lastName: lastName,
                          email: email,
                          newEmail: newEmail,
                          unverifiedEmail: unverifiedEmail,
                          image: image,
                          phoneNumber: phoneNumber,
                          newPhoneNumber: newPhoneNumber,
                          lat: lat,
                          lng: lng,
                          zipCode: zipCode,
                          address: address,
                          emailVerifiedAt: emailVerifiedAt,
                        ),
                      ),
                    ).then(onGoBack);
                  },
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -2,
                  ),
                  leading: const Icon(
                    Icons.settings_outlined,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                ListTile(
                  onTap: () {
                    QuickAlert.show(
                      context: context,
                      type: QuickAlertType.warning,
                      title: "Are you sure",
                      text:
                          'You want to delete your account\nYou will not be able to undo this action',
                      cancelBtnText: "Ok",
                      confirmBtnColor: Colors.red,
                      onConfirmBtnTap: () async {
                        var response = await BaseClient().deleteAccount(
                          "/delete-account",
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
                            await localStorage.clear();
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
                      showCancelBtn: false,
                    );
                  },
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -2,
                  ),
                  leading: const Icon(
                    Icons.power_settings_new,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Delete Account',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Divider(
                  color: HexColor("#E8E8E8"),
                ),
                ListTile(
                  onTap: () async {
                    var response = await BaseClient().logOut(
                      "/logout",
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
                        await localStorage.clear();
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
                  visualDensity: const VisualDensity(
                    horizontal: 0,
                    vertical: -2,
                  ),
                  leading: const Icon(
                    Icons.power_settings_new,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
