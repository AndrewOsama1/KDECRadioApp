class RadioKingTrack {
  late String artist;
  late String title;
  late String nextTrack;
  late double duration;
  late bool isLive;
  late String cover;
  late String message;

  RadioKingTrack(
    this.artist,
    this.title,
    this.nextTrack,
    this.duration,
    this.cover,
    this.message, {
    required this.isLive,
  });

  RadioKingTrack.fromJson(Map<String, dynamic> json) {
    artist = json['artist'] is String ? json['artist'].toString() : '';

    title = json['title'] is String ? json['title'].toString() : '';

    cover = json['cover'] is String ? json['cover'].toString() : '';

    duration = double.tryParse(json['duration'].toString()) ?? 0.0;

    // ignore: avoid_bool_literals_in_conditional_expressions
    isLive = json['is_live'] is bool ? json['is_live'] as bool : false;

    nextTrack =
        json['next_track'] is String ? json['next_track'].toString() : '';
    message = json['message'] is String ? json['message'].toString() : '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['artist'] = artist;
    data['title'] = title;
    data['cover'] = cover;
    data['duration'] = duration;
    data['is_live'] = isLive;
    data['next_track'] = nextTrack;
    data['message'] = message;
    return data;
  }
}
