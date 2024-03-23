// import 'dart:developer';
// import 'dart:io';
//
// import 'package:chatterbox/api/apis.dart';
// import 'package:chatterbox/main.dart';
// import 'package:chatterbox/screens/home_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
//
// import '../helper/dialogs.dart';
//
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   bool _isAnimate = false;
//
//   @override
//   void initState() {
//     Future.delayed(const Duration(milliseconds: 500), () {
//       setState(() {
//         _isAnimate = true;
//       });
//     });
//     super.initState();
//   }
//
//   _handleGoogleClick() {
//     Dialogs.showProgressBar(context);
//     _signInWithGoogle().then((user) async {
//
//       if (user != null) {
//         log('\nUser:${user.user}');
//         log('\nUserAdditionalInfo:${user.additionalUserInfo}');
//
//         if (await APIs.userExists(APIs.user)) {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (context) {
//                 return const HomeScreen();
//               }));
//         } else {
//           await APIs.createUser().then(
//                 (value) => {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) {
//                     return const HomeScreen();
//                   },
//                 ),
//               ),
//             },
//           );
//         }
//       }
//     });
//   }
//
//   Future<UserCredential?> _signInWithGoogle() async {
//     try {
//       await InternetAddress.lookup('google.com');
//       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//       final GoogleSignInAuthentication? googleAuth =
//       await googleUser?.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth?.accessToken,
//         idToken: googleAuth?.idToken,
//       );
//       return await APIs.auth.signInWithCredential(credential);
//     } catch (e) {
//       log("\n_signInWithGoogle:$e");
//       Dialogs.showSnackbar(context, 'Something went wrong(Check Internet!)');
//       print("Login");
//
//     }
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: const Text('Welcome to ChatterBox'),
//       ),
//       body: Stack(
//         children: [
//           AnimatedPositioned(
//             top: mq.height * .15,
//             right: _isAnimate ? mq.width * .25 : -mq.width * .5,
//             width: mq.width * .5,
//             duration: const Duration(seconds: 1),
//             child: Image.asset('assets/images/icon.png'),
//           ),
//           Positioned(
//             bottom: mq.height * .15,
//             left: mq.width * .05,
//             width: mq.width * .9,
//             height: mq.height * .06,
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.lightGreenAccent.shade100,
//                   shape: const StadiumBorder(),
//                   elevation: 1),
//               onPressed: () {
//                 _handleGoogleClick();
//               },
//               icon: Image.asset(
//                 'assets/images/google.png',
//                 height: mq.height * .02,
//               ),
//               label: RichText(
//                 text: const TextSpan(
//                   style: TextStyle(color: Colors.black, fontSize: 16),
//                   children: [
//                     TextSpan(text: 'Login with '),
//                     TextSpan(
//                       text: 'Google',
//                       style: TextStyle(fontWeight: FontWeight.w500),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
