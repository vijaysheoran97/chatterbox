import 'dart:developer';

import 'package:chatterbox/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:chatterbox/chatter_box/provider/auth_provider.dart';
import 'package:chatterbox/chatter_box/service/auth_service.dart';
import 'package:chatterbox/chatter_box/utils/storage_halper.dart';
import 'package:chatterbox/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chatterbox/chatter_box/auth/login_screen.dart';
import 'package:chatterbox/chatter_box/screens/homeScreen.dart';
import 'package:chatterbox/chatter_box/settings/settings.dart';
import 'package:chatterbox/chatter_box/settings/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chatter_box/theme/dark_theme.dart';
import 'chatter_box/theme/theme_manager.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? selectedTheme = prefs.getString('selectedTheme');

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeManager(selectedTheme),
      child: const MyApp(),
    ),
  );


import 'firebase_options.dart';

late Size mq;


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // SystemChrome.setPreferredOrientations(
  //         [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
  //     .then((value) {
  //   _initializeFirebase();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var result = await FlutterNotificationChannel.registerNotificationChannel(
      description: 'For Showing Message Notification',
      id: 'chats',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'Chats');
  log('\nNotification Channel Result: $result');
  runApp(const MyApp());
  // }
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  Get.put(AuthService());
  Get.put(StorageHalper());
  AuthProvider userProvider =AuthProvider();
  userProvider.loadLoginStatus();
    return MaterialApp(
      title: 'Public Chats',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 1,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 19,
          ),
          backgroundColor: Colors.white,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}