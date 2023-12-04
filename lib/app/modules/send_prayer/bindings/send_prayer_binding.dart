import 'package:get/get.dart';

import '../controllers/send_prayer_controller.dart';

class SendPrayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SendPrayerController>(SendPrayerController());
  }
}
