import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In th, this message translates to:
  /// **'Café Order'**
  String get appTitle;

  /// No description provided for @tabMenu.
  ///
  /// In th, this message translates to:
  /// **'เมนู'**
  String get tabMenu;

  /// No description provided for @tabCart.
  ///
  /// In th, this message translates to:
  /// **'ตะกร้า'**
  String get tabCart;

  /// No description provided for @tabShop.
  ///
  /// In th, this message translates to:
  /// **'ร้าน'**
  String get tabShop;

  /// No description provided for @settings.
  ///
  /// In th, this message translates to:
  /// **'ตั้งค่า'**
  String get settings;

  /// No description provided for @darkMode.
  ///
  /// In th, this message translates to:
  /// **'โหมดมืด'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In th, this message translates to:
  /// **'ภาษา'**
  String get language;

  /// No description provided for @allCategories.
  ///
  /// In th, this message translates to:
  /// **'ทั้งหมด'**
  String get allCategories;

  /// No description provided for @price.
  ///
  /// In th, this message translates to:
  /// **'{price} บาท'**
  String price(int price);

  /// No description provided for @cupSize.
  ///
  /// In th, this message translates to:
  /// **'ขนาดแก้ว'**
  String get cupSize;

  /// No description provided for @sweetness.
  ///
  /// In th, this message translates to:
  /// **'ความหวาน'**
  String get sweetness;

  /// No description provided for @toppings.
  ///
  /// In th, this message translates to:
  /// **'ท็อปปิง'**
  String get toppings;

  /// No description provided for @quantity.
  ///
  /// In th, this message translates to:
  /// **'จำนวน'**
  String get quantity;

  /// No description provided for @cupName.
  ///
  /// In th, this message translates to:
  /// **'ชื่อบนแก้ว *'**
  String get cupName;

  /// No description provided for @note.
  ///
  /// In th, this message translates to:
  /// **'หมายเหตุถึงบาริสต้า'**
  String get note;

  /// No description provided for @lessSugarHint.
  ///
  /// In th, this message translates to:
  /// **'หวานน้อย ดีต่อสุขภาพ'**
  String get lessSugarHint;

  /// No description provided for @addToCart.
  ///
  /// In th, this message translates to:
  /// **'ใส่ตะกร้า · {price} บาท'**
  String addToCart(int price);

  /// No description provided for @addedToCart.
  ///
  /// In th, this message translates to:
  /// **'เพิ่ม {name} ลงตะกร้าแล้ว'**
  String addedToCart(String name);

  /// No description provided for @cartEmpty.
  ///
  /// In th, this message translates to:
  /// **'ตะกร้ายังว่าง'**
  String get cartEmpty;

  /// No description provided for @removeItem.
  ///
  /// In th, this message translates to:
  /// **'ลบ {name}'**
  String removeItem(String name);

  /// No description provided for @checkout.
  ///
  /// In th, this message translates to:
  /// **'สั่งซื้อ · {price} บาท'**
  String checkout(int price);

  /// No description provided for @orderPlaced.
  ///
  /// In th, this message translates to:
  /// **'สั่งซื้อ {id} แล้ว'**
  String orderPlaced(String id);

  /// No description provided for @orderSummary.
  ///
  /// In th, this message translates to:
  /// **'{cups, plural, other{{cups} รายการ}} รวม {price} บาท'**
  String orderSummary(int cups, int price);

  /// No description provided for @ok.
  ///
  /// In th, this message translates to:
  /// **'ตกลง'**
  String get ok;

  /// No description provided for @menuSemantics.
  ///
  /// In th, this message translates to:
  /// **'{name} ราคา {price} บาท'**
  String menuSemantics(String name, int price);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
