import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/chat_user_model.dart';

class ViewProfileScreen extends StatelessWidget {
  final ChatUser user;


  const ViewProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mq = MediaQuery.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(user.name),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.size.width * .05),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: mq.size.height * .03),
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.size.height * .1),
                  child: Image.network(
                    user.image,
                    width: mq.size.height * .2,
                    height: mq.size.height * .2,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                    const CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
                  ),
                ),
                SizedBox(height: mq.size.height * .03),
                Text(
                  'Email: ${user.email}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: mq.size.height * .02),
                Text(
                  'About: ${user.about}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: mq.size.height * .02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(
                            text:
                            'Name: ${user.name}\nEmail: ${user.email}\nAbout: ${user.about}'));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                            Text('Contact details copied to clipboard'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.content_copy),
                      label: const Text('Copy Contact'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}






