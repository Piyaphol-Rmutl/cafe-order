import 'package:flutter/material.dart';

import '../l10n_ext.dart';

/// หน้าตั้งค่า: โหมดมืดและภาษา (สัปดาห์ 7 ค่าอยู่ที่รากของแอป ส่งผ่าน callback)
class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.onThemeModeChanged,
    required this.onLocaleChanged,
  });

  final ValueChanged<ThemeMode> onThemeModeChanged;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lang = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          // .adaptive: บน iOS แสดงเป็นสวิตช์แบบ Cupertino โดยอัตโนมัติ
          SwitchListTile.adaptive(
            title: Text(l10n.darkMode),
            secondary: const Icon(Icons.dark_mode),
            value: isDark,
            onChanged: (on) =>
                onThemeModeChanged(on ? ThemeMode.dark : ThemeMode.light),
          ),
          ListTile(
            leading: const Icon(Icons.translate),
            title: Text(l10n.language),
            trailing: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'th', label: Text('ไทย')),
                ButtonSegment(value: 'en', label: Text('EN')),
              ],
              selected: {lang},
              onSelectionChanged: (s) => onLocaleChanged(Locale(s.first)),
            ),
          ),
        ],
      ),
    );
  }
}
