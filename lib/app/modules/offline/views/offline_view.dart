import 'package:church_app/app/data/audio_controller.dart';
import 'package:church_app/app/data/local_storage_controller.dart';
import 'package:church_app/app/routes/app_pages.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/firebase_controller.dart';
import '../controllers/offline_controller.dart';

class OfflineView extends GetView<OfflineController> {
  const OfflineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Offline'),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Obx(
        () => Get.find<LoaclStorageController>().cachedFiles.isEmpty
            ? Center(
                child: Text('Offline'.tr),
              )
            : ListView.builder(
                itemBuilder: (context, index) => ListTile(
                  title: Text(
                    Get.find<LoaclStorageController>().cachedFiles[index].title,
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    Get.find<LoaclStorageController>()
                            .cachedFiles[index]
                            .album ??
                        '',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Get.find<AudioHandlerController>().addAll(
                      Get.find<LoaclStorageController>().cachedFiles,
                      Get.find<LoaclStorageController>()
                          .cachedFiles[index]
                          .title,
                    );
                    Get.toNamed(Routes.AUDIO_PLAYER, arguments: {
                      'title': Get.find<LoaclStorageController>()
                          .cachedFiles[index]
                          .title
                    });
                  },
                ),
                itemCount:
                    Get.find<LoaclStorageController>().cachedFiles.length,
              ),
      ),
    );
  }
}
