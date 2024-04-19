// class ChatUser {
//   late String id;
//   late String name;
//   late String email;
//   late String about;
//   late String image;
//   late String createdAt;
//   late bool isOnline;
//   late String lastActive;
//   late String pushToken;
//   late bool isProfessional;
//   String audioUrl;
//   int? audioDuration;
//
//   ChatUser({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.about,
//     required this.image,
//     required this.createdAt,
//     required this.isOnline,
//     required this.lastActive,
//     required this.pushToken,
//     required this.isProfessional,
//     required this.audioUrl,
//     required this.audioDuration,
//   });
//
//   ChatUser.fromJson(Map<String, dynamic>? json)
//       : id = json?['id'] ?? '',
//         name = json?['name'] ?? '',
//         email = json?['email'] ?? '',
//         about = json?['about'] ?? '',
//         image = json?['image'] ?? '',
//         createdAt = json?['createdAt'] ?? '',
//         isOnline = json?['isOnline'] ?? false,
//         lastActive = json?['lastActive'] ?? '',
//         pushToken = json?['pushToken'] ?? '',
//         isProfessional = json?['isProfessional'] ?? false,
//         audioUrl = json?['audioUrl'] ?? '', // Initialize audioUrl field
//         audioDuration = json?['audioDuration']; // Initialize audioDuration field
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'email': email,
//       'about': about,
//       'image': image,
//       'createdAt': createdAt,
//       'isOnline': isOnline,
//       'lastActive': lastActive,
//       'pushToken': pushToken,
//       'isProfessional': isProfessional,
//       'audioUrl': audioUrl, // Add audioUrl field
//       'audioDuration': audioDuration, // Add audioDuration field
//     };
//   }
// }

class ChatUser {
  late String id;
  late String name;
  late String email;
  late String about;
  late String image;
  late String createdAt;
  late bool isOnline;
  late String lastActive;
  late String pushToken;
  late bool isProfessional;
  late String audioUrl;
  int? audioDuration;
  late String groupId; // Add groupId field

 
  late bool isMuted;
  late bool isBlocked;


  ChatUser({
    required this.id,
    required this.name,
    required this.email,
    required this.about,
    required this.image,
    required this.createdAt,
    required this.isOnline,
    required this.lastActive,
    required this.pushToken,
    required this.isProfessional,
    required this.audioUrl,
    required this.audioDuration,

    required this.groupId, // Initialize groupId field

    required this.isMuted,
    this.isBlocked = false,

  });

  ChatUser.fromJson(Map<String, dynamic>? json)
      : id = json?['id'] ?? '',
        name = json?['name'] ?? '',
        email = json?['email'] ?? '',
        about = json?['about'] ?? '',
        image = json?['image'] ?? '',
        createdAt = json?['createdAt'] ?? '',
        isOnline = json?['isOnline'] ?? false,
        lastActive = json?['lastActive'] ?? '',
        pushToken = json?['pushToken'] ?? '',
        isProfessional = json?['isProfessional'] ?? false,
        audioUrl = json?['audioUrl'] ?? '',
        audioDuration = json?['audioDuration'],

        groupId = json?['groupId'] ?? '', // Initialize groupId field

        isMuted = json?['isMuted'] ?? false,
        isBlocked = json?['isBlocked'] ?? false;


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'about': about,
      'image': image,
      'createdAt': createdAt,
      'isOnline': isOnline,
      'lastActive': lastActive,
      'pushToken': pushToken,
      'isProfessional': isProfessional,
      'audioUrl': audioUrl,
      'audioDuration': audioDuration,
      'groupId': groupId,
      'isMuted' : isMuted,
      'isBlocked': isBlocked,
    };
  }
}
