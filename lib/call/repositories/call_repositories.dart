import 'package:chatterbox/chatter_box/utils/app_string_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/current_user_provider.dart';
import '../screens/call_screen.dart';

final callRepositoryProvider = Provider<CallRepository>((ref) {
  return CallRepository(FirebaseFirestore.instance, ref);
});

class CallRepository {
  CallRepository(
      FirebaseFirestore firestore,
      ProviderRef ref,
      )   : _firestore = firestore,
        _ref = ref;
  final FirebaseFirestore _firestore;
  final ProviderRef _ref;

  Stream<DocumentSnapshot> get callDocsSnapshotsStream {
    return _firestore
       // .collection(AppStringConstant.callsCollection)
        .doc(_ref.read(currentUserProvider as ProviderListenable).uid) // Access user ID directly
        .snapshots();
  }

  //
  // Future<void> createCall(
  //     BuildContext context, {
  //       required Call senderCall,
  //       required Call receiverCall,
  //     }) async {
  //   await _firestore
  //       .collection(AppStringConstant.callsCollection)
  //       .doc(senderCall.callerId)
  //       .set(senderCall.toMap());
  //
  //   await _firestore
  //       .collection(AppStringConstant.callsCollection)
  //       .doc(receiverCall.receiverId)
  //       .set(receiverCall.toMap());

    // ignore: use_build_context_synchronously
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => CallScreen(
  //         channelId: senderCall.callId,
  //         call: senderCall,
  //         isGroupChat: false,
  //       ),
  //     ),
  //   );
  // }

  // Future<void> endCall(
  //     BuildContext context, {
  //       required String callerId,
  //       required String receiverId,
  //     }) async {
  //   await _firestore
  //       .collection(AppStringConstant.callsCollection)
  //       .doc(callerId)
  //       .delete();
  //
  //   await _firestore
  //       .collection(AppStringConstant.callsCollection)
  //       .doc(receiverId)
  //       .delete();
   //}
}