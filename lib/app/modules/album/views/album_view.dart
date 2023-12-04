import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_app/app/core/app_export.dart';
import 'package:church_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../data/audio_controller.dart';
import '../controllers/album_controller.dart';

final AudioHandlerController controllur = Get.find<AudioHandlerController>();

class AlbumView extends GetView<AlbumController> {
  const AlbumView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(
        //   controller.albumInfo.albumName,
        //   style: const TextStyle(color: Colors.black),
        // ),
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context)),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('assets/images/good2.jpg'), // Your background image
            fit: BoxFit.cover,
          ),
        ),
        // Make the background image cover the whole screen
        width: double.infinity,
        height: double.infinity,
        child: Obx(
          () => controller.loadingData.value
              ? Center(
                  child: LoadingAnimationWidget.threeArchedCircle(
                    size: 60,
                    color: Colors.white,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: SizedBox(
                          height: getSize(350),
                          width: getSize(350),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              cacheKey: controller.albumInfo.albumName,
                              imageUrl: controller.posterUrl.value,
                              errorWidget: (context, url, error) => Image.asset(
                                'assets/images/placeholder.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // ElevatedButton.icon(
                      //   onPressed: () {},
                      //   style: ElevatedButton.styleFrom(
                      //     foregroundColor: Colors.white,
                      //     backgroundColor: AppConstants.secondaryColor,
                      //   ),
                      //   icon: const Icon(Icons.share),
                      //   label: const Text('Share'),
                      // ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                          padding: getPadding(top: 22),
                          child: Text(
                            controller.albumInfo.albumName,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtUrbanistRomanBoldAA,
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                          padding: getPadding(top: 24),
                          child: Divider(
                              height: getVerticalSize(1),
                              thickness: getVerticalSize(1),
                              color: ColorConstant.blueGray100)),
                      ...controller.songs.map(
                        (e) => ListTile(
                          onTap: () async {
                            controller.playPlaylist(e.title);
                            Get.toNamed(
                              Routes.AUDIO_PLAYER,
                              arguments: {
                                'title': controller.albumInfo.albumName,
                              },
                            );
                          },
                          title: Text(
                            e.title,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtUrbanistRomanBoldx,
                          ),
                          trailing: Obx(
                            () => CustomImageView(
                                svgPath: (controllur.playing == true &&
                                        controllur.currentSongTitle == e.title)
                                    ? ImageConstant
                                        .imgTrash // Use the play icon if playing
                                    : ImageConstant
                                        .imgPlay1 // Use your pause icon path
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
