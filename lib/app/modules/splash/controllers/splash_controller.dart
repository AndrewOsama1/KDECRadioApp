import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:church_app/amplifyconfiguration.dart';
import 'package:church_app/app/data/audio_controller.dart';
import 'package:church_app/app/data/internet_connection_controller.dart';
import 'package:church_app/app/data/local_storage_controller.dart';
import 'package:church_app/app/routes/app_pages.dart';
import 'package:get/get.dart';

Future<void> configureAmplify() async {
  if (!Amplify.isConfigured) {
    await Amplify.addPlugins([AmplifyAuthCognito(), AmplifyStorageS3()]);
// ... add other plugins, if any
    await Amplify.configure(amplifyconfig);
  }
}

class SplashController extends GetxController {
  @override
  Future onInit() async {
    Get.put(AudioHandlerController(), permanent: true);
    Get.put(LoaclStorageController(), permanent: true);
    Get.put<InternetConnectionController>(
      InternetConnectionController(),
      permanent: true,
    );
    super.onInit();
  }
}
