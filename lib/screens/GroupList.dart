import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'group_message.dart';

class GroupListPage extends StatelessWidget {
  final String currentUserID;

  const GroupListPage({Key? key, required this.currentUserID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('groups').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final List<DocumentSnapshot> groupDocs = snapshot.data!.docs;

          // Filter groups where the currentUserID is in the 'members' array
          final List<DocumentSnapshot> userGroups = groupDocs.where((groupDoc) {
            final List<dynamic> members = groupDoc['members'] ?? [];
            return members.contains(currentUserID);
          }).toList();

          return ListView.builder(
            itemCount: userGroups.length,
            itemBuilder: (BuildContext context, int index) {
              final DocumentSnapshot groupDoc = userGroups[index];
              final String groupId = groupDoc.id;
              final Map<String, dynamic> data = groupDoc.data() as Map<String, dynamic>;
              final Timestamp createdAt = data['createdAt'] as Timestamp;

              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupMessagePage(groupId: groupId),
                    ),
                  );
                },
                leading: CircleAvatar(child: Icon(Icons.group_outlined)),
                title: Text('${data['name']}', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Created at - ${_formatDateTime(createdAt)}'),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDateTime(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    String formattedDateTime = '${dateTime.day}/${dateTime.month}/${dateTime.year}  ${dateTime.hour}:${dateTime.minute}';
    return formattedDateTime;
  }
}

