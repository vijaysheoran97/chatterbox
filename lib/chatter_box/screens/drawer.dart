// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:chatterbox/api/apis.dart';
// import 'package:chatterbox/chatter_box/auth/login_screen.dart';
// import 'package:chatterbox/chatter_box/screens/newMessage.dart';
// import 'package:chatterbox/chatter_box/service/auth_service.dart';
// import 'package:chatterbox/chatter_box/settings/settings.dart';
// import 'package:chatterbox/helper/dialogs.dart';
// import 'package:chatterbox/helper/my_date_util.dart';
// import 'package:chatterbox/main.dart';
// import 'package:chatterbox/models/chat_user_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../service/auth_service.dart';
// import '../settings/settings.dart';
// import '../theme/dark_theme.dart';
// import '../theme/light_theme.dart';
// import '../theme/theme_manager.dart';
// import 'newMessage.dart';
//
// class DrawerPage extends StatefulWidget {
//   final ChatUser user;
//   const DrawerPage({Key? key, required this.user}) : super(key: key);
//
//   @override
//   State<DrawerPage> createState() => _DrawerPageState();
// }
//
// class _DrawerPageState extends State<DrawerPage> {
//
//   late String _selectedMode = 'light';
//   bool _showThemeOptions = false;
//   bool _isProfessional = false;
//
//
//   late User _currentUser; // To store the current user data
//
//   @override
//   void initState() {
//     super.initState();
//     _loadThemePreference();
//     _loadCurrentUser(); // Load current user when the widget initializes
//     // Fetch user's professional status from Firebase
//     fetchProfessionalStatus();
//   }
//
//   void fetchProfessionalStatus() async {
//     final userData = await APIs.firestore.collection('users').doc(widget.user.id).get();
//     setState(() {
//       _isProfessional = userData['isProfessional'] ?? false;
//     });
//   }
//
//   Future<void> _loadCurrentUser() async {
//     _currentUser = FirebaseAuth.instance.currentUser!;
//   }
//
//   Future<void> _loadThemePreference() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _selectedMode = prefs.getString('selectedTheme') ?? 'light';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final themeManager = Provider.of<ThemeManager>(context, listen: false);
//
//     return Drawer(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       child: ListView(
//         padding: EdgeInsets.zero,
//         children: <Widget>[
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: Colors.blue,
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Stack(
//                     children: [
//                       Positioned(
//                         top: 0,
//                         left: 0,
//                         child: CircleAvatar(
//                           radius: mq.height * 0.04,
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(mq.height * .1),
//                             child: CachedNetworkImage(
//                               // width: mq.height * .14,
//                               // height:  mq.height * .14,
//                               fit: BoxFit.cover,
//                               imageUrl: widget.user.image,
//                               errorWidget: (context, url, error) => CircleAvatar(
//                                 child: Icon(CupertinoIcons.person),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         top: 0,
//                         left: mq.height * 0.1,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Text(
//                                   widget.user.name,
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 if (_isProfessional)
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 3),
//                                     child: Icon(
//                                       Icons.verified,
//                                       size: 16,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8.0),
//                   child: Text(
//                     widget.user.email,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//
//
//           ListTile(
//             leading: Icon(Icons.group_outlined),
//             title: Text('New Group'),
//             onTap: () {
//               // Add onTap handler for Item 1
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.person_outline_rounded),
//             title: Text('Contacts'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 CupertinoPageRoute(
//                   builder: (context) => const NewMessagePage(title: Text('Contacts')),
//                 ),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.bookmark_border_outlined),
//             title: Text('Saved'),
//             onTap: () {
//               // Add onTap handler for Item 2
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.settings_outlined),
//             title: Text('Settings'),
//             onTap: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 CupertinoPageRoute(builder: (context) => const SettingPage()),
//               );
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.monetization_on_outlined),
//             title: Text('Monetisation'),
//             onTap: () {
//               // Add onTap handler for Item 2
//             },
//           ),
//           Divider(
//             color: Colors.grey.shade300,
//           ),
//           ListTile(
//             leading: Icon(Icons.change_circle_outlined),
//             title: Text('Themes'),
//             trailing: Icon(_showThemeOptions
//                 ? Icons.keyboard_arrow_up_outlined
//                 : Icons.keyboard_arrow_down_outlined),
//             onTap: () {
//               setState(() {
//                 _showThemeOptions = !_showThemeOptions;
//               });
//             },
//           ),
//           if (_showThemeOptions) ...[
//             RadioListTile(
//               title: const Text('Light Theme'),
//               value: 'light',
//               groupValue: _selectedMode,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedMode = value!;
//                 });
//                 themeManager.setTheme(lightTheme);
//                 _saveThemePreference('light');
//                 Navigator.pop(context);
//               },
//               activeColor: Colors.blue,
//             ),
//             RadioListTile(
//               title: const Text('Dark Theme'),
//               value: 'dark',
//               groupValue: _selectedMode,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedMode = value!;
//                 });
//                 themeManager.setTheme(darkTheme);
//                 _saveThemePreference('dark');
//                 Navigator.pop(context);
//               },
//               activeColor: Colors.blue,
//             ),
//           ],
//           ListTile(
//             leading: Icon(Icons.help_outline_outlined),
//             title: Text('Help center'),
//             onTap: () {
//               // Add onTap handler for Item 2
//             },
//           ),
//           ListTile(
//
//
//             leading: Icon(Icons.logout_outlined, color: Colors.red,),
//             title: Text('Logout', style: TextStyle(color: Colors.red),),
//
//             onTap: () async {
//               Dialogs.showProgressBar(context);
//               await APIs.updateActiveStatus(false);
//               await APIs.auth.signOut().then((value) async {
//                 await GoogleSignIn().signOut().then((value) {
//
//                   Navigator.pop(context);
//                   APIs.auth = FirebaseAuth.instance;
//                   Navigator.pushReplacement(context,
//                       MaterialPageRoute(builder: (_) => const LoginScreen()));
//                 });
//               });
//             },
//           ),
//           SizedBox(height: mq.height * .02),
//           ListTile(
//             title: Row(mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   'Joined On: ',
//                   style: TextStyle(
//                     //color: Colors.black87,
//                       fontWeight: FontWeight.w500,
//                       fontSize: 15),
//                 ),
//                 Text(
//                     MyDateUtil.getLastMessageTime(
//                         context: context,
//                         time: widget.user.createdAt,
//                         showYear: true),
//                     style: const TextStyle(
//                       // color: Colors.black54,
//                         fontSize: 15)),
//               ],
//             ),
//
//           )
//         ],
//       ),
//     );
//   }
//
//   Future<void> _saveThemePreference(String theme) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('selectedTheme', theme);
//     } catch (e) {
//       print('Error saving theme preference: $e');
//     }
//   }
// }
//

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatterbox/api/apis.dart';
import 'package:chatterbox/chatter_box/auth/login_screen.dart';
import 'package:chatterbox/chatter_box/screens/newMessage.dart';
import 'package:chatterbox/chatter_box/settings/settings.dart';
import 'package:chatterbox/helper/dialogs.dart';
import 'package:chatterbox/helper/my_date_util.dart';
import 'package:chatterbox/main.dart';
import 'package:chatterbox/models/chat_user_model.dart';
import 'package:chatterbox/screens/create_group.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/dark_theme.dart';
import '../theme/light_theme.dart';
import '../theme/theme_manager.dart';

