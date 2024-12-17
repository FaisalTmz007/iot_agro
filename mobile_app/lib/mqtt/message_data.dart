class MessageData {
  final String message;
  final String timeStamp;

  MessageData(this.message, this.timeStamp);

  Map<String, dynamic> toMap() {
    return {
      'msg': message,
      'timeStamp': timeStamp,
    };
  }
}
