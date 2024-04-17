// import 'package:chatterbox/api/apis.dart';
// import 'package:flutter/material.dart';
//
// class Notifications extends StatefulWidget {
//   const Notifications({super.key});
//
//   @override
//   State<Notifications> createState() => _NotificationsState();
// }
//
// class _NotificationsState extends State<Notifications> {
//   late bool switchValue = false;
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProfessionalStatus();
//   }
//
//   void fetchProfessionalStatus() async {
//     final userData = await APIs.firestore.collection('users').doc(APIs.user.uid).get();
//     final isProfessional = userData['isProfessional'] ?? false;
//     setState(() {
//       switchValue = isProfessional;
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       backgroundColor: Theme.of(context).colorScheme.background,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: const Text('Notifications'),
//       ),
//       body: Column(
//         children: [
//           ListTile(
//             title: Text(
//               'Allow Notifications',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             trailing: Switch(
//               value: switchValue,
//               onChanged: (value) {
//                 setState(() {
//                   switchValue = value;
//                 });
//                 saveProfessionalStatus(value);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   void saveProfessionalStatus(bool isProfessional) async {
//     APIs.me.isProfessional = isProfessional;
//     await APIs.firestore.collection('users').doc(APIs.user.uid).update({
//       'isProfessional': isProfessional,
//     });
//   }
// }

import 'package:flutter/material.dart';

class Nitifications extends StatefulWidget {
  const Nitifications({super.key});

  @override
  State<Nitifications> createState() => _NitificationsState();
}

class _NitificationsState extends State<Nitifications> {

  late bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Notifications'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text("Allow Notifications",
            style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Switch(
              value: switchValue,
              onChanged: (value){
                setState(() {
                  switchValue = value;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
