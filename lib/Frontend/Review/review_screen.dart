import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../Backend/base_client.dart';

class Review extends StatefulWidget {
  final String jobId;
  const Review({
    super.key,
    required this.jobId,
  });

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  String _enteredText = '';
  int doubleOne = 1;
  int doubleTwo = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Review",
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
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Share your experience",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Row(
                  children: const [
                    Text(
                      "Rate the quality",
                    ),
                    Text(
                      "*",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 20, 20),
                child: RatingBar.builder(
                  itemSize: 24,
                  initialRating: 1,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    if (mounted) {
                      doubleOne = rating.toInt();
                    }
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Row(
                  children: const [
                    Text(
                      "Service was on time",
                    ),
                    Text(
                      "*",
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 20, 20),
                child: RatingBar.builder(
                  itemSize: 24,
                  initialRating: 1,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    if (mounted) {
                      doubleTwo = rating.toInt();
                    }
                  },
                ),
              ),
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Text(
                  "Comment",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
                textAlignVertical: TextAlignVertical.top,
                onChanged: (value) {
                  if (mounted) {
                    setState(() {
                      _enteredText = value;
                    });
                  }
                },
                maxLines: 15,
                maxLength: 1000,
                decoration: InputDecoration(
                  hintText:
                      "What did you like or didn't like this service? Share as many details as you can",
                  hintStyle: const TextStyle(fontSize: 12),
                  border: const OutlineInputBorder(),

                  // Display the number of entered characters
                  counterText:
                      '${_enteredText.length.toString()}/1000 character(s)',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () async {
                  var response = await BaseClient().rateJob(
                    "/ratings/${widget.jobId}",
                    doubleOne.toString(),
                    doubleTwo.toString(),
                    _enteredText,
                  );
                  //
                  if (response["success"]) {
                    await EasyLoading.dismiss();

                    if (mounted) {
                      final snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Rated!',
                          message: '${response["message"]}',
                          contentType: ContentType.success,
                        ),
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar);
                      }
                    }
                  } else {
                    await EasyLoading.dismiss();
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
                },
                child: const Text('Submit'),
              ),
            ),
            // TextButton(
            //   onPressed: () {},
            //   child: const Text("Skip"),
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     const SizedBox(
            //       width: 50,
            //     ),
            //     Expanded(
            //       child: Padding(
            //         padding: const EdgeInsets.all(20),
            //         child: ElevatedButton(
            //           style: ElevatedButton.styleFrom(
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(50),
            //             ),
            //             minimumSize: const Size.fromHeight(50),
            //             backgroundColor: HexColor("#24B550"),
            //           ),
            //           onPressed: () {},
            //           child: const Text('Rate our app'),
            //         ),
            //       ),
            //     ),
            //     const SizedBox(
            //       width: 50,
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
