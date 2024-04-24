// // import 'package:chatterbox/api/apis.dart';
// // import 'package:chatterbox/chatter_box/auth/login_screen.dart';
// // import 'package:chatterbox/chatter_box/screens/drawer.dart';
// // import 'package:chatterbox/model/user_info_model.dart';
// // import 'package:chatterbox/screens/home_screen.dart';
// // import 'package:chatterbox/screens/profile_screen.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// //
// // import '../tabs/callList.dart';
// // import '../tabs/chatlist.dart';
// // import '../tabs/statusList.dart';
// //
// // class HomePage extends StatefulWidget {
// //   const HomePage({Key? key}) : super(key: key);
// //
// //   @override
// //   State<HomePage> createState() => _HomePageState();
// // }
// // class _HomePageState extends State<HomePage> {
// //   late TextEditingController _searchController;
// //   bool _isSearching = false;
// //
// //  //final me = User;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _searchController = TextEditingController();
// //     APIs.getSelfInfo().then((_) {
// //       setState(() {
// //
// //       });
// //     } );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     if (APIs.me! == null) {
// //       return Scaffold(
// //         body: Center(
// //           child: CircularProgressIndicator(),
// //         ),
// //       );
// //     }
// //     return DefaultTabController(
// //       length: 3,
// //       child: Scaffold(
// //         backgroundColor: Theme.of(context).colorScheme.background,
// //         appBar: AppBar(
// //           backgroundColor: Colors.transparent,
// //           leading: Builder(
// //             builder: (BuildContext context) {
// //               return IconButton(
// //                 onPressed: () {
// //                   Scaffold.of(context).openDrawer();
// //                 },
// //                 icon: const Icon(Icons.menu_outlined),
// //               );
// //             },
// //           ),
// //           title: _isSearching
// //               ? TextField(
// //             controller: _searchController,
// //             decoration: const InputDecoration(
// //               border: InputBorder.none,
// //               hintText: "Search...",
// //             ),
// //             onChanged: (query) {
// //               // Handle search query
// //               // Pass the query to HomeScreen for search functionality
// //             },
// //           )
// //               : const Text('ChatterBox'),
// //           actions: [
// //             IconButton(
// //               onPressed: () {
// //                 setState(() {
// //                   _isSearching = !_isSearching;
// //                   if (!_isSearching) {
// //                     _searchController.clear();
// //                   }
// //                 });
// //               },
// //               icon: Icon(
// //                 _isSearching ? Icons.clear : Icons.search_outlined,
// //               ),
// //             ),
// //             IconButton(
// //               onPressed: () {
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (_) => ProfileScreen(user: APIs.me),
// //                   ),
// //                 );
// //               },
// //               icon: const Icon(
// //                 Icons.more_vert,
// //               ),
// //             ),
// //           ],
// //           bottom: const TabBar(
// //             isScrollable: false,
// //             labelPadding: EdgeInsets.zero,
// //             indicatorSize: TabBarIndicatorSize.tab,
// //             tabs: [
// //               Tab(
// //                 text: 'Chats',
// //               ),
// //               Tab(
// //                 text: 'Status',
// //               ),
// //               Tab(
// //                 text: 'Calls',
// //               ),
// //             ],
// //           ),
// //         ),
// //         body: const TabBarView(
// //           children: [
// //             HomeScreen(),
// //             StatusListPage(),
// //             CallListPage(),
// //           ],
// //         ),
// //        drawer:  DrawerPage(user: APIs.me),
// //       ),
// //     );
// //   }
// // }
// //
// //
//
//
// import 'package:flutter/material.dart';
// import 'package:chatterbox/api/apis.dart';
// import 'package:chatterbox/chatter_box/auth/login_screen.dart';
// import 'package:chatterbox/chatter_box/screens/drawer.dart';
// import 'package:chatterbox/model/user_info_model.dart';
// import 'package:chatterbox/screens/home_screen.dart';
// import 'package:chatterbox/screens/profile_screen.dart';
// import '../tabs/callList.dart';
// import '../tabs/chatlist.dart';
// import '../tabs/statusList.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   late TextEditingController _searchController;
//   bool _isSearching = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _searchController = TextEditingController();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<void>(
//       future: APIs.getSelfInfo(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // Display a loading indicator while waiting for APIs.getSelfInfo() to complete
//           return Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         } else if (snapshot.hasError) {
//           // Display an error message if APIs.getSelfInfo() encounters an error
//           return Scaffold(
//             body: Center(
//               child: Text('Error: ${snapshot.error}'),
//             ),
//           );
//         } else {
//           // APIs.getSelfInfo() completed successfully, build the HomePage widget
//           return DefaultTabController(
//             length: 3,
//             child: Scaffold(
//               backgroundColor: Theme.of(context).colorScheme.background,
//               appBar: AppBar(
//                 backgroundColor: Colors.transparent,
//                 leading: Builder(
//                   builder: (BuildContext context) {
//                     return IconButton(
//                       onPressed: () {
//                         Scaffold.of(context).openDrawer();
//                       },
//                       icon: const Icon(Icons.menu_outlined),
//                     );
//                   },
//                 ),
//                 title: _isSearching
//                     ? TextField(
//                   controller: _searchController,
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     hintText: "Search...",
//                   ),
//                   onChanged: (query) {
//                     // Handle search query
//                     // Pass the query to HomeScreen for search functionality
//                   },
//                 )
//                     : const Text('ChatterBox'),
//                 actions: [
//                   IconButton(
//                     onPressed: () {
//                       setState(() {
//                         _isSearching = !_isSearching;
//                         if (!_isSearching) {
//                           _searchController.clear();
//                         }
//                       });
//                     },
//                     icon: Icon(
//                       _isSearching ? Icons.clear : Icons.search_outlined,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => ProfileScreen(user: APIs.me),
//                         ),
//                       );
//                     },
//                     icon: const Icon(
//                       Icons.more_vert,
//                     ),
//                   ),
//                 ],
//                 bottom: const TabBar(
//                   isScrollable: false,
//                   labelPadding: EdgeInsets.zero,
//                   indicatorSize: TabBarIndicatorSize.tab,
//                   tabs: [
//                     Tab(
//                       text: 'Chats',
//                     ),
//                     Tab(
//                       text: 'Status',
//                     ),
//                     Tab(
//                       text: 'Calls',
//                     ),
//                   ],
//                 ),
//               ),
//               body: TabBarView(
//                 children: [
//                   HomeScreen(),
//                   StatusListPage(user: APIs.me),
//                   CallListPage(),
//                 ],
//               ),
//               drawer: DrawerPage(user: APIs.me),
//             ),
//           );
//         }
//       },
//     );
//   }
// }

