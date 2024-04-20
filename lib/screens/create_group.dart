import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  late String currentUserID = '';
  List<String> selectedUserIDs = [];
  final TextEditingController _groupNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserID = user.uid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create group'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredDocs = snapshot.data!.docs.where((doc) =>
              (doc.data() as Map<String, dynamic>).containsKey('name') &&
              doc.id != currentUserID);

          return ListView(
            children: filteredDocs.map((DocumentSnapshot document) {
              Map<String, dynamic>? data =
                  document.data() as Map<String, dynamic>?;

              String username = data?['name'] ?? 'No Username';

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: data?['image'] != null
                      ? NetworkImage(data?['image'] as String)
                      : null,
                  child: data?['image'] == null
                      ? const Icon(Icons.account_circle)
                      : null,
                ),
                title: Text(username),
                subtitle: Text(data?['email'] as String? ?? 'No Email'),
                onTap: () {
                  setState(() {
                    final userID = document.id;
                    if (selectedUserIDs.contains(userID)) {
                      selectedUserIDs.remove(userID);
                    } else {
                      selectedUserIDs.add(userID);
                    }
                  });
                },
                tileColor: selectedUserIDs.contains(document.id)
                    ? Colors.blue.withOpacity(0.2)
                    : null,
                trailing: selectedUserIDs.contains(document.id)
                    ? const Icon(Icons.check)
                    : null,
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            selectedUserIDs.isNotEmpty ? () => _createGroup(context) : null,
        child: const Icon(Icons.check),
      ),
    );
  }

  void _createGroup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create Group'),
          content: TextField(
            controller: _groupNameController,
            decoration: const InputDecoration(
              hintText: 'Enter group name',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addGroupToFirestore();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _addGroupToFirestore() {
    final CollectionReference groupsCollection =
        FirebaseFirestore.instance.collection('groups');

    selectedUserIDs.add(currentUserID);

    groupsCollection.add({
      'name': _groupNameController.text.trim(),
      'members': selectedUserIDs,
      'admin': currentUserID,
      'createdAt': Timestamp.now(),
    }).then((DocumentReference groupDoc) {
      String groupId = groupDoc.id;

      FirebaseFirestore.instance.collection('users').doc(currentUserID).update({
        'groupIds': FieldValue.arrayUnion([groupId]),
      }).then((_) {
        print('Group created successfully! Group ID: $groupId');
      }).catchError((error) {
        print('Failed to update user document with group ID: $error');
      });
    }).catchError((error) {
      print('Failed to create group: $error');
    });
  }
}
