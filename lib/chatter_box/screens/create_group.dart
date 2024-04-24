import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        title: const Text('Create group'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if(snapshot.data == null){
            return const Center(child: CircularProgressIndicator());
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
                  child: data?['image'] == null ? const Icon(Icons.account_circle) : null,
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
                trailing: selectedUserIDs.contains(document.id) ? const Icon(Icons.check) : null,
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: selectedUserIDs.isNotEmpty ? () => _createGroup(context) : null,
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



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';
//
// import '../../screens/home_screen.dart';
//
// class CreateGroup extends StatefulWidget {
//   final List<Map<String, dynamic>> membersList;
//
//   const CreateGroup({required this.membersList, Key? key}) : super(key: key);
//
//   @override
//   State<CreateGroup> createState() => _CreateGroupState();
// }
//
// class _CreateGroupState extends State<CreateGroup> {
//   final TextEditingController _groupName = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   bool isLoading = false;
//
//   void createGroup() async {
//     setState(() {
//       isLoading = true;
//     });
//
//     String groupId = Uuid().v1();
//
//     await _firestore.collection('groups').doc(groupId).set({
//       "members": widget.membersList,
//       "id": groupId,
//     });
//
//     for (int i = 0; i < widget.membersList.length; i++) {
//       String uid = widget.membersList[i]['uid'];
//
//       await _firestore
//           .collection('users')
//           .doc(uid)
//           .collection('groups')
//           .doc(groupId)
//           .set({
//         "name": _groupName.text,
//         "id": groupId,
//       });
//     }
//
//     await _firestore.collection('groups').doc(groupId).collection('chats').add({
//       "message": "${_auth.currentUser!.displayName} Created This Group.",
//       "type": "notify",
//     });
//
//     Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (_) => HomeScreen()), (route) => false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Group Name"),
//       ),
//       body: isLoading
//           ? Container(
//         height: size.height,
//         width: size.width,
//         alignment: Alignment.center,
//         child: CircularProgressIndicator(),
//       )
//           : Column(
//         children: [
//           SizedBox(
//             height: size.height / 10,
//           ),
//           Container(
//             height: size.height / 14,
//             width: size.width,
//             alignment: Alignment.center,
//             child: Container(
//               height: size.height / 14,
//               width: size.width / 1.15,
//               child: TextField(
//                 controller: _groupName,
//                 decoration: InputDecoration(
//                   hintText: "Enter Group Name",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: size.height / 50,
//           ),
//           ElevatedButton(
//             onPressed: createGroup,
//             child: Text("Create Group"),
//           ),
//         ],
//       ),
//     );
//   }
// }

