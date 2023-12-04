import 'package:church_app/app/widgets/play_button.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../widgets/change_language_widget.dart';
import '../../../widgets/search_delegate.dart';
import '../../notifications/views/notifications_view.dart';
import '../controllers/live_controller.dart';
import 'package:church_app/app/core/app_export.dart';

class LiveView extends GetView<LiveController> {
  const LiveView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchWidgetDelegate());
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationsView()));
            },
            icon: const Icon(
              Icons.notifications,
              color: Colors.white,
            ),
          ),
          const ChangeLanguageWidget(),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  "assets/images/good2.jpg"), // Your background image
              fit: BoxFit.cover,
            ),
          ),
          // Make the background image cover the whole screen
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: getPadding(top: 5, bottom: 10),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Radio'.tr,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtUrbanistRomanBoldm,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          'Live'.tr,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtUrbanistRomanBoldm,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: SizedBox(
                  height: 350,
                  width: 350,
                  child: ClipRRect(
                    borderRadius: BorderRadiusStyle.roundedBorder16,
                    child: WebViewWidget(
                      controller: controller.webViewController,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: const PlayButton(
                  isRadio: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
