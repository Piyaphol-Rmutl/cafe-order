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

  @override
  String get orderHistory => 'Order history';

  @override
  String get noOrders => 'No orders yet';

  @override
  String get historyError => 'Could not load order history';

  @override
  String get receipt => 'Receipt';

  @override
  String get favorite => 'Favorite';

  @override
  String get loadError => 'Could not load the menu';

  @override
  String get retry => 'Retry';

  @override
  String get orderFailed => 'Order failed, please try again';

  @override
  String get signIn => 'Sign in';

  @override
  String get signUp => 'Sign up';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get displayName => 'Display name';

  @override
  String get signOut => 'Sign out';

  @override
  String get noAccount => 'No account? Sign up';

  @override
  String get haveAccount => 'Have an account? Sign in';

  @override
  String get barista => 'Barista';

  @override
  String get orderStatus => 'Order status';

  @override
  String get trackOrder => 'Track order';

  @override
  String get noActiveOrders => 'No active orders';

  @override
  String get orderNotFound => 'Order not found';

  @override
  String get orderStatusError => 'Could not load the order status';

  @override
  String get nearestBranch => 'Find nearest branch';

  @override
  String get findingLocation => 'Finding your location…';

  @override
  String get openSettings => 'Open settings';

  @override
  String distanceKm(String km) {
    return '$km km';
  }

  @override
  String get review => 'Review';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get pickPhoto => 'Choose from library';

  @override
  String get photoError =>
      'Could not open the camera or photo library. Check permissions in Settings';

  @override
  String get comment => 'Comment';

  @override
  String get saveReview => 'Save review';

  @override
  String get reviewSaved => 'Review saved';

  @override
  String points(int points) {
    return '$points points';
  }

  @override
  String get forYou => 'Picked for you';

  @override
  String get aiSimulated => 'AI (simulated)';

  @override
  String get tryIt => 'Try it';
}
