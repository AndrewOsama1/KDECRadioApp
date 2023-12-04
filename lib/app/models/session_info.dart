class SessionInfo {
  late String channelName;
  late String token;
  late String description;
  late String hostName;
  late String lang;
  late String imgPath;

  SessionInfo(
      {required this.channelName,
      required this.token,
      required this.description,
      required this.hostName,
      required this.lang,
      required this.imgPath});

  SessionInfo.fromJson(Map<String, dynamic> json) {
    channelName = json['channelName'].toString();
    token = json['token'].toString();
    description = json['description'].toString();
    hostName = json['hostName'].toString();
    lang = json['lang'].toString();
    imgPath = json['imgPath'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['channelName'] = channelName;
    data['token'] = token;
    data['description'] = description;
    data['hostName'] = hostName;
    data['lang'] = lang;
    data['imgPath'] = imgPath;
    return data;
  }
}
