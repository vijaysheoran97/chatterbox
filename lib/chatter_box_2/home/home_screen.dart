// import 'package:chatterbox/chatter_box/utils/app_color_constant.dart';
// import 'package:chatterbox/chatter_box/utils/app_string_constant.dart';
// import 'package:chatterbox/chatter_box_2/home/calls_screen.dart';
// import 'package:chatterbox/chatter_box_2/home/home_fab.dart';
// import 'package:chatterbox/chatter_box_2/routers_constants/routes_constants.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// class HomeScreen extends ConsumerStatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   ConsumerState<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends ConsumerState<HomeScreen>
//     with WidgetsBindingObserver, TickerProviderStateMixin {
//   late final TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _tabController = TabController(length: 3, vsync: this);
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//
//     switch (state) {
//       case AppLifecycleState.resumed:
//       case AppLifecycleState.inactive:
//         ref.watch(senderUserDataControllerProvider).setSenderUserState(true);
//         break;
//       case AppLifecycleState.paused:
//       case AppLifecycleState.detached:
//         ref.watch(senderUserDataControllerProvider).setSenderUserState(false);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       initialIndex: 0,
//       child: Scaffold(
//         appBar: _buildAppBar(context),
//         body: TabBarView(
//           controller: _tabController,
//           children: const [
//             ChatsList(),
//             StatusScreen(),
//             CallsScreen(),
//           ],
//         ),
//         floatingActionButton: HomeFAB(tabController: _tabController),
//       ),
//     );
//   }
//
//   /// AppBar of the home screen
//   AppBar _buildAppBar(BuildContext context) {
//     return AppBar(
//       centerTitle: false,
//       systemOverlayStyle: const SystemUiOverlayStyle(
//         statusBarColor: AppColorConstant.primary,
//       ),
//       title: Text(
//         AppStringConstant.appName,
//         style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       actions: [
//         IconButton(
//           onPressed: () {},
//           icon: const Icon(
//             Icons.search,
//             color: AppColorConstant.appBarActionIcon,
//           ),
//         ),
//         PopupMenuButton(
//           icon: const Icon(Icons.more_vert),
//           itemBuilder: (context) => [
//             PopupMenuItem(
//               child: const Text('Logout'),
//               onTap: () {
//                 FirebaseAuth.instance.signOut();
//                 Future(
//                       () => Navigator.pushReplacementNamed(
//                     context,
//                     AppRoutes.landingScreen,
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ],
//       bottom: TabBar(
//         controller: _tabController,
//         indicatorColor: AppColorConstant.white,
//         indicatorWeight: 4.0,
//         labelColor: AppColorConstant.sTabLabel,
//         unselectedLabelColor: AppColorConstant.uTabLabel,
//         labelStyle: Theme.of(context).textTheme.headlineSmall,
//         tabs: const [
//           Tab(text: 'CHATS'),
//           Tab(text: 'STATUS'),
//           Tab(text: 'CALLS'),
//         ],
//       ),
//     );
//   }
// }
