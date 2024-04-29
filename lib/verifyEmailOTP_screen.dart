// import 'package:flutter/material.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:page_transition/page_transition.dart';

// import '../Login/logIn_screen.dart';
// import 'Frontend/Sign_Up/verifyPhoneNumber_screen.dart';
// import 'editProfile_screen.dart';
// import 'verifyPhoneNumber_screen.dart';

// class VerifyEmailOTP extends StatefulWidget {
//   final String email;
//   final String phoneNumber;
//   const VerifyEmailOTP({
//     super.key,
//     required this.email,
//     required this.phoneNumber,
//   });

//   @override
//   State<VerifyEmailOTP> createState() => _VerifyEmailOTPState();
// }

// class _VerifyEmailOTPState extends State<VerifyEmailOTP> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         physics: const ClampingScrollPhysics(),
//         child: Column(
//           children: [
//             SizedBox(
//               height: MediaQuery.of(context).size.height / 10,
//             ),
//             Image.asset(
//               'images/logo.png',
//               width: 300,
//             ),
//             const SizedBox(
//               height: 60,
//             ),
//             const Text(
//               "Enter the code",
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(
//               height: 5,
//             ),
//             Text(
//               "Sent to ${widget.email}",
//               style: const TextStyle(fontSize: 12),
//             ),
//             const SizedBox(
//               height: 40,
//             ),
//             OtpTextField(
//               numberOfFields: 6,
//               borderColor: HexColor("#0275D8"),
//               showFieldAsBox: false,
//               enabledBorderColor: Colors.black,
//               focusedBorderColor: HexColor("#0275D8"),
//               //runs when a code is typed in
//               onCodeChanged: (String code) {
//                 //handle validation or checks here
//               },
//               //runs when every textfield is filled
//               onSubmit: (String verificationCode) {
//                 Navigator.push(
//                   context,
//                   PageTransition(
//                     type: PageTransitionType.rightToLeftWithFade,
//                     child: VerifyPhoneNumber(
//                       phoneNumber: widget.phoneNumber,
//                     ),
//                   ),
//                 );
//                 // showDialog(
//                 //     context: context,
//                 //     builder: (context) {
//                 //       return AlertDialog(
//                 //         title: const Text("Verification Code"),
//                 //         content:
//                 //             Text('Code entered is $verificationCode'),
//                 //       );
//                 //     },);
//               }, // end onSubmit
//             ),
//             const SizedBox(
//               height: 40,
//             ),
//             TextButton(
//               onPressed: () {},
//               child: const Text('Resend Code'),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   "Already have an account?",
//                   style: TextStyle(fontSize: 12),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       PageTransition(
//                         type: PageTransitionType.rightToLeftWithFade,
//                         child: const LogIn(),
//                       ),
//                     );
//                   },
//                   child: const Text(
//                     "  Log in",
//                     style: TextStyle(fontSize: 12, color: Colors.blue),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
