import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/backend_queries_controller.dart';
import '../../../data/firebase_controller.dart';

class SendPrayerController extends GetxController {
  RxList<String> messages = ['prayerMsg'.tr].obs;
  final TextEditingController messageController = TextEditingController();
  RxString userName = ''.obs; // Use RxString for reactive updates

  void setUserName(String name) {
    userName.value = name;
  }
}
