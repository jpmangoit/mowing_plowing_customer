import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadPhotosBusiness extends StatefulWidget {
  const UploadPhotosBusiness({super.key});

  @override
  State<UploadPhotosBusiness> createState() => _UploadPhotosBusinessState();
}

class _UploadPhotosBusinessState extends State<UploadPhotosBusiness> {
  bool loading = true;
  final ImagePicker imagePicker = ImagePicker();
  TextEditingController instructionController = TextEditingController();
  List<XFile>? imageFileList;
  String? image0;
  String? image1;
  String? image2;
  String? image3;

  void selectImages() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    final List<XFile> selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages.isNotEmpty) {
      imageFileList = [];
      await localStorage.remove("image0B");
      await localStorage.remove("image1B");
      await localStorage.remove("image2B");
      await localStorage.remove("image3B");
      imageFileList!.addAll(selectedImages);
      image0 = imageFileList![0].path;
      await localStorage.setString('image0B', imageFileList![0].path);
      image1 = imageFileList!.length > 1 ? imageFileList![1].path : null;
      imageFileList!.length > 1
          ? await localStorage.setString('image1B', imageFileList![1].path)
          : null;
      image2 = imageFileList!.length > 2 ? imageFileList![2].path : null;
      imageFileList!.length > 2
          ? await localStorage.setString('image2B', imageFileList![2].path)
          : null;
      image3 = imageFileList!.length > 3 ? imageFileList![3].path : null;
      imageFileList!.length > 3
          ? await localStorage.setString('image3B', imageFileList![3].path)
          : null;
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future showImages() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    image0 = localStorage.getString("image0B");
    image1 = localStorage.getString("image1B");
    image2 = localStorage.getString("image2B");
    image3 = localStorage.getString("image3B");
    if (localStorage.getString('instructionB') == null) {
      instructionController = TextEditingController();
      await localStorage.setString('instructionB', instructionController.text);
    } else {
      var instructionText = localStorage.getString('instructionB');
      instructionController = TextEditingController(text: instructionText);
    }
    if (mounted) {
      setState(() {});
    }
  }

  void completeFunct() {
    showImages().then((value) async {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      await localStorage.setBool("nextOn3", true);
      loading = false;
      if (mounted) {
        setState(() {});
      }
    });
  }

  void remove() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    await localStorage.remove("nextOn3");
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
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          const Text(
            "Details",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 20,
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Upload photos (Optional)",
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            child: loading
                ? LoadingAnimationWidget.fourRotatingDots(
                    color: HexColor("#0275D8"),
                    size: 40,
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            child: image0 == null
                                ? Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        "images/container.png",
                                        height: 200,
                                        width: 250,
                                      ),
                                      Image.asset(
                                        "images/image.png",
                                        height: 100,
                                        width: 100,
                                      ),
                                    ],
                                  )
                                : Image.file(
                                    File(image0!),
                                    height: 225,
                                    width: 250,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Column(
                            children: [
                              SizedBox(
                                child: image1 != null
                                    ? Image.file(
                                        File(image1!),
                                        height: 70,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            "images/container.png",
                                            height: 65,
                                            width: 80,
                                          ),
                                          Image.asset(
                                            "images/image.png",
                                            height: 30,
                                            width: 30,
                                          ),
                                        ],
                                      ),
                              ),
                              SizedBox(
                                height: image1 != null ? 5 : null,
                              ),
                              SizedBox(
                                child: image2 != null
                                    ? Image.file(
                                        File(image2!),
                                        height: 70,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            "images/container.png",
                                            height: 65,
                                            width: 80,
                                          ),
                                          Image.asset(
                                            "images/image.png",
                                            height: 30,
                                            width: 30,
                                          ),
                                        ],
                                      ),
                              ),
                              SizedBox(
                                height: image2 != null ? 5 : null,
                              ),
                              SizedBox(
                                child: image3 != null
                                    ? Image.file(
                                        File(image3!),
                                        height: 70,
                                        width: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            "images/container.png",
                                            height: 65,
                                            width: 80,
                                          ),
                                          Image.asset(
                                            "images/image.png",
                                            height: 30,
                                            width: 30,
                                          ),
                                        ],
                                      ),
                              ),
                            ],
                          )
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          selectImages();
                        },
                        child: const Text('Browse Files'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Special Instructions (Optional)",
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Material(
                        elevation: 5.0,
                        shadowColor: Colors.grey,
                        borderRadius: BorderRadius.circular(30),
                        child: TextFormField(
                          minLines: 3,
                          maxLines: 10,
                          controller: instructionController,
                          decoration: const InputDecoration(
                            hintText:
                                "Tell us anything that will help service provider complete this job",
                            hintStyle: TextStyle(fontSize: 12),
                            isDense: true,
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.all(20),
                            border: InputBorder.none,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(30),
                              ),
                              borderSide: BorderSide(
                                width: 0,
                                style: BorderStyle.none,
                              ),
                            ),
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                          autofocus: false,
                          readOnly: true,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: TextFormField(
                                      minLines: 1,
                                      maxLines: 5,
                                      autofocus: true,
                                      onChanged: (value) async {
                                        SharedPreferences localStorage =
                                            await SharedPreferences
                                                .getInstance();
                                        instructionController.text = value;
                                        await localStorage.setString(
                                            'instructionB', value);
                                        if (mounted) {
                                          setState(() {});
                                        }
                                      },
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                            Colors.grey,
                                          ),
                                        ),
                                        child: const Text('CANCEL'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('SUBMIT'),
                                      ),
                                    ],
                                  );
                                });
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
