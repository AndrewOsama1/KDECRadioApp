import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:audio_service/audio_service.dart';
import 'package:church_app/app/core/app_export.dart';
import 'package:church_app/app/data/firebase_controller.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/album_info.dart';
import '../models/notification_info.dart';
import '../models/song_info.dart';
import '../models/user_info.dart';
import 'queue_controller.dart';

class BackendController extends GetxController {
  static const String baseUrl = 'https://kdechurch.herokuapp.com';
  static const String imgUrl = '$baseUrl/api/img/';
  static const String Url = 'https://kdec-church-testing-app.onrender.com';

  static final CacheOptions options = CacheOptions(
    store: MemCacheStore(),
    hitCacheOnErrorExcept: <int>[401, 403],
    maxStale: const Duration(days: 7),
  );

  // ..interceptors.add(
  //   DioCacheInterceptor(options: options),
  // );
// api to get all albums
  Future<List<AlbumInfo>> getAllAlbums(String id) async {
    try {
      final _dio = await http();
      final dio.Response response = await _dio.get(
        '$Url/api/en/category/$id/albums',
      );

      final List<AlbumInfo> list = <AlbumInfo>[];
      if (response.statusCode == 200) {
        try {
          final List<dynamic> albums =
              response.data['results']['albums'] as List<dynamic>;
          for (final a in albums) {
            list.add(AlbumInfo.fromJson(a as Map<String, dynamic>));
          }
        } catch (e) {
          log(e.toString());
        }
      }

      return list;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

//api to get all info on the album
  Future<AlbumInfo> getAlbumInfo(String id) async {
    try {
      final _dio = await http();

      final dio.Response response = await _dio.get('$Url/api/en/album/$id');
      return AlbumInfo.fromJson(
          response.data['results']['album'] as Map<String, dynamic>);
    } catch (e) {
      log(e.toString());
      return AlbumInfo(albumName: '', imgPath: '', id: '');
    }
  }

//api to get all songs
  Future<List<MediaItem>> getAllSongs(String id) async {
    final _dio = await http();

    final dio.Response response = await _dio.get('$Url/api/en/album/$id/songs');
    Get.find<QueueController>().clearQueue();

    for (final a in response.data['results']['songs'] as List) {
      try {
        final String temp = a['songName'].toString();
        Get.find<QueueController>().add(
          MediaItem(
            id: a['path'],
            album: response.data['results']['albumName'],
            displayTitle: temp,
            title: temp,
            duration: const Duration(),
          ),
        );
      } catch (e) {
        log(e.toString());
      }
    }
    return Get.find<QueueController>().getQueue;
  }

//api for search result
  Future<List<SongInfo>> getSearch(String query) async {
    final _dio = await http();

    final dio.Response response = await _dio.get(
      '$Url/api/en/song?search=$query',
    );
    final List list = response.data['results']['songs'] as List;
    final List<SongInfo> songList = <SongInfo>[];
    for (final e in response.data['results']['songs'] as List) {
      songList.add(SongInfo.fromJson(e as Map<String, dynamic>));
    }
    return songList;
  }

//api to get all notifications
  Future<List<NotificationInfo>> getAllNotifications(String idToken) async {
    final _dio = await http();

    final dio.Response response = await _dio.get(
        '$Url/api/en/user/${Get.find<FirebaseController>().firebaseUser.value!.uid}/notification');
    final List list = response.data as List;
    final List<NotificationInfo> notifications = <NotificationInfo>[];
    for (final e in list) {
      log(e.toString());
      notifications.add(NotificationInfo.fromJson(e as Map<String, dynamic>));
    }
    return notifications;
  }

//api to get all categories
  Future<List<Map<Object, String>>> getCategories() async {
    try {
      final _dio = await http();

      final dio.Response response = await _dio.get('$Url/api/en/category');
      // String decoded = Utf8Decoder().convert(response.bodyBytes);
      final List<Map<Object, String>> categories = <Map<Object, String>>[];

      final List data = response.data['results']['categories'] as List;
      print(response);
      for (final a in data) {
        final Map<Object, String> category = {
          'title': a['categoryTitle'],
          'id': a['id'].toString()
        };
        categories.add(category);
      }
      return categories;
    } catch (e) {
      log(e.toString());
      return [];
    }
  }

//api to get all users info
  Future<UserModel?> getUserInfo(String firebaseToken) async {
    if (Get.find<FirebaseController>().firebaseUser.value == null) {
      return null;
    }
    try {
      final _dio = await http();

      final dio.Response response = await _dio.get(
        '$Url/api/en/user/${Get.find<FirebaseController>().firebaseUser.value!.uid}',
        options: dio.Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Cookie': firebaseToken
          },
        ),
      );

      final UserModel result = UserModel.fromJson(
        response.data['results']['user'] as Map<String, dynamic>,
      );
      return result;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

//api to create user for the server ( not in firebase)
  Future<String> createUser(String token, String user) async {
    log(token);
    try {
      final _dio = await http();

      final dio.Response response = await _dio.post(
        '$Url/api/en/user/add',
        options: dio.Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Cookie": token
          },
        ),
        data: user,
      );
      log(response.data.toString());
      return response.data.toString();
    } catch (e) {
      log(e.toString());
      return '';
    }
  }

  //update all info for users
  Future<String> updateUser(String token, String user) async {
    log(token);
    try {
      final _dio = await http();

      final dio.Response response = await _dio.put(
        '$Url/api/en/user/${Get.find<FirebaseController>().firebaseUser.value!.uid}/update',
        options: dio.Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Cookie": token
          },
        ),
        data: user,
      );
      log(response.data.toString());
      return response.data.toString();
    } catch (e) {
      log(e.toString());
      return '';
    }
  }
}
