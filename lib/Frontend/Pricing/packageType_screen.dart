import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PackageType extends StatefulWidget {
  final String package;
  const PackageType({
    super.key,
    required this.package,
  });

  @override
  State<PackageType> createState() => _PackageTypeState();
}

class _PackageTypeState extends State<PackageType> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.package == "Basic"
              ? "Basic Package"
              : widget.package == "Standard"
                  ? "Standard Package"
                  : "Premium Package",
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.package == "Basic"
                              ? "Basic  (Save 10%)"
                              : widget.package == "Standard"
                                  ? "Standard  (Save 12%)"
                                  : "Premium  (Save 12%)",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.package == "Basic"
                              ? "\$300"
                              : widget.package == "Standard"
                                  ? "\$600"
                                  : "\$1200",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: HexColor("#0275D8"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "images/package.png",
                          height: 40,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.circle,
                              size: 12,
                              color: HexColor("#24B550"),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Flexible(
                            child: Text(
                              "Price per service may vary. You can check your current quote on the Mowing & Plowing App or",
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "Website: https://mowingplowing.com",
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.circle,
                              size: 12,
                              color: HexColor("#24B550"),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Flexible(
                            child: Text(
                              "Package includes Mowing & Plowing credits equal to amount of package purchase price",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.circle,
                              size: 12,
                              color: HexColor("#24B550"),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              widget.package == "Basic"
                                  ? "Save 10% off on every order between Nov-1 to April-1"
                                  : widget.package == "Standard"
                                      ? "Save 12% off on every order between Nov-1 to April-1"
                                      : "Save 15% off on every order between Nov-1 to April-1",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 12,
                            color: HexColor("#24B550"),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              widget.package == "Basic"
                                  ? "Save 12% off on a yard clean up service"
                                  : widget.package == "Standard"
                                      ? "Save 15% off on a yard clean up service"
                                      : "Save 20% off on a yard clean up service",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Icon(
                              Icons.circle,
                              size: 12,
                              color: HexColor("#24B550"),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Flexible(
                            child: Text(
                              "Unused credits can be used on any of our services, including leaf removal, lawn mowing & landscaping",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: HexColor("#0275D8"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {},
            child: Text(
              widget.package == "Basic"
                  ? "\$300 Pay"
                  : widget.package == "Standard"
                      ? "\$600 Pay"
                      : "\$1200 Pay",
            ),
          ),
        ],
      ),
    );
  }
}
