import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_app/app/data/audio_controller.dart';
import 'package:church_app/app/routes/app_pages.dart';
import 'package:church_app/app/widgets/play_button.dart';
import 'package:church_app/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miniplayer/miniplayer.dart';

//thats is the mini player that appears when the user plays a song
class MiniPlayerWidget extends StatelessWidget {
  final VoidCallback? onClose;

  const MiniPlayerWidget({Key? key, this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: SizedBox(
        width: Get.width * 0.95,
        child: Miniplayer(
          backgroundColor: Colors.black,
          minHeight: 80,
          maxHeight: 80,
          builder: (height, percentage) {
            return StreamBuilder(
              stream: Get.find<AudioHandlerController>().audioHandler.mediaItem,
              builder: (_, mediaItem) => (mediaItem.hasData &&
                      mediaItem.connectionState == ConnectionState.active)
                  ? Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => Get.toNamed(
                              Routes.AUDIO_PLAYER,
                              arguments: {
                                'title': Get.find<AudioHandlerController>()
                                        .audioHandler
                                        .mediaItem
                                        .value
                                        ?.album ??
                                    ''
                              },
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: Get.find<AudioHandlerController>()
                                    .currentPoster
                                    .value,
                                cacheKey: Get.find<AudioHandlerController>()
                                    .audioHandler
                                    .mediaItem
                                    .value
                                    ?.album,
                                width: 60,
                                height: 60,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () => Get.toNamed(
                                    Routes.AUDIO_PLAYER,
                                    arguments: {
                                      'title':
                                          Get.find<AudioHandlerController>()
                                                  .audioHandler
                                                  .mediaItem
                                                  .value
                                                  ?.album ??
                                              ''
                                    },
                                  ),
                                  child: FittedBox(
                                    child: Text(
                                      mediaItem.data?.title ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Get.toNamed(
                                    Routes.AUDIO_PLAYER,
                                    arguments: {
                                      'title':
                                          Get.find<AudioHandlerController>()
                                                  .audioHandler
                                                  .mediaItem
                                                  .value
                                                  ?.album ??
                                              ''
                                    },
                                  ),
                                  child: Text(
                                    mediaItem.data?.album ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                Obx(
                                  () => ProgressBar(
                                    baseBarColor: Colors.white,
                                    progressBarColor: Colors.black,
                                    timeLabelLocation: TimeLabelLocation.none,
                                    progress: Get.find<AudioHandlerController>()
                                        .progressDuration
                                        .value,
                                    buffered: Get.find<AudioHandlerController>()
                                        .bufferedDuration
                                        .value,
                                    total: Get.find<AudioHandlerController>()
                                        .totalDuration
                                        .value,
                                    onSeek: (duration) {
                                      Get.find<AudioHandlerController>()
                                          .seek(duration);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          const PlayButton(radius: 22, iconSize: 22),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: GestureDetector(
                              onTap: () {
                                Get.find<AudioHandlerController>()
                                    .stopMediaPlayer();
// Replace 'Routes.AUTHENTICATION' with your actual authentication route
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const Center(child: LinearProgressIndicator()),
            );
          },
        ),
      ),
    );
  }
}
