import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart' as audioplayers;
// import 'package:agora_uikit/agora_uikit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatterbox/chatter_box/settings/user_setting_screen.dart';
import 'package:chatterbox/screens/view_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
//import 'package:contacts_service/contacts_service.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../api/apis.dart';
import '../helper/my_date_util.dart';
import '../main.dart';
import '../models/chat_user_model.dart';
import '../models/message.dart';
import '../widget/message_card.dart';
import 'package:record/record.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseStorage storage = FirebaseStorage.instance;

  List<Message> _list = [];
  List<Messages> listToken = [];
  final _textController = TextEditingController();
  bool _showEmoji = false, _isUploading = false;
   bool _isRecording = false;
  late Record audioRecord;
  late AudioPlayer audioPlayer;
  String audioPath = '';

    @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioRecord = Record();
    super.initState();
  }

  @override
  void dispose() {
    audioRecord.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      if (await audioRecord.hasPermission()) {
        await audioRecord.start();
        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      print('Error Start Recording : $e');
    }
  }

  Future<void> stopRecording(ChatUser chatUser) async {
    try {
      String? path = await audioRecord.stop();
      setState(() {
        _isRecording = false;
        audioPath = path!;
      });

      if (audioPath.isNotEmpty) {
        String fileName = '${DateTime.now().millisecondsSinceEpoch}.mp3';

        Reference ref = FirebaseStorage.instance.ref().child('audio/$fileName');

        await ref.putFile(File(audioPath));

        String audioUrl = await ref.getDownloadURL();

        String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
        Message audioMessage = Message(
          toId: chatUser.id,
          audioUrl: audioUrl,
          type: Type.audio,
          msg: '',
          read: '',
          fromId: userId,
          sent: DateTime.now().millisecondsSinceEpoch.toString(), senderName: '',
        );

        await APIs.sendMessage(chatUser, audioUrl, Type.audio);
      }
    } catch (e) {
      print('Error stop recording : $e');
    }
  }

  Future<void> playRecording() async {
    try {
      final audioplayers.UrlSource urlSource =
      audioplayers.UrlSource(audioPath);
      await audioPlayer.play(urlSource);
    } catch (e) {
      print('Error playing recording : $e');
    }
  }

  void showTemporaryMessage(BuildContext context) {
    final RenderBox buttonBox = context.findRenderObject() as RenderBox;
    final buttonPosition = buttonBox.localToGlobal(Offset.zero);

    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom:
        MediaQuery.of(context).viewInsets.bottom + 60,
        left: 60,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            alignment: Alignment.bottomRight,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 0,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Text(
                  'Hold to record, release to send',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(overlayEntry);

    Future.delayed(const Duration(milliseconds: 1500), () {
      overlayEntry.remove();
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (_showEmoji) {
              setState(() {
                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();

                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;

                          _list = data
                              ?.map((e) => Message.fromJson(e.data()))
                              .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,
                              itemCount: _list.length,
                              padding: EdgeInsets.only(top: mq.height * .01),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MessageCard(
                                  message: _list[index],
                                );
                              },
                            );
                          } else {
                            return const Center(
                              child: Text(
                                'Say Hii! 👋',
                                style: TextStyle(fontSize: 20),
                              ),
                            );
                          }
                      }
                    },
                  ),
                ),
                if (_isUploading)
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                _chatInput(),
                if (_showEmoji)
                  SizedBox(
                    height: mq.height * .34,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: Config(
                        bgColor: const Color.fromARGB(255, 234, 248, 255),
                        columns: 8,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0), //
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ViewProfileScreen(user: widget.user),
          ),
        );
      },
      child: StreamBuilder(
        stream: APIs.getUserInfo(widget.user),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;
          final list =
              data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

          return AppBar(
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            title: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * .03),
                  child: CachedNetworkImage(
                    width: mq.height * .05,
                    height: mq.height * .05,
                    imageUrl:
                    list.isNotEmpty ? list[0].image : widget.user.image,
                    errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list.isNotEmpty ? list[0].name : widget.user.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      list.isNotEmpty
                          ? list[0].isOnline
                          ? 'Online'
                          : MyDateUtil.getLastActiveTime(
                          context: context,
                          lastActive: list[0].lastActive)
                          : MyDateUtil.getLastActiveTime(
                          context: context,
                          lastActive: widget.user.lastActive),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              // StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              //   stream: APIs.getToken(widget.user),
              //   builder: (context, snapshot) {
              //     switch (snapshot.connectionState) {
              //       case ConnectionState.waiting:
              //       case ConnectionState.none:
              //         return const SizedBox();
              //
              //       case ConnectionState.active:
              //       case ConnectionState.done:
              //         final data = snapshot.data?.docs;
              //
              //         listToken = data
              //             ?.map((e) => Messages.fromJson(e.data()))
              //             .toList() ??
              //             [];
              //
              //         if (listToken.isNotEmpty) {
              //           print(
              //               "${listToken[0].token}00000000000000000000000000000000000000000000000");
              //           final firstMessage = listToken.first;
              //           if (firstMessage != null) {
              //             return IconButton(
              //               onPressed: () {
              //                 // Navigator.push(
              //                 //   context,
              //                 //   MaterialPageRoute(
              //                 //     builder: (context) => VideoCallScreen(
              //                 //       calleeName: '',
              //                 //       callToken: firstMessage.token,
              //                 //       messages: firstMessage,
              //                 //     ),
              //                 //   ),
              //                 // );
              //               },
              //               icon: const Icon(Icons.call),
              //             );
              //           } else {
              //             print("First message is null");
              //             return const SizedBox();
              //           }
              //         } else {
              //           print("listToken is empty");
              //           return const SizedBox();
              //         }
              //     }
              //   },
              // ),
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: APIs.getToken(widget.user), // Use getAllToken stream
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      return const SizedBox();

                    case ConnectionState.active:
                    case ConnectionState.done:
                      final data = snapshot.data?.docs;

                      listToken = data
                          ?.map((e) => Messages.fromJson(e.data()))
                          .toList() ??
                          [];
                      if (listToken.isNotEmpty) {
                        print(
                            "${listToken[0].token}00000000000000000000000000000000000000000000000");
                      } else {
                        print("listToken is empty");
                      }

                      return IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    onTap: () async {
                                      await APIs.sendToken(widget.user,
                                          "007eJxTYJBgstH4oDD72pXlgd8zk07fF5xx49U2OY5t3anqHkJTkiwUGFIsTc0sDNJSjRPNkkzMzJItEo2SzM0tUgwTTVNNEg3MlCz40hoCGRmmpCxlZGSAQBCfm8E5I7GkJLVIwSm/goEBAM8GIA8=");
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => VideoCallScreen(
                                      //       calleeName: '',
                                      //       callToken: listToken.isNotEmpty
                                      //           ? listToken[0].token
                                      //           : '',
                                      //       messages: listToken.first,
                                      //     ),
                                      //   ),
                                      // );
                                    },
                                    leading: const Icon(Icons.videocam),
                                    title: const Text('Video Call'),
                                  ),
                                  ListTile(
                                    onTap: () async {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) =>
                                      //         const AudioCallScreen(
                                      //       callerName: '',
                                      //     ),
                                      //   ),
                                      // );
                                    },
                                    leading: const Icon(Icons.call),
                                    title: const Text('Voice Call'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.add_ic_call_outlined),
                      );
                  }
                },
              ),
          PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'view_contact') {
                    viewContact(context);
                  } else if (value == 'setting') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserSettingsScreen(user: widget.user),
                      ),
                    );
                  }
                  // else if (value == 'block_user') {
                  //   blockUser();
                  // }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'view_contact',
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('View Contact'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'setting',
                    child: ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Setting'),
                    ),
                  ),
                ],
                icon: const Icon(Icons.more_vert),
              ),
            ],
          );
        },
      ),
    );
  }


  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  // Emoji button
                  IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      setState(() => _showEmoji = !_showEmoji);
                    },
                    icon: const Icon(Icons.emoji_emotions,
                        color: Colors.blueAccent, size: 25),
                  ),

                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      onTap: () {
                        if (_showEmoji)
                          setState(() => _showEmoji = !_showEmoji);
                      },
                      decoration: const InputDecoration(
                          hintText: 'Type Something...',
                          hintStyle: TextStyle(color: Colors.blueAccent),
                          border: InputBorder.none),
                      onChanged: (_) =>
                          setState(() {}),
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      _showBottomSheet();
                    },
                    icon: const Icon(
                      Icons.attach_file,
                      color: Colors.blueAccent,
                      size: 26,
                    ),
                  ),

                  IconButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                          source: ImageSource.camera, imageQuality: 70);
                      if (image != null) {
                        log('Image Path:${image.path}');
                        setState(() => _isUploading = true);
                        await APIs.sendChatImage(widget.user, File(image.path));
                        setState(() => _isUploading = false);
                      }
                    },
                    icon: const Icon(Icons.camera_alt_rounded,
                        color: Colors.blueAccent, size: 26),
                  ),

                  // Adding some space
                  SizedBox(width: mq.width * .02),
                ],
              ),
            ),
          ),

          _textController.text.isEmpty
              ? GestureDetector(
            onLongPressStart: (_) {
              setState(() {
                _isRecording = true;
                startRecording();
              });
            },
            onLongPressEnd: (_) {
              setState(() {
                _isRecording = false;
                stopRecording(widget.user);
              });
            },
            child: _isRecording
                ? Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.redAccent,
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.square,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            )
                : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.blueAccent,
              ),
              child: IconButton(
                onPressed: () {
                  showTemporaryMessage(context);
                },
                icon: const Icon(
                  Icons.mic,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          )
              : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.green, // Background color for the send button
            ),
            child: IconButton(
              onPressed: () {
                if (_textController.text.isNotEmpty) {
                  APIs.sendMessage(
                      widget.user, _textController.text, Type.text);
                  _textController.text = '';
                }
              },
              icon: const Icon(Icons.send, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }
  // Widget _chatInput() {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(
  //         vertical: mq.height * .01, horizontal: mq.width * .025),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: Card(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(15),
  //             ),
  //             child: Row(
  //               children: [
  //                 //emoji button
  //                 IconButton(
  //                   onPressed: () {
  //                     FocusScope.of(context).unfocus();
  //                     setState(() => _showEmoji = !_showEmoji);
  //                   },
  //                   icon: const Icon(Icons.emoji_emotions,
  //                       color: Colors.blueAccent, size: 25),
  //                 ),
  //
  //                 Expanded(
  //                     child: TextField(
  //                       controller: _textController,
  //                       keyboardType: TextInputType.multiline,
  //                       maxLines: null,
  //                       onTap: () {
  //                         if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
  //                       },
  //                       decoration: const InputDecoration(
  //                           hintText: 'Type Something...',
  //                           hintStyle: TextStyle(color: Colors.blueAccent),
  //                           border: InputBorder.none),
  //                     )),
  //
  //                 IconButton(
  //                     onPressed: () {
  //                       _showBottomSheet();
  //                     },
  //                     icon: const Icon(
  //                       Icons.attach_file,
  //                       color: Colors.blueAccent,
  //                       size: 26,
  //                     )),
  //
  //                 IconButton(
  //                   onPressed: () async {
  //                     final ImagePicker picker = ImagePicker();
  //                     final XFile? image = await picker.pickImage(
  //                         source: ImageSource.camera, imageQuality: 70);
  //                     if (image != null) {
  //                       log('Image Path:${image.path}');
  //                       setState(() => _isUploading = true);
  //                       await APIs.sendChatImage(widget.user, File(image.path));
  //                       setState(() => _isUploading = false);
  //                     }
  //                   },
  //                   icon: const Icon(Icons.camera_alt_rounded,
  //                       color: Colors.blueAccent, size: 26),
  //                 ),
  //                 SizedBox(width: mq.width * .02),
  //               ],
  //             ),
  //           ),
  //         ),
  //
  //         //send message button
  //         MaterialButton(
  //           onPressed: () {
  //             if (_textController.text.isNotEmpty) {
  //               APIs.sendMessage(widget.user, _textController.text, Type.text);
  //               _textController.text = '';
  //             }
  //           },
  //           minWidth: 0,
  //           padding:
  //           const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
  //           shape: const CircleBorder(),
  //           color: Colors.green,
  //           child: const Icon(Icons.send, color: Colors.white, size: 28),
  //         )
  //       ],
  //     ),
  //   );
  // }





  void _showBottomSheet() {
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
          padding:
          EdgeInsets.only(top: mq.height * .03, bottom: mq.height * .03),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final List<XFile> mediaFiles =
                        await picker.pickMultipleMedia(
                          imageQuality: 70,
                          maxWidth: 800,
                        );
                        for (var mediaFile in mediaFiles) {
                          if (mediaFile.path.contains('.mp4')) {
                            setState(() => _isUploading = true);
                            await APIs.sendChatVideo(
                                widget.user, File(mediaFile.path));
                            setState(() => _isUploading = false);
                          } else {
                            setState(() => _isUploading = true);
                            await APIs.sendChatImage(
                                widget.user, File(mediaFile.path));
                            setState(() => _isUploading = false);
                          }
                        }
                      },
                      child: Image.asset(
                        "assets/images/gallery (1).png",
                        width: mq.width * .3 * 0.5,
                        height: mq.height * .15 * 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Gallery',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        FilePickerResult? result = await FilePicker.platform
                            .pickFiles(type: FileType.audio);
                        if (result != null) {
                          File file = File(result.files.single.path!);
                          log('Video Path: ${file.path}');
                          setState(() => _isUploading = true);
                          await APIs.sendChatAudio(
                              widget.user, File(file.path));
                          setState(() => _isUploading = false);
                        }
                      },
                      child: Image.asset(
                        "assets/images/audio-headset (1).png",
                        width: mq.width * .3 * 0.5,
                        height: mq.height * .15 * 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Audio',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 70);
                        if (image != null) {
                          log('Image Path: ${image.path}');
                          setState(() => _isUploading = true);
                          await APIs.sendChatImage(
                              widget.user, File(image.path));
                          setState(() => _isUploading = false);

                          final XFile? video = await picker.pickVideo(
                              source: ImageSource.camera,
                              maxDuration: const Duration(minutes: 1));
                          if (video != null) {
                            log('Video Path: ${video.path}');
                            setState(() => _isUploading = true);
                            await APIs.sendChatVideo(
                                widget.user, File(video.path));
                            setState(() => _isUploading = false);
                          }
                        }
                      },
                      child: Image.asset(
                        "assets/images/photo.png",
                        width: mq.width * .3 * 0.5,
                        height: mq.height * .15 * 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Camera',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: mq.width * .08),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        try {
                          var status = await Permission.contacts.request();
                          if (status.isGranted) {
                            final Contact? contact =
                            await ContactsService.openDeviceContactPicker();
                            if (contact != null) {
                              String? contactName = contact.displayName
                                  ?.replaceAll(RegExp(r'[^\x00-\x7F]+'), '');
                              String? contactPhone =
                              contact.phones?.isNotEmpty ?? false
                                  ? contact.phones!.first.value
                                  : null;
                              Directory tempDir = await getTemporaryDirectory();
                              File tempFile =
                              File('${tempDir.path}/contact.txt');
                              await tempFile.writeAsString(
                                  'Name: $contactName, Phone: $contactPhone');

                              setState(() => _isUploading = true);
                              APIs apiInstance = APIs();
                              await apiInstance.shareContact(widget.user,
                                  tempFile, contactName!, contactPhone!);
                              setState(() => _isUploading = false);
                            }
                          } else {
                            print('Permission denied to access contacts');
                          }
                        } catch (e) {
                          print('Error sharing contact: $e');
                        }
                      },
                      child: Image.asset(
                        "assets/images/contact.png",
                        width: mq.width * .3 * 0.5,
                        height: mq.height * .15 * 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Contact',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        try {
                          var status = await Permission.location.request();
                          if (status.isGranted) {
                            Position position = await Geolocator.getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.high,
                            );

                            if (position != null && position.latitude != null && position.longitude != null) {
                              double latitude = position.latitude;
                              double longitude = position.longitude;

                              setState(() => _isUploading = true);
                              APIs apiInstance = APIs();
                              await apiInstance.shareLocation(widget.user, latitude, longitude);
                              setState(() => _isUploading = false);
                            } else {
                              print('Failed to retrieve location');
                            }
                          } else {
                            print('Permission denied to access location');
                          }
                        } catch (e) {
                          print('Error sharing location: $e');
                        }
                      },


                      // onTap: () async {
                      //   try {
                      //     var status = await Permission.location.request();
                      //     if (status.isGranted) {
                      //       Position position = await Geolocator.getCurrentPosition(
                      //         desiredAccuracy: LocationAccuracy.high,
                      //       );
                      //
                      //       double? latitude = position.latitude;
                      //       double? longitude = position.longitude;
                      //
                      //       if (latitude != null && longitude != null) {
                      //         setState(() => _isUploading = true);
                      //         APIs apiInstance = APIs();
                      //         await apiInstance.shareLocation(widget.user, latitude, longitude);
                      //         setState(() => _isUploading = false);
                      //       } else {
                      //         print('Failed to retrieve location');
                      //       }
                      //     } else {
                      //       print('Permission denied to access location');
                      //     }
                      //   } catch (e) {
                      //     print('Error sharing location: $e');
                      //   }
                      // },

                      child: Image.asset(
                        "assets/images/circle (2).png",
                        width: mq.width * .3 * 0.5,
                        height: mq.height * .15 * 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Location',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ],
            )
          ],
        );
      },
    );
  }
  void viewContact(BuildContext context) {
    String userEmail = widget.user.email;
    try {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("User's Email"),
          content: Text(userEmail),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        ),
      );
    } catch (e) {
      print('Error showing dialog: $e');
    }
  }
}

