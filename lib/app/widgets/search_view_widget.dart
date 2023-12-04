import 'package:church_app/app/data/backend_queries_controller.dart';
import 'package:church_app/app/models/album_info.dart';
import 'package:church_app/app/models/song_info.dart';
import 'package:church_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_style.dart';

class SearchView extends StatelessWidget {
  final SongInfo songInfo;

  const SearchView({Key? key, required this.songInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 10, bottom: 10),
      child: ListTile(
        title: Text(
          songInfo.songName,
          style: AppStyle.txtUrbanistSemiBold16WhiteA709,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
        ),
        onTap: () async {
          final AlbumInfo albumInfo =
              await Get.find<BackendController>().getAlbumInfo(
            songInfo.albumId,
          );
          Get.toNamed(Routes.ALBUM, arguments: albumInfo);
        },
      ),
    );
  }
}