// import 'package:chatterbox/api/apis.dart';
// import 'package:chatterbox/chatter_box/auth/login_screen.dart';
// import 'package:chatterbox/chatter_box/screens/drawer.dart';
// import 'package:chatterbox/model/user_info_model.dart';
// import 'package:chatterbox/screens/home_screen.dart';
// import 'package:chatterbox/screens/profile_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../tabs/callList.dart';
// import '../tabs/chatlist.dart';
// import '../tabs/statusList.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
// class _HomePageState extends State<HomePage> {
//   late TextEditingController _searchController;
//   bool _isSearching = false;
//
//  //final me = User;
//
//   @override
//   void initState() {
//     super.initState();
//     _searchController = TextEditingController();
//     APIs.getSelfInfo().then((_) {
//       setState(() {
//
//       });
//     } );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (APIs.me! == null) {
//       return Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         backgroundColor: Theme.of(context).colorScheme.background,
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           leading: Builder(
//             builder: (BuildContext context) {
//               return IconButton(
//                 onPressed: () {
//                   Scaffold.of(context).openDrawer();
//                 },
//                 icon: const Icon(Icons.menu_outlined),
//               );
//             },
//           ),
//           title: _isSearching
//               ? TextField(
//             controller: _searchController,
//             decoration: const InputDecoration(
//               border: InputBorder.none,
//               hintText: "Search...",
//             ),
//             onChanged: (query) {
//               // Handle search query
//               // Pass the query to HomeScreen for search functionality
//             },
//           )
//               : const Text('ChatterBox'),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 setState(() {
//                   _isSearching = !_isSearching;
//                   if (!_isSearching) {
//                     _searchController.clear();
//                   }
//                 });
//               },
//               icon: Icon(
//                 _isSearching ? Icons.clear : Icons.search_outlined,
//               ),
//             ),
//             IconButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => ProfileScreen(user: APIs.me),
//                   ),
//                 );
//               },
//               icon: const Icon(
//                 Icons.more_vert,
//               ),
//             ),
//           ],
//           bottom: const TabBar(
//             isScrollable: false,
//             labelPadding: EdgeInsets.zero,
//             indicatorSize: TabBarIndicatorSize.tab,
//             tabs: [
//               Tab(
//                 text: 'Chats',
//               ),
//               Tab(
//                 text: 'Status',
//               ),
//               Tab(
//                 text: 'Calls',
//               ),
//             ],
//           ),
//         ),
//         body: const TabBarView(
//           children: [
//             HomeScreen(),
//             StatusListPage(),
//             CallListPage(),
//           ],
//         ),
//        drawer:  DrawerPage(user: APIs.me),
//       ),
//     );
//   }
// }
//
//


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../api/apis.dart';
import '../../screens/GroupList.dart';

import 'package:chatterbox/screens/group_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../api/apis.dart';

import '../../screens/home_screen.dart';
import '../../screens/profile_screen.dart';
import '../tabs/callList.dart';
import '../tabs/statusList.dart';
import 'drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _searchController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: APIs.getSelfInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else {
          return DefaultTabController(

            initialIndex: 1,

            length: 4, // Increase the length to accommodate the new tab
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      icon: const Icon(Icons.menu_outlined),
                    );
                  },
                ),
                title: _isSearching
                    ? TextField(


                  controller: _searchController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search...",
                  ),
                  onChanged: (query) {
                  },
                )
                    : const Text('CINLINE'),


                actions: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isSearching = !_isSearching;
                        if (!_isSearching) {
                          _searchController.clear();
                        }
                      });
                    },
                    icon: Icon(
                      _isSearching ? Icons.clear : Icons.search_outlined,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileScreen(user: APIs.me),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.more_vert,
                    ),
                  ),
                ],
                bottom: TabBar(
                  isScrollable: false,
                  labelPadding: EdgeInsets.zero,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(
                      // New tab with icon only
                      icon: Icon(Icons.group),
                    ),
                    Tab(

                      text: AppLocalizations.of(context)!.chats,

                    ),
                    Tab(
                      text: AppLocalizations.of(context)!.status,
                    ),
                    Tab(
                      text: AppLocalizations.of(context)!.calls,
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [


                  GroupListPage(currentUserID: APIs.me.id,),
                  const HomeScreen(),
                  StatusListPage(user: APIs.me),
                  const CallListPage(),


                ],
              ),
              drawer: DrawerPage(user: APIs.me),
            ),
          );
        }
      },
    );
  }
}