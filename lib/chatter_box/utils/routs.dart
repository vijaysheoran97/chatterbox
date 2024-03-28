// ignore_for_file: constant_identifier_names

import 'package:chatterbox/call/video_call/video_call_screen.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String SplashPage = "Splash Page";
  static const String HomePage = "Home Page";
  static const String CallPage = "Call Page";
}

Map<String, WidgetBuilder> routes = {
  AppRoutes.CallPage: (context) => const VideoCallScreen(calleeName: '',),
};
