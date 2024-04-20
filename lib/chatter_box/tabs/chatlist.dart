// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../screens/newMessage.dart';
//
// class ChatListPage extends StatefulWidget {
//   const ChatListPage({super.key});
//
//   @override
//   State<ChatListPage> createState() => _ChatListPageState();
// }
//
// class _ChatListPageState extends State<ChatListPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text('Chats Tab Content'),
//       ),
//       floatingActionButton: FloatingActionButton.extended(onPressed: () {
//         Navigator.push(
//           context,
//           CupertinoPageRoute(builder: (context) => const NewMessagePage(title: Text('New Message'),)),
//         );
//       },
//         label: Icon(Icons.add_comment_sharp),),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/newMessage.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Chats Tab Content'),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => const NewMessagePage(title: Text('New Message'),)),
        );
      },
        label: Icon(Icons.add_comment_sharp),),
    );
  }
}