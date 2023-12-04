import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../authentication/controllers/authentication_controller.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  Widget messageIcon = Icon(Icons.messenger);

  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    initFirebaseMessaging();
  }

  void initFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (message.notification != null &&
          message.notification?.title == "New Message") {
        updateMessageIconWithBadge();
      }
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (message.notification?.title == "New Message") {
      updateMessageIconWithBadge();
    }
  }

  void updateMessageIcon() {
    messageIcon = Icon(Icons.messenger);
    // Optionally, you can save the icon state in SharedPreferences here if needed.
  }

  Future<void> saveIconState(Widget icon) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('messageIcon', icon.toString());
  }

  final RxInt currentIndex = 0.obs;
  final Rx<String> currentTitle = ''.obs;

  void changePage(int index) {
    currentIndex(index);
    if (index == 0) {
      currentTitle('live');
    }
    if (index == 1) {
      currentTitle('browse');
    }
    if (index == 2) {
      currentTitle('notifications');
    }
    if (index == 3) {
      currentTitle('profile');
    }
    if (index == 4) {
      currentTitle('profile');
    }
    if (index == 5) {
      currentTitle('profile');
    }
  }

  void updateMessageIconWithBadge() {
    messageIcon = Stack(
      children: [
        Icon(Icons.messenger),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: Text(
              '1',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
              ),
            ),
          ),
        ),
      ],
    );
    saveIconState(messageIcon);
  }

  void resetMessageIcon() {
    messageIcon = Icon(Icons.messenger);
    saveIconState(messageIcon);
  }

  HomeController() {
    initializeFirebase();

    // Call handleTokenRequest when the controller is initialized
    // handleTokenRequest();
  }
}

// Example usage to reset the icon when a button is pressed
