import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceCategory extends StatefulWidget {
  const ServiceCategory({super.key});

  @override
  State<ServiceCategory> createState() => _ServiceCategoryState();
}

class _ServiceCategoryState extends State<ServiceCategory> {
  String? category;
  bool loading = true;
  var categories = [
    'Home',
    'Business',
    'Car',
  ];

  Future localStorage() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    String? catg = localStorage.getString('category');
    if (catg == null) {
      category = "Home";
      await localStorage.setString('category', "Home");
    } else {
      category = catg;
    }
  }

  void completeFunct() {
    localStorage().then((value) async {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      await localStorage.setBool("nextOn1", true);
      loading = false;
      if (mounted) {
        setState(() {});
      }
    });
  }

  void remove() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.remove("nextOn1");
  }

  @override
  void initState() {
    super.initState();
    completeFunct();
  }

  @override
  void dispose() {
    remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Where do you need service?"),
        SizedBox(
          child: loading
              ? LoadingAnimationWidget.fourRotatingDots(
                  color: HexColor("#0275D8"),
                  size: 40,
                )
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Material(
                    elevation: 5.0,
                    shadowColor: Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                    child: DropdownButtonFormField(
                      menuMaxHeight: 400,
                      borderRadius: BorderRadius.circular(30),
                      elevation: 5,
                      dropdownColor: Colors.grey[100],
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        isDense: true,
                        prefixIcon: Icon(
                          Icons.category,
                          color: HexColor("#0275D8"),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        border: InputBorder.none,
                      ),
                      iconEnabledColor: HexColor("#0275D8"),
                      value: category,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: categories.map((String items) {
                        return DropdownMenuItem(
                          value: items,
                          child: Text(items),
                        );
                      }).toList(),
                      onChanged: (String? newValue) async {
                        SharedPreferences localStorage =
                            await SharedPreferences.getInstance();
                        category = newValue!;
                        if (mounted) {
                          setState(() {});
                        }
                        await localStorage.setString('category', newValue);
                      },
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
