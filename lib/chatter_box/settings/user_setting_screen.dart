import 'package:chatterbox/models/chat_user_model.dart';
import 'package:flutter/material.dart';

class UserSettingsScreen extends StatefulWidget {
  final ChatUser user;

  const UserSettingsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text('Mute User',
                style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 18),),
              trailing: Switch(
                value: widget.user.isMuted,
                onChanged: (value) {
                  setState(() {
                    widget.user.isMuted = value;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: const  Text(
                'Block User',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              trailing:  Switch(
                value: widget.user.isBlocked,
                onChanged: (value) {
                  setState(() {
                    widget.user.isBlocked = value;
                  });
                },
              ),
            )

          ],
        ),
      ),
    );
  }
}