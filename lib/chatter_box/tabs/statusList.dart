import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatusListPage extends StatefulWidget {
  const StatusListPage({super.key});

  @override
  State<StatusListPage> createState() => _StatusListPageState();
}

class _StatusListPageState extends State<StatusListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Status Tab Content'),
      ),
      floatingActionButton: FloatingActionButton.extended(onPressed: () {
        // Navigator.push(
        //   context,
        //   CupertinoPageRoute(builder: (context) => const NewMessagePage(title: Text('New Message'),)),
        // );
      },
        label: Icon(Icons.add_a_photo_outlined),),
    );
  }
}
