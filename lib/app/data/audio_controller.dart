import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:church_app/app/data/audio_handler.dart';
import 'package:church_app/app/data/local_storage_controller.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioHandlerController extends GetxController {
  late final MyAudioHandler audioHandler;

  final RxBool playing = false.obs;
  final Rx<LoopMode> loopMode = LoopMode.off.obs;
  final RxBool shuffleMode = false.obs;
  final Rx<String> currentPoster = ''.obs;

  final Rx<Duration> totalDuration = Duration.zero.obs;
  final Rx<Duration> progressDuration = Duration.zero.obs;
  final Rx<Duration> bufferedDuration = Duration.zero.obs;

  final Rx<List<String>> playlist = Rx<List<String>>([]);
  final Rx<String> currentSongTitle = ''.obs;
  final RxBool isFirstSong = false.obs;
  final RxBool isLastSong = false.obs;

  void _listenToChangesInPlaylist() {
    audioHandler.queue.listen((playingList) {
      if (playingList.isEmpty) {
        playlist([]);
        currentSongTitle('');
      } else {
        final newList = playingList.map((item) => item.title).toList();
        playlist(newList);
      }
      _updateSkipButtons();
    });
  }

  void _listenToPlaybackState() {
    audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playing(false);
      } else if (!isPlaying) {
        playing(false);
      } else if (processingState != AudioProcessingState.completed) {
        playing(true);
      } else {
        audioHandler.seek(Duration.zero);
        audioHandler.pause();
      }
    });
  }

  void _listenToCurrentPosition() {
    audioHandler.player.positionStream.listen(progressDuration);

    AudioService.position.listen(progressDuration);
  }

  void _listenToBufferedPosition() {
    audioHandler.playbackState.listen((playbackState) {
      bufferedDuration(playbackState.bufferedPosition);
      if (audioHandler.player.duration != null &&
          bufferedDuration.value.inSeconds ==
              audioHandler.player.duration?.inSeconds &&
          audioHandler.mediaItem.value?.id != null &&
          audioHandler.mediaItem.value?.id != 'LIVE') {
        log('added to cached');
        Get.find<LoaclStorageController>()
            .addToPlayed(audioHandler.mediaItem.value!);
      }

      // progressDuration(playbackState.position);
    });
  }

  void _listenToTotalDuration() {
    audioHandler.player.durationStream.listen(totalDuration);
  }

  void _listenToChangesInSong() {
    audioHandler.mediaItem.listen((mediaItem) {
      currentSongTitle(mediaItem?.title ?? '');
      _updateSkipButtons();
    });
  }

  void _updateSkipButtons() {
    final mediaItem = audioHandler.mediaItem.value;
    final playlist = audioHandler.queue.value;
    if (playlist.length < 2 || mediaItem == null) {
      isFirstSong(true);
      isLastSong(true);
    } else {
      isFirstSong(playlist.first == mediaItem);
      isLastSong(playlist.last == mediaItem);
    }
  }

  void play() => audioHandler.play();
  Future pause() async => audioHandler.pause();

  void seek(Duration position) => audioHandler.seek(position);

  void previous() {
    totalDuration(Duration.zero);
    audioHandler.skipToPrevious();
  }

  void next() {
    totalDuration(Duration.zero);
    audioHandler.skipToNext();
  }

  void repeat() {
    loopMode(loopMode.value == LoopMode.off
        ? LoopMode.one
        : loopMode.value == LoopMode.one
            ? LoopMode.all
            : LoopMode.off);
    switch (loopMode.value) {
      case LoopMode.off:
        audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
        break;
      case LoopMode.one:
        audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        break;
      case LoopMode.all:
        audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        break;
    }
  }

  void shuffle() {
    shuffleMode.toggle();
    if (shuffleMode.value) {
      audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
    } else {
      audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
    }
  }

  Future<void> addAll(List<MediaItem> list, String songName) async {
    totalDuration(Duration.zero);
    try {
      if (playing.value) {
        await pause();
      }
      final current = list.indexWhere((element) => element.title == songName);
      await audioHandler.removeAll();
      await audioHandler.addQueueItems(list, index: current);
      // await audioHandler.skipToQueueItem(current);
    } catch (e) {
      log(e.toString(), stackTrace: StackTrace.current);
    }
  }

  void stopMediaPlayer() {
    // Stop the media player
    stop();
  }

  Future<void> add(MediaItem item) async {
    try {
      await audioHandler.addQueueItem(item);
    } catch (e) {
      log(e.toString(), stackTrace: StackTrace.current);
    }
  }

  void remove() {
    final lastIndex = audioHandler.queue.value.length - 1;
    if (lastIndex < 0) {
      return;
    }
    audioHandler.removeQueueItemAt(lastIndex);
  }

  @override
  void dispose() {
    audioHandler.customAction('dispose');
    audioHandler.queue.value.clear();
    super.dispose();
  }

  void stop() {
    totalDuration(Duration.zero);
    audioHandler.stop();
  }

  @override
  Future<void> onInit() async {
    audioHandler = await AudioService.init(
      builder: MyAudioHandler.new,
      config: const AudioServiceConfig(
        androidNotificationChannelId:
            'com.genesiscreations.chruchapp.channel.audio',
        androidNotificationChannelName: 'KDEC Radio',
        androidNotificationIcon: 'drawable/ic_stat_kdec',
        androidNotificationOngoing: true,
      ),
    );
    _listenToChangesInPlaylist();
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();
    super.onInit();
  }
}
