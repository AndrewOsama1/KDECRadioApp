import 'package:audio_service/audio_service.dart';
import 'package:church_app/app/data/audio_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class PlayButton extends StatefulWidget {
  final double iconSize;
  final double radius;
  final bool isRadio;

  const PlayButton({
    Key? key,
    this.iconSize = 35,
    this.radius = 30,
    this.isRadio = false,
  }) : super(key: key);

  @override
  PlayButtonState createState() => PlayButtonState();
}

class PlayButtonState extends State<PlayButton> with TickerProviderStateMixin {
  late AnimationController iconController;

  @override
  void dispose() {
    iconController.dispose(); // you need this
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    iconController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: Get.find<AudioHandlerController>().audioHandler.playbackState,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.playing &&
              widget.isRadio &&
              Get.find<AudioHandlerController>().currentSongTitle.value ==
                  'LIVE') {
            iconController.reverse();
          } else if (snapshot.data!.playing &&
              !widget.isRadio &&
              Get.find<AudioHandlerController>().currentSongTitle.value !=
                  'LIVE') {
            iconController.reverse();
          } else {
            iconController.forward();
          }
          return (snapshot.data!.processingState == ProcessingState.loading ||
                  snapshot.data!.processingState == ProcessingState.buffering)
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: widget.radius,
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () async {
                      if (Get.find<AudioHandlerController>().playing.value) {
                        if (snapshot.data!.playing) {
                          Get.find<AudioHandlerController>().pause();
                        } else {
                          Get.find<AudioHandlerController>().play();
                        }
                      } else {
                        // Play
                        if (widget.isRadio) {
                          await Get.find<AudioHandlerController>().add(
                            const MediaItem(
                              id: 'http://stream.radiojar.com/km83ueburnhvv',
                              title: 'LIVE',
                            ),
                          );
                          Get.find<AudioHandlerController>()
                              .currentSongTitle('LIVE');
                          Get.find<AudioHandlerController>().play();
                        } else {
                          Get.find<AudioHandlerController>().play();
                        }
                      }
                    },
                    icon: AnimatedIcon(
                      icon: AnimatedIcons.pause_play,
                      progress: iconController,
                    ),
                    iconSize: widget.iconSize,
                  ),
                );
        } else {
          return Container();
        }
      },
    );
  }
}
