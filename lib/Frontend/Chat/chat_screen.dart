import 'dart:async';
import 'dart:convert';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Backend/api_constants.dart';
import '../../Backend/base_client.dart';
import '../Appointments/noti.dart';
import '../Login/logIn_screen.dart';

class Chat extends StatefulWidget {
  final String orderId;

  const Chat({
    super.key,
    required this.orderId,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  Map<String, dynamic>? userMap;
  String? orderNo;
  String? providerImage = "";
  int? providerId;
  String? customerId = "";
  String? customerImage = "";
  String? customerName = "";
  final TextEditingController _textController = TextEditingController();
  var ids = [];
  List<Message> messages = [];
  String last = "";
  String mess = "";
  bool load = true;
  String token = "";
  ScrollController _myController = ScrollController();

  // pusher
  //
  late FlutterPusher pusherClient;
  late Echo echo;

  void onConnectionStateChange(ConnectionStateChange event) {
    print("STATE:${event.currentState}");
    if (event.currentState == 'CONNECTED') {
      print('CONNECTED');
    } else if (event.currentState == 'DISCONNECTED') {
      print('DISCONNECTED');
    }
  }

  //
  //

  // echoSetUp
  //
  void _setUpEcho() {
    // print("echo.private 4");
    pusherClient = getPusherClient(token);
    echo = echoSetup(token, pusherClient);
    pusherClient.connect(onConnectionStateChange: onConnectionStateChange);
    // listen
    //
    echo.private("notifications.$customerId").stopListening('.NewNotification');
    echo.private("notifications.$customerId").listen('.NewNotification',
        (notification) {
      Noti.showNotification(notification["notification"]);
    });
    echo.private("order-live-chat.${widget.orderId}").listen(
          ".MessageSent",
          (e) => {
            print(e),
            // print(e["message"]["user_id"]),
            // print(customerId),
            if (mounted &&
                e["message"]["user_id"].toString() != customerId.toString())
              {
                setState(() {
                  ids.add(e["message"]["id"]);
                  // final dateTime =
                  //     DateTime.parse(e["message"]["created_at"].toString());
                  // final format = DateFormat('yyyy-MM-dd HH:mm');
                  messages.add(
                    Message(
                      id: e["message"]["user_id"],
                      imageUrl: customerImage!,
                      text: e["message"]["message"].toString(),
                      // time: format.format(dateTime),
                      time: e["message"]["created_at"].toString(),
                    ),
                  );
                })
              }
          },
        );
  }

  //
  //

  // get chat
  //
  Future getUserChat() async {
    var response = await BaseClient().getChat(
      "/customers-chat/${widget.orderId}",
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
        //
        orderNo = response["data"]["order_id"].toString();
        providerId = response["data"]["provider"]["id"];
        customerImage = response["data"]["provider"]["image"];
        customerName = response["data"]["provider"]["first_name"] +
            " " +
            response["data"]["provider"]["last_name"];
        messages = [];
        for (var i = 0; i < response["data"]["messages"].length; i++) {
          // print("Messages");
          // print(response["data"]["messages"][i]["message"]);
          ids.add(response["data"]["messages"][i]["id"]);
          // String hello = TimeOfDay.fromDateTime(
          //   DateTime.now().subtract(
          //     Duration(
          //       minutes: response["messages"][i]["time_from_now_in_min"],
          //     ),
          //   ),
          // ).toString();
          // String ello = hello.substring(10);
          // last = ello.substring(0, ello.length - 1);
          // final dateTime = DateTime.parse(
          //     response["data"]["messages"][i]["created_at"].toString());
          // final format = DateFormat('yyyy-MM-dd HH:mm');
          messages.add(
            Message(
              id: response["data"]["messages"][i]["user_id"],
              imageUrl: response["data"]["messages"][i]["user_id"] == customerId
                  ? providerImage
                  : response["data"]["provider"]["image"]!,
              text: response["data"]["messages"][i]["message"],
              // time: format.format(dateTime),
              time: response["data"]["messages"][i]["created_at"].toString(),
            ),
          );
        }
        //
      } else {
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Alert!',
            message: '${json.decode(response.body)["message"]}',
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
  }

  //
  //

  // local storage
  //
  Future localStorageData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = localStorage.getString('token')!;
    String? user = localStorage.getString('user');
    userMap = jsonDecode(user!) as Map<String, dynamic>;
    customerId = userMap!["id"].toString();
    providerImage = userMap!["image"];
    load = false;
  }

  //
  //

  void completeFunct() {
    localStorageData().then((value) async {
      await getUserChat().then((value) async {
        _setUpEcho();
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  // chat bubble
  //
  _chatBubble(Message message, bool isMe) {
    if (isMe) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.topRight,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.80,
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  )
                ]),
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(imageUrl + message.imageUrl),
                ),
              ),
            ],
          ),
          // !isSameUser
          //     ?
          Text(
            message.time,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black45,
            ),
          )
          // : Container(child: null),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  )
                ]),
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(imageUrl + message.imageUrl),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.80,
                  ),
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                      )
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // !isSameUser
          //     ?
          Text(
            message.time,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black45,
            ),
          )
          // : Container(child: null),
        ],
      );
    }
  }

  //
  //

  // send message
  //
  Future sendMessage(String message) async {
    var response = await BaseClient().sendMessagePress(
      "/customers-chat/send-message",
      widget.orderId,
      message,
      providerId!.toString(),
      orderNo!,
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
      if (!response["success"]) {
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
  }

  //
  //

  // send message area
  //
  _sendMessageArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: [
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(Icons.file_open),
          //   iconSize: 25,
          //   color: Theme.of(context).primaryColor,
          // ),
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration.collapsed(
                  hintText: "Send a message .."),
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {
                mess = value;
              },
            ),
          ),
          IconButton(
            onPressed: () {
              if (mounted) {
                setState(() {
                  _textController.clear();
                  final dateTime = DateTime.parse(DateTime.now().toString());
                  final format = DateFormat('yyyy-MM-dd HH:mm');
                  messages.add(
                    Message(
                      id: int.parse(customerId!),
                      imageUrl: providerImage!,
                      text: mess,
                      time: format.format(dateTime),
                    ),
                  );
                });
                sendMessage(mess);
              }
            },
            icon: const Icon(Icons.send),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  //
  //

  @override
  void initState() {
    completeFunct();
    // getUserChat();
    // _setUpEcho();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      pusherClient = getPusherClient(token);
      echo = echoSetup(token, pusherClient);
      pusherClient.connect(onConnectionStateChange: onConnectionStateChange);
      echo.private("notifications.$customerId").listen('.NewNotification',
          (notification) {
        Noti.showNotification(notification["notification"]);
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int? prevUserId;
    Timer(
      const Duration(milliseconds: 500),
      () => _myController.hasClients
          ? _myController.jumpTo(_myController.position.maxScrollExtent)
          : null,
    );

    return load
        ? Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),
                Align(
                  alignment: Alignment.center,
                  child: LoadingAnimationWidget.fourRotatingDots(
                    color: HexColor("#0275D8"),
                    size: 80,
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white, // red as border color
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: ClipOval(
                          // ignore: unnecessary_null_comparison
                          child: customerImage != null || customerImage != ""
                              ? ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl + customerImage!,
                                    height: 80,
                                    width: 80,
                                    placeholder: (context, url) =>
                                        LoadingAnimationWidget.inkDrop(
                                      color: HexColor("#0275D8"),
                                      size: 40,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                )
                              : ClipOval(
                                  child: Image.asset(
                                  'images/upload.jpg',
                                  height: 80,
                                )),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(customerName!),
                  // const SizedBox(
                  //   width: 5,
                  // ),
                  // SizedBox(
                  //   child: online == 1
                  //       ? const Icon(
                  //           Icons.circle,
                  //           color: Color.fromARGB(255, 4, 245, 12),
                  //           size: 10,
                  //         )
                  //       : null,
                  // ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _myController,
                    // reverse: true,
                    padding: const EdgeInsets.all(20),
                    itemCount: messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Message message = messages[index];
                      final bool isMe = message.id == int.parse(customerId!);
                      // final bool isSameUser = prevUserId == message.id;
                      // prevUserId = message.id;
                      return _chatBubble(message, isMe);
                    },
                  ),
                ),
                _sendMessageArea(),
              ],
            ),
          );
  }
}

class Message {
  final String time;
  final String text;
  final int id;
  final String imageUrl;

  Message({
    required this.time,
    required this.text,
    required this.id,
    required this.imageUrl,
  });
}
