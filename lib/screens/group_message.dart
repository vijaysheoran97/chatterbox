// import 'package:chatterbox/screens/group_details.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../main.dart';
//
// class GroupMessagePage extends StatefulWidget {
//   final String groupId;
//
//   const GroupMessagePage({Key? key, required this.groupId}) : super(key: key);
//
//   @override
//   State<GroupMessagePage> createState() => _GroupMessagePageState();
// }
//
// class _GroupMessagePageState extends State<GroupMessagePage> {
//   String groupName = '';
//   final _textController = TextEditingController();
//   bool _showEmoji = false,
//       _isUploading = false;
//   bool _isRecording = false;// Store the group name
//
//   @override
//   void initState() {
//     super.initState();
//     fetchGroupData(); // Fetch group data when the widget initializes
//   }
//
//   Future<void> fetchGroupData() async {
//     try {
//       // Retrieve the group document from Firestore using the groupId
//       DocumentSnapshot groupSnapshot =
//       await FirebaseFirestore.instance.collection('groups').doc(widget.groupId).get();
//
//       if (groupSnapshot.exists) {
//         // If the document exists, extract the group name
//         Map<String, dynamic>? data = groupSnapshot.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>
//         setState(() {
//           groupName = data?['name'] ?? ''; // Update the groupName
//         });
//       } else {
//         // Handle case where the group document doesn't exist
//         print('Group document does not exist');
//       }
//     } catch (error) {
//       // Handle any errors that occur during the process
//       print('Error retrieving group document: $error');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leadingWidth: 35,
//         title: InkWell(
//           onTap: () {
//             // Navigate to the GroupDetailPage when tapped on the title
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => GroupDetailsPage(groupId: widget.groupId),
//               ),
//             );
//           },
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               CircleAvatar(child: Icon(Icons.group_outlined)),
//               SizedBox(width: 5),
//               Text(groupName, style: TextStyle()),
//             ],
//           ),
//         ),
//
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           _chatInput(),
//         ],
//       ),
//     );
//   }
//
//
//   Widget _chatInput() {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//           vertical: mq.height * .01, horizontal: mq.width * .025),
//       child: Row(
//         children: [
//           Expanded(
//             child: Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Row(
//                 children: [
//                   // Emoji button
//                   IconButton(
//                     onPressed: () {
//                       // FocusScope.of(context).unfocus();
//                       // setState(() => _showEmoji = !_showEmoji);
//                     },
//                     icon: const Icon(Icons.emoji_emotions,
//                         color: Colors.blueAccent, size: 25),
//                   ),
//
//                   Expanded(
//                     child: TextField(
//                       controller: _textController,
//                       keyboardType: TextInputType.multiline,
//                       maxLines: null,
//                       onTap: () {
//                         // if (_showEmoji)
//                         //   setState(() => _showEmoji = !_showEmoji);
//                       },
//                       decoration: const InputDecoration(
//                           hintText: 'Type Something...',
//                           hintStyle: TextStyle(color: Colors.blueAccent),
//                           border: InputBorder.none),
//                       onChanged: (_) =>
//                           setState(() {}), // Trigger rebuild on text change
//                     ),
//                   ),
//
//                   IconButton(
//                     onPressed: () {
//                       //_showBottomSheet();
//                     },
//                     icon: const Icon(
//                       Icons.attach_file,
//                       color: Colors.blueAccent,
//                       size: 26,
//                     ),
//                   ),
//
//                   IconButton(
//                     onPressed: () async {
//                       // final ImagePicker picker = ImagePicker();
//                       // final XFile? image = await picker.pickImage(
//                       //     source: ImageSource.camera, imageQuality: 70);
//                       // if (image != null) {
//                       //   log('Image Path:${image.path}');
//                       //   setState(() => _isUploading = true);
//                       //   await APIs.sendChatImage(widget.user, File(image.path));
//                       //   setState(() => _isUploading = false);
//                       // }
//                     },
//                     icon: const Icon(Icons.camera_alt_rounded,
//                         color: Colors.blueAccent, size: 26),
//                   ),
//
//                   // Adding some space
//                   SizedBox(width: mq.width * .02),
//                 ],
//               ),
//             ),
//           ),
//
//
//           // Send message button
//           _textController.text.isEmpty
//               ? GestureDetector(
//             onLongPressStart: (_) {
//               // setState(() {
//               //   _isRecording = true;
//               //   // Start recording audio
//               //   // Start your recording logic here
//               //   startRecording();
//               // });
//             },
//             onLongPressEnd: (_) {
//               // setState(() {
//               //   _isRecording = false;
//               //   // Stop recording audio and send it
//               //   // Stop your recording logic here
//               //   stopRecording(widget.user);
//               //
//               //   // Send your recorded audio here
//               // });
//             },
//             child: _isRecording
//                 ? Container(
//               height: 60,
//               width: 60,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(50),
//                 color: Colors
//                     .redAccent, // Background color for the send button
//               ),
//               child: IconButton(
//                 onPressed: () {
//                   // This onPressed is for handling tap events during recording if needed
//                 },
//                 icon: Icon(
//                   Icons.square,
//                   color: Colors.white,
//                   size: 28,
//                 ),
//               ),
//             )
//                 : Container(
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(50),
//                 color: Colors
//                     .blueAccent, // Background color for the send button
//               ),
//               child: IconButton(
//                 onPressed: () {
//                   //showTemporaryMessage(context);
//                 },
//                 icon: Icon(
//                   Icons.mic,
//                   color: Colors.white,
//                   size: 28,
//                 ),
//               ),
//             ),
//           )
//               : Container(
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(50),
//               color: Colors.green, // Background color for the send button
//             ),
//             child: IconButton(
//               onPressed: () {
//                 // if (_textController.text.isNotEmpty) {
//                 //   APIs.sendMessage(
//                 //       widget.user, _textController.text, Type.text);
//                 //   _textController.text = '';
//                 // }
//               },
//               icon: const Icon(Icons.send, color: Colors.white, size: 28),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


