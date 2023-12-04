import 'dart:math';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_app/app/core/app_export.dart';
import 'package:church_app/app/data/audio_controller.dart';
import 'package:church_app/app/data/local_storage_controller.dart';
import 'package:church_app/app/widgets/play_button.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controllers/audio_player_controller.dart';

enum RepeatState {
  off,
  repeatSong,
  repeatPlaylist,
}

final audio = AudioPlayer();

class AudioPlayerView extends GetView<AudioPlayerController> {
  const AudioPlayerView({super.key});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(
      stream: Get.find<AudioHandlerController>().audioHandler.mediaItem,
      builder: (context, mediaItem) => mediaItem.data == null
          ? Center(
              child: LoadingAnimationWidget.threeArchedCircle(
                size: 60,
                color: Colors.white,
              ),
            )
          : DefaultTextStyle(
              style: const TextStyle(
                  color: Colors.white), // Set text color to white

              child: Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: Get.back,
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.black,
                  elevation: 0,
                ),
                body: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/good2.jpg'), // Your background image
                      fit: BoxFit.cover,
                    ),
                  ),
                  // Make the background image cover the whole screen
                  width: double.infinity,
                  height: double.infinity,

                  child: Obx(
                    () => Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Center(
                          child: FutureBuilder<GetUrlResult>(
                            future: Amplify.Storage.getUrl(
                                key: mediaItem.data?.displayTitle ?? ''),
                            builder: (context, snapshot) =>
                                snapshot.connectionState == ConnectionState.done
                                    ? Container(
                                        height: getSize(350),
                                        width: getSize(350),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            getHorizontalSize(
                                              198,
                                            ),
                                          ),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: snapshot.data?.url == null
                                                ? const AssetImage(
                                                    'assets/images/placeholder.png',
                                                  ) as ImageProvider
                                                : CachedNetworkImageProvider(
                                                    snapshot.data!.url,
                                                    cacheKey:
                                                        mediaItem.data?.album,
                                                  ),
                                          ),
                                        ),
                                      )
                                    : Center(
                                        child: LoadingAnimationWidget
                                            .threeArchedCircle(
                                          size: 60,
                                          color: Colors.white,
                                        ),
                                      ),
                          ),
                        ),
                        if (Get.find<AudioHandlerController>()
                                .totalDuration
                                .value
                                .inSeconds <
                            1)
                          Center(
                            child: LoadingAnimationWidget.threeArchedCircle(
                              size: 60,
                              color: Colors.white,
                            ),
                          )
                        else ...[
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .center, // Align text to the left

                              children: [
                                Padding(
                                    padding: getPadding(top: 1),
                                    child: Text(mediaItem.data?.album ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style:
                                            AppStyle.txtUrbanistRomanBold32)),
                                Padding(
                                    padding: getPadding(top: 10),
                                    child: Text(mediaItem.data?.title ?? '',
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle
                                            .txtUrbanistSemiBold18Gray80001
                                            .copyWith(
                                                letterSpacing:
                                                    getHorizontalSize(0.2)))),
                              ],
                            ),
                          ),
                          Obx(
                            () => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ProgressBar(
                                  progress: Get.find<AudioHandlerController>()
                                      .progressDuration
                                      .value,
                                  timeLabelTextStyle:
                                      AppStyle.txtUrbanistRomanBoldy,
                                  thumbColor: Colors.blue,
                                  thumbGlowColor: Colors.blue,
                                  barHeight: 4,
                                  baseBarColor: Colors.white,
                                  progressBarColor: Colors.blue,
                                  buffered: Get.find<AudioHandlerController>()
                                      .bufferedDuration
                                      .value,
                                  total: Get.find<AudioHandlerController>()
                                      .totalDuration
                                      .value,
                                  bufferedBarColor: Colors.white,
                                  onSeek: (duration) {
                                    Get.find<AudioHandlerController>()
                                        .seek(duration);
                                    ;
                                  }),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: IconButton(
                              onPressed: () =>
                                  Get.find<LoaclStorageController>()
                                          .isInFavorite(mediaItem.data!.title)
                                      ? Get.find<LoaclStorageController>()
                                          .removeFromFav(mediaItem.data!.title)
                                      : Get.find<LoaclStorageController>()
                                          .addToFav(
                                          mediaItem.data!,
                                        ),
                              icon: Get.find<LoaclStorageController>()
                                      .isInFavorite(mediaItem.data!.title)
                                  ? const Icon(
                                      Icons.favorite,
                                      color: Colors.blue,
                                      size: 33,
                                    )
                                  : const Icon(
                                      Icons.favorite_outline,
                                      color: Colors.white,
                                      size: 33,
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(
                                    Get.locale == const Locale('ar', 'AR')
                                        ? pi
                                        : 0,
                                  ),
                                  child: Obx(
                                    () => Get.find<AudioHandlerController>()
                                            .isFirstSong
                                            .value
                                        ? Container() // This is an empty container, you can replace it with any other widget or leave it empty.
                                        : IconButton(
                                            onPressed: () => Get.locale ==
                                                    const Locale('ar', 'AR')
                                                ? Get.find<
                                                        AudioHandlerController>()
                                                    .audioHandler
                                                    .skipToNext()
                                                : Get.find<
                                                        AudioHandlerController>()
                                                    .previous(),
                                            icon: const Icon(
                                              Icons.skip_previous,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                                const PlayButton(),
                                Transform(
                                  alignment: Alignment.center,
                                  transform: Matrix4.rotationY(
                                    Get.locale == const Locale('ar', 'AR')
                                        ? pi
                                        : 0,
                                  ),
                                  child: Obx(
                                    () => Get.find<AudioHandlerController>()
                                            .isLastSong
                                            .value
                                        ? Container() // This is an empty container, you can replace it with any other widget or leave it empty.
                                        : IconButton(
                                            onPressed: () => Get.locale ==
                                                    const Locale('ar', 'AR')
                                                ? Get.find<
                                                        AudioHandlerController>()
                                                    .audioHandler
                                                    .skipToNext()
                                                : Get.find<
                                                        AudioHandlerController>()
                                                    .previous(),
                                            icon: const Icon(
                                              Icons.skip_next,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
