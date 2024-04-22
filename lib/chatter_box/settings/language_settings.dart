import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chatterbox/providers/language_change_controller.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({Key? key}) : super(key: key);

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

enum Language { english, hindi }


class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  Language _selectedLanguage = Language.english; // Default language

  @override
  void initState() {
    super.initState();
    // Load the selected language when the widget initializes
    _loadSelectedLanguage();
  }

  Future<void> _loadSelectedLanguage() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final languageIndex = sp.getInt('languageIndex') ?? 0; // Default to English if not found
    setState(() {
      _selectedLanguage = Language.values[languageIndex];
    });
  }

  Future<void> _saveLanguagePreference(Language selectedLanguage) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setInt('languageIndex', selectedLanguage.index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.languages),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context)!.selectLanguages),
            trailing: PopupMenuButton(
              initialValue: _selectedLanguage,
              onSelected: (Language item) async {
                setState(() {
                  _selectedLanguage = item;
                });
                // Save selected language
                await _saveLanguagePreference(item);
                // Change language immediately
                Provider.of<LanguageChangeController>(context, listen: false).changeLanguage(
                  item == Language.english ? Locale('en') : Locale('hi'),
                );
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<Language>>[
                const PopupMenuItem(
                  value: Language.english,
                  child: Text('English'),
                ),
                const PopupMenuItem(
                  value: Language.hindi,
                  child: Text('हिंदी'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