/*import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/apis.dart';

class GroupMessage {
  final String senderId;
  final String message;
  final String? imageUrl;
  final Timestamp timestamp;

  GroupMessage({
    required this.senderId,
    required this.message,
    this.imageUrl,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'message': message,
      'imageUrl': imageUrl, // Include imageUrl in the map
      'timestamp': timestamp,
    };
  }
}

class GroupChatPage extends StatefulWidget {
  final String groupId;

  const GroupChatPage({Key? key, required this.groupId}) : super(key: key);

  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<List<GroupMessage>> _messagesStream;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _messagesStream = _firestore
        .collection('group_chats')
        .doc(widget.groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => GroupMessage(
      senderId: doc['senderId'],
      message: doc['message'],
      imageUrl: doc['imageUrl'], // Get imageUrl from Firestore
      timestamp: doc['timestamp'],
    ))
        .toList());
  }

  Future<void> _sendMessage(String message, {File? image}) async {
    try {
      String currentUserId = APIs.user.uid;
      if (image != null) {
        setState(() {
          _isUploading = true;
        });
        String? imageUrl = await APIs.uploadFile(image); // Upload image to Firebase Storage
        setState(() {
          _isUploading = false;
        });
        await _firestore
            .collection('group_chats')
            .doc(widget.groupId)
            .collection('messages')
            .add({
          'senderId': currentUserId,
          'message': message,
          'imageUrl': imageUrl, // Save imageUrl in Firestore
          'timestamp': Timestamp.now(),
        });
      } else {
        await _firestore
            .collection('group_chats')
            .doc(widget.groupId)
            .collection('messages')
            .add({
          'senderId': currentUserId,
          'message': message,
          'timestamp': Timestamp.now(),
        });
      }
      _textController.clear();
      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<GroupMessage>>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
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
                      subtitle: message.imageUrl != null
                          ? Image.network(message.imageUrl!)
                          : null,
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
                    decoration: InputDecoration(
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
}*/







import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../../api/apis.dart';

class GroupMessage {
  final String senderId;
  final String message;
  final String? imageUrl;
  final Timestamp timestamp;

  GroupMessage({
    required this.senderId,
    required this.message,
    this.imageUrl,
    required this.timestamp,
  });

  factory GroupMessage.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return GroupMessage(
      senderId: data['senderId'],
      message: data['message'],
      imageUrl: data['imageUrl'],
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'message': message,
      'imageUrl': imageUrl, // Include imageUrl in the map
      'timestamp': timestamp,
    };
  }
}

class GroupChatPage extends StatefulWidget {
  final String groupId;

  const GroupChatPage({Key? key, required this.groupId}) : super(key: key);

  @override
  _GroupChatPageState createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Stream<List<GroupMessage>> _messagesStream;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _messagesStream = _firestore
        .collection('group_chats')
        .doc(widget.groupId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => GroupMessage.fromFirestore(doc))
        .toList());
  }

  Future<void> _sendMessage(String message, {File? image}) async {
    try {
      String currentUserId = APIs.user.uid;
      if (image != null) {
        setState(() {
          _isUploading = true;
        });
        String? imageUrl =
        await APIs.uploadFile(image); // Upload image to Firebase Storage
        setState(() {
          _isUploading = false;
        });
        await _firestore
            .collection('group_chats')
            .doc(widget.groupId)
            .collection('messages')
            .add({
          'senderId': currentUserId,
          'message': message.isEmpty ? null : message,
          'imageUrl': imageUrl, // Save imageUrl in Firestore
          'timestamp': Timestamp.now(),
        });
      } else if (message.trim().isNotEmpty) {
        await _firestore
            .collection('group_chats')
            .doc(widget.groupId)
            .collection('messages')
            .add({
          'senderId': currentUserId,
          'message': message,
          'timestamp': Timestamp.now(),
        });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<GroupMessage>>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
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
                      subtitle: message.imageUrl != null
                          ? Image.network(message.imageUrl!)
                          : null,
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
                    decoration: InputDecoration(
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