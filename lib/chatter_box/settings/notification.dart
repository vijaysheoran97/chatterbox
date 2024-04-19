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
