import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../Backend/base_client.dart';
import '../Chat/chat_screen.dart';
import '../Notifications/notification_screen.dart';
import '../Payment/payment_screen1.dart';
import '../Services/serviceDetails_screen.dart';
import '../Services/trackService_screen.dart';

class Noti {
  static initializeNotification() async {
    await AwesomeNotifications().initialize(
        null, // icon for your app notification
        [
          NotificationChannel(
              channelKey: 'key1',
              channelName: 'Notification customer',
              channelDescription: "Notifications",
              playSound: true,
              enableLights: true,
              enableVibration: true)
        ]);
  }

  static listenActionStream(context) {
    AwesomeNotifications().actionStream.listen((receivedAction) async {
      var payload = receivedAction.payload;
      print("------------------------------------------");
      print(payload);

      if (payload != null) {
        if (payload['id'] != null && payload['flag'] == 'Chat') {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeftWithFade,
              // 3
              child: Chat(
                orderId: payload['id'].toString(),
              ),
            ),
          ).then((value) => {});
        } else {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeftWithFade,
              // 3
              child: const Notifications(),
            ),
          );
        }
      }
    });
  }

  static showNotification(data) async {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: data['id'],
          channelKey: 'key1',
          title: data['title'],
          body: data['content'],
          wakeUpScreen: true,
          payload: {"id": data['order_id'].toString(), "flag": data["flag"]},
          category: NotificationCategory.Message,
          displayOnBackground: true,
          displayOnForeground: true),
      // actionButtons: [
      //   NotificationActionButton(key: 'VIEW', label: 'VIEW'),
      //   NotificationActionButton(
      //       key: 'DISMISS',
      //       label: 'Dismiss',
      //       buttonType: ActionButtonType.Default,
      //       isDangerousOption: true)
      // ],
    );
  }
}
