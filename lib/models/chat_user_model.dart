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
  });

  ChatUser.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        name = json['name'] ?? '',
        email = json['email'] ?? '',
        about = json['about'] ?? '',
        image = json['image'] ?? '',
        createdAt = json['created_at'] ?? '',
        isOnline = json['is_online'] ?? false,
        lastActive = json['last_active'] ?? '',
        pushToken = json['push_token'] ?? '',
        isProfessional = json['is_professional'] ?? false;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['about'] = about;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['last_active'] = lastActive;
    data['push_token'] = pushToken;
    data['is_professional'] = isProfessional;
    return data;
  }
}
