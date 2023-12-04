import 'package:church_app/app/core/app_export.dart';
import 'package:church_app/app/data/audio_controller.dart';
import 'package:church_app/app/data/local_storage_controller.dart';
import 'package:church_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import '../../../../widgets/change_language_widget.dart';
import '../../../../widgets/search_delegate.dart';
import '../../../notifications/views/notifications_view.dart';
import '../controllers/favorites_controller.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});

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
      body: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("assets/images/good2.jpg"),
            fit: BoxFit.cover,
          ),
          border: Border.all(),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Obx(
          () => Get.find<LoaclStorageController>().favorites.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: getPadding(top: 5, bottom: 10),
                        child: Center(
                          child: Text(
                            'Favourites'.tr,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtUrbanistRomanBoldz,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 300.0),
                        child: Text(
                          'Empty'.tr,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemBuilder: (context, index) => ListTile(
                    title: Text(
                      Get.find<LoaclStorageController>().favorites[index].title,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtUrbanistSemiBold16WhiteA709,
                    ),
                    subtitle: Text(
                      Get.find<LoaclStorageController>()
                              .favorites[index]
                              .album ??
                          '',
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtUrbanistSemiBold16WhiteA708,
                    ),
                    onTap: () {
                      Get.find<AudioHandlerController>().addAll(
                        Get.find<LoaclStorageController>().favorites,
                        Get.find<LoaclStorageController>()
                            .favorites[index]
                            .title,
                      );
                      Get.toNamed(Routes.AUDIO_PLAYER);
                    },
                    trailing: IconButton(
                      onPressed: () {
                        Get.find<LoaclStorageController>().removeFromFavWidget(
                          Get.find<LoaclStorageController>()
                              .favorites[index]
                              .title,
                        );
                      },
                      icon: const Icon(
                        Icons.remove_circle_outline_rounded,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  itemCount:
                      Get.find<LoaclStorageController>().favorites.length,
                ),
        ),
      ),
    );
  }
}
