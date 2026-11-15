import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';

/// เขียน context.l10n แทน AppLocalizations.of(context)
extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
  bool get isEnglish => Localizations.localeOf(this).languageCode == 'en';
}

/// ชื่อเมนูและหมวดตามภาษาที่ใช้อยู่ (ข้อมูลใน cafe_core เป็นภาษาไทย)
extension MenuItemL10n on MenuItem {
  String nameFor(BuildContext context) =>
      context.isEnglish ? displayNameEn : name;
}

extension MenuCategoryL10n on MenuCategory {
  String labelFor(BuildContext context) {
    if (!context.isEnglish) return label;
    return switch (this) {
      MenuCategory.coffee => 'Coffee',
      MenuCategory.tea => 'Tea & milk',
      MenuCategory.soda => 'Soda',
      MenuCategory.bakery => 'Bakery',
    };
  }
}
