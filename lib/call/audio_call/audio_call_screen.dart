// import 'package:chatterbox/chatter_box/utils/app_color_constant.dart';
// import 'package:flutter/material.dart';
// import 'package:agora_rtc_engine/rtc_engine.dart';
//
// class AudioCallScreen extends StatefulWidget {
//   final String callerName;
//   const AudioCallScreen({Key? key, required this.callerName}) : super(key: key);
//
//   @override
//   _AudioCallScreenState createState() => _AudioCallScreenState();
// }
//
// class _AudioCallScreenState extends State<AudioCallScreen> {
//   late final RtcEngine _engine;
//   bool _joined = false;
//   bool _muted = false;
//   bool _enableSpeakerphone = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initEngine();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _engine.destroy();
//   }
//
//   _initEngine() async {
//     _engine = await RtcEngine.createWithContext(
//         RtcEngineContext('d95680fe3a6b466c8a2b778d1a5e4a06'));
//     _addListeners();
//     await _engine.enableAudio();
//     setState(() {});
//     await _joinChannel();
//   }
//
//   void _addListeners() {
//     _engine.setEventHandler(
//       RtcEngineEventHandler(
//         joinChannelSuccess: (channel, uid, elapsed) {
//           setState(() {
//             _joined = true;
//           });
//         },
//         leaveChannel: (stats) {
//           setState(() {
//             _joined = false;
//           });
//         },
//         error: (errorCode) {
//           print('Error code: $errorCode');
//         },
//       ),
//     );
//   }
//
//   _joinChannel() async {
//     await _engine.joinChannel(
//         '007eJxTYFix5sGtms0lf34+ePbuNNtztsm/vwqv3/lJZjLvrbApc7IPKjCkWJqaWRikpRonmiWZmJklWyQaJZmbW6QYJpqmmiQamNXvYU9rCGRk+Cz8noERCkF8bgbnjMSSktQiBaf8CgYGAPgYJr0=',
//         'Chatter Box', null, 0);
//   }
//
//   void _endCall() async {
//     await _engine.leaveChannel();
//     Navigator.pop(context); // Navigate back to the previous screen
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   AppColorConstant.buttonColor,  AppColorConstant.buttonColor,
//                 ],
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Incoming Call',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 CircleAvatar(
//                   radius: 80,
//                   backgroundColor: Colors.white,
//                   child: Icon(
//                     Icons.person,
//                     size: 100,
//                     color: Colors.blue.shade800,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   widget.callerName, // Display caller's name
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   'Calling...',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                   ),
//                 ),
//                 Expanded(child: Container()),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         setState(() {
//                           _muted = !_muted;
//                         });
//                         _engine.muteLocalAudioStream(_muted);
//                       },
//                       icon: Icon(
//                         _muted ? Icons.mic_off : Icons.mic,
//                         color: Colors.white,
//                         size: 36,
//                       ),
//                     ),
//                     const SizedBox(width: 40),
//                     IconButton(
//                       onPressed: () {
//                         setState(() {
//                           _enableSpeakerphone = !_enableSpeakerphone;
//                         });
//                         _engine.setEnableSpeakerphone(_enableSpeakerphone);
//                       },
//                       icon: Icon(
//                         _enableSpeakerphone
//                             ? Icons.volume_off
//                             : Icons.volume_up,
//                         color: Colors.white,
//                         size: 36,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 FloatingActionButton(
//                   onPressed: _endCall,
//                   backgroundColor: Colors.red,
//                   child: const Icon(Icons.call_end),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//


//
// import 'package:chatterbox/chatter_box/utils/app_color_constant.dart';
// import 'package:flutter/material.dart';
// import 'package:agora_rtc_engine/rtc_engine.dart';
//
// class AudioCallScreen extends StatefulWidget {
//   final String callerName;
//   const AudioCallScreen({Key? key, required this.callerName}) : super(key: key);
//
//   @override
//   _AudioCallScreenState createState() => _AudioCallScreenState();
// }
//
// class _AudioCallScreenState extends State<AudioCallScreen> {
//   late final RtcEngine _engine;
//   bool _joined = false;
//   bool _muted = false;
//   bool _enableSpeakerphone = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initEngine();
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _engine.destroy();
//   }
//
//   _initEngine() async {
//     _engine = await RtcEngine.createWithContext(
//         RtcEngineContext('d95680fe3a6b466c8a2b778d1a5e4a06'));
//     _addListeners();
//     await _engine.enableAudio();
//     setState(() {});
//     await _joinChannel();
//   }
//
//   void _addListeners() {
//     _engine.setEventHandler(
//       RtcEngineEventHandler(
//         joinChannelSuccess: (channel, uid, elapsed) {
//           setState(() {
//             _joined = true;
//           });
//         },
//         leaveChannel: (stats) {
//           setState(() {
//             _joined = false;
//           });
//         },
//         error: (errorCode) {
//           print('Error code: $errorCode');
//         },
//       ),
//     );
//   }
//
//   _joinChannel() async {
//     await _engine.joinChannel(
//         '007eJxTYFix5sGtms0lf34+ePbuNNtztsm/vwqv3/lJZjLvrbApc7IPKjCkWJqaWRikpRonmiWZmJklWyQaJZmbW6QYJpqmmiQamNXvYU9rCGRk+Cz8noERCkF8bgbnjMSSktQiBaf8CgYGAPgYJr0=',
//         'Chatter Box', null, 0);
//   }
//
//   void _endCall() async {
//     await _engine.leaveChannel();
//     Navigator.pop(context); // Navigate back to the previous screen
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   AppColorConstant.buttonColor,  AppColorConstant.buttonColor,
//                 ],
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Incoming Call',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 CircleAvatar(
//                   radius: 80,
//                   backgroundColor: Colors.white,
//                   child: Icon(
//                     Icons.person,
//                     size: 100,
//                     color: Colors.blue.shade800,
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text(
//                   widget.callerName, // Display caller's name
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 const Text(
//                   'Calling...',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                   ),
//                 ),
//                 Expanded(child: Container()),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     IconButton(
//                       onPressed: () {
//                         setState(() {
//                           _muted = !_muted;
//                         });
//                         _engine.muteLocalAudioStream(_muted);
//                       },
//                       icon: Icon(
//                         _muted ? Icons.mic_off : Icons.mic,
//                         color: Colors.white,
//                         size: 36,
//                       ),
//                     ),
//                     const SizedBox(width: 40),
//                     IconButton(
//                       onPressed: () {
//                         setState(() {
//                           _enableSpeakerphone = !_enableSpeakerphone;
//                         });
//                         _engine.setEnableSpeakerphone(_enableSpeakerphone);
//                       },
//                       icon: Icon(
//                         _enableSpeakerphone
//                             ? Icons.volume_off
//                             : Icons.volume_up,
//                         color: Colors.white,
//                         size: 36,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 FloatingActionButton(
//                   onPressed: _endCall,
//                   backgroundColor: Colors.red,
//                   child: const Icon(Icons.call_end),
//                 ),
//                 const SizedBox(height: 20),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//}