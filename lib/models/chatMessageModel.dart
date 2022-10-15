class Message {
  final String senderId;
  final String recieverid;
  final String text;
  final String type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  final String url;
  
  Message({
    required this.senderId,
    required this.recieverid,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
    required this.url,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recieverid': recieverid,
      'text': text,
      'type': String,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
       'url' : url
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      recieverid: map['recieverid'] ?? '',
      text: map['text'] ?? '',
      type: (map['type'] as String).toString(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      messageId: map['messageId'] ?? '',
      isSeen: map['isSeen'] ?? false,
      url : map['url'] ?? "",
    );
  }
}
