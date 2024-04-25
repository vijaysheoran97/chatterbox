import 'package:chatterbox/chatter_box/provider/user_chat_provider.dart';
import 'package:chatterbox/models/chat_user_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class UserSettingsScreen extends StatefulWidget {
  final ChatUser user;

  const UserSettingsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  late UserChatProvider userChatProvider;

  @override
  void initState() {
    super.initState();
    userChatProvider = Provider.of<UserChatProvider>(context,listen: false);
  }
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
              trailing: Switch(
                value: widget.user.isBlocked,
                onChanged: (value) async {
                  setState(() {
                    widget.user.isBlocked = value;
                  });
                  if (value) {
                    await _blockUser();
                  } else {
                    await _unblockUser();
                  }
                },
              ),
            )

          ],
        ),
      ),
    );
  }
  Future<void> _blockUser() async {
    try {
       userChatProvider.blockUser(widget.user.id, '');
      Fluttertoast.showToast(
        msg: 'User Blocked',
        fontSize: 18,
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'User Error: $error',
        fontSize: 18,
      );
      setState(() {
        widget.user.isBlocked = !widget.user.isBlocked;
      });
    }
  }

   Future<void> _unblockUser() async {
    try {
       userChatProvider.unblockUser(widget.user.id, '');
      Fluttertoast.showToast(
        msg: 'User unblock',
        fontSize: 18,
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: 'User Error $error',
        fontSize: 18,
      );
      setState(() {
        widget.user.isBlocked = !widget.user.isBlocked;
      });
    }
  }
}