import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Backend/base_client.dart';
import '../Login/logIn_screen.dart';

class Payment3 extends StatefulWidget {
  const Payment3({super.key});

  @override
  State<Payment3> createState() => _Payment3State();
}

class _Payment3State extends State<Payment3> {
  String cardNumber = '';
  String expiryDate = '';
  String month = "";
  String year = "";
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _form = GlobalKey();
  @override
  void initState() {
    border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: Colors.grey[350]!,
        // width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Add Credit or Debit card",
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
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "This method will be used for service payments",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Form(
              key: _form,
              child: CreditCardForm(
                formKey: formKey,
                obscureCvv: true,
                obscureNumber: true,
                cardNumber: cardNumber,
                cvvCode: cvvCode,
                isHolderNameVisible: true,
                isCardNumberVisible: true,
                isExpiryDateVisible: true,
                cardHolderName: cardHolderName,
                expiryDate: expiryDate,
                themeColor: HexColor("#0275D8"),
                cardNumberDecoration: InputDecoration(
                  labelText: 'Number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                  focusedBorder: border,
                  enabledBorder: border,
                ),
                expiryDateDecoration: InputDecoration(
                  focusedBorder: border,
                  enabledBorder: border,
                  labelText: 'Expired Date',
                  hintText: 'XX/XX',
                ),
                cvvCodeDecoration: InputDecoration(
                  focusedBorder: border,
                  enabledBorder: border,
                  labelText: 'CVV',
                  hintText: 'XXX',
                ),
                cardHolderDecoration: InputDecoration(
                  focusedBorder: border,
                  enabledBorder: border,
                  labelText: 'Card Holder',
                ),
                onCreditCardModelChange: onCreditCardModelChange,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: HexColor("#0275D8"),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  if (!(formKey.currentState!.validate())) {
                    return;
                  }
                  var response = await BaseClient().addCard(
                    "/add-card",
                    cardNumber.replaceAll(' ', ''),
                    expiryDate.substring(0, 2),
                    "20${expiryDate.substring(3, 5)}",
                    cvvCode,
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
                      await localStorage.remove('cards');
                      List<dynamic> cards = response["data"];
                      await localStorage.setString(
                        'cards',
                        jsonEncode(cards),
                      );
                      if (mounted) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        Navigator.of(context).pop();
                        // Navigator.of(context).pop();
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    if (mounted) {
      setState(() {
        cardNumber = creditCardModel!.cardNumber;
        expiryDate = creditCardModel.expiryDate;
        cardHolderName = creditCardModel.cardHolderName;
        cvvCode = creditCardModel.cvvCode;
        isCvvFocused = creditCardModel.isCvvFocused;
      });
    }
  }
}
