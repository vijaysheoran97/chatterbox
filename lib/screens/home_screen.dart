import 'package:chatterbox/api/apis.dart';
import 'package:chatterbox/main.dart';
import 'package:chatterbox/screens/profile_screen.dart';
import 'package:chatterbox/widget/chat_user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../helper/dialogs.dart';
import '../models/chat_user_model.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  void initState() {
    APIs.getSelfInfo();
    super.initState();
    SystemChannels.lifecycle.setMessageHandler((message){
      if (APIs.auth.currentUser != null) {
        if (message.toString().contains('resume')) {
          APIs.updateActiveStatus(true);
        }
        if (message.toString().contains('pause')) {
          APIs.updateActiveStatus(false);
        }
      }
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: (){
          if(_isSearching){
            setState(() {
              _isSearching=!_isSearching;
            });
            return Future.value(false);
          }

          else{
            return Future.value(true);
          }


        },
        child: Scaffold(
          // appBar: AppBar(
          //   leading: const Icon(Icons.home),
          //   title: _isSearching
          //       ? TextField(
          //           decoration: const InputDecoration(
          //               border: InputBorder.none, hintText: "Name,Email,..."),
          //           autofocus: true,
          //           style: const TextStyle(fontSize: 16, letterSpacing: 1),
          //           onChanged: (val) {
          //             _searchList.clear();
          //             for (var i in _list) {
          //               if (i.name.toLowerCase().contains(val.toLowerCase()) ||
          //                   i.email.toLowerCase().contains(val.toLowerCase())) {
          //                 _searchList.add(i);
          //               }
          //               setState(() {
          //                 _searchList;
          //               });
          //             }
          //           },
          //         )
          //       : Text('ChatterBox'),
          //   actions: [
          //     IconButton(
          //       onPressed: () {
          //         setState(() {
          //           _isSearching = !_isSearching;
          //         });
          //       },
          //       icon: Icon(
          //         _isSearching ? Icons.clear_outlined : Icons.search,
          //       ),
          //     ),
          //     IconButton(
          //       onPressed: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (_) => ProfileScreen(user: APIs.me),
          //           ),
          //         );
          //       },
          //       icon: const Icon(
          //         Icons.more_vert,
          //       ),
          //     ),
          //   ],
          // ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: FloatingActionButton(
              onPressed: () {
                _addChatUserDialog();
              },
              child: const Icon(
                Icons.add_comment_rounded,
              ),
            ),
          ),
          body: StreamBuilder(
              stream: APIs.getAllUsers(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case ConnectionState.active:
                  case ConnectionState.done:
                    final data = snapshot.data?.docs;
                    _list =
                        data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                            [];
                }
                if (_list.isNotEmpty) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _isSearching ? _searchList.length : _list.length,
                    padding: EdgeInsets.only(top: mq.height * .01),
                    itemBuilder: (context, index) {
                      return ChatUserCard(
                        user: _isSearching ? _searchList[index] : _list[index],
                      );
                      // return Text('Name: ${list[index]}');
                    },
                  );
                } else {
                  return const Center(
                      child: Text(
                        'No Connections Found!',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ));
                }
              }),
        ),
      ),
    );
  }
  void _addChatUserDialog() {
    String email = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
          contentPadding: const EdgeInsets.only(
              left: 24, right: 24, top: 20, bottom: 10),

          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),

          //title
          title: const Row(
            children: [
              Icon(
                Icons.person_add,
                color: Colors.blue,
                size: 28,
              ),
              Text('Add User')
            ],
          ),

          //content
          content: TextFormField(
            maxLines: null,
            onChanged: (value) => email = value,
            decoration: InputDecoration(
                hintText: 'Email Id',
                prefixIcon: const Icon(Icons.email, color: Colors.blue),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
          ),

          //actions
          actions: [
            //cancel button
            MaterialButton(
                onPressed: () {
                  //hide alert dialog
                  Navigator.pop(context);
                },
                child: const Text('Cancel',
                    style: TextStyle(color: Colors.blue, fontSize: 16))),

            //add button
            MaterialButton(
                onPressed: () async {
                  //hide alert dialog
                  Navigator.pop(context);
                  if (email.isNotEmpty) {
                    await APIs.addChatUser(email).then((value) {
                      if (!value) {
                        Dialogs.showSnackbar(
                            context, 'User does not Exists!');
                      }
                    });
                  }
                },
                child: const Text(
                  'Add',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ))
          ],
        ));
  }
}