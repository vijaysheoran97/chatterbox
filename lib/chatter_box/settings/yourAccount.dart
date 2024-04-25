import 'package:flutter/material.dart';
import '../../api/apis.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class YourAccountPage extends StatefulWidget {
  const YourAccountPage({Key? key}) : super(key: key);

  @override
  State<YourAccountPage> createState() => _YourAccountPageState();
}

class _YourAccountPageState extends State<YourAccountPage> {
  late bool switchValue = false;

  @override
  void initState() {
    super.initState();
    fetchProfessionalStatus();
  }

  void fetchProfessionalStatus() async {
    final userData = await APIs.firestore.collection('users').doc(APIs.user.uid).get();
    final isProfessional = userData['isProfessional'] ?? false;
    setState(() {
      switchValue = isProfessional;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(AppLocalizations.of(context)!.youraccount),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.switchToProfessional,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: Switch(
              value: switchValue,
              onChanged: (value) {
                setState(() {
                  switchValue = value;
                });
                saveProfessionalStatus(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  void saveProfessionalStatus(bool isProfessional) async {
    APIs.me.isProfessional = isProfessional;
    await APIs.firestore.collection('users').doc(APIs.user.uid).update({
      'isProfessional': isProfessional,
    });
  }
}
