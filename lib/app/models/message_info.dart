class MessageInfo {
  String text;
  String time;
  bool isMe;

  MessageInfo(
    this.text,
    this.time, {
    required this.isMe,
  });
}
