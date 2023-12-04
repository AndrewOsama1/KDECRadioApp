import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:church_app/app/data/audio_controller.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);

  MyAudioHandler() {
    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();
  }

  Future<void> _loadEmptyPlaylist() async {
    try {
      await player.setAudioSource(_playlist);
    } catch (e) {
      log('Error: $e');
    }
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    player.playbackEventStream.listen((PlaybackEvent event) {
      final bool playing = player.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[player.processingState]!,
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[player.loopMode]!,
        shuffleMode: (player.shuffleModeEnabled)
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: playing,
        updatePosition: player.position,
        bufferedPosition: player.bufferedPosition,
        speed: player.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  void _listenForDurationChanges() {
    player.durationStream.listen((duration) {
      var index = player.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty || index >= newQueue.length) {
        return;
      }
      if (player.shuffleModeEnabled) {
        index = player.shuffleIndices![index];
      }
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
      Get.find<AudioHandlerController>().progressDuration(duration);
    });
  }

  void _listenForCurrentSongIndexChanges() {
    player.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) {
        return;
      }
      if (player.shuffleModeEnabled) {
        index = player.shuffleIndices![index];
      }
      mediaItem.add(playlist[index]);
    });
  }

  void _listenForSequenceStateChanges() {
    player.sequenceStateStream.listen((SequenceState? sequenceState) {
      final sequence = sequenceState?.effectiveSequence;
      if (sequence == null || sequence.isEmpty) {
        return;
      }
      final items = sequence.map((source) => source.tag as MediaItem);
      queue.add(items.toList());
    });
  }

  @override
  Future<void> addQueueItems(
    List<MediaItem> mediaItems, {
    int index = 0,
  }) async {
    try {
      if (player.playing) {
        await player.pause();
      }
      final audioSource = mediaItems.map(_createAudioSource);
      await _playlist.addAll(audioSource.toList()).then((value) {
        final newQueue = queue.value..addAll(mediaItems);
        queue.add(newQueue);
        mediaItem.value = mediaItems[0];
      });
      if (index != 0) {
        await player.seek(Duration.zero, index: index);
      }
      player.play();
    } catch (e) {
      log(e.toString(), stackTrace: StackTrace.current);
    }
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    // await player.stop();
    if (mediaItem.title == 'LIVE') {
      try {
        final audioSource = AudioSource.uri(
          Uri.parse(mediaItem.id),
          tag: mediaItem,
        );
        _playlist.clear();
        _playlist.add(audioSource).then((value) {
          queue.value.clear();
          final newQueue = queue.value..add(mediaItem);
          queue.add(newQueue);
          player.play();
        });
      } catch (e) {
        log(e.toString(), stackTrace: StackTrace.current);
      }
      return;
    }
    try {
      final audioSource = _createAudioSource(mediaItem);
      _playlist.add(audioSource).then((value) {
        final newQueue = queue.value..add(mediaItem);
        queue.add(newQueue);
        player.play();
      });
    } catch (e) {
      log(e.toString(), stackTrace: StackTrace.current);
    }
  }

  LockCachingAudioSource _createAudioSource(MediaItem mediaItem) {
    final theSource = LockCachingAudioSource(
      Uri.parse(mediaItem.id),
      tag: mediaItem,
    );
    return theSource;
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    // manage Just Audio
    _playlist.removeAt(index);

    // notify system
    final newQueue = queue.value..removeAt(index);
    queue.add(newQueue);
  }

  Future<void> removeAll() async {
    try {
      if (player.playing) {
        await player.stop();
      }
      if (_playlist.children.isNotEmpty) {
        _playlist.clear();
      }
    } catch (e) {
      log(e.toString(), stackTrace: StackTrace.current);
    }
  }

  @override
  Future<void> play() async {
    try {
      if (player.playing) {
        await player.stop();
      }
      player.play();
    } catch (e) {
      log(e.toString(), stackTrace: StackTrace.current);
    }
  }

  @override
  Future<void> pause() async => player.pause();

  @override
  Future<void> seek(Duration position) => player.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async {
    try {
      if (index < 0 || index >= queue.value.length) {
        return;
      }
      if (player.shuffleModeEnabled) {
        await player.pause();

        await player.seek(Duration.zero, index: player.shuffleIndices![index]);
        player.play();
        return;
      }
      await player.pause();

      await player.seek(Duration.zero, index: index);
      player.play();
    } catch (e) {
      log(e.toString(), stackTrace: StackTrace.current);
    }
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        player.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        player.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.group:
      case AudioServiceRepeatMode.all:
        player.setLoopMode(LoopMode.all);
        break;
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      player.setShuffleModeEnabled(false);
    } else {
      await player.shuffle();
      player.setShuffleModeEnabled(true);
    }
  }

  @override
  Future customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'dispose') {
      await player.dispose();
      queue.value.clear();
      super.stop();
    }
  }

  @override
  Future<void> stop() async {
    try {
      await player.stop();
      queue.value.clear();
      mediaItem.value = null;
      await _playlist.clear();
      return super.stop();
    } catch (e) {
      log(e.toString(), stackTrace: StackTrace.current);
    }
  }
}
