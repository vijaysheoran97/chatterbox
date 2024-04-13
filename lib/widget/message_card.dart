import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/public/tau.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

import '../api/apis.dart';
import '../helper/dialogs.dart';
import '../helper/my_date_util.dart';
import '../main.dart';
import '../models/chat_user_model.dart';
import '../models/message.dart';


class MessageCard extends StatefulWidget {
  const MessageCard({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  late bool isMe;
  late AudioPlayer audioPlayer;
  String audioPath = '';
  late bool isPlaying = false; // Track whether audio is playing

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
  }


  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _greenMessage() : _blueMessage(),
    );
  }

  Widget _blueMessage() {
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ||
                widget.message.type == Type.video || widget.message.type == Type.audio
                ? mq.width * .03
                : mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
              color: const Color.fromARGB(225, 221, 245, 255),
              border: Border.all(color: Colors.lightBlue),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: widget.message.type == Type.text
                ? Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            )
                : _buildMediaWidget(widget.message.msg),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
            MyDateUtil.getFormattedTime(
              context: context,
              time: widget.message.sent,
            ),
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaWidget(String mediaUrl) {
    if (widget.message.type == Type.image ) {
      return CachedNetworkImage(
        imageUrl: mediaUrl,
        placeholder: (context, url) => const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.error,
          size: 70,
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildMediaWidgetVideo(String mediaUrl) {
    if (widget.message.type == Type.video) {
      return AspectRatio(
        aspectRatio: 16 / 9, // Adjust aspect ratio as needed
        child: Chewie(
          controller: ChewieController(
            videoPlayerController: VideoPlayerController.network(
              mediaUrl,
            ),
            autoPlay: false,
            looping: false,
            placeholder: const Center(child: CircularProgressIndicator()),
            errorBuilder: (context, errorMessage) {
              return Center(
                child: Text(
                  'Error loading video: $errorMessage',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            },
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildMediaWidgetAudio(String mediaUrl) {
    if (widget.message.type == Type.audio) {
      return Row(
        children: [
          IconButton(
            onPressed: () {
              if (isPlaying) {
                audioPlayer.pause(); // Pause the audio
              } else {
                playRecording(widget.message.msg); // Start playing the audio
              }
            },
            icon: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 30,)), // Toggle icon based on playback state
          ),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              'Audio Message',
              // ': ${widget.message.msg ?? 'Audio URL not available'}',
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }


  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: mq.width * .04,
            ),
            _buildReadStatusIcon(),
            const SizedBox(
              width: 2,
            ),
            Text(
              MyDateUtil.getFormattedTime(context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
          ],
        ),

        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image ||
                widget.message.type == Type.video || widget.message.type == Type.audio
                ? mq.width * .03
                : mq.width * .04),
            margin: EdgeInsets.symmetric(
                horizontal: mq.width * .04, vertical: mq.height * .01),
            decoration: BoxDecoration(
              color: const Color.fromARGB(225, 218, 255, 176),
              border: Border.all(color: Colors.lightGreen),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: widget.message.type == Type.text
                ? Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            )
                : widget.message.type == Type.image
                ? _buildMediaWidget(widget.message.msg) : widget.message.type == Type.video ?
            _buildMediaWidgetVideo(widget.message.msg) : widget.message.type == Type.audio ?
            _buildMediaWidgetAudio(widget.message.msg)
                : Container(),
          ),
        ),
        // Flexible(
        //   child: Container(
        //     padding: EdgeInsets.all(widget.message.type == Type.image ? mq.width * .03 : mq.width * .04),
        //     margin: EdgeInsets.symmetric(horizontal: mq.width * .04, vertical: mq.height * .01),
        //     decoration: BoxDecoration(
        //       color: const Color.fromARGB(225, 218, 255, 176),
        //       border: Border.all(color: Colors.lightGreen),
        //       borderRadius: const BorderRadius.only(
        //         topLeft: Radius.circular(30),
        //         topRight: Radius.circular(30),
        //         bottomLeft: Radius.circular(30),
        //       ),
        //     ),
        //     child: _buildMessageContent(),
        //   ),
        // ),
      ],
    );
  }

  // Widget _buildMessageContent() {
  //   if (widget.message.type == Type.text) {
  //     return Text(
  //       widget.message.msg,
  //       style: const TextStyle(fontSize: 15, color: Colors.black87),
  //     );
  //   }  else if (widget.message.type == Type.audio) {
  //     return Row(
  //       children: [
  //         IconButton(
  //           onPressed: () {
  //             if (isPlaying) {
  //               audioPlayer.pause(); // Pause the audio
  //             } else {
  //               playRecording(widget.message.msg); // Start playing the audio
  //             }
  //           },
  //           icon: Container(
  //             height: 45,
  //             width: 45,
  //             decoration: BoxDecoration(
  //               color: Colors.black,
  //               borderRadius: BorderRadius.circular(50)
  //             ),
  //               child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 30,)), // Toggle icon based on playback state
  //         ),
  //         SizedBox(width: 8),
  //         Flexible(
  //           child: Text(
  //             'Audio Message',
  //                 // ': ${widget.message.msg ?? 'Audio URL not available'}',
  //             style: const TextStyle(fontSize: 15, color: Colors.black87),
  //           ),
  //         ),
  //       ],
  //     );
  //   } else {
  //     return ClipRRect(
  //       borderRadius: BorderRadius.circular(15),
  //       child: CachedNetworkImage(
  //         imageUrl: widget.message.msg,
  //         placeholder: (context, url) => Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: CircularProgressIndicator(
  //             strokeWidth: 2,
  //           ),
  //         ),
  //         errorWidget: (context, url, error) => const Icon(
  //           Icons.image,
  //           size: 70,
  //         ),
  //       ),
  //     );
  //   }
  // }


  void playRecording(String audioPath) async {
    try {
      final audioplayers.UrlSource urlSource = audioplayers.UrlSource(audioPath);
      await audioPlayer.play(urlSource);
    } catch (e) {
      print('Error playing recording : $e');
    }
  }

  Widget _buildReadStatusIcon() {
    if (widget.message.read.isNotEmpty) {
      return const Icon(
        Icons.done_all_rounded,
        color: Colors.blue,
        size: 20,
      );
    } else if (widget.message.sent.isNotEmpty) {
      return const Icon(
        Icons.done,
        color: Colors.grey,
        size: 20,
      );
    } else {
      return const Icon(
        Icons.error,
        color: Colors.red,
        size: 20,
      );
    }
  }

  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 4,
              margin: EdgeInsets.symmetric(
                vertical: mq.height * .015,
                horizontal: mq.width * .4,
              ),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            widget.message.type == Type.text
                ? _OptionItem(
              icon: const Icon(
                Icons.copy_all_rounded,
                color: Colors.blue,
                size: 26,
              ),
              name: 'Copy Text',
              onTap: () async {
                await Clipboard.setData(
                  ClipboardData(text: widget.message.msg),
                ).then((value) {
                  Navigator.pop(context);
                  Dialogs.showSnackbar(context, 'Text Copied!');
                });
              },
            )
                : _OptionItem(
              icon: const Icon(
                Icons.download_rounded,
                color: Colors.blue,
                size: 26,
              ),
              name: 'Save Image',
              onTap: () async {
                try {
                  log('Image Url: ${widget.message.msg}');
                  await GallerySaver.saveImage(
                    widget.message.msg,
                    albumName: 'Chatter Box',
                  ).then((success) {
                    Navigator.pop(context);
                    if (success != null && success) {
                      Dialogs.showSnackbar(
                        context,
                        'Image Successfully Saved!',
                      );
                    }
                  });
                } catch (e) {
                  log('ErrorWhileSavingImg: $e');
                }
              },
            ),
            if (isMe)
              Divider(
                color: Colors.black54,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),
            if (widget.message.type == Type.text && isMe)
              _OptionItem(
                icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                name: 'Edit Message',
                onTap: () {
                  Navigator.pop(context);
                  _showMessageUpdateDialog();
                },
              ),
            if (isMe)
              _OptionItem(
                icon: const Icon(Icons.delete_forever, color: Colors.red, size: 26),
                name: 'Delete Message',
                onTap: () async {
                  await APIs.deleteMessage(widget.message).then((value) {
                    Navigator.pop(context);
                  });
                },
              ),
            Divider(
              color: Colors.black54,
              endIndent: mq.width * .04,
              indent: mq.width * .04,
            ),
            _OptionItem(
              icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
              name: 'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
              onTap: () {},
            ),
            _OptionItem(
              icon: const Icon(Icons.remove_red_eye, color: Colors.green),
              name: widget.message.read.isEmpty
                  ? 'Read At: Not seen yet'
                  : 'Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        contentPadding: const EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(
              Icons.message,
              color: Colors.blue,
              size: 28,
            ),
            Text(' Update Message'),
          ],
        ),
        content: TextFormField(
          initialValue: updatedMsg,
          maxLines: null,
          onChanged: (value) => updatedMsg = value,
          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              APIs.updateMessage(widget.message, updatedMsg);
            },
            child: const Text(
              'Update',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem({required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(left: mq.width * .05, top: mq.height * .015, bottom: mq.height * .015),
        child: Row(
          children: [
            icon,
            Flexible(
              child: Text(
                '    $name',
                style: const TextStyle(fontSize: 15, letterSpacing: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

