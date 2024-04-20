// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../screens/newMessage.dart';
//
// class CallListPage extends StatefulWidget {
//   const CallListPage({super.key});
//
//   @override
//   State<CallListPage> createState() => _CallListPageState();
// }
//
// class _CallListPageState extends State<CallListPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text('Calls Tab Content'),
//       ),
//       floatingActionButton: FloatingActionButton.extended(onPressed: () {
//         // Navigator.push(
//         //   context,
//         //   CupertinoPageRoute(builder: (context) => const NewMessagePage(title: Text('New Message'),)),
//         // );
//       },
//         label: Icon(Icons.add_ic_call_outlined),),
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/newMessage.dart';

class CallListPage extends StatefulWidget {
  const CallListPage({super.key});

  @override
  State<CallListPage> createState() => _CallListPageState();
}

class _CallListPageState extends State<CallListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Calls Tab Content'),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {
        // Navigator.push(
        //   context,
        //   CupertinoPageRoute(builder: (context) => const NewMessagePage(title: Text('New Message'),)),
        // );
      },
        label: Icon(Icons.add_ic_call_outlined),),
    );
  }
}