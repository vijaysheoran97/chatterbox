import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/dark_theme.dart';
import '../theme/light_theme.dart';
import '../theme/theme_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ThemesPage extends StatefulWidget {
  const ThemesPage({Key? key}) : super(key: key);

  @override
  State<ThemesPage> createState() => _ThemesPageState();
}

class _ThemesPageState extends State<ThemesPage> {
  late String _selectedMode = 'light';

  @override
  void initState() {
    super.initState();
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMode = prefs.getString('selectedTheme') ?? 'light';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(),
        title: Text(
          AppLocalizations.of(context)!.theme,
          style: TextStyle(
            letterSpacing: 0.5,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              AppLocalizations.of(context)!.theme,

              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            GestureDetector(
              onTap: () {
                _showThemeSelector(context);
              },
              child: ListTile(

                title: Text(AppLocalizations.of(context)!.chooseTheme),
                subtitle: Text(AppLocalizations.of(context)!.chooseThemeSubtitle),

                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _selectedMode,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showThemeSelector(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context, listen: false);
    showModalBottomSheet(
      backgroundColor: Theme.of(context).colorScheme.onTertiary,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                AppLocalizations.of(context)!.selectTheme,

                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
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
          ),
        );
      },
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
