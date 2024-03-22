import 'package:chatterbox/chatter_box/auth/login_screen.dart';
import 'package:chatterbox/chatter_box/screens/newMessage.dart';
import 'package:chatterbox/chatter_box/settings/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/dark_theme.dart';
import '../theme/light_theme.dart';
import '../theme/theme_manager.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  late String _selectedMode = 'light'; // Initialize with default value
  bool _showThemeOptions =
      false; // Added to control whether to show theme options

  @override
  void initState() {
    super.initState();
    _loadThemePreference(); // Load theme preference when the widget initializes
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMode = prefs.getString('selectedTheme') ?? 'light';
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: false);

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.group_outlined),
            title: Text('New Group'),
            onTap: () {
              // Add onTap handler for Item 1
            },
          ),
          ListTile(
            leading: Icon(Icons.person_outline_rounded),
            title: Text('Contacts'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => const NewMessagePage(
                          title: Text('Contacts'),
                        )),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.bookmark_border_outlined),
            title: Text('Saved'),
            onTap: () {
              // Add onTap handler for Item 2
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const SettingPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.monetization_on_outlined),
            title: Text('Monetisation'),
            onTap: () {
              // Add onTap handler for Item 2
            },
          ),

          Divider(
            color: Colors.grey.shade300,
          ),
          ListTile(
            leading: Icon(Icons.change_circle_outlined),
            title: Text('Themes'),
            trailing: Icon(_showThemeOptions
                ? Icons.keyboard_arrow_up_outlined
                : Icons.keyboard_arrow_down_outlined),
            onTap: () {
              setState(() {
                _showThemeOptions = !_showThemeOptions;
              });
            },
          ),
          if (_showThemeOptions) ...[
            RadioListTile(
              title: const Text('Light Theme'),
              value: 'light',
              groupValue: _selectedMode,
              onChanged: (value) {
                setState(() {
                  _selectedMode = value!;
                });
                themeManager.setTheme(lightTheme);
                _saveThemePreference('light');
                Navigator.pop(context);
              },
              activeColor: Colors.blue,
            ),
            RadioListTile(
              title: const Text('Dark Theme'),
              value: 'dark',
              groupValue: _selectedMode,
              onChanged: (value) {
                setState(() {
                  _selectedMode = value!;
                });
                themeManager.setTheme(darkTheme);
                _saveThemePreference('dark');
                Navigator.pop(context);
              },
              activeColor: Colors.blue,
            ),
          ],

          ListTile(
            leading: Icon(Icons.help_outline_outlined),
            title: Text('Help center'),
            onTap: () {
              // Add onTap handler for Item 2
            },
          ),
          ListTile(
            leading: Icon(
              Icons.logout_outlined,
              color: Colors.red,
            ),
            title: Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
          ),
          // Add more ListTiles for additional drawer items
        ],
      ),
    );
  }

  Future<void> _saveThemePreference(String theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedTheme', theme);
    } catch (e) {
      print('Error saving theme preference: $e');
    }
  }
}
