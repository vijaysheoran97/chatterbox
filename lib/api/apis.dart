import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:chatterbox/firebase_options.dart';
import 'package:chatterbox/models/chat_user_model.dart';
import 'package:chatterbox/models/message.dart';
import 'package:chatterbox/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

import '../chatter_box/screens/noti_screen.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static FirebaseStorage storage = FirebaseStorage.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static late ChatUser me;

  static User get user => auth.currentUser!;
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

//*********************************************
  Future<File?> downloadFile(String fileUrl, String fileName) async {
    try {
      final Directory tempDir = Directory.systemTemp;
      final File file = File('${tempDir.path}/$fileName');
      if (await file.exists()) {
        return file;
      }
      await storage.refFromURL(fileUrl).writeToFile(file);
      return file;
    } catch (e) {
      print('Error downloading file: $e');
      return null;
    }
  }

  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<void> uplaodFile(String fileName, String filePath) async {
    File file = File(filePath);
    try {
      await firebaseStorage.ref('Files/$fileName').putFile(file).then((p0) {
        log("Uploaded");
      });
    } catch (e) {
      log("Error: $e");
    }
  }

  Future<ListResult> listFiles() async {
    ListResult listResults = await firebaseStorage.ref("Files").listAll();
    return listResults;
  }

  //*******************************************

  static Future<void> sendPushNotification(
      ChatUser chatUser, String msg) async {
    try {
      final body = {
        "to": chatUser.pushToken,
        "notification": {
          "title": chatUser.name,
          "body": msg,
          "android_channel_id": "chats"
        },
      };

      var res = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json',
            HttpHeaders.authorizationHeader:
                'key=AAAAQ0Bf7ZA:APA91bGd5IN5v43yedFDo86WiSuyTERjmlr4tyekbw_YW6JrdLFblZcbHdgjDmogWLJ7VD65KGgVbETS0Px7LnKk8NdAz4Z-AsHRp9WoVfArA5cNpfMKcjh_MQI-z96XQk5oIDUwx8D1'
          },
          body: jsonEncode(body));
      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

  static Future<void> deleteMessage(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  //*******************************************
  static Future<void> deleteToken(Messages messages) async {
    await firestore
        .collection('token/${getConversationID(messages.toId)}/tokens/')
        .doc(messages.sent)
        .delete();
  }

  //*******************************************

  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log('Push Token: $t');
      }
    });
  }

  static Future<bool> userExists(User user) async {
    if (user == null) return false; // Check if user is null

    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  static Future<bool> addChatUser(String email) async {
    final data = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    log('data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      log('user exists: ${data.docs.first.data()}');

      firestore
          .collection('users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      return false;
    }
  }

  static Future<void> getSelfInfo() async {
    await firestore.collection('users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);
        await getFirebaseMessagingToken();

        APIs.updateActiveStatus(true);
        log('My Data: ${user.data()}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey, I'm using CINLINE!",
      image: user.photoURL.toString(),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
      isProfessional: false,
      audioUrl: '',


      audioDuration: null,
      groupId: 'groupId',
      // Initializing isProfessional

      // audioDuration: null,
      isMuted: false,

    );

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': me.name,
      'about': me.about,
    });
  }

  //***************************************
  static Future<void> sendMessageWithFileUrl(
      String recipientId, String fileUrl, Type fileType) async {
    print('Sending message with file URL to $recipientId: $fileUrl');
  }

  static Future<String?> uploadFile(File file) async {
    try {
      print('Uploading file: ${file.path}');
      return 'https://example.com/file-url';
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  //**************************************

  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    log("Extension: $ext");
    final ref = storage.ref().child("profile_picture/${user.uid}.$ext");
    await ref
        .putFile(
          file,
          SettableMetadata(contentType: 'image/$ext'),
        )
        .then((p0) =>
            {log('Data Transferred; ${p0.bytesTransferred / 1000} kb')});
    me.image = await ref.getDownloadURL();
    await firestore.collection('users').doc(user.uid).update({
      'image': me.image,
    });
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      ChatUser chatUser) {
    return firestore
        .collection('users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('users').doc(user.uid).update({
      'is_online': isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
      'push_token': me.pushToken,
    });
  }

  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  //***********************************
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllToken(
      ChatUser user) {
    return firestore
        .collection('token/${getConversationID(user.id)}/tokens/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  //***********************************

  /// send ***************************************** Message

  static Future<void> sendMessage(
    ChatUser chatUser,
    String msg,
    Type type, {
    String contactName = '',
    String contactPhone = '',
    double? latitude,
    double? longitude,
  }) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message message = Message(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time,
        contactName: contactName,
        contactPhone: contactPhone,
        latitude: latitude,
        longitude: longitude,
        senderName: '');
    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) =>
        sendPushNotification(chatUser, type == Type.text ? msg : 'image'));
  }

  // static Future<void> sendMessage(
  //     ChatUser chatUser,
  //     String msg,
  //     Type type) async {
  //   final time = DateTime.now().millisecondsSinceEpoch.toString();
  //   final Message message = Message(
  //       toId: chatUser.id,
  //       msg: msg,
  //       read: '',
  //       type: type,
  //       fromId: user.uid,
  //       sent: time);
  //   final ref =
  //   firestore.collection('chats/${getConversationID(chatUser.id)}/messages/');
  //   await ref.doc(time).set(message.toJson()).then((value) => sendPushNotification(chatUser, type == Type.text ? msg : 'image'));
  // }

  /// send *************************************** token

  static Future<void> sendToken(
    ChatUser chatUser,
    String token,
  ) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Messages messages = Messages(
        toId: chatUser.id,
        token: token,
        read: '',
        fromId: user.uid,
        sent: time);
    final ref =
        firestore.collection('token/${getConversationID(chatUser.id)}/tokens/');
    await ref
        .doc(time)
        .set(messages.toJson())
        .then((value) => sendPushNotification(chatUser, token));
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getToken(ChatUser user) {
    return firestore
        .collection('token/${getConversationID(user.id)}/tokens/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<String?> getFirebaseToken() async {
    await firebaseMessaging.requestPermission();
    String? token = await firebaseMessaging.getToken();
    return token;
  }

  ///************************************************

  static Future<void> updateMessageReadStatus(Message message) async {
    await firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
    // await Noti.shownoti();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  ///******************************************** send image

  static Future<void> sendChatImage(ChatUser chatUser, File file) async {
    final ext = file.path.split('.').last;
    final ref = storage.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });
    final imageUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  ///********************************************* send video

  static Future<void> sendChatVideo(ChatUser chatUser, File videoFile) async {
    final ext = videoFile.path.split('.').last;
    final ref = storage.ref().child(
        'videos/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(videoFile, SettableMetadata(contentType: 'video/$ext'))
        .then((taskSnapshot) {
      log('Data Transferred: ${taskSnapshot.bytesTransferred / 1} mb');
    });

    final videoUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, videoUrl, Type.video);
  }

  ///*********************************************  Send audio
  static Future<void> sendChatAudio(ChatUser chatUser, File audioFile) async {
    final ext = audioFile.path.split('.').last;
    final ref = storage.ref().child(
        'audio/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    await ref
        .putFile(audioFile, SettableMetadata(contentType: 'audio/$ext'))
        .then((taskSnapshot) {
      log('Data Transferred: ${taskSnapshot.bytesTransferred / 1} mb');
    });

    final audioUrl = await ref.getDownloadURL();
    await sendMessage(chatUser, audioUrl, Type.audio);
    await FirebaseFirestore.instance.collection('chats').doc(getConversationID(chatUser.id))
        .collection('messages').add({
      'audioUrl': audioUrl,
      'type': 'audio',
      'timestamp': Timestamp.now(),
      // Add other necessary fields
    });
  }

  ///*********************************************  Contact share

  Future<void> shareContact(ChatUser chatUser, File contactFile,
      String contactName, String contactPhone) async {
    try {
      final ext = contactFile.path.split('.').last;
      final ref = FirebaseStorage.instance.ref().child(
          'audio/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
      final uploadTask = ref.putFile(
        contactFile,
        SettableMetadata(contentType: 'audio/$ext'),
      );
      await uploadTask.whenComplete(() {
        print(
            'Data Transferred: ${uploadTask.snapshot.totalBytes / (1024 * 1024)} MB');
      });
      final downloadURL = await ref.getDownloadURL();
      await sendMessage(chatUser, downloadURL.toString(), Type.contact,
          contactName: contactName, contactPhone: contactPhone);
    } catch (e) {
      print('Error sharing contact: $e');
    }
  }

  ///********************************************* Contact Location///

  Future<void> shareLocation(
      ChatUser chatUser, double latitude, double longitude) async {
    try {
      if (latitude != null && longitude != null) {
        final locationData = {'latitude': latitude, 'longitude': longitude};
        final locationJson = json.encode(locationData);

        final ref = FirebaseStorage.instance.ref().child(
            'locations/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.json');
        final uploadTask = ref.putData(
          Uint8List.fromList(utf8.encode(locationJson)),
          SettableMetadata(contentType: 'application/json'),
        );

        await uploadTask.whenComplete(() {
          print(
              'Data Transferred: ${uploadTask.snapshot.totalBytes / (1024 * 1024)} MB');
        });

        final downloadURL = await ref.getDownloadURL();
        await sendMessage(chatUser, downloadURL.toString(), Type.location,
            latitude: latitude, longitude: longitude);
      } else {
        print('Latitude or longitude is null');
      }
    } catch (e) {
      print('Error sharing location: $e');
    }
  }

  Future<String> getAddress(double? latitude, double? longitude) async {
    try {
      if (latitude != null && longitude != null) {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(latitude, longitude);
        if (placemarks != null && placemarks.isNotEmpty) {
          Placemark address = placemarks.first;
          String formattedAddress =
              "${address.name}, ${address.locality}, ${address.administrativeArea}, ${address.country}";
          return formattedAddress;
        } else {
          return "Address not found";
        }
      } else {
        return "Latitude or longitude is null";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  static Future<void> updateMessage(Message message, String updatedMsg) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMsg});
  }

  ///******************* Send audio call request
  static Future<void> sendAudioCallRequest(ChatUser chatUser) async {
    try {
      log('Sending audio call request to ${chatUser.name}');
    } catch (e) {
      log('Error sending audio call request: $e');
    }
  }

  /// ***************** Send video call request
  static Future<void> sendVideoCallRequest(ChatUser chatUser) async {
    try {
      log('Sending video call request to ${chatUser.name}');
    } catch (e) {
      log('Error sending video call request: $e');
    }
  }

  ///**********************GROUP CHAT

  static Future<void> createChatGroup(ChatUser chatGroup) async {
    try {
      await firestore.collection('chat_groups').add(chatGroup.toJson());
    } catch (e) {
      print('Error creating chat group: $e');
    }
  }

  static Future<void> addUserToGroup(ChatUser chatGroup, ChatUser user) async {
    try {
      await firestore.collection('chat_groups').doc(chatGroup.id).update({
        'members': FieldValue.arrayUnion([user.toJson()]),
      });
    } catch (e) {
      print('Error adding user to group: $e');
    }
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getGroupMessages(
      ChatUser chatGroup) {
    try {
      return firestore
          .collection('chat_groups/${chatGroup.id}/messages')
          .snapshots();
    } catch (e) {
      print('Error getting group messages: $e');
      return Stream.empty();
    }
  }

  static Future<void> leaveGroup(ChatUser chatGroup, ChatUser user) async {
    try {
      await firestore.collection('chat_groups').doc(chatGroup.id).update({
        'members': FieldValue.arrayRemove([user.toJson()]),
      });
    } catch (e) {
      print('Error leaving group: $e');
    }
  }

  static Future<void> sendMessageToGroup(
      ChatUser chatGroup, String message, File? image) async {
    try {
      String? imageUrl = image != null ? await uploadFile(image) : null;
      await firestore.collection('chat_groups/${chatGroup.id}/messages').add({
        'senderId': user.uid,
        'message': message,
        'imageUrl': imageUrl,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print('Error sending message to group: $e');
    }
  }
}
