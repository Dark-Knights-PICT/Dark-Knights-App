import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

import '../project/env.dart';
import 'local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  LocalNotificationService.initialize();
  log('Handling a background message: ${message.messageId}');
  LocalNotificationService.createanddisplaynotification(message);
}

class FirebaseNotifications {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> initialize() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    _firebaseMessaging.requestPermission();
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) => {
          if (message != null)
            {
              LocalNotificationService.createanddisplaynotification(message),
              log('Message data: ${message.notification!.title}')
            },
        });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) => {
          LocalNotificationService.createanddisplaynotification(message),
          log('Message data: ${message.notification!.title}'),
        });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) => {
          LocalNotificationService.createanddisplaynotification(message),
          log('Message data: ${message.notification!.title}'),
        });

    const storage = FlutterSecureStorage();

    String? fcmToken = await storage.read(key: 'fcmToken');
    if (fcmToken == null) {
      fcmToken = await _firebaseMessaging.getToken();
      await storage.write(key: 'fcmToken', value: fcmToken);

      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final tokenCollection = _firestore.collection('tokens');
      await tokenCollection.add({'fcmToken': fcmToken});
    }
    log('FCM Token: $fcmToken');
  }
}

class Api {
  final String fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  final fcmKey = fcmServerKey;
  void sendFcm(String title, String body, String fcmToken) async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$fcmKey'
    };
    var request = http.Request('POST', Uri.parse(fcmUrl));
    request.body =
        '''{"to":"$fcmToken","priority":"high","notification":{"title":"$title","body":"$body","sound": "default"}}''';
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
