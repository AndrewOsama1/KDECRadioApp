import 'package:get/get.dart';

import '../controllers/notifications_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<NotificationsController>(NotificationsController());
  }
}
