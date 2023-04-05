//SHA1 = E5:6B:FF:2E:50:B5:4B:0D:9C:8E:8C:A2:50:C2:00:53:61:F2:7D:16

// ignore_for_file: avoid_print

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static final StreamController<String> _messageStream =
      StreamController.broadcast();
  static Stream<String> get messagesStream => _messageStream.stream;

  static Future _backGroundHandler(RemoteMessage message) async {
    print('BackGround ${message.data}');
    _messageStream.add(message.data['product'] ?? 'No product');
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print('On Message ${message.data}');
    _messageStream.add(message.data['product'] ?? 'No product');
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    print('On Message Open App ${message.data}');
    _messageStream.add(message.data['product'] ?? 'No product');
  }

  static Future initApp() async {
    //push notifications
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    print('Token: $token');

    //handlers

    FirebaseMessaging.onBackgroundMessage(_backGroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);
  }

  static closeStreams() {
    _messageStream.close();
  }
}
