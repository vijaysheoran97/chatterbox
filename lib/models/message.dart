enum Type { text, image, audio }

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
      'type': type.name, // Serialize Type enum to string
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
      default:
        return Type.text;
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

