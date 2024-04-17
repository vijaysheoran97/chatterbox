

class Message {
  late final String toId;
  late final String msg;
  late final String read;
  late final String fromId;
  late final String sent;
  late final Type type;
  String? audioUrl; // New field for audio URL

  Message({
    required this.toId,
    required this.msg,
    required this.read,
    required this.type,
    required this.fromId,
    required this.sent,
    this.audioUrl, // New field for audio URL
  });

  Message.fromJson(Map<String, dynamic> json)
      : toId = json['toId'].toString(),
        msg = json['msg'].toString(),
        read = json['read'].toString(),
        fromId = json['fromId'].toString(),
        sent = json['sent'].toString(),
        type = _parseType(json['type'].toString()), // Parse Type enum from string
        audioUrl = json['audioUrl']?.toString(); // Deserialize audio URL if present

  Map<String, dynamic> toJson() {
    return {
      'toId': toId,
      'msg': msg,
      'read': read,
      'type': _getTypeString(type), // Serialize Type enum to string
      'fromId': fromId,
      'sent': sent,
      'audioUrl': audioUrl, // Serialize audio URL if present
    };
  }

  // Helper method to parse Type enum from string
  static Type _parseType(String typeString) {
    switch (typeString) {
      case 'image':
        return Type.image;
      case 'audio':
        return Type.audio;
      case 'video':
        return Type.video;
      default:
        return Type.text;
    }
  }

  // Helper method to get string representation of Type enum
  static String _getTypeString(Type type) {
    switch (type) {
      case Type.image:
        return 'image';
      case Type.audio:
        return 'audio';
      case Type.video:
        return 'video';
      default:
        return 'text';
    }
  }
}


enum Type { text, image, token, audio, video }



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

