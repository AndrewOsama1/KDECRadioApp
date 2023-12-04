import 'package:get/get.dart';

import '../controllers/splash_controller.dart';
import '../../send_prayer/controllers/send_prayer_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SendPrayerController>(SendPrayerController());

    Get.put<SplashController>(SplashController());
  }
}
