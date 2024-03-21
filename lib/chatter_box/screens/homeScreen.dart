import 'package:chatterbox/chatter_box/auth/login_screen.dart';
import 'package:chatterbox/chatter_box/screens/drawer.dart';
import 'package:chatterbox/chatter_box/service/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
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
await AuthService().logOut();
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
                text: 'Calls',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Add your content for the "Chats" tab here
            Center(
              child: Text('Chats Tab Content'),
            ),
            // Add your content for the "Calls" tab here
            Center(
              child: Text('Calls Tab Content'),
            ),
          ],
        ),
        drawer: DrawerPage(), // Use CustomDrawer widget here
      ),
    );
  }
}
