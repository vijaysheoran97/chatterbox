import 'package:chatterbox/chatter_box/settings/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          'Settings',
          style: TextStyle(
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.tertiary
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Your account'),
              subtitle: Text('See information about your account and learn about your account deactivation options.',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
            ),
            SizedBox(height: 10,),

            ListTile(
              leading: Icon(Icons.lock_outlined),
              title: Text('Security and account access'),
              subtitle: Text("Manage your account's security and keep track of your account's usages, including apps that you have connected to your account.",
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),)
            ),
            SizedBox(height: 10,),

            ListTile(
              leading: Icon(Icons.workspace_premium_outlined),
              title: Text('Premium'),
              subtitle: Text("See what's included in Premium and manage your settings.",
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
            ),
            SizedBox(height: 10,),
            ListTile(
              leading: Icon(Icons.privacy_tip_outlined),
              title: Text('Privacy and safety'),
              subtitle: Text("Manage what information you see and share on Q to others.",
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
            ),
            SizedBox(height: 10,),
            ListTile(
              leading: Icon(Icons.notifications_active_outlined),
              title: Text('Notifications'),
              subtitle: Text("Select the kinds of nitification you get about your activities, interests and recommendations.",
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
            ),
            SizedBox(height: 10,),
            ListTile(
              leading: Icon(Icons.language_outlined),
              title: Text('Languages'),
              subtitle: Text("Choose languages as per your preferences and compatibility",
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
            ),

            SizedBox(height: 10,),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const ThemesPage()),
                );
              },
              leading: Icon(Icons.light_mode_outlined),
              title: Text('Themes'),
              subtitle: Text("Choose themes as per your preferences and compatibility",
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
            ),

            SizedBox(height: 10,),
            ListTile(
              leading: Icon(Icons.help_outline_outlined),
              title: Text('Help centre'),
              subtitle: Text("Get answer to some common questions related to Q and get 24*7 assistance.",
                style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
            )
          ],
        ),
      ),
    );
  }
}