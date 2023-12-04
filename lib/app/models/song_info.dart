class SongInfo {
  late String albumId;
  late String lang;
  late String songName;
  late String author;

  SongInfo(this.albumId, this.lang, this.songName);
  SongInfo.fromJson(Map<String, dynamic> json) {
    albumId = json['albumId'].toString();
    lang = json['lang'].toString();
    songName = json['songName'].toString();
    author = json['author'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['albumId'] = albumId;
    data['lang'] = lang;
    data['songName'] = songName;
    data['author'] = author;

    return data;
  }
}
