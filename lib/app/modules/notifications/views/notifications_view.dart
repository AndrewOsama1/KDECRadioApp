import 'package:church_app/app/data/backend_queries_controller.dart';
import 'package:church_app/app/data/firebase_controller.dart';
import 'package:church_app/app/models/notification_info.dart';
import 'package:church_app/app/theme/app_style.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../widgets/change_language_widget.dart';
import '../../../widgets/search_delegate.dart';
import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Disable the default back button
        elevation: 0,
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(
                context); // Navigate back when the back arrow is pressed
          },
          icon: const Icon(
            Icons.arrow_back, // You can use any icon you prefer
            color: Colors.white,
          ),
        ),
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
          const ChangeLanguageWidget(),
        ],
      ),
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/good2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: FutureBuilder<List<NotificationInfo>>(
          future: Get.find<BackendController>().getAllNotifications(
            FirebaseController.instance.userToken.value,
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.isNotEmpty) {
                return ListView.separated(
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) => notificationContainer(
                    snapshot.data![index].title,
                    snapshot.data![index].body,
                  ),
                  itemCount: snapshot.data!.length,
                );
              } else {
                return Center(
                  child: Text(
                    "You don't have notifications".tr,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
            } else if (!snapshot.hasData) {
              return Center(
                child: Text(
                  "You don't have notifications".tr,
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              return Center(
                child: LoadingAnimationWidget.threeArchedCircle(
                  size: 40,
                  color: Colors.white,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget notificationContainer(String head, String body) {
    return ListTile(
      title: Text(
        head,
        style: AppStyle.txtUrbanistRomanBold18WhiteA700,
      ),
      subtitle: Text(
        body,
        style: AppStyle.txtUrbanistRomanBoldxx,
      ),
      tileColor: Colors.lightBlueAccent,
    );
  }
}
