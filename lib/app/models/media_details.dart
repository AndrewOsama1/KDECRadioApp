import 'dart:convert';

class MediaDetails {
  late String id;
  late String title;
  late String? album;

  MediaDetails({
    required this.id,
    required this.title,
    this.album,
  });
  MediaDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    title = json['title'].toString();
    album = json['album'] is String ? json['album'].toString() : '';
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['album'] = album;
    return data;
  }

  static Map<String, dynamic> toMap(MediaDetails music) =>
      {'id': music.id, 'title': music.title, 'album': music.album};

  static String encode(List<MediaDetails> musics) => json.encode(
        musics
            .map<Map<String, dynamic>>(
              MediaDetails.toMap,
            )
            .toList(),
      );

  static List<MediaDetails> decode(String musics) =>
      (json.decode(musics) as List<Map<String, dynamic>>)
          .map<MediaDetails>(MediaDetails.fromJson)
          .toList();
}
