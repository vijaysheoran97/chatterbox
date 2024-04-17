import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../api/apis.dart';
import '../../models/chat_user_model.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StatusListPage extends StatefulWidget {
  final ChatUser user;
  const StatusListPage({Key? key, required this.user}) : super(key: key);

  @override
  State<StatusListPage> createState() => _StatusListPageState();
}

class _StatusListPageState extends State<StatusListPage> {
  final TextEditingController _statusController = TextEditingController();


  bool _isProfessional = false;

  @override
  void initState() {
    super.initState();
    // Fetch user's professional status from Firebase
    fetchProfessionalStatus();
  }

  void fetchProfessionalStatus() async {
    final userData = await APIs.firestore.collection('users').doc(widget.user.id).get();
    if (userData.exists) {
      setState(() {
        _isProfessional = userData.data()?['isProfessional'] ?? false;
      });
    } else {
      // Handle the case where the document doesn't exist or "isProfessional" field is missing
      print('User data not found or isProfessional field missing');
    }
  }




  void uploadStatus(BuildContext context) {
    String statusText = _statusController.text;
    User? user = FirebaseAuth.instance.currentUser; // Get the current user
    if (user != null) {
      // If user is authenticated
      FirebaseFirestore.instance.collection('statuses').add({
        'text': statusText,
        'timestamp': DateTime.now(),
        'userId': user.uid, // Include the user ID
      }).then((_) {
        // Status uploaded successfully
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Status uploaded successfully!'),
        ));
        _statusController.clear();
        Navigator.pop(
            context); // Close the bottom sheet after status is uploaded
      }).catchError((error) {
        // Error uploading status
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to upload status: $error'),
        ));
      });
    } else {
      // If user is not authenticated
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User not authenticated.'),
      ));
    }
  }

  void _deleteStatus(DocumentSnapshot status) {
    // Get the ID of the status document
    String statusId = status.id;

    // Check if the status belongs to the current user
    String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    String statusUserId = status['userId'];

    if (currentUserId == statusUserId) {
      // If the status belongs to the current user, delete it
      FirebaseFirestore.instance.collection('statuses').doc(statusId).delete()
          .then((value) {
        // Status deleted successfully
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Status deleted successfully!'),
        ));
      })
          .catchError((error) {
        // Error deleting status
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to delete status: $error'),
        ));
      });
    } else {
      // If the status doesn't belong to the current user, show an error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You can only delete your own status.'),
      ));
    }
  }


  // Method to show the text field in a bottom sheet
  void _showTextFieldBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      // Ensure the bottom sheet takes full screen height
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom,
          ),
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(AppLocalizations.of(context)!.toUploadStatus,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        maxLength: 50,
                        controller: _statusController,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context)!.enterStatus),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        uploadStatus(context);
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .tertiary
                          ),
                          child: Icon(Icons.send, size: 20, color: Theme
                              .of(context)
                              .colorScheme
                              .onTertiary,)),
                    )
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('statuses')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: const CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  final currentUser = FirebaseAuth.instance.currentUser;
                  final List<DocumentSnapshot> currentUserStatuses = [];
                  final List<DocumentSnapshot> otherUserStatuses = [];

                  snapshot.data!.docs.forEach((status) {
                    if (status['userId'] == currentUser?.uid) {
                      currentUserStatuses.add(status);
                    } else {
                      otherUserStatuses.add(status);
                    }
                  });

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (currentUserStatuses.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.yourstatus,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: currentUserStatuses.length,
                              itemBuilder: (context, index) {
                                var status = currentUserStatuses[index];
                                // Retrieve the profile image URL of the current user
                                String? profileImageUrl = FirebaseAuth.instance
                                    .currentUser?.photoURL;
                                return _buildStatusTile(
                                    status, currentUser!.displayName ?? '',
                                    profileImageUrl);
                              },
                            ),
                          ],
                        ),
                      if (otherUserStatuses.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.otherstatus,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(height: 8),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: otherUserStatuses.length,
                              itemBuilder: (context, index) {
                                var status = otherUserStatuses[index];
                                return FutureBuilder(
                                  future: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(status['userId'])
                                      .get(),
                                  builder: (context, AsyncSnapshot<
                                      DocumentSnapshot> userSnapshot) {
                                    if (userSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return ListTile(
                                        title: Center(child: CircularProgressIndicator()),
                                      );
                                    }
                                    if (userSnapshot.hasError) {
                                      return ListTile(
                                        title: Text('Error loading user data'),
                                      );
                                    }

                                    var userData = userSnapshot.data!;
                                    return _buildStatusTile(status,
                                        userData['name'] ?? 'Unknown User',
                                        userData['image']);
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // FloatingActionButton.small(onPressed: () {}, child: Icon(Icons.camera_alt_outlined),) ,
          SizedBox(height: 8,),
          FloatingActionButton.extended(
            onPressed: () {
              _showTextFieldBottomSheet(context); // Pass the function reference
            },
            label: Icon(Icons.edit_outlined),
          ),
        ],
      ),

    );
  }

  Widget _buildStatusTile(DocumentSnapshot status, String userName, String? profileImageUrl) {
    final currentUser = FirebaseAuth.instance.currentUser;

    // Check if the current user ID matches the user ID of the status
    final bool isCurrentUserStatus = currentUser != null && currentUser.uid == status['userId'];

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.status),
                  if (isCurrentUserStatus) // Show delete icon only for the current user's status
                    IconButton(
                      onPressed: () {
                        _deleteStatus(status);
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                    )
                ],
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    status['text'],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${AppLocalizations.of(context)!.postedby}: $userName',
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${AppLocalizations.of(context)!.date}: ${_formatDate(status['timestamp'])}',
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  ),
                  Text(
                    '${AppLocalizations.of(context)!.time}: ${_formatTime(status['timestamp'])}',
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              ),
              actions: [
                SizedBox(width: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: profileImageUrl != null ? NetworkImage(profileImageUrl) : null,
          child: profileImageUrl == null ? Icon(Icons.account_circle) : null,
        ),
        title: Row(
          children: [
            Text(userName),
            FutureBuilder(
              future: FirebaseFirestore.instance.collection('users').doc(status['userId']).get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(); // Return an empty widget while loading
                }
                if (snapshot.hasError || !snapshot.data!.exists) {
                  return SizedBox(); // Return an empty widget if user document not found
                }
                final userData = snapshot.data!.data() as Map<String, dynamic>?; // Cast userData to Map<String, dynamic>?
                final bool isProfessional = userData?['isProfessional'] ?? false;

                if (isProfessional) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: Icon(
                      Icons.verified,
                      size: 16,
                      color: Colors.blue,
                    ),
                  );
                } else {
                  return SizedBox(); // Return an empty widget if user is not professional
                }
              },
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              status['text'],
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          ],
        ),
      ),
    );
  }



  String _formatDate(Timestamp timestamp) {
    // Convert Firestore Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();
    // Format the date as desired (e.g., "yyyy-MM-dd")
    return '${dateTime.year}-${_addLeadingZero(
        dateTime.month)}-${_addLeadingZero(dateTime.day)}';
  }

  String _formatTime(Timestamp timestamp) {
    // Convert Firestore Timestamp to DateTime
    DateTime dateTime = timestamp.toDate();
    // Format the time as desired (e.g., "HH:mm")
    return '${_addLeadingZero(dateTime.hour)}:${_addLeadingZero(
        dateTime.minute)}';
  }

  String _addLeadingZero(int value) {
    return value < 10 ? '0$value' : '$value';
  }
}