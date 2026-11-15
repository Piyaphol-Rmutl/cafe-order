import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/settings_model.dart';
import '../l10n_ext.dart';

/// หน้าตั้งค่า: โหมดมืดและภาษา (สัปดาห์ 8 อ่าน/แก้ผ่าน SettingsModel)
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = context.read<SettingsModel>(); // แค่เรียกเมธอด ใช้ read
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
                settings.themeMode = on ? ThemeMode.dark : ThemeMode.light,
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
              onSelectionChanged: (s) => settings.locale = Locale(s.first),
            ),
          ),
        ],
      ),
    );
  }
}
