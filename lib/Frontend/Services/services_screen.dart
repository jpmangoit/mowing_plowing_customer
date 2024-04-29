import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Services",
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(
                height: 10,
              ),
              Text(
                "Lawn Mowing",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Order a Lawn Mowing service from selected area, anytime. Our professional and insured fleet will cutand trim your Lawn, clear off any hard surfaces and send you a photo of a job well done",
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Car Snow Removal",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Order a Snow Plowing Service from anywhere, any-time. Our professional and insured fleet will come to plow your driveway clear of snow. Whenever there’s a storm, rest assured that we’ve got you covered",
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Home Snow Plowing",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Order a Snow Plowing Service from anywhere, any-time. Our professional and insured fleet will come to plow your driveway clear of snow. Whenever there’s a storm, rest assured that we’ve got you covered",
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Business Snow Plowing",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Order a Snow Plowing Service from anywhere, any-time. Our professional and insured fleet will come to plow your driveway clear of snow. Whenever there’s a storm, rest assured that we’ve got you covered.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
