import 'dart:convert';
import 'package:f_mesajlasma_uygulamasi/models/user_model.dart' as MyUser;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:f_mesajlasma_uygulamasi/app/chat_page.dart';
import 'package:f_mesajlasma_uygulamasi/viewmodel/chat_view_model.dart';
import 'package:f_mesajlasma_uygulamasi/viewmodel/user_viewmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    print("arka planda gelen data: " + message["data"].toString());
    NotificationHandler.showNotification(message);
  }

  // if (message.containsKey('notification')) {
  //   // Handle notification message
  //   final dynamic notification = message['notification'];
  // }

  return Future<void>.value();
}

class NotificationHandler {
  FirebaseMessaging _fcm = FirebaseMessaging();
  BuildContext _context;

  NotificationHandler._internal();

  static final NotificationHandler _singleton = NotificationHandler._internal();

  factory NotificationHandler() {
    return _singleton;
  }

  initializeFCMNotification(BuildContext context) async {
    _context = context;
    var initializationonSettingAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationonSettingIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        android: initializationonSettingAndroid,
        iOS:
            initializationonSettingIOS); // bunun içinde ios android var idi hata veriyor idi
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    _fcm.subscribeToTopic("all");
    _fcm.onTokenRefresh.listen((event) async {
      User _currentUser = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .doc("tokens/" + _currentUser.uid)
          .set({"token": event});
    });

    _fcm.configure(
      onBackgroundMessage: myBackgroundMessageHandler,
      onMessage: (Map<String, dynamic> message) async {
        print(
            "onMessage tetiklendi: title:  " + message["data"]["title"] + "\n");
        print("onMessage tetiklendi: message:  " +
            message["data"]["message"] +
            "\n");
        showNotification(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print(
            "onLaunch tetiklendi: title:  " + message["data"]["title"] + "\n");
        print("onLaunch tetiklendi: message:  " +
            message["data"]["message"] +
            "\n");
      },
      onResume: (Map<String, dynamic> message) async {
        print(
            "onResume tetiklendi: title:  " + message["data"]["title"] + "\n");
      },
    );
  }

  static void showNotification(Map<String, dynamic> message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        '1234', 'yeni mesaj', 'bildirim kanalı',
        importance: Importance.max, priority: Priority.min, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        iOS: iOSPlatformChannelSpecifics,
        android:
            androidPlatformChannelSpecifics); // bunun içinde ios android var idi hata veriyor idi;
    await flutterLocalNotificationsPlugin.show(0, message["data"]["title"],
        message["data"]["message"], platformChannelSpecifics,
        payload: jsonEncode(message));
    print("\n\n\n SHOW NOTİFİCATİONNNN \n\n\n");
  }

  Future onSelectNotification(String payload) async {
    print("\n\n\nTIKLADINNNN\n\n\n");
    final _userViewModel = Provider.of<UserViewModel>(_context);
    if (payload != null) {
      debugPrint("notification payload: " + payload);
      Map<String, dynamic> gelenBildirim = await jsonDecode(payload);

      Navigator.of(_context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => ChatViewModel(
              currentUser: _userViewModel.user,
              oppositeUser: MyUser.User(
                userID: gelenBildirim["data"]["gonderenUserID"],
              ),
            ),
            child: ChatPage(gelenBildirim["data"]["gonderenUserName"]),
          ),
        ),
      );
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {
    return Future<void>.value();
  }
}
