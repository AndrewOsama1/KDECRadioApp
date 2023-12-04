import 'dart:developer';

import 'package:church_app/app/data/backend_queries_controller.dart';
import 'package:church_app/app/data/firebase_controller.dart';
import 'package:church_app/app/data/queue_controller.dart';
import 'package:church_app/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:simple_connection_checker/simple_connection_checker.dart';

class InternetConnectionController extends GetxController {
  late final RxBool connected;
  late final RxBool launchConnected;
// if there is no wifi it display screen
  Future displayNoInternetScreen({
    required bool isConnected,
  }) async {
    log('Connection is $isConnected');

    if (!isConnected) {
      Get.offAllNamed(Routes.OFFLINE);
      launchConnected(false);
    } else {
      Get.put(BackendController(), permanent: true);
      Get.put(QueueController(), permanent: true);
      Get.put(FirebaseController(), permanent: true);

      if (Get.find<FirebaseController>().firebaseUser.value != null) {
        if (Get.currentRoute == Routes.HOME) {
          return;
        }
        Get.offAllNamed(Routes.HOME);
      } else {
        if (Get.currentRoute == Routes.AUTHENTICATION) {
          return;
        }
        Get.offAllNamed(Routes.AUTHENTICATION);
      }
    }
  }

  @override
  // intials
  Future onInit() async {
    final bool isConn = await SimpleConnectionChecker.isConnectedToInternet();
    connected = RxBool(isConn);
    launchConnected = RxBool(isConn);
    log('Connection is 26 ${connected.value}');
    connected.bindStream(SimpleConnectionChecker().onConnectionChange);
    ever(
      connected,
      (callback) => displayNoInternetScreen(isConnected: callback),
    );
    super.onInit();
  }
}
