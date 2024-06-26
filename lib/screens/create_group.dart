import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({Key? key}) : super(key: key);

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  late String currentUserID = ''; // Initialize with an empty string
  List<String> selectedUserIDs = []; // List to store selected user IDs
  final TextEditingController _groupNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser(); // Retrieve current user's ID when the widget initializes
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
        title: Text(AppLocalizations.of(context)!.createGroup),

      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if(snapshot.data == null){
            return Center(child: const CircularProgressIndicator());
          }

          // Filter out documents without a 'name' field
          final filteredDocs = snapshot.data!.docs.where((doc) =>
          (doc.data() as Map<String, dynamic>).containsKey('name') && doc.id != currentUserID);

          return ListView(
            children: filteredDocs.map((DocumentSnapshot document) {
              Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

              // If the username field is null or missing, provide a default value
              String username = data?['name'] ?? 'No Username';

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: data?['image'] != null
                      ? NetworkImage(data?['image'] as String)
                      : null, // Set to null if profile image URL is null
                  child: data?['image'] == null ? Icon(Icons.account_circle) : null,
                ),
                title: Text(username),
                subtitle: Text(data?['email'] as String? ?? 'No Email'), // Display email address or a default value if it's null
                onTap: () {
                  // Add or remove user from the selected list
                  setState(() {
                    final userID = document.id;
                    if (selectedUserIDs.contains(userID)) {
                      selectedUserIDs.remove(userID);
                    } else {
                      selectedUserIDs.add(userID);
                    }
                  });
                },
                // Set a different background color for selected users
                tileColor: selectedUserIDs.contains(document.id) ? Colors.blue.withOpacity(0.2) : null,
                // Show select icon in the trailing when a user is selected
                trailing: selectedUserIDs.contains(document.id) ? Icon(Icons.check) : null,
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: selectedUserIDs.isNotEmpty ? () => _createGroup(context) : null,
        child: Icon(Icons.check),
      ),
    );
  }

  void _createGroup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.createGroup),
          content: TextField(
            controller: _groupNameController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.enterGroupName,

            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                _addGroupToFirestore();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.add),

            ),
          ],
        );
      },
    );
  }

  void _addGroupToFirestore() {
    final CollectionReference groupsCollection = FirebaseFirestore.instance.collection('groups');

    // Include the current user's ID in the selectedUserIDs list
    selectedUserIDs.add(currentUserID);

    groupsCollection.add({
      'name': _groupNameController.text.trim(),
      'members': selectedUserIDs,
      'admin': currentUserID, // Make the current user the admin
      'createdAt': Timestamp.now(),
    }).then((DocumentReference groupDoc) {
      String groupId = groupDoc.id; // Extract the group ID from the DocumentReference

      // Update the current user's document with the group ID
      FirebaseFirestore.instance.collection('users').doc(currentUserID).update({
        'groupIds': FieldValue.arrayUnion([groupId]), // Add the group ID to the user's list of group IDs
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

