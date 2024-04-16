// import 'dart:async';
// import 'package:chatterbox/chatter_box/utils/app_color_constant.dart';
// import 'package:chatterbox/chatter_box/utils/app_string_constant.dart';
// import 'package:flutter/material.dart';
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
//
// class VideoCallScreen extends StatefulWidget {
//   final String calleeName;
//
//   const VideoCallScreen({Key? key, required this.calleeName}) : super(key: key);
//
//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }
//
// class _VideoCallScreenState extends State<VideoCallScreen> {
//   Object? image;
//   int? _remoteUid;
//   RtcEngine? _engine;
//   bool _localUserJoined = false;
//
//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//   }
//
//   Future<void> initAgora() async {
//     await [Permission.microphone, Permission.camera].request();
//
//     _engine = await RtcEngine.create(AppStringConstant.appId);
//
//     _engine?.setEventHandler(
//       RtcEngineEventHandler(
//         joinChannelSuccess: (String channel, int uid, int elapsed) {
//           print("local user $uid joined channel$channel elapsed$elapsed");
//           setState(() {
//             _localUserJoined = true;
//           });
//         },
//         userJoined: (int uid, int elapsed) {
//           print("remote user $uid joined");
//           setState(() {
//             _remoteUid = uid;
//           });
//         },
//         userOffline: (int uid, UserOfflineReason reason) {
//           print("remote user $uid left channel");
//           setState(() {
//             _remoteUid = null;
//             _engine?.disableVideo();
//             _engine?.disableAudio();
//             _engine?.leaveChannel();
//           });
//           Navigator.pop(context);
//         },
//       ),
//     );
//     await _engine?.enableVideo();
//     await _engine?.enableAudio();
//     await _engine?.joinChannel(
//         AppStringConstant.appToken, AppStringConstant.appChannelName, null, 0);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     image = ModalRoute.of(context)?.settings.arguments;
//     double radius = 24;
//     print("_remoteUid:::$_remoteUid");
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             _remoteUid == null
//                 ? Container(
//                     height: MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                       image: NetworkImage(image.toString()),
//                       fit: BoxFit.fill,
//                     )),
//                   )
//                 : Container(
//                     height: MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     child: Center(child: _remoteVideo())),
//             Positioned(
//               right: 0,
//               top: 0,
//               left: 0,
//               bottom: 0,
//               child: Stack(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 10, horizontal: 16),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.pop(context);
//                               },
//                               child: const Icon(
//                                 Icons.arrow_back_outlined,
//                                 size: 30,
//                               ),
//                             ),
//                             Text(
//                               widget.calleeName,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 20,
//                                 color: AppColorConstant.black,
//                               ),
//                             ),
//                             Card(
//                               shape: const RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(360))),
//                               child: CircleAvatar(
//                                 radius: radius,
//                                 backgroundColor: Colors.white,
//                                 child: GestureDetector(
//                                   onTap: () {},
//                                   child: const Icon(
//                                     Icons.person_add,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Expanded(child: Container()),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             vertical: 4,
//                             horizontal: MediaQuery.of(context).size.width / 10),
//                         child: Card(
//                           shape: const RoundedRectangleBorder(
//                               side: BorderSide(color: Colors.grey),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(360))),
//                           child: CircleAvatar(
//                             radius: radius,
//                             backgroundColor: Colors.white,
//                             child: GestureDetector(
//                               onTap: () {
//                                 setState(
//                                   () {
//                                     _engine?.disableAudio();
//                                   },
//                                 );
//                               },
//                               child: const Icon(
//                                 Icons.keyboard_voice_outlined,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Card(
//                               shape: const RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(360))),
//                               child: CircleAvatar(
//                                 radius: radius,
//                                 backgroundColor: Colors.white,
//                                 child: GestureDetector(
//                                   onTap: () async {
//                                     setState(() {});
//                                   },
//                                   child: const Icon(
//                                     Icons.message,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             CircleAvatar(
//                               radius: 36,
//                               backgroundColor: Colors.white,
//                               child: GestureDetector(
//                                 onTap: () {
//                                   Navigator.pop(context);
//                                   _engine?.leaveChannel();
//                                 },
//                                 child: const Card(
//                                   color: Colors.red,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(360))),
//                                   child: Padding(
//                                     padding: EdgeInsets.all(20),
//                                     child: Icon(
//                                       Icons.call_end_outlined,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Card(
//                               shape: const RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(360))),
//                               child: CircleAvatar(
//                                 radius: radius,
//                                 backgroundColor: Colors.white,
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       _engine?.switchCamera();
//                                     });
//                                   },
//                                   child: const Icon(
//                                     Icons.swap_horiz_outlined,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                   Positioned(
//                       right: 20,
//                       bottom: 80,
//                       child: Container(
//                         height: MediaQuery.of(context).size.width / 2.5,
//                         width: MediaQuery.of(context).size.width / 3,
//                         decoration: BoxDecoration(
//                             image: DecorationImage(
//                               image: NetworkImage(image.toString()),
//                               fit: BoxFit.fill,
//                             ),
//                             color: Colors.black,
//                             border: Border.all(color: Colors.black)),
//                         child: Center(
//                           child: _localUserJoined
//                               ? const RtcLocalView.SurfaceView()
//                               : const CircularProgressIndicator(),
//                         ),
//                       )),
//                   // Positioned(
//                   //     right: 20,
//                   //     bottom: MediaQuery.of(context).size.width / 2.5 + 80,
//                   //     child: Container(
//                   //       height: MediaQuery.of(context).size.width / 2.5,
//                   //       width: MediaQuery.of(context).size.width / 3,
//                   //       decoration: BoxDecoration(
//                   //           color: Colors.black,
//                   //           border: Border.all(color: Constant.primaryColor)),
//                   //       child: _remoteVideo(),
//                   //     )),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget? _remoteVideo() {
//     print("_remoteUid:$_remoteUid");
//
//     if (_remoteUid != null) {
//       setState(() {});
//       return RtcRemoteView.SurfaceView(
//         uid: _remoteUid!,
//         channelId: AppStringConstant.appChannelName,
//       );
//     }
//     setState(() {});
//     return null;
//   }
//
//   @override
//   void dispose() {
//     _engine?.destroy();
//     _engine?.disableLastmileTest();
//     _engine?.leaveChannel();
//     _engine?.disableAudio();
//     _engine?.disableVideo();
//     super.dispose();
//   }
// }



