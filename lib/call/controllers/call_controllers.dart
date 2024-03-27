import 'package:chatterbox/call/repositories/call_repositories.dart';
import 'package:chatterbox/models/call_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../providers/current_user_provider.dart';

final callControllerProvider = Provider<CallController>(
      (ref) {
    return CallController(
      callRepository: ref.read(callRepositoryProvider),
      ref: ref,
    );
  },
);

class CallController {
  CallController({
    required CallRepository callRepository,
    required ProviderRef ref,
  })  : _callRepository = callRepository,
        _ref = ref;

  final CallRepository _callRepository;
  final ProviderRef _ref;

  Stream<DocumentSnapshot> get callDocsSnapshotsStream {
    return _callRepository.callDocsSnapshotsStream;
  }

  Future<void> createCall(
      bool mounted,
      BuildContext context, {
        required String name,
        required String profilePic,
        required String receiverName,
        required String receiverId,
        required String receiverProfilePic,
        required bool isGroupChat,
      }) async {
    final String callId = const Uuid().v1();
    User user = _ref.read(currentUserProvider! as ProviderListenable<User>);

    final Call senderCall = Call(
      callerId: user.uid,
      callerName: name,
      callerPic: profilePic,
      receiverId: receiverId,
      receiverName: receiverName,
      receiverPic: receiverProfilePic,
      callId: callId,
      hasDialled: true,
    );

    // final Call receiverCall = Call(
    //   callerId: user.uid,
    //   callerName: name,
    //   callerPic: profilePic,
    //   receiverId: receiverId,
    //   receiverName: receiverName,
    //   receiverPic: receiverProfilePic,
    //   callId: callId,
    //   hasDialled: false,
    // );
    //
    // _callRepository.createCall(
    //   context,
    //   senderCall: senderCall,
    //   receiverCall: receiverCall,
    // );
  }
  //
  // Future<void> endCall(
  //     BuildContext context, {
  //       required String callerId,
  //       required String receiverId,
  //     }) async {
  //   _callRepository.endCall(
  //     context,
  //     callerId: callerId,
  //     receiverId: receiverId,
  //   );
  // }
}