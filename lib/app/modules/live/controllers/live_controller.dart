import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LiveController extends GetxController {
  late final WebViewController webViewController;

  @override
  Future<void> onInit() async {
    super.onInit();
    webViewController = WebViewController();
    await webViewController.setJavaScriptMode(
      JavaScriptMode.unrestricted,
    );
    await webViewController.loadRequest(
      Uri.parse('https://kdec-radio.pages.dev/'),
    );
  }

  // @override
  // void dispose() {
  //   webViewController.clearCache();
  //   webViewController.clearLocalStorage();
  //   super.dispose();
  // }
}