// import 'package:chatterbox/api/apis.dart';
// import 'package:chatterbox/models/message.dart';
// import 'package:flutter/material.dart';
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
//
// class VideoCallScreen extends StatefulWidget {
//   final String calleeName;
//   String callToken;
//   final Messages messages;
//
//
//   VideoCallScreen({Key? key, required this.calleeName, required this.callToken, required this.messages})
//       : super(key: key);
//
//   @override
//   State<VideoCallScreen> createState() => _VideoCallScreenState();
// }
//
// class _VideoCallScreenState extends State<VideoCallScreen> {
//   Object? image;
//   int? _remoteUid;
//   RtcEngine? _engine;
//   bool _localUserJoined = false;
//
//   @override
//   void initState() {
//     super.initState();
//     initAgora();
//   }
//
//   Future<void> initAgora() async {
//     await [Permission.microphone, Permission.camera].request();
//
//     _engine = await RtcEngine.create('d95680fe3a6b466c8a2b778d1a5e4a06');
//
//     _engine?.setEventHandler(
//       RtcEngineEventHandler(
//         joinChannelSuccess: (String channel, int uid, int elapsed) {
//           setState(() {
//             _localUserJoined = true;
//           });
//         },
//         userJoined: (int uid, int elapsed) {
//           print("remote user $uid joined");
//           setState(() {
//             _remoteUid = uid;
//           });
//         },
//         userOffline: (int uid, UserOfflineReason reason) {
//           print("remote user $uid left channel");
//           setState(() {
//             _remoteUid = null;
//             _engine?.disableVideo();
//             _engine?.disableAudio();
//             _engine?.leaveChannel();
//           });
//           // Corrected call to deleteToken method
//           // Assuming `Messages` class is defined elsewhere
//
//
//           // Messages messages =
//           //     Messages(toId: '', token: '', read: '', fromId: '', sent: '');
//           // APIs.deleteToken(messages);
//           // Navigator.pop(context);
//         },
//       ),
//     );
//
//     await _engine?.enableVideo();
//     await _engine?.enableAudio();
//     await _engine?.joinChannel(widget.callToken, 'Chatter Box', null, 0);
//   }
//
//   Future<void> handleTokenExpiration() async {
//     String newToken = await getNewToken();
//
//     if (newToken.isNotEmpty) {
//       setState(() {
//         widget.callToken = newToken;
//       });
//
//       await _engine?.joinChannel(widget.callToken, 'Chatter Box', null, 0);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Token expired. Call cannot be continued.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//
//       Navigator.pop(context);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     image = ModalRoute.of(context)?.settings.arguments;
//     double radius = 24;
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(
//           children: [
//             _remoteUid == null
//                 ? Container(
//                     height: MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                       image: NetworkImage(image.toString()),
//                       fit: BoxFit.fill,
//                     )),
//                   )
//                 : Container(
//                     height: MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     child: Center(child: _remoteVideo())),
//             Positioned(
//               right: 0,
//               top: 0,
//               left: 0,
//               bottom: 0,
//               child: Stack(
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 10, horizontal: 16),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             GestureDetector(
//                               onTap: () {
//                                 Navigator.pop(context);
//                               },
//                               child: const Icon(
//                                 Icons.arrow_back_outlined,
//                                 size: 30,
//                               ),
//                             ),
//                             Text(
//                               widget.calleeName,
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 20,
//                                 color: Colors.black,
//                               ),
//                             ),
//                             Card(
//                               shape: const RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(360))),
//                               child: CircleAvatar(
//                                 radius: radius,
//                                 backgroundColor: Colors.white,
//                                 child: GestureDetector(
//                                   onTap: () {},
//                                   child: const Icon(
//                                     Icons.person_add,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Expanded(child: Container()),
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             vertical: 4,
//                             horizontal: MediaQuery.of(context).size.width / 10),
//                         child: Card(
//                           shape: const RoundedRectangleBorder(
//                               side: BorderSide(color: Colors.grey),
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(360))),
//                           child: CircleAvatar(
//                             radius: radius,
//                             backgroundColor: Colors.white,
//                             child: GestureDetector(
//                               onTap: () {
//                                 setState(
//                                   () {
//                                     _engine?.disableAudio();
//                                   },
//                                 );
//                               },
//                               child: const Icon(
//                                 Icons.keyboard_voice_outlined,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Padding(
//                         padding: const EdgeInsets.all(10),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Card(
//                               shape: const RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(360))),
//                               child: CircleAvatar(
//                                 radius: radius,
//                                 backgroundColor: Colors.white,
//                                 child: GestureDetector(
//                                   onTap: () async {
//                                     setState(() {});
//                                   },
//                                   child: const Icon(
//                                     Icons.message,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             CircleAvatar(
//                               radius: 36,
//                               backgroundColor: Colors.white,
//                               child: GestureDetector(
//                                 onTap: () async {
//                                   // await APIs.deleteToken(listToken.first);
//                                   await APIs.deleteToken(widget.messages);
//                                   Navigator.pop(context);
//                                   _engine?.leaveChannel();
//                                 },
//                                 child: const Card(
//                                   color: Colors.red,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(360))),
//                                   child: Padding(
//                                     padding: EdgeInsets.all(20),
//                                     child: Icon(
//                                       Icons.call_end_outlined,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Card(
//                               shape: const RoundedRectangleBorder(
//                                   borderRadius:
//                                       BorderRadius.all(Radius.circular(360))),
//                               child: CircleAvatar(
//                                 radius: radius,
//                                 backgroundColor: Colors.white,
//                                 child: GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       _engine?.switchCamera();
//                                     });
//                                   },
//                                   child: const Icon(
//                                     Icons.swap_horiz_outlined,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                   Positioned(
//                       right: 20,
//                       bottom: 80,
//                       child: Container(
//                         height: MediaQuery.of(context).size.width / 2.5,
//                         width: MediaQuery.of(context).size.width / 3,
//                         decoration: BoxDecoration(
//                             image: DecorationImage(
//                               image: NetworkImage(image.toString()),
//                               fit: BoxFit.fill,
//                             ),
//                             color: Colors.black,
//                             border: Border.all(color: Colors.black)),
//                         child: Center(
//                           child: _localUserJoined
//                               ? const RtcLocalView.SurfaceView()
//                               : const CircularProgressIndicator(),
//                         ),
//                       )),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget? _remoteVideo() {
//     if (_remoteUid != null) {
//       return RtcRemoteView.SurfaceView(
//         uid: _remoteUid!,
//         channelId: 'Chatter Box',
//       );
//     }
//     return null;
//   }
//
//   @override
//   void dispose() {
//     _engine?.destroy();
//     _engine?.disableLastmileTest();
//     _engine?.leaveChannel();
//     _engine?.disableAudio();
//     _engine?.disableVideo();
//     super.dispose();
//   }
//
//   Future<String> getNewToken() async {
//     return 'Your New Token';
//   }
// }
//
