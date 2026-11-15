// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Café Order';

  @override
  String get tabMenu => 'Menu';

  @override
  String get tabCart => 'Cart';

  @override
  String get tabShop => 'Shop';

  @override
  String get settings => 'Settings';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get language => 'Language';

  @override
  String get allCategories => 'All';

  @override
  String price(int price) {
    return '฿$price';
  }

  @override
  String get cupSize => 'Cup size';

  @override
  String get sweetness => 'Sweetness';

  @override
  String get toppings => 'Toppings';

  @override
  String get quantity => 'Quantity';

  @override
  String get cupName => 'Name on cup *';

  @override
  String get note => 'Note to barista';

  @override
  String get lessSugarHint => 'Less sugar, healthier choice';

  @override
  String addToCart(int price) {
    return 'Add to cart · ฿$price';
  }

  @override
  String addedToCart(String name) {
    return 'Added $name to cart';
  }

  @override
  String get cartEmpty => 'Your cart is empty';

  @override
  String removeItem(String name) {
    return 'Remove $name';
  }

  @override
  String checkout(int price) {
    return 'Order · ฿$price';
  }

  @override
  String orderPlaced(String id) {
    return 'Order $id placed';
  }

  @override
  String orderSummary(int cups, int price) {
    String _temp0 = intl.Intl.pluralLogic(
      cups,
      locale: localeName,
      other: '$cups items',
      one: '1 item',
    );
    return '$_temp0, total ฿$price';
  }

  @override
  String get ok => 'OK';

  @override
  String menuSemantics(String name, int price) {
    return '$name, $price baht';
  }
}
