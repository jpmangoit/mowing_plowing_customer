import 'package:flutter/material.dart';

class Legal extends StatefulWidget {
  const Legal({super.key});

  @override
  State<Legal> createState() => _LegalState();
}

class _LegalState extends State<Legal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Legal",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Please read these terms carefully before using our application.",
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Acknowledgment",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "These client terms of service the client terms describe your rights and responsibilities when using our online client portal or other platforms the services. If you area client or an authorized user (defined below), these client terms govern your access and use of the services.Client is the organization that you represent in agreeing to the contract (e.g. your employer). These client terms form a building contract between client and us. If you personally use our services, you acknowledge your understanding of the contract and agree to the contract on behalf of client.",
            ),
            SizedBox(
              height: 40,
            ),
            Text(
              "Introduction",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Sed non dui aliquam, ullamcorper est non, aliquet mauris. Quisque lacus ligula, dapibus nec dignissim non, tincidunt vel quam. Etiam porttitor iaculis odio.",
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Using our services",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Sed luctus tristique est, non tempor ipsum tincidunt in. Vestibulum commodo eu augue nec maximus. Vestibulum vel metus varius turpis finibus accumsan in eu ligula. Phasellus semper ornare orci, sit amet fermentum neque faucibus id. Vestibulum id ante massa.",
            ),
          ],
        ),
      ),
    );
  }
}
