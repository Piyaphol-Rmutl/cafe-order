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

  /// No description provided for @orderHistory.
  ///
  /// In th, this message translates to:
  /// **'ประวัติคำสั่งซื้อ'**
  String get orderHistory;

  /// No description provided for @noOrders.
  ///
  /// In th, this message translates to:
  /// **'ยังไม่มีคำสั่งซื้อ'**
  String get noOrders;

  /// No description provided for @historyError.
  ///
  /// In th, this message translates to:
  /// **'โหลดประวัติคำสั่งซื้อไม่สำเร็จ'**
  String get historyError;

  /// No description provided for @receipt.
  ///
  /// In th, this message translates to:
  /// **'ใบเสร็จ'**
  String get receipt;

  /// No description provided for @favorite.
  ///
  /// In th, this message translates to:
  /// **'รายการโปรด'**
  String get favorite;

  /// No description provided for @loadError.
  ///
  /// In th, this message translates to:
  /// **'โหลดเมนูไม่สำเร็จ'**
  String get loadError;

  /// No description provided for @retry.
  ///
  /// In th, this message translates to:
  /// **'ลองอีกครั้ง'**
  String get retry;

  /// No description provided for @orderFailed.
  ///
  /// In th, this message translates to:
  /// **'สั่งซื้อไม่สำเร็จ กรุณาลองใหม่'**
  String get orderFailed;

  /// No description provided for @signIn.
  ///
  /// In th, this message translates to:
  /// **'เข้าสู่ระบบ'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In th, this message translates to:
  /// **'สมัครสมาชิก'**
  String get signUp;

  /// No description provided for @email.
  ///
  /// In th, this message translates to:
  /// **'อีเมล'**
  String get email;

  /// No description provided for @password.
  ///
  /// In th, this message translates to:
  /// **'รหัสผ่าน'**
  String get password;

  /// No description provided for @displayName.
  ///
  /// In th, this message translates to:
  /// **'ชื่อที่แสดง'**
  String get displayName;

  /// No description provided for @signOut.
  ///
  /// In th, this message translates to:
  /// **'ออกจากระบบ'**
  String get signOut;

  /// No description provided for @noAccount.
  ///
  /// In th, this message translates to:
  /// **'ยังไม่มีบัญชี? สมัครสมาชิก'**
  String get noAccount;

  /// No description provided for @haveAccount.
  ///
  /// In th, this message translates to:
  /// **'มีบัญชีแล้ว? เข้าสู่ระบบ'**
  String get haveAccount;

  /// No description provided for @barista.
  ///
  /// In th, this message translates to:
  /// **'บาริสต้า'**
  String get barista;

  /// No description provided for @orderStatus.
  ///
  /// In th, this message translates to:
  /// **'สถานะคำสั่งซื้อ'**
  String get orderStatus;

  /// No description provided for @trackOrder.
  ///
  /// In th, this message translates to:
  /// **'ติดตามสถานะ'**
  String get trackOrder;

  /// No description provided for @noActiveOrders.
  ///
  /// In th, this message translates to:
  /// **'ไม่มีคำสั่งซื้อที่รอทำ'**
  String get noActiveOrders;

  /// No description provided for @orderNotFound.
  ///
  /// In th, this message translates to:
  /// **'ไม่พบคำสั่งซื้อ'**
  String get orderNotFound;

  /// No description provided for @orderStatusError.
  ///
  /// In th, this message translates to:
  /// **'โหลดสถานะคำสั่งซื้อไม่สำเร็จ'**
  String get orderStatusError;

  /// No description provided for @nearestBranch.
  ///
  /// In th, this message translates to:
  /// **'หาสาขาใกล้ฉัน'**
  String get nearestBranch;

  /// No description provided for @findingLocation.
  ///
  /// In th, this message translates to:
  /// **'กำลังหาตำแหน่ง…'**
  String get findingLocation;

  /// No description provided for @openSettings.
  ///
  /// In th, this message translates to:
  /// **'เปิดการตั้งค่า'**
  String get openSettings;

  /// No description provided for @distanceKm.
  ///
  /// In th, this message translates to:
  /// **'{km} กม.'**
  String distanceKm(String km);

  /// No description provided for @review.
  ///
  /// In th, this message translates to:
  /// **'รีวิว'**
  String get review;

  /// No description provided for @takePhoto.
  ///
  /// In th, this message translates to:
  /// **'ถ่ายภาพ'**
  String get takePhoto;

  /// No description provided for @pickPhoto.
  ///
  /// In th, this message translates to:
  /// **'เลือกจากคลังภาพ'**
  String get pickPhoto;

  /// No description provided for @photoError.
  ///
  /// In th, this message translates to:
  /// **'เปิดกล้องหรือคลังภาพไม่ได้ ตรวจสอบสิทธิ์ในการตั้งค่า'**
  String get photoError;

  /// No description provided for @comment.
  ///
  /// In th, this message translates to:
  /// **'ความเห็น'**
  String get comment;

  /// No description provided for @saveReview.
  ///
  /// In th, this message translates to:
  /// **'บันทึกรีวิว'**
  String get saveReview;

  /// No description provided for @reviewSaved.
  ///
  /// In th, this message translates to:
  /// **'บันทึกรีวิวแล้ว'**
  String get reviewSaved;

  /// No description provided for @points.
  ///
  /// In th, this message translates to:
  /// **'แต้มสะสม {points} แต้ม'**
  String points(int points);

  /// No description provided for @forYou.
  ///
  /// In th, this message translates to:
  /// **'แนะนำสำหรับคุณ'**
  String get forYou;

  /// No description provided for @aiSimulated.
  ///
  /// In th, this message translates to:
  /// **'AI (จำลอง)'**
  String get aiSimulated;

  /// No description provided for @tryIt.
  ///
  /// In th, this message translates to:
  /// **'ลองเลย'**
  String get tryIt;
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
