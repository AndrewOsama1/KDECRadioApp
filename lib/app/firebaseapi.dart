import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// this page is responsible for notification coming from dashboard
class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _andriodChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'High Importance Notifications',
      description: 'This channel is used for important notifications',
      importance: Importance.defaultImportance);
  final _localNotifications = FlutterLocalNotificationsPlugin();

  Future<void> handleBackgroundHandler(RemoteMessage message) async {
    // Handle the background message here, e.g., show a local notification
    print(message.notification?.title);
    print(message.notification?.body);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print('Token: $fcmToken');
    initPushNotifications();
    initLocalNotifications();
  }

  Future<void> initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundHandler);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                _andriodChannel.id, _andriodChannel.name,
                channelDescription: _andriodChannel.description,
                icon: "@mipmap/splash"),
          ),
          payload: jsonEncode(message.toMap()));
    });
  }

  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android =
        AndroidInitializationSettings('@drawable/launcher_icon.png');
    const settings = InitializationSettings(android: android, iOS: iOS);
    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_andriodChannel);
  }
}
