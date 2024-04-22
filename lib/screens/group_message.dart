import 'dart:developer';
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

import '../api/apis.dart';
import '../main.dart';
import 'groupdetails.dart';

class GroupMessagePage extends StatefulWidget {
  final String groupId;

  const GroupMessagePage({Key? key, required this.groupId}) : super(key: key);

  @override
  State<GroupMessagePage> createState() => _GroupMessagePageState();
}

class _GroupMessagePageState extends State<GroupMessagePage> {
  String groupName = '';
  final _textController = TextEditingController();
  bool _showEmoji = false,
      _isUploading = false;
  bool _isRecording = false;// Store the group name


  @override
  void initState() {
    super.initState();
    fetchGroupData(); // Fetch group data when the widget initializes
  }

  Future<void> fetchGroupData() async {
    try {
      // Retrieve the group document from Firestore using the groupId
      DocumentSnapshot groupSnapshot =
      await FirebaseFirestore.instance.collection('groups').doc(widget.groupId).get();

      if (groupSnapshot.exists) {
        // If the document exists, extract the group name
        Map<String, dynamic>? data = groupSnapshot.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>
        setState(() {
          groupName = data?['name'] ?? ''; // Update the groupName
        });
      } else {
        // Handle case where the group document doesn't exist
        print('Group document does not exist');
      }
    } catch (error) {
      // Handle any errors that occur during the process
      print('Error retrieving group document: $error');

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 35,
        title: InkWell(
          onTap: () {
            // Navigate to the GroupDetailPage when tapped on the title
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupDetailsPage(groupId: widget.groupId),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(child: Icon(Icons.group_outlined)),
              SizedBox(width: 5),
              Text(groupName, style: TextStyle()),
            ],
          ),
        ),

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _chatInput(),
        ],
      ),
    );
  }


  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  // Emoji button
                  IconButton(
                    onPressed: () {
                      // FocusScope.of(context).unfocus();
                      // setState(() => _showEmoji = !_showEmoji);
                    },
                    icon: const Icon(Icons.emoji_emotions,
                        color: Colors.blueAccent, size: 25),
                  ),

                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        // if (_showEmoji)
                        //   setState(() => _showEmoji = !_showEmoji);
                      },
                      decoration: const InputDecoration(
                          hintText: 'Type Something...',
                          hintStyle: TextStyle(color: Colors.blueAccent),
                          border: InputBorder.none),
                      onChanged: (_) =>
                          setState(() {}), // Trigger rebuild on text change
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      //_showBottomSheet();
                    },
                    icon: const Icon(
                      Icons.attach_file,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),

                  IconButton(
                    onPressed: () async {
                      // final ImagePicker picker = ImagePicker();
                      // final XFile? image = await picker.pickImage(
                      //     source: ImageSource.camera, imageQuality: 70);
                      // if (image != null) {
                      //   log('Image Path:${image.path}');
                      //   setState(() => _isUploading = true);
                      //   await APIs.sendChatImage(widget.user, File(image.path));
                      //   setState(() => _isUploading = false);
                      // }
                    },
                    icon: const Icon(Icons.camera_alt_rounded,
                        color: Colors.blueAccent, size: 26),
                  ),

                  // Adding some space
                  SizedBox(width: mq.width * .02),
                ],
              ),
            ),
          ),


          // Send message button
          _textController.text.isEmpty
              ? GestureDetector(
            onLongPressStart: (_) {
              // setState(() {
              //   _isRecording = true;
              //   // Start recording audio
              //   // Start your recording logic here
              //   startRecording();
              // });
            },
            onLongPressEnd: (_) {
              // setState(() {
              //   _isRecording = false;
              //   // Stop recording audio and send it
              //   // Stop your recording logic here
              //   stopRecording(widget.user);
              //
              //   // Send your recorded audio here
              // });
            },
            child: _isRecording
                ? Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors
                    .redAccent, // Background color for the send button
              ),
              child: IconButton(
                onPressed: () {
                  // This onPressed is for handling tap events during recording if needed
                },
                icon: Icon(
                  Icons.square,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            )
                : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors
                    .blueAccent, // Background color for the send button
              ),
              child: IconButton(
                onPressed: () {
                  //showTemporaryMessage(context);
                },
                icon: Icon(
                  Icons.mic,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          )
              : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.green, // Background color for the send button
            ),
            child: IconButton(
              onPressed: () {
                // if (_textController.text.isNotEmpty) {
                //   APIs.sendMessage(
                //       widget.user, _textController.text, Type.text);
                //   _textController.text = '';
                // }
              },
              icon: const Icon(Icons.send, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
}

