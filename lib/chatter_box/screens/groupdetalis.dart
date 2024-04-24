import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupDetailsPage extends StatefulWidget {
  final String groupId;

  const GroupDetailsPage({Key? key, required this.groupId}) : super(key: key);

  @override
  State<GroupDetailsPage> createState() => _GroupDetailsPageState();
}

class _GroupDetailsPageState extends State<GroupDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('groups')
            .doc(widget.groupId)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Group not found'));
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          // Extract the list of member IDs and admin ID from the group data
          List<dynamic> memberIds = data['members'];
          String adminId = data['admin'];

          return ListView.builder(
            itemCount: memberIds.length,
            itemBuilder: (BuildContext context, int index) {
              // Fetch member details from Firestore using the member ID
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(memberIds[index])
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(); // Return empty SizedBox while loading
                  }

                  if (snapshot.hasError ||
                      !snapshot.hasData ||
                      !snapshot.data!.exists) {
                    return const Text('Member not found');
                  }

                  Map<String, dynamic> memberData =
                      snapshot.data!.data() as Map<String, dynamic>;

                  // Display "You" in the title if the current member is the logged-in user
                  String titleText =
                      memberIds[index] == FirebaseAuth.instance.currentUser?.uid
                          ? 'You'
                          : memberData['name'] as String;

                  // Display "Admin" in the trailing if the current member is the admin
                  Widget? trailing = adminId == memberIds[index]
                      ? const Text(
                          'Admin',
                          style: TextStyle(
                              color: Colors
                                  .green), // Customize the style as needed
                        )
                      : null;

                  // Display member details in a ListTile
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: memberData['image'] != null
                          ? NetworkImage(memberData['image'] as String)
                          : null,
                      child: memberData['image'] == null
                          ? const Icon(Icons.account_circle)
                          : null,
                    ),
                    title: Text(titleText),
                    subtitle: Text(memberData['email'] as String),
                    trailing: trailing,
                    // Add more member details here if needed
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
