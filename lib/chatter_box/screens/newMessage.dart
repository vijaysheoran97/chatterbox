import 'package:flutter/material.dart';

class NewMessagePage extends StatefulWidget {
  const NewMessagePage({Key? key, required this.title}) : super(key: key);

  final Widget title;

  @override
  State<NewMessagePage> createState() => _NewMessagePageState();
}

class _NewMessagePageState extends State<NewMessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: BackButton(),
        title: widget.title,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search_outlined),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.group_outlined),
              ),
              title: Text('New group'),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.person_add_alt),
              ),
              title: Text('New contact'),
            ),
            Container(
              height: 200, // Set a fixed height or use constraints accordingly
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 20,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text('New Item ${index + 1}'),
                    subtitle: Text('Subtitle for Item ${index + 1}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

