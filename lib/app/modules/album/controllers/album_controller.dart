import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:audio_service/audio_service.dart';
import 'package:church_app/app/data/audio_controller.dart';
import 'package:church_app/app/data/backend_queries_controller.dart';
import 'package:church_app/app/models/album_info.dart';
import 'package:get/get.dart';

class AlbumController extends GetxController {
  final AlbumInfo albumInfo = Get.arguments as AlbumInfo;
  final RxBool loadingData = true.obs;
  final Rx<String> posterUrl = ''.obs;

  final RxList<MediaItem> songs = RxList<MediaItem>([]);

  Future getPoster() async {
    final data = await Amplify.Storage.getUrl(
      key: '${albumInfo.albumName}/${albumInfo.imgPath}',
    );
    posterUrl(albumInfo.imgPath);
  }

  Future getPlaylistSongs(String id) async {
    final List<MediaItem> data =
        await Get.find<BackendController>().getAllSongs(id);
    songs(data);
  }

  Future playPlaylist(String songName) async {
    log(songName);
    log(songs.indexWhere((element) => element.title == songName).toString());
    await Get.find<AudioHandlerController>().addAll(songs, songName);
    Get.find<AudioHandlerController>().currentPoster(posterUrl.toString());
  }

  @override
  Future<void> onInit() async {
    loadingData(true);
    await getPoster();
    await getPlaylistSongs(albumInfo.id);
    loadingData(false);
    super.onInit();
  }
}
