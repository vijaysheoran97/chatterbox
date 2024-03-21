class User {
  User({
    required this.name,
    required this.uid,
    this.profilePic,
    required this.isOnline,
    required this.phoneNumber,
    required this.groupId,
    required this.blockId,
    required this.blockName,
    required this.blockType,
    required this.blockLocation,
    this.blockDescription,
  });

  final String name;
  final String uid;
  final String? profilePic;
  final bool isOnline;
  final String phoneNumber;
  final List<String> groupId;

  final String blockId;
  final String blockName;
  final String blockType;
  final String blockLocation;
  final String? blockDescription;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'uid': uid,
      'profilePic': profilePic,
      'isOnline': isOnline,
      'phoneNumber': phoneNumber,
      'groupId': groupId,
      'blockId': blockId,
      'blockName': blockName,
      'blockType': blockType,
      'blockLocation': blockLocation,
      'blockDescription': blockDescription,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] as String,
      uid: map['uid'] as String,
      profilePic:
      map['profilePic'] != null ? map['profilePic'] as String : null,
      isOnline: map['isOnline'] as bool,
      phoneNumber: map['phoneNumber'] as String,
      groupId: (map['groupId'] as List).map((e) => e.toString()).toList(),
      blockId: map['blockId'] as String,
      blockName: map['blockName'] as String,
      blockType: map['blockType'] as String,
      blockLocation: map['blockLocation'] as String,
      blockDescription: map['blockDescription'] as String?,
    );
  }

  @override
  String toString() {
    return 'User(name: $name, uid: $uid, profilePic: $profilePic, isOnline: $isOnline, phoneNumber: $phoneNumber, groupId: $groupId, blockId: $blockId, blockName: $blockName, blockType: $blockType, blockLocation: $blockLocation, blockDescription: $blockDescription)';
  }
}
