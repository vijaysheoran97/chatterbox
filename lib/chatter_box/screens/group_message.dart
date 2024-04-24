// import 'dart:async';
// import 'dart:io';
//
// import 'package:chatterbox/api/apis.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
//
// class GroupMessage {
//   final String senderId;
//   final String message;
//   final String? imageUrl;
//   final String? audioUrl;
//   final String? videoUrl;
//   final Timestamp timestamp;
//
//   GroupMessage({
//     required this.senderId,
//     required this.message,
//     this.imageUrl,
//     this.audioUrl,
//     this.videoUrl,
//     required this.timestamp,
//   });
//
//   factory GroupMessage.fromFirestore(DocumentSnapshot doc) {
//     Map data = doc.data() as Map<String, dynamic>;
//     return GroupMessage(
//       senderId: data['senderId'],
//       message: data['message'],
//       imageUrl: data['imageUrl'],
//       audioUrl: data['audioUrl'],
//       videoUrl: data['videoUrl'],
//       timestamp: data['timestamp'] ?? Timestamp.now(),
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'senderId': senderId,
//       'message': message,
//       'imageUrl': imageUrl, // Include imageUrl in the map
//       'audioUrl': audioUrl, // Include audioUrl in the map
//       'videoUrl': videoUrl, // Include videoUrl in the map
//       'timestamp': timestamp,
//     };
//   }
// }
//
// class GroupChatPage extends StatefulWidget {
//   final String groupId;
//   final String groupName;
//
//   const GroupChatPage({Key? key, required this.groupId, required this.groupName}) : super(key: key);
//
//   @override
//   _GroupChatPageState createState() => _GroupChatPageState();
// }
//
// class _GroupChatPageState extends State<GroupChatPage> {
//   final TextEditingController _textController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   late Stream<List<GroupMessage>> _messagesStream;
//   bool _isUploading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _messagesStream = getGroupMessages().map((snapshot) =>
//         snapshot.docs
//             .map((doc) => GroupMessage.fromFirestore(doc))
//             .toList());
//   }
//
//   Stream<QuerySnapshot<Map<String, dynamic>>> getGroupMessages() {
//     try {
//       return FirebaseFirestore.instance
//           .collection('chat_groups/${widget.groupId}/messages')
//           .orderBy('timestamp', descending: true)
//           .snapshots();
//     } catch (e) {
//       print('Error getting group messages: $e');
//       return const Stream.empty();
//     }
//   }
//
//   Future<void> _sendMessage(String message, {File? image, File? audio, File? video}) async {
//     try {
//       String currentUserId = 'currentUserId';
//       if (image != null || audio != null || video != null) {
//         setState(() {
//           _isUploading = true;
//         });
//         String? imageUrl = image != null ? await uploadFile(image) : null;
//         String? audioUrl = audio != null ? await uploadFile(audio) : null;
//         String? videoUrl = video != null ? await uploadFile(video) : null;
//
//         if (imageUrl != null || audioUrl != null || videoUrl != null) {
//           await APIs.sendMessageToGroup(widget.groupId, '', imageUrl, audioUrl, videoUrl);
//         }
//         setState(() {
//           _isUploading = false;
//         });
//       } else if (message.trim().isNotEmpty) {
//         await APIs.sendMessageToGroup(widget.groupId, message, null, null, null);
//       }
//       _textController.clear();
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           0.0,
//           curve: Curves.easeOut,
//           duration: const Duration(milliseconds: 300),
//         );
//       }
//     } catch (e) {
//       print('Error sending message: $e');
//     }
//   }
//
//   Future<void> _pickImage(ImageSource source) async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.getImage(source: source);
//     if (pickedFile != null) {
//       _sendMessage('', image: File(pickedFile.path));
//     }
//   }
//
//   Future<void> _pickAudio() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       _sendMessage('', video: File(pickedFile.path));
//     }
//   }
//
//   Future<void> _pickVideo() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       _sendMessage('', video: File(pickedFile.path));
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.groupName),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<List<GroupMessage>>(
//               stream: _messagesStream,
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(
//                     child: Text('No messages yet'),
//                   );
//                 }
//                 return ListView.builder(
//                   reverse: true,
//                   controller: _scrollController,
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (context, index) {
//                     final message = snapshot.data![index];
//                     return ListTile(
//                       title: Text(message.message),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (message.imageUrl != null)
//                             Image.network(message.imageUrl!),
//                           if (message.audioUrl != null)
//                             TextButton(
//                               onPressed: () {},
//                               child: const Text('Play Audio'),
//                             ),
//                           if (message.videoUrl != null)
//                             TextButton(
//                               onPressed: () {},
//                               child: const Text('Play Video'),
//                             ),
//                         ],
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _textController,
//                     decoration: const InputDecoration(
//                       hintText: 'Type a message...',
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.camera_alt),
//                   onPressed: () => _pickImage(ImageSource.camera),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.image),
//                   onPressed: () => _pickImage(ImageSource.gallery),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.mic),
//                   onPressed: () => _pickAudio(),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.video_call),
//                   onPressed: () => _pickVideo(),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () {
//                     final message = _textController.text.trim();
//                     if (message.isNotEmpty) {
//                       _sendMessage(message);
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class ChatUser {
//   final String id;
//
//   ChatUser({required this.id});
//
//   Map<String, dynamic> toJson() {
//     return {'id': id};
//   }
// }
//
// Future<String?> uploadFile(File file) async {
//   try {
//     final firebase_storage.Reference storageRef =
//     firebase_storage.FirebaseStorage.instance.ref().child('chat_files');
//
//     final firebase_storage.UploadTask uploadTask = storageRef.putFile(file);
//     final firebase_storage.TaskSnapshot downloadSnapshot =
//     (await uploadTask.whenComplete(() => null)!);
//
//     final String downloadUrl = (await downloadSnapshot.ref.getDownloadURL())!;
//     return downloadUrl;
//   } catch (e) {
//     print('Error uploading file: $e');
//     return null;
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//




import 'dart:async';
import 'dart:io';

import 'package:chatterbox/api/apis.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';

class GroupMessage {
  final String senderId;
  final String message;
  final String? imageUrl;
  final String? audioUrl;
  final String? videoUrl;
  final Timestamp timestamp;

  GroupMessage({
    required this.senderId,
    required this.message,
    this.imageUrl,
    this.audioUrl,
    this.videoUrl,
    required this.timestamp,
  });

  factory GroupMessage.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return GroupMessage(
      senderId: data['senderId'],
      message: data['message'],
      imageUrl: data['imageUrl'],
      audioUrl: data['audioUrl'],
      videoUrl: data['videoUrl'],
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'message': message,
      'imageUrl': imageUrl, // Include imageUrl in the map
      'audioUrl': audioUrl, // Include audioUrl in the map
      'videoUrl': videoUrl, // Include videoUrl in the map
      'timestamp': timestamp,
    };
  }
}

class GroupChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;

  const GroupChatPage({Key? key, required this.groupId, required this.groupName}) : super(key: key);

  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late Stream<List<GroupMessage>> _messagesStream;
  bool _isUploading = false;
  late AudioPlayer _audioPlayer;
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _messagesStream = getGroupMessages().map((snapshot) =>
        snapshot.docs
            .map((doc) => GroupMessage.fromFirestore(doc))
            .toList());

    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getGroupMessages() {
    try {
      return FirebaseFirestore.instance
          .collection('chat_groups/${widget.groupId}/messages')
          .orderBy('timestamp', descending: true)
          .snapshots();
    } catch (e) {
      print('Error getting group messages: $e');
      return Stream.empty();
    }
  }

  Future<void> _sendMessage(String message, {File? image, File? audio, File? video}) async {
    try {
      String currentUserId = 'currentUserId';
      if (image != null || audio != null || video != null) {
        setState(() {
          _isUploading = true;
        });
        String? imageUrl = image != null ? await uploadFile(image) : null;
        String? audioUrl = audio != null ? await uploadFile(audio) : null;
        String? videoUrl = video != null ? await uploadFile(video) : null;

        if (imageUrl != null || audioUrl != null || videoUrl != null) {
          await APIs.sendMessageToGroup(widget.groupId, '', imageUrl, audioUrl, videoUrl);
        }
        setState(() {
          _isUploading = false;
        });
      } else if (message.trim().isNotEmpty) {
        await APIs.sendMessageToGroup(widget.groupId, message, null, null, null);
      }
      _textController.clear();
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: source);
    if (pickedFile != null) {
      _sendMessage('', image: File(pickedFile.path));
    }
  }

  Future<void> _pickAudio() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      _sendMessage('', audio: file);
    }
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      _sendMessage('', video: File(pickedFile.path));
    }
  }

  void _playAudio(String url) async {
    await _audioPlayer.stop();
    await _audioPlayer.play(url, isLocal: true);
  }

  void _playVideo(String url) {
    _chewieController = ChewieController(
      videoPlayerController: VideoPlayerController.network(url),
      autoPlay: true,
      looping: true,
    );
    _chewieController.enterFullScreen();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<GroupMessage>>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No messages yet'),
                  );
                }
                return ListView.builder(
                  reverse: true,
                  controller: _scrollController,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final message = snapshot.data![index];
                    return ListTile(
                      title: Text(message.message),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (message.imageUrl != null)
                            Image.network(message.imageUrl!),
                          if (message.audioUrl != null)
                            TextButton(
                              onPressed: () {
                                _playAudio(message.audioUrl!);
                              },
                              child: Text('Play Audio'),
                            ),
                          if (message.videoUrl != null)
                            TextButton(
                              onPressed: () {
                                _playVideo(message.videoUrl!);
                              },
                              child: Text('Play Video'),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
                IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: () => _pickAudio(),
                ),
                IconButton(
                  icon: Icon(Icons.video_call),
                  onPressed: () => _pickVideo(),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    final message = _textController.text.trim();
                    if (message.isNotEmpty) {
                      _sendMessage(message);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatUser {
  final String id;

  ChatUser({required this.id});

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}

Future<String?> uploadFile(File file) async {
  try {
    final firebase_storage.Reference storageRef =
    firebase_storage.FirebaseStorage.instance.ref().child('chat_files');

    final firebase_storage.UploadTask uploadTask = storageRef.putFile(file);
    final firebase_storage.TaskSnapshot downloadSnapshot =
    (await uploadTask.whenComplete(() => null)!);

    final String downloadUrl = (await downloadSnapshot.ref.getDownloadURL())!;
    return downloadUrl;
  } catch (e) {
    print('Error uploading file: $e');
    return null;
  }
}











