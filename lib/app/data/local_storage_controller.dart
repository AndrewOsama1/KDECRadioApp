// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:json_cache/json_cache.dart';
import 'package:localstorage/localstorage.dart';

class LoaclStorageController extends GetxController {
  final _storage = LocalStorage('kdec');
  late final JsonCache jsonCache;

  final RxList<MediaItem> favorites = RxList<MediaItem>([]);
  final RxList<MediaItem> cachedFiles = RxList<MediaItem>([]);

  Future getFavs() async {
    // await jsonCache.clear();
    final Map<String, dynamic>? data = await jsonCache.value('favs');
    if (data != null && data['favs'] != null) {
      favorites([]);
      for (final el in data['favs']) {
        final Map<String, dynamic> currentFav = el as Map<String, dynamic>;
        final MediaItemTopia item = MediaItemTopia.fromMap(currentFav);
        favorites.add(
          MediaItem(
            id: item.id,
            title: item.title,
            album: item.album,
          ),
        );
      }
    } else {
      await jsonCache.refresh('favs', {'favs': []});
    }
  }

  Future getPlayedAndCached() async {
    // await jsonCache.clear();
    final Map<String, dynamic>? data = await jsonCache.value('cached');
    if (data != null && data['cached'] != null) {
      cachedFiles([]);
      for (final el in data['cached']) {
        final Map<String, dynamic> currentCached = el as Map<String, dynamic>;
        final MediaItemTopia item = MediaItemTopia.fromMap(currentCached);
        if (!isInCached(item.id)) {
          cachedFiles.add(
            MediaItem(
              id: item.id,
              title: item.title,
              album: item.album,
            ),
          );
        }
      }
    } else {
      await jsonCache.refresh('cached', {'cached': []});
    }
  }

  bool isInFavorite(String title) {
    for (final fav in favorites) {
      if (fav.title == title) {
        return true;
      }
    }
    return false;
  }

  bool isInCached(String id) {
    for (final cached in cachedFiles) {
      if (cached.id == id) {
        return true;
      }
    }
    return false;
  }

  Future removeFromFav(String title) async {
    final List<MediaItem> newList =
        favorites.where((p0) => p0.title != title).toList();
    final List<Map<String, dynamic>> newFavs = newList
        .map(
          (e) => MediaItemTopia(
            e.id,
            e.title,
            e.album,
          ).toMap(),
        )
        .toList();
    await jsonCache.refresh('favs', {'favs': newFavs});
    await getFavs();
  }

  void removeFromFavWidget(String title) {
    Get.defaultDialog(
      middleText: 'Are you sure to remove the song from your fav list?'.tr,
      confirm: TextButton(
        onPressed: () {
          removeFromFav(title);
          Get.back();
        },
        child: const Text('Confirm'),
      ),
      cancel: TextButton(
        onPressed: Get.back,
        child: const Text('Cancel'),
      ),
    );
  }

  Future addToFav(MediaItem mediaItem) async {
    final Map<String, dynamic>? data = await jsonCache.value('favs');
    final MediaItemTopia item = MediaItemTopia(
      mediaItem.id,
      mediaItem.title,
      mediaItem.album,
    );
    await jsonCache.refresh('favs', {
      'favs': [
        ...data!['favs'],
        item.toMap(),
      ]
    });
    await getFavs();
  }

  Future addToPlayed(MediaItem mediaItem) async {
    final Map<String, dynamic>? data = await jsonCache.value('cached');
    final MediaItemTopia item = MediaItemTopia(
      mediaItem.id,
      mediaItem.title,
      mediaItem.album,
    );
    if (isInCached(item.id)) {
      return;
    }
    await jsonCache.refresh('cached', {
      'cached': [
        ...data!['cached'],
        item.toMap(),
      ]
    });
    await getPlayedAndCached();
  }

  @override
  void onInit() {
    jsonCache = JsonCacheMem(JsonCacheLocalStorage(_storage));
    getFavs();
    getPlayedAndCached();
    super.onInit();
  }
}

class MediaItemTopia {
  /// A unique id.
  final String id;

  /// The title of this media item.
  final String title;

  /// The album this media item belongs to.
  final String? album;

  MediaItemTopia(this.id, this.title, this.album);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'album': album,
    };
  }

  factory MediaItemTopia.fromMap(Map<String, dynamic> map) {
    return MediaItemTopia(
      map['id'] as String,
      map['title'] as String,
      map['album'] != null ? map['album'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MediaItemTopia.fromJson(String source) =>
      MediaItemTopia.fromMap(json.decode(source) as Map<String, dynamic>);
}
