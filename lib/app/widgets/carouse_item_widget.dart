import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:church_app/app/core/app_export.dart';
import 'package:church_app/app/models/album_info.dart';
import 'package:church_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BuildCarouselItem extends StatelessWidget {
  final int carouselIndex, itemIndex;
  final AlbumInfo albumInfo;

  BuildCarouselItem(
      {super.key,
      required this.carouselIndex,
      required this.itemIndex,
      required this.albumInfo});
  late final Future<GetUrlResult> _future = Amplify.Storage.getUrl(key: '');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Get.toNamed(
                Routes.ALBUM,
                arguments: albumInfo,
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                getHorizontalSize(
                  15,
                ),
              ),
              child: FutureBuilder<GetUrlResult>(
                future: _future,
                builder: (context, snapshot) =>
                    snapshot.connectionState == ConnectionState.done
                        ? CachedNetworkImage(
                            fit: BoxFit.cover,
                            cacheKey: albumInfo.albumName,
                            imageUrl: albumInfo.imgPath,
                            //    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Image.asset('assets/images/placeholder.png'),
                            width: Get.width * 0.6,
                            height: Get.height * 0.3,
                          )
                        : Center(
                            child: LoadingAnimationWidget.threeArchedCircle(
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            albumInfo.albumName,
            style: AppStyle.txtUrbanistRomanBoldxx,
          ),
        ),
      ],
    );
  }
}