import 'newMessage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class DrawerPage extends StatefulWidget {
  final ChatUser user;
  const DrawerPage({Key? key, required this.user}) : super(key: key);

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {

  late String _selectedMode = 'light';
  bool _showThemeOptions = false;
  bool _isProfessional = false;


  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
    _loadCurrentUser();
    fetchProfessionalStatus();
  }

  void fetchProfessionalStatus() async {
    final userData = await APIs.firestore.collection('users').doc(widget.user.id).get();
    setState(() {
      _isProfessional = userData['isProfessional'] ?? false;
    });
  }

  Future<void> _loadCurrentUser() async {
    _currentUser = FirebaseAuth.instance.currentUser!;
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMode = prefs.getString('selectedTheme') ?? 'light';
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: false);

    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        child: CircleAvatar(
                          radius: mq.height * 0.04,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(mq.height * .1),
                            child: CachedNetworkImage(
                              // width: mq.height * .14,
                              // height:  mq.height * .14,
                              fit: BoxFit.cover,
                              imageUrl: widget.user.image,
                              errorWidget: (context, url, error) => const CircleAvatar(
                                child: Icon(CupertinoIcons.person),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: mq.height * 0.1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.user.name,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (_isProfessional)
                                  const Padding(
                                    padding: EdgeInsets.only(left: 3),
                                    child: Icon(
                                      Icons.verified,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    widget.user.email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),



          ListTile(

            leading: Icon(Icons.group_outlined),
            title: Text(AppLocalizations.of(context)!.newgroup),

            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const CreateGroupPage(),
                ),
              );
            },
          ),
          ListTile(

            leading: Icon(Icons.person_outline_rounded),
            title: Text(AppLocalizations.of(context)!.contacts),

            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const NewMessagePage(title: Text('Contacts')),
                ),
              );
            },
          ),
          ListTile(

            leading: Icon(Icons.bookmark_border_outlined),
            title: Text(AppLocalizations.of(context)!.saved),

            onTap: () {
              // Add onTap handler for Item 2
            },
          ),
          ListTile(

            leading: Icon(Icons.settings_outlined),
            title: Text(AppLocalizations.of(context)!.settings),

            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => const SettingPage()),
              );
            },
          ),
          ListTile(

            leading: Icon(Icons.monetization_on_outlined),
            title: Text(AppLocalizations.of(context)!.monetisation),

            onTap: () {
              // Add onTap handler for Item 2
            },
          ),
          Divider(
            color: Colors.grey.shade300,
          ),
          ListTile(

            leading: Icon(Icons.change_circle_outlined),
            title: Text(AppLocalizations.of(context)!.theme),

            trailing: Icon(_showThemeOptions
                ? Icons.keyboard_arrow_up_outlined
                : Icons.keyboard_arrow_down_outlined),
            onTap: () {
              setState(() {
                _showThemeOptions = !_showThemeOptions;
              });
            },
          ),
          if (_showThemeOptions) ...[
            RadioListTile(
              title: Text(AppLocalizations.of(context)!.lighttheme),
              value: 'light',
              groupValue: _selectedMode,
              onChanged: (value) {
                setState(() {
                  _selectedMode = value!;
                });
                themeManager.setTheme(lightTheme);
                _saveThemePreference('light');
                Navigator.pop(context);
              },
              activeColor: Colors.blue,
            ),
            RadioListTile(
              title: Text(AppLocalizations.of(context)!.darktheme),
              value: 'dark',
              groupValue: _selectedMode,
              onChanged: (value) {
                setState(() {
                  _selectedMode = value!;
                });
                themeManager.setTheme(darkTheme);
                _saveThemePreference('dark');
                Navigator.pop(context);
              },
              activeColor: Colors.blue,
            ),
          ],
          ListTile(

            leading: Icon(Icons.help_outline_outlined),
            title: Text(AppLocalizations.of(context)!.helpcenter),

            onTap: () {
              // Add onTap handler for Item 2
            },
          ),
          ListTile(



            leading: Icon(Icons.logout_outlined, color: Colors.red,),
            title: Text(AppLocalizations.of(context)!.logout, style: TextStyle(color: Colors.red),),


            onTap: () async {
              Dialogs.showProgressBar(context);
              await APIs.updateActiveStatus(false);
              await APIs.auth.signOut().then((value) async {
                await GoogleSignIn().signOut().then((value) {

                  Navigator.pop(context);
                  APIs.auth = FirebaseAuth.instance;
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()));
                });
              });
            },
          ),
          SizedBox(height: mq.height * .02),
          ListTile(
            title: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  '${AppLocalizations.of(context)!.joinedOn} : ',

                  style: TextStyle(
                    //color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
                ),
                Text(
                    MyDateUtil.getLastMessageTime(
                        context: context,
                        time: widget.user.createdAt,
                        showYear: true),
                    style: const TextStyle(
                      // color: Colors.black54,
                        fontSize: 15)),
              ],
            ),

          )
        ],
      ),
    );
  }

  Future<void> _saveThemePreference(String theme) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selectedTheme', theme);
    } catch (e) {
      print('Error saving theme preference: $e');
    }
  }
}