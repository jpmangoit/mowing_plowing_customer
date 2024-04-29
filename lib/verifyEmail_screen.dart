// import 'package:flutter/material.dart';
// import 'package:page_transition/page_transition.dart';

// import 'Frontend/Login/logIn_screen.dart';
// import 'verifyEmailOTP_screen.dart';

// class VerifyEmail extends StatefulWidget {
//   final String email;
//   final String phoneNumber;
//   const VerifyEmail({
//     super.key,
//     required this.email,
//     required this.phoneNumber,
//   });

//   @override
//   State<VerifyEmail> createState() => _VerifyEmailState();
// }

// class _VerifyEmailState extends State<VerifyEmail> {
//   final GlobalKey<FormState> _form = GlobalKey();
//   @override
//   void initState() {
//     super.initState();
//   }

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
//             Container(
//               alignment: Alignment.center,
//               child: const Text(
//                 "Verify your email",
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Form(
//               key: _form,
//               child: Column(
//                 children: [
//                   const Text(
//                     "We'll text a code to verify your email",
//                     style: TextStyle(fontSize: 12),
//                   ),
//                   const SizedBox(
//                     height: 40,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 20, right: 20),
//                     child: Material(
//                       elevation: 5.0,
//                       shadowColor: Colors.grey,
//                       borderRadius: BorderRadius.circular(10),
//                       child: TextFormField(
//                         decoration: const InputDecoration(
//                           isDense: true,
//                           contentPadding: EdgeInsets.all(10),
//                           border: InputBorder.none,
//                           labelText: 'Your email',
//                         ),
//                         initialValue: widget.email,
//                         validator: (value) {
//                           if (value == null || value == "") {
//                             return "Please enter email";
//                           } else if (!value.contains("@") ||
//                               !value.contains(".com") ||
//                               value.length < 5) {
//                             return "Please enter valid email";
//                           }

//                           return null;
//                         },
//                         onChanged: (value) {
//                           setState(() {
//                             // email = value;
//                           });
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 80,
//             ),
//             Container(
//               padding: const EdgeInsets.only(left: 20, right: 20),
//               alignment: Alignment.center,
//               child: Column(
//                 children: [
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       minimumSize: const Size.fromHeight(50),
//                     ),
//                     onPressed: () {
//                       if (!(_form.currentState?.validate() ?? true)) {
//                         return;
//                       }
//                       Navigator.push(
//                         context,
//                         PageTransition(
//                           type: PageTransitionType.rightToLeftWithFade,
//                           child: VerifyEmailOTP(
//                             email: widget.email,
//                             phoneNumber: widget.phoneNumber,
//                           ),
//                         ),
//                       );
//                     },
//                     child: const Text('NEXT'),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         "Already have an account?",
//                         style: TextStyle(fontSize: 12),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             PageTransition(
//                               type: PageTransitionType.rightToLeftWithFade,
//                               child: const LogIn(),
//                             ),
//                           );
//                         },
//                         child: const Text(
//                           "  Log in",
//                           style: TextStyle(fontSize: 12, color: Colors.blue),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
