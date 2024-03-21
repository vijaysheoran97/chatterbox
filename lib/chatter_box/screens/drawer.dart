import 'package:chatterbox/chatter_box/settings/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  @override
  Widget build(BuildContext context) {
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
              // Add onTap handler for Item 2
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
          ListTile(
            leading: Icon(Icons.help_outline_outlined),
            title: Text('Help center'),
            onTap: () {
              // Add onTap handler for Item 2
            },
          ),
          ListTile(
            leading: Icon(Icons.change_circle_outlined),
            title: Text('Themes'),
            trailing: Icon(Icons.keyboard_arrow_down_outlined),
            onTap: () {
              // Add onTap handler for Item 2
            },
          ),
          // Add more ListTiles for additional drawer items
        ],
      ),
    );
  }
}
