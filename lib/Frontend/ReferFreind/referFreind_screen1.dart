import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'referFreind_screen2.dart';

class ReferFreind1 extends StatefulWidget {
  const ReferFreind1({super.key});

  @override
  State<ReferFreind1> createState() => _ReferFreind1State();
}

class _ReferFreind1State extends State<ReferFreind1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Refer a friend",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReferFreind2(),
                    ),
                  );
                },
                child: Text(
                  "Get Started",
                  style: TextStyle(
                    color: HexColor("#0275D8"),
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Know someone who needs mowing and plowing service?",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Center(
                child: Text(
                  "Invite them to Mowing and Plowing",
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                color: HexColor("#ECECEC"),
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Active Offers",
                            style: TextStyle(
                              fontSize: 12,
                              color: HexColor("#707070"),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey[400],
                        thickness: 1,
                      ),
                      ListTile(
                        title: const Text(
                          'Refer a friend and get 50\$ into your Mowing and plowing cash wallet',
                          style: TextStyle(fontSize: 13),
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_right_sharp,
                          color: HexColor("#0275D8"),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ReferFreind2(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
