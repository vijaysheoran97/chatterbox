class Message {
  Message({
    required this.toId,
    required this.msg,
    required this.read,
    required this.type,
    required this.fromId,
    required this.sent,
    this.contactName,
    this.contactPhone,
  });

  final String toId;
  final String msg;
  final String read;
  final String fromId;
  final String sent;
  final Type type;
  final String? contactName;
  final String? contactPhone;

  Message.fromJson(Map<String, dynamic> json)
      : toId = json['toId'].toString(),
        msg = json['msg'].toString(),
        read = json['read'].toString(),
        type = _getTypeFromString(json['type'].toString()),
        fromId = json['fromId'].toString(),
        sent = json['sent'].toString(),
        contactName = json['contactName'],
        contactPhone = json['contactPhone'];

  Map<String, dynamic> toJson() {
    return {
      'toId': toId,
      'msg': msg,
      'read': read,
      'type': type.name,
      'fromId': fromId,
      'sent': sent,
      'contactName': contactName,
      'contactPhone': contactPhone,
    };
  }

  static Type _getTypeFromString(String typeString) {
    switch (typeString) {
      case 'text':
        return Type.text;
      case 'image':
        return Type.image;
      case 'token':
        return Type.token;
      case 'audio':
        return Type.audio;
      case 'video':
        return Type.video;
      case 'contact':
        return Type.contact;
      default:
        throw ArgumentError('Invalid message type: $typeString');
    }
  }
}


enum Type { text, image, token, audio, video, contact }





class Messages {
  Messages({
    required this.toId,
    required this.token,
    required this.read,
    required this.fromId,
    required this.sent
  });

  late final String toId;
  late final String token;
  late final String read;
  late final String fromId;
  late final String sent;

  Messages.fromJson(Map<String, dynamic> json) {
    toId = json['toId'].toString();
    token = json['token'].toString();
    read = json['read'].toString();
    fromId = json['fromId'].toString();
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['token'] = token;
    data['read'] = read;
    data['fromId'] = fromId;
    data['sent'] = sent;
    return data;
  }
}
