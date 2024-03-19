import 'package:chatterbox/chatter_box/settings/settings.dart';
import 'package:chatterbox/chatter_box/settings/themes.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chatter_box/theme/dark_theme.dart';
import 'chatter_box/theme/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? selectedTheme = prefs.getString('selectedTheme');

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeManager(selectedTheme),
      child: MyApp(),
    ),
  );

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeManager.currentTheme,
          darkTheme: darkTheme,
          title: 'Q',
          home: SettingPage(),
        );
      },
    );
  }
}
