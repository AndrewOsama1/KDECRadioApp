import 'package:church_app/app/modules/discover/controllers/discover_controller.dart';
import 'package:church_app/app/modules/live/controllers/live_controller.dart';
import 'package:church_app/app/modules/notifications/controllers/notifications_controller.dart';
import 'package:church_app/app/modules/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<LiveController>(LiveController());
    Get.put<DiscoverController>(DiscoverController());
    Get.put<NotificationsController>(NotificationsController());
    Get.put<ProfileController>(ProfileController());
  }
}
