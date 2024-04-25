import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserChatProvider with ChangeNotifier {
  // Block a user
  void blockUser(String blockedUserId, String currentUserId) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(currentUserId)
        .set({'blockedUserId': blockedUserId}).then((_) async {
      notifyListeners();
    });
  }

  // Unblock a user
  void unblockUser(String blockedUserId, String currentUserId) async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(currentUserId)
        .delete()
        .then((_) async {
      notifyListeners();
    });
  }
}