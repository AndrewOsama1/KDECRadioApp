import 'dart:ffi';
import 'package:church_app/app/core/app_export.dart';
import 'package:church_app/app/data/audio_controller.dart';
import 'package:church_app/app/modules/authentication/views/authentication_view.dart';
import 'package:church_app/app/modules/discover/views/discover_view.dart';
import 'package:church_app/app/modules/live/views/live_view.dart';
import 'package:church_app/app/modules/notifications/views/notifications_view.dart';
import 'package:church_app/app/modules/profile/favorites/views/favorites_view.dart';
import 'package:church_app/app/modules/profile/views/profile_view.dart';
import 'package:church_app/app/routes/app_pages.dart';
import 'package:church_app/app/widgets/change_language_widget.dart';
import 'package:church_app/app/widgets/mini_player.dart';
import 'package:church_app/app/widgets/search_delegate.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../send_prayer/views/send_prayer_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final http = Dio();
    // String? token;
    //
    // Future<void> getToken() async {
    //   final prefs = await SharedPreferences.getInstance();
    //   token = prefs.getString('token');
    // }
    //
    // void handleDioError(DioError error, ErrorInterceptorHandler handler) {
    //   if (error.response != null) {
    //     final response = error.response!;
    //     final statusCode = response.statusCode;
    //     final responseBody = response.data;
    //     print('Error Status Code: $statusCode');
    //     print('Error Response Body: $responseBody');
    //   } else {
    //     print('Network Error: ${error.message}');
    //   }
    //   handler.next(error);
    // }
    //
    // http.interceptors.add(InterceptorsWrapper(onError: handleDioError));
    //
    // http.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
    //   options.headers['Cookie'] = 'S_UT=$token';
    //   return handler.next(options);
    // }));

    return Scaffold(
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black,
          textTheme: Theme.of(context).textTheme.copyWith(caption: TextStyle()),
        ),
        child: Obx(
          () => BottomNavigationBar(
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.list_outlined),
                label: 'Home'.tr,
              ),
              BottomNavigationBarItem(
                icon: controller.messageIcon,
                label: 'Messages'.tr,
              ),
              BottomNavigationBarItem(
                icon: _buildLiveIcon(),
                label: 'Live'.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline_rounded),
                label: 'Favourites'.tr,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_circle_outlined),
                label: 'Profile'.tr,
              ),
            ],
            currentIndex: controller.currentIndex.value,
            selectedItemColor: Colors.white,
            onTap: (int index) {
              if (index == 1) {
                // The "Messages" tab is tapped, so change the page and update the icon.
                controller.changePage(index);
                controller.updateMessageIcon();
              } else {
                controller.changePage(index); // Handle other tab changes
              }
            },
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.transparent,
            showUnselectedLabels: true,
            selectedLabelStyle: AppStyle.txtUrbanistRomanBoldy,
            unselectedLabelStyle: AppStyle.txtUrbanistRomanBoldy,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => IndexedStack(
                index: controller.currentIndex.value,
                children: const [
                  DiscoverView(),
                  SendPrayerView(),
                  LiveView(),
                  FavoritesView(),
                  MyProfileView(),
                ],
              ),
            ),
          ),
          Obx(
            () => (Get.find<AudioHandlerController>().currentSongTitle.value !=
                        'LIVE' &&
                    Get.find<AudioHandlerController>()
                        .currentSongTitle
                        .value
                        .isNotEmpty)
                ? const MiniPlayerWidget()
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

Widget _buildLiveIcon() {
  return GetBuilder<HomeController>(
    init: HomeController(),
    builder: (controller) {
      return _LiveIconWidget();
    },
  );
}

class _LiveIconWidget extends StatefulWidget {
  @override
  __LiveIconWidgetState createState() => __LiveIconWidgetState();
}

class __LiveIconWidgetState extends State<_LiveIconWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _liveIconController;

  @override
  void initState() {
    super.initState();
    _liveIconController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _liveIconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _liveIconController,
      child: Image.asset(
        'assets/images/newradio.png',
        width: 50.0,
        height: 30.0,
        color: Colors.red,
      ),
    );
  }
}
