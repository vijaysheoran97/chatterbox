
import 'package:chatterbox/chatter_box/screens/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../tabs/callList.dart';
import '../tabs/chatlist.dart';
import '../tabs/statusList.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(

      length: 3,

      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Open drawer on button click
                },
                icon: Icon(Icons.menu_outlined),
              );
            },
          ),
          title: Text('ChatterBox'),
          actions: [
            IconButton(

              onPressed: ()async {
Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
              },

              icon: Icon(Icons.search_outlined),
            )
          ],
          bottom: TabBar(
            isScrollable: false, // make tabs non-scrollable
            labelPadding: EdgeInsets.zero, // remove padding around labels
            indicatorSize: TabBarIndicatorSize.tab, // set indicator size to full tab
            tabs: [
              Tab(
                text: 'Chats',
              ),
              Tab(

                text: 'Status',
              ),
              Tab(

                text: 'Calls',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [

            ChatListPage(),
            StatusListPage(),
            CallListPage(),
          ],
        ),
        drawer: DrawerPage(), 
        // Use CustomDrawer widget here

      ),
    );
  }
}
