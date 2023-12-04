class NotificationInfo {
  late String title;
  late String body;
  late String sendAt;

  NotificationInfo(this.title, this.body);
  NotificationInfo.fromJson(Map<String, dynamic> json) {
    title = json['title'].toString();
    body = json['body'].toString();
    sendAt = json['sendAt'].toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['title'] = title;
    data['body'] = body;
    return data;
  }
}
