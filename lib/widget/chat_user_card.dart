import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../api/apis.dart';
import '../helper/my_date_util.dart';
import '../main.dart';
import '../models/chat_user_model.dart';
import '../models/message.dart';
import '../screens/chat_screen.dart';
import 'dialog/profile_dialog.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;

  const ChatUserCard({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;
  bool _isProfessional = false;
  String? _groupName;

  @override
  void initState() {
    super.initState();
    fetchProfessionalStatus();
  }

  void fetchProfessionalStatus() async {
    final userData =
        await APIs.firestore.collection('users').doc(widget.user.id).get();
    setState(() {
      _isProfessional = userData['isProfessional'] ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: mq.width * .04,
        vertical: 4,
      ),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatScreen(
                user: widget.user,
              ),
            ),
          );
        },
        child: ListTile(
          leading: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => ProfileDialog(user: widget.user),
              );
            },
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .03),
                  child: CachedNetworkImage(
                    width: mq.height * .055,
                    height: mq.height * .055,
                    imageUrl: widget.user.image,
                    errorWidget: (context, url, error) => const CircleAvatar(
                      child: Icon(CupertinoIcons.person),
                    ),
                  ),
                ),
              ],
            ),
          ),
          title: Row(
            children: [
              Text(widget.user.name),
              if (_isProfessional)
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: Icon(
                    Icons.verified,
                    size: 16,
                    color: Colors.blue,
                  ),
                ),
            ],
          ),
          subtitle: Text(
            _message != null
                ? _message!.type == Type.image
                    ? 'image'
                    : _message!.msg
                : widget.user.about,
            maxLines: 1,
          ),
          trailing: _message == null
              ? null
              : _message!.read.isEmpty && _message!.fromId != APIs.user.uid
                  ? Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                  : Text(
                      MyDateUtil.getLastMessageTime(
                        context: context,
                        time: _message!.sent,
                      ),
                      style: const TextStyle(),
                    ),
        ),
      ),
    );
  }
}
