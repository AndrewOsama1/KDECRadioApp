class AlbumInfo {
  late String albumName;
  late String imgPath;
  late String id;

  AlbumInfo({
    required this.albumName,
    required this.imgPath,
    required this.id,
  });

  AlbumInfo.fromJson(Map<String, dynamic> json) {
    albumName = json['albumName'].toString();
    imgPath = json['imgPath'].toString();
    id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['albumName'] = albumName;
    data['imgPath'] = imgPath;
    data['id'] = id;

    return data;
  }
}
