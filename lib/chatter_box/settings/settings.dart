import 'package:chatterbox/chatter_box/settings/language_settings.dart';
import 'package:chatterbox/chatter_box/settings/themes.dart';
import 'package:chatterbox/chatter_box/settings/yourAccount.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: TextStyle(
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.tertiary),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => YourAccountPage()));
              },
              leading: const Icon(Icons.person_outline),
              title: Text(AppLocalizations.of(context)!.youraccount),
              subtitle: Text(
                AppLocalizations.of(context)!.youraccountSubtitle,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
                leading: const Icon(Icons.lock_outlined),
                title: Text(AppLocalizations.of(context)!.securityAndAccountAccess),
                subtitle: Text(
                  AppLocalizations.of(context)!.securityAndAccountAccessSubtitle,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                )),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(Icons.workspace_premium_outlined),
              title: Text(AppLocalizations.of(context)!.preminum),
              subtitle: Text(
                AppLocalizations.of(context)!.premiumSubtitle,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: Text(AppLocalizations.of(context)!.privacyAndSafety),
              subtitle: Text(
                AppLocalizations.of(context)!.privacyAndSafetySubtitle,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(Icons.notifications_active_outlined),
              title: Text(AppLocalizations.of(context)!.notifications),
              subtitle: Text(
                AppLocalizations.of(context)!.notificationsSubtitle,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LanguageSettingsPage()));
              },
              leading: const Icon(Icons.language_outlined),
              title: Text(AppLocalizations.of(context)!.languages),
              subtitle: Text(
                AppLocalizations.of(context)!.languagesSubtitle,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) => const ThemesPage()),
                );
              },
              leading: const Icon(Icons.light_mode_outlined),
              title: Text(AppLocalizations.of(context)!.theme),
              subtitle: Text(
                AppLocalizations.of(context)!.themeSubtitle,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              leading: const Icon(Icons.help_outline_outlined),
              title: Text(AppLocalizations.of(context)!.helpcenter),
              subtitle: Text(
                AppLocalizations.of(context)!.helpcenterSubtitle,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
            )
          ],
        ),
      ),
    );
  }
}
