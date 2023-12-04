import 'package:church_app/app/core/app_export.dart';
import 'package:church_app/app/data/backend_queries_controller.dart';
import 'package:church_app/app/models/album_info.dart';
import 'package:church_app/app/modules/notifications/views/notifications_view.dart';
import 'package:church_app/app/widgets/carouse_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../widgets/change_language_widget.dart';
import '../../../widgets/search_delegate.dart';
import '../../authentication/controllers/authentication_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../send_prayer/controllers/send_prayer_controller.dart';
import '../controllers/discover_controller.dart';

@override
void dependencies() {
  Get.put<SendPrayerController>(SendPrayerController());
  Get.put<ProfileController>(ProfileController());

  Get.put<AuthenticationController>(AuthenticationController());
}

class DiscoverView extends GetView<DiscoverController> {
  final int carouselIndex;

  const DiscoverView({this.carouselIndex = 1, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current time
    final DateTime now = DateTime.now();
    final int currentHour = now.hour;

    // Define the greeting message based on the time
    String greetingMessage = 'Good Morning'.tr;
    if (currentHour >= 12 && currentHour < 17) {
      greetingMessage = 'Good Afternoon'.tr;
    } else if (currentHour >= 17) {
      greetingMessage = 'Good Evening'.tr;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/good2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 12, top: 30, right: 10, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        greetingMessage,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                        style: AppStyle.txtUrbanistRomanBoldv,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              showSearch(
                                  context: context,
                                  delegate: SearchWidgetDelegate());
                            },
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NotificationsView()));
                            },
                            icon: const Icon(
                              Icons.notifications,
                              color: Colors.white,
                            ),
                          ),
                          const ChangeLanguageWidget(),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  child: Obx(
                    () => controller.loadingData.value
                        ? Column(
                            children: [
                              LoadingAnimationWidget.threeArchedCircle(
                                size: 70,
                                color: Colors.white,
                              ),
                            ],
                          )
                        : SingleChildScrollView(
                            child: Column(
                              children: List.generate(
                                controller.categories.length,
                                (int index) => Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              controller.categories[index]
                                                  ['title']!,
                                              style: AppStyle
                                                  .txtUrbanistRomanBoldx),
                                        ),
                                      ),
                                      FutureBuilder(
                                        future: Get.find<BackendController>()
                                            .getAllAlbums(controller
                                                .categories[index]['id']!),
                                        builder: (context, snapshot) {
                                          return snapshot.connectionState ==
                                                  ConnectionState.done
                                              ? SizedBox(
                                                  width: 500,
                                                  height: 300,
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        snapshot.data?.length ??
                                                            0,
                                                    itemBuilder: (
                                                      BuildContext context,
                                                      int itemIndex,
                                                    ) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child:
                                                            BuildCarouselItem(
                                                          albumInfo: snapshot
                                                                      .data?[
                                                                  itemIndex] ??
                                                              AlbumInfo(
                                                                albumName: '',
                                                                imgPath: '',
                                                                id: '',
                                                              ),
                                                          carouselIndex:
                                                              carouselIndex,
                                                          itemIndex: itemIndex,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : Center(
                                                  child: LoadingAnimationWidget
                                                      .threeArchedCircle(
                                                    size: 60,
                                                    color: Colors.white,
                                                  ),
                                                );
                                        },
                                      ),
                                      if (index ==
                                          controller.categories.length - 1)
                                        const SizedBox(height: 100)
                                      else
                                        const SizedBox()
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
