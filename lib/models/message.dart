class Message {
  late final String toId;
  late final String msg;
  late final String read;
  late final String fromId;
  late final String sent;
  late final Type type;
  late final String? contactName;
  late final String? contactPhone;
  late final double? latitude;
  late final double? longitude;
  String? audioUrl;

  Message({
    required this.toId,
    required this.msg,
    required this.read,
    required this.type,
    required this.fromId,
    required this.sent,
    this.contactName,
    this.contactPhone,
    this.latitude,
    this.longitude,
    this.audioUrl,
  });

  Message.fromJson(Map<String, dynamic> json)
      : toId = json['toId'].toString(),
        msg = json['msg'].toString(),
        read = json['read'].toString(),
        fromId = json['fromId'].toString(),
        sent = json['sent'].toString(),
        contactName = json['contactName'],
        contactPhone = json['contactPhone'],
        latitude = json['latitude'] != null ? double.parse(json['latitude'].toString()) : null,
        longitude = json['longitude'] != null ? double.parse(json['longitude'].toString()) : null,
        type = _parseType(json['type'].toString()),
        audioUrl = json['audioUrl']?.toString();

  Map<String, dynamic> toJson() {
    return {
      'toId': toId,
      'msg': msg,
      'read': read,
      'type': type.name,
     // 'type': _getTypeString(type),
     // 'type': _parseType(type),
      'fromId': fromId,
      'sent': sent,
      'contactName': contactName,
      'contactPhone': contactPhone,
      'latitudde': latitude,
      'longitude': longitude,
      'audioUrl': audioUrl,
    };
  }

  static Type _parseType(String typeString) {
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
        case 'location':
        return Type.location;
      default:
        throw ArgumentError('Invalid message type: $typeString');
    }
  }

  // static String _getTypeString(Type type) {
  //   switch (type) {
  //     case 'text' :
  //       return Type.text;
  //     case 'image':
  //       return Type.image;
  //     case Type.audio:
  //       return 'audio';
  //     case Type.video:
  //       return 'video';
  //     default:
  //       throw ArgumentError('Invalid message type: $type');
  //   }
  // }
}


enum Type { text, image, token, audio, video, contact, location }



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

