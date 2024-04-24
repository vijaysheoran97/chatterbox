// import 'dart:developer';
// import 'dart:io';
// import 'package:chatterbox/screens/splash_screen.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:chatterbox/chatter_box/provider/auth_provider.dart';
// import 'package:chatterbox/chatter_box/service/auth_service.dart';
// import 'package:chatterbox/chatter_box/utils/storage_halper.dart';
// import 'package:chatterbox/firebase_options.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'chatter_box/theme/dark_theme.dart';
// import 'chatter_box/theme/theme_manager.dart';
//
// late Size mq;
//
// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   HttpOverrides.global = MyHttpOverrides();
//   SystemChrome.setPreferredOrientations(
//           [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
//       .then((value) {
//     _initializeFirebase();
//     runApp(const MyApp());
//   });
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   String? selectedTheme = prefs.getString('selectedTheme');
//   // var result = await FlutterNotificationChannel.registerNotificationChannel(
//   //     description: 'For Showing Message Notification',
//   //     id: 'chats',
//   //     importance: NotificationImportance.IMPORTANCE_HIGH,
//   //     name: 'Chats');
//  // log('\nNotification Channel Result: $result');
//   runApp(
//     ChangeNotifierProvider(
//       create: (context) => ThemeManager(selectedTheme),
//       child: const MyApp(),
//     ),
//   );
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     Get.put(AuthService());
//     Get.put(StorageHalper());
//     AuthProvider userProvider = AuthProvider();
//     userProvider.loadLoginStatus();
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (context) {
//           return userProvider;
//         })
//       ],
//       child: Consumer<ThemeManager>(
//         builder: (context, themeManager, child) {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             theme: themeManager.currentTheme,
//             darkTheme: darkTheme,
//             title: 'ChatterBox',
//             home: const SplashScreen(),
//           );
//         },
//       ),
//     );
//   }
// }
//
//
// _initializeFirebase() async {
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
// }

import 'dart:developer';
import 'dart:io';
import 'package:chatterbox/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:chatterbox/chatter_box/provider/auth_provider.dart';
import 'package:chatterbox/chatter_box/service/auth_service.dart';
import 'package:chatterbox/chatter_box/utils/storage_halper.dart';
import 'package:chatterbox/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chatter_box/settings/language_settings.dart';
import 'chatter_box/theme/dark_theme.dart';
import 'chatter_box/theme/theme_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:chatterbox/providers/language_change_controller.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;


late Size mq;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations(

      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    log('Failed to initialize Firebase: $e');
  }

  SharedPreferences prefs;
  try {
    prefs = await SharedPreferences.getInstance();
  } catch (e) {
    log('Failed to initialize SharedPreferences: $e');
    return; // Return to prevent runApp from executing if SharedPreferences initialization fails
  }


  var result = await FlutterNotificationChannel.registerNotificationChannel(
      description: 'For Showing Message Notification',
      id: 'chats',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'Chats');
  log('\nNotification Channel Result: $result');

  String? selectedTheme = prefs.getString('selectedTheme');
  LanguageChangeController languageController = LanguageChangeController();
  await languageController.loadSelectedLanguage(); // Load selected language
  Language selectedLanguage = languageController.appLocale == Locale('en') ? Language.english : Language.hindi;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => languageController),
        FutureProvider<SharedPreferences?>(
          create: (_) => SharedPreferences.getInstance(),
          initialData: null, // initialData can be null or anything you want as default
        ),
      ],
      child: Builder(
        builder: (context) {
          return ChangeNotifierProvider.value(
            value: ThemeManager(selectedTheme),
            child: MyApp(selectedLanguage: selectedLanguage, prefs: prefs),
          );
        },
      ),
    ),
  );

}

Language _getSelectedLanguage(SharedPreferences prefs) {
  final languageIndex = prefs.getInt('languageIndex') ?? 0; // Default to English if not found
  return Language.values[languageIndex];

}

class MyApp extends StatelessWidget {
  final Language selectedLanguage;
  final SharedPreferences prefs;

  const MyApp({Key? key, required this.selectedLanguage, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AuthService());
    Get.put(StorageHalper());
    AuthProvider userProvider = AuthProvider();
    userProvider.loadLoginStatus();

    return MultiProvider(
      providers: [

        ChangeNotifierProvider(create: (_) => userProvider),
        ChangeNotifierProvider(create: (_) => LanguageChangeController())
      ],
      child: Consumer3<ThemeManager, LanguageChangeController, SharedPreferences?>(
        builder: (context, themeManager, languageController, sharedPreferences, child) {
          return Consumer<LanguageChangeController>(
            builder: (context, languageController, _) {
              Locale appLocale;
              if (languageController.appLocale != null) {
                appLocale = languageController.appLocale!;
              } else {
                if (selectedLanguage == Language.english) {
                  appLocale = Locale('en');
                } else {
                  appLocale = Locale('hi');
                }
              }

              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: themeManager.currentTheme,
                darkTheme: darkTheme,
                title: 'CINLINE',
                locale: appLocale,
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate
                ],
                supportedLocales: [
                  Locale('en'),
                  Locale('hi')
                ],
                home: const SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }
}

