# Café Order — แอปประกอบการบรรยาย ENGCE307 (บันทึกรายสัปดาห์)

แอปสั่งเครื่องดื่มร้านกาแฟของคณะ พัฒนาต่อยอดทีละสัปดาห์ ทุกสัปดาห์มีแท็ก `wNN` ที่ผ่าน `flutter analyze` (ไม่มี issue) และชุดทดสอบสะสมทั้งหมด เอกสารนี้ใช้ตอนแก้เอกสารรายสัปดาห์: บอกว่าแต่ละหัวข้อบรรยายยกโค้ดจากไฟล์/คลาสใด

## การใช้งานทั่วไป

```bash
git checkout w07                       # เปิดแอป ณ สัปดาห์ใดก็ได้
flutter pub get
flutter run -d "iPhone 18 Pro"         # หรือ Pixel_10_Pro_XL
```

- พาธของโฟลเดอร์นี้มีอักษรไทย ทำให้ `flutter analyze` และ build iOS ล้ม ให้คัดลอกไปพาธ ASCII ก่อน (ดู `weekly/SPEC.md` หัวข้อการทดสอบโค้ด) — `flutter test` ใช้ในพาธเดิมได้
- จุดสาธิตที่ไม่ใช่ส่วนของแอปจริงอยู่ใน `lib/demos/wNN_*.dart` เปิดจากปุ่ม "เมนูผู้พัฒนา" (ไอคอน developer_mode บนแถบด้านบน) รายการทั้งหมดอยู่ใน `lib/demos/demo_menu.dart`
- เมนูผู้พัฒนาใช้ `Navigator.push` ตั้งแต่สัปดาห์ 1 (เป็นเครื่องมือของผู้สอน ไม่ใช่เนื้อหา)
- `packages/cafe_core/` เป็นแพ็กเกจ Dart ล้วน ทดสอบด้วย `dart test` ในโฟลเดอร์นั้น
- ภาพหน้าจอทุกภาพไม่มีป้าย DEBUG (`debugShowCheckedModeBanner: false` ใน `lib/main.dart`)
- เครื่องมือ: Flutter 3.47.6 / Dart 3.13.5, iOS Simulator iPhone 18 Pro (iOS 27.2), Firebase CLI 15.36

### จำนวนเทสต์สะสม (แอป + cafe_core)

| แท็ก | แอป (`flutter test`) | cafe_core (`dart test`) | อื่น ๆ |
|---|---|---|---|
| w01 | 3 | – | |
| w02 | 3 | 11 | |
| w03 | 4 | 11 | |
| w04 | 8 | 11 | |
| w05 | 16 | 11 | |
| w06 | 24 | 11 | |
| w07 | 33 | 11 | |
| w08 | 42 | 11 | |
| w10 | 56 | 12 | |
| w11 | 67 | 12 | |
| w12 | 77 | 12 | rules_check 11 กรณี, integration_test/emulator_test.dart 1 |
| w13 | 88 | 14 | integration_test/device_test.dart 2 |
| w14 | 96 | 14 | integration_test/app_test.dart 1 (iOS + Android) |
| w15 | 103 | 14 | release APK ลงนามแล้ว |
| w16 | 109 | 16 | |

ชื่อไฟล์เทสต์บอกสัปดาห์ที่เพิ่ม (`test/wNN_*.dart`) ตัวช่วยร่วม: `test/helpers.dart` (`testApp()`, `cafeApp()`), `test/fakes.dart` (Repository/Service ปลอม), `test/server.dart` (MockClient ต่อกับเซิร์ฟเวอร์จำลอง), `test/flutter_test_config.dart` (จอทดสอบ 390×844)

---

## สัปดาห์ 1 — แท็ก `w01` เครื่องมือ

ฟีเจอร์: `flutter create --org th.ac.rmutl.engce307 --platforms android,ios cafe_order`, หน้าว่าง "เร็ว ๆ นี้", ปุ่มเมนูผู้พัฒนา

| หัวข้อบรรยาย | จุดสาธิต |
|---|---|
| อุปกรณ์เคลื่อนที่/วงจรชีวิตแอป | `lib/demos/w01_lifecycle.dart` `LifecycleDemo` (AppLifecycleListener บันทึก resumed → inactive → hidden → paused) |
| Native/Web/Hybrid/Cross-platform | เชิงแนวคิด (ไม่มีโค้ด) |
| สถาปัตยกรรม Flutter และเครื่องมือ | `lib/main.dart` (`main` → `runApp` → `CafeOrderApp` → `MaterialApp`), `lib/demos/w01_hot_reload.dart` `HotReloadDemo` (สถานะคงอยู่เมื่อ Hot Reload, หายเมื่อ Hot Restart) |

- รัน: `flutter run` แล้วกด Home/สลับแอปในหน้า "วงจรชีวิตของแอป"
- ทดสอบ: 3 เทสต์ (`test/w01_app_test.dart`) จำลองสถานะด้วย `handleAppLifecycleStateChanged`
- ยังไม่ได้ทดสอบ: การสลับแอปจริงบนเครื่องจำลอง (ทดสอบผ่านเทสต์วิดเจ็ตเท่านั้น), การติดตั้งเครื่องมือบน Windows/Linux

## สัปดาห์ 2 — แท็ก `w02` ภาษา Dart

ฟีเจอร์: แพ็กเกจ `packages/cafe_core` (Dart ล้วน, `dart create -t package`)

| หัวข้อบรรยาย | จุดสาธิต |
|---|---|
| ชนิดข้อมูล ตัวแปร Null Safety ฟังก์ชัน | `src/menu_item.dart` `MenuItem` (`nameEn` เป็น `String?`, `displayNameEn` ใช้ `??`, factory `fromJson`), พารามิเตอร์ระบุชื่อใน `OrderItem(...)` |
| คอลเลกชันและ OOP | `groupByCategory()` (Map), `OrderItem.toppings` (Set), enum มีฟิลด์ `CupSize`/`Sweetness`/`MenuCategory`, `src/priced.dart` mixin `Priced`, `src/promotion.dart` คลาสนามธรรม `Promotion` → `PercentOff`, `CupsDiscount` (สืบทอด), `Order.summary` คืน Record `({int cups, int total})` |
| อะซิงโครนัส | `src/menu_loader.dart` `loadMenu()` (Future + async/await), `simulateOrderProgress()` (Stream ด้วย async* / yield) |

- รัน: `cd packages/cafe_core && dart run example/cafe_core_example.dart` (พิมพ์เมนูตามหมวด ยอดรวม โปรโมชัน และสถานะทีละขั้น)
- ทดสอบ: `dart test` 11 เทสต์
- หมายเหตุ: ราคาเป็นจำนวนเต็ม (บาท) เลี่ยงทศนิยม; สัปดาห์ต่อมามีการเพิ่มใน core คือ `cupName` (w05), JSON ของ Order (w10), `Branch` (w11), `geo.dart` (w13), `recommendation.dart` (w16)

## สัปดาห์ 3 — แท็ก `w03` วิดเจ็ตและแอสเซต

ฟีเจอร์: หน้าแรกของร้าน (โลโก้ ชื่อร้าน ข้อมูลร้าน เมนูแนะนำจาก `cafe_core`)

| หัวข้อบรรยาย | จุดสาธิต |
|---|---|
| วิดเจ็ตและต้นไม้วิดเจ็ต | `lib/ui/home/home_page.dart` `HomePage` (Scaffold → AppBar + ListView → Image, Text, InfoRow, Card) |
| pubspec.yaml และ StatelessWidget | `pubspec.yaml` (path dependency `cafe_core`, `assets:`), `lib/ui/home/info_row.dart` `InfoRow` (วิดเจ็ตที่สร้างเอง) |
| Text, Icon, Image, แอสเซต | `Image.asset('assets/images/logo.png')`, `Icon(Icons.schedule)`, `Theme.of(context).textTheme` |

- ทดสอบ: 4 เทสต์ (`test/w03_home_test.dart` ตรวจ AssetImage และจำนวน InfoRow)
- หมายเหตุ: สัปดาห์ 6 ย้าย `ui/home/` → `ui/shop/` (`ShopPage`, `ShopHeader`) ภาพโลโก้/เมนูวาดด้วย Python (PIL) เอง ไม่มีลิขสิทธิ์ผู้อื่น

## สัปดาห์ 4 — แท็ก `w04` เลย์เอาต์

ฟีเจอร์: รายการเมนูพร้อมรูป (ส่วนหัวร้านเป็นแถวแรกของรายการ), การ์ดกริด

| หัวข้อบรรยาย | จุดสาธิต |
|---|---|
| Constraints / Overflow | `lib/demos/w04_layout.dart` `BrokenMenuRow` (ล้น) เทียบ `FixedMenuRow` (Expanded), กล่อง 300×80 ที่ถูกบังคับเต็มกว้าง vs ห่อด้วย Center |
| ลูกเดียว/หลายลูก, Stack | `lib/ui/menu/menu_card.dart` `MenuTile` (Row + Expanded + Padding), `MenuGridCard` (Column + Expanded + Stack + Positioned ป้ายหมวด) |
| ListView.builder / GridView | `lib/ui/menu/menu_list.dart` `MenuList`, `MenuGrid` (`SliverGridDelegateWithMaxCrossAxisExtent`) |

- ทดสอบ: 8 เทสต์ (`test/w04_layout_test.dart` ตรวจว่า Broken ล้นด้วย `takeException()` และ Fixed ไม่ล้น)
- เครื่องจำลอง: รันบน iPhone 18 Pro แล้ว (`docs/screens/w04_menu_list.png`)

## สัปดาห์ 5 — แท็ก `w05` รับข้อมูลและ StatefulWidget

ฟีเจอร์: หน้าปรับแต่งเครื่องดื่ม (เปิดด้วย `Navigator.push` แบบย่อ อธิบายละเอียดในสัปดาห์ 6)

| หัวข้อบรรยาย | จุดสาธิต |
|---|---|
| StatefulWidget, setState, วงจรชีวิต State | `lib/ui/customize/customize_page.dart` `CustomizePage`/`_CustomizePageState` (ราคาบนปุ่มคำนวณใหม่ทุก setState, dispose controller); `lib/demos/w05_state_lifecycle.dart` `StateLifecycleDemo` แสดงลำดับ createState → initState → didChangeDependencies → build → didUpdateWidget → deactivate → dispose |
| ปุ่ม ท่าทาง | `MenuTile` ใช้ `InkWell` (แตะ = เปิดหน้า, กดค้าง = BottomSheet), `lib/demos/w05_gestures.dart` `GestureDemo` (แตะ แตะสองครั้ง กดค้าง ปัด) |
| ฟอร์มและการตรวจข้อมูล | `Form` + `TextFormField` (ชื่อบนแก้ว บังคับ, หมายเหตุ ≤ 50), `lib/ui/customize/validators.dart`, SegmentedButton, ChoiceChip, CheckboxListTile, IconButton ที่ปิดได้ (`onPressed: null`) |

- ทดสอบ: 16 เทสต์
- ข้อค้นพบที่ใช้สอนได้: ฟอร์มใน `ListView` (lazy) ช่องที่ยังไม่ถูกสร้างจะไม่ถูก `validate()` จึงใช้ `SingleChildScrollView` + `Column`; การ log ใน `createState` ต้องปิด lint `no_logic_in_create_state` (เพื่อการสาธิตเท่านั้น)

## สัปดาห์ 6 — แท็ก `w06` นำทางและ Responsive

ฟีเจอร์: go_router โครงแท็บ เมนู/ตะกร้า/ร้าน, หน้าตะกร้าและสั่งซื้อ (กล่องยืนยัน), Drawer

| หัวข้อบรรยาย | จุดสาธิต |
|---|---|
| Navigator แบบสแตก | `lib/demos/w06_navigator.dart` `NavigatorDemo` → `SizePickerPage` (`await push<CupSize>` / `pop(size)`), ในแอป: `MenuPage._open` ใช้ `await context.push<OrderItem>('/menu/:id')` และ `CustomizePage._submit` → `Navigator.pop(item)` |
| go_router, NavigationBar, Drawer, TabBar | `lib/router.dart` `createRouter()` (ShellRoute, `/menu/:id` บน root navigator, NotFoundPage), `lib/ui/shell/app_shell.dart` `AppShell` + `_AppDrawer`, `lib/ui/menu/menu_page.dart` (DefaultTabController แยกหมวด) |
| Adaptive/Responsive, Sliver | `AppShell` (MediaQuery ≥ 840 → NavigationRail), `_MenuBody` (LayoutBuilder: < 600 รายการ, 600–899 กริด, ≥ 900 กริด + บานปรับแต่งด้านขวา), `lib/ui/shop/shop_page.dart` (CustomScrollView + SliverAppBar.large + SliverToBoxAdapter + SliverList) |

- สถานะตะกร้าเป็น `List<OrderItem>` ที่รากของแอปส่งผ่าน router (ยกสถานะขึ้น) ยังไม่มี badge — ลบในหน้าตะกร้าแล้วหน้าอื่นไม่รู้ = ปัญหาที่สัปดาห์ 8 แก้
- ทดสอบ: 24 เทสต์ (`test/w06_navigation_test.dart` จอแคบ/กว้างด้วย `tester.view.physicalSize`)
- ข้อค้นพบ: `InfoRow` ล้นในจอแคบ (แก้ด้วย Expanded) — เทสต์จับได้; จอทดสอบเริ่มต้น 800×600 ตกช่วงกริด จึงตั้ง 390×844 ใน `test/flutter_test_config.dart`

## สัปดาห์ 7 — แท็ก `w07` ธีม แอนิเมชัน การเข้าถึง

ฟีเจอร์: ธีมสว่าง/มืด, ภาษาไทย/อังกฤษ, หน้าตั้งค่า (`/settings` ใน Drawer)

| หัวข้อบรรยาย | จุดสาธิต |
|---|---|
| Material 3 / Cupertino / ธีม | `lib/theme.dart` `buildTheme()` (ColorScheme.fromSeed สีน้ำตาลกาแฟ), `lib/ui/settings/settings_page.dart` (`SwitchListTile.adaptive`), `lib/demos/w07_cupertino.dart` `CupertinoDemo` |
| Implicit / Explicit, Hero | `CupPreview` (AnimatedContainer ความสูงแก้ว), AnimatedOpacity คำแนะนำหวานน้อย ใน `customize_page.dart`; `lib/ui/widgets/brewing_indicator.dart` `BrewingIndicator` (AnimationController + SlideTransition/FadeTransition) และ `lib/demos/w07_animation.dart` (เล่น/หยุด/ย้อน); Hero `menu-{id}` ใน `lib/ui/menu/menu_image.dart` |
| Semantics, ขนาดตัวอักษร, หลายภาษา | `MenuTile` ห่อ `Semantics(button: true, label: 'ลาเต้ ราคา 55 บาท', excludeSemantics: true)`, รูปประกอบ `excludeFromSemantics`; `l10n.yaml`, `lib/l10n/app_th.arb` (ต้นแบบ) / `app_en.arb` (plural ใน `orderSummary`), `lib/ui/l10n_ext.dart` (`context.l10n`, `nameFor`) |

- ทดสอบ: 33 เทสต์ (`matchesSemantics`, textScaler 2.0 ไม่ล้น, ค่าความสูงกลางแอนิเมชัน)
- ข้อจำกัด: ชื่อท็อปปิง สถานะคำสั่งซื้อ และข้อความ validator อยู่ใน cafe_core/ภาษาไทย ไม่เปลี่ยนเมื่อเลือก English; Hero ปิดในโหมดสองบาน (tag ซ้ำ)
- เคล็ดลับเทสต์: แอนิเมชันต้อง `pump()` หนึ่งครั้งก่อน `pump(duration)`

## สัปดาห์ 8 — แท็ก `w08` การจัดการสถานะ

ฟีเจอร์: badge จำนวนแก้วบนแท็บตะกร้า, ปัดเพื่อลบ, ปุ่มลดจำนวน

| หัวข้อบรรยาย | จุดสาธิต |
|---|---|
| Ephemeral vs App State, Lifting State Up | เทียบ `git diff w07 w08 -- lib/main.dart lib/router.dart`: ตะกร้าเลิกเป็น List ที่ราก; ฟอร์มใน `CustomizePage` และ `_MenuBody._selected` ยังเป็นสถานะชั่วคราว |
| ChangeNotifier, ListenableBuilder, InheritedWidget | `lib/state/cart_model.dart` `CartModel` (items อ่านอย่างเดียว + notifyListeners), `lib/state/settings_model.dart`; `lib/demos/w08_listenable_builder.dart` (สองกิ่งฟังโมเดลเดียว), `lib/demos/w08_inherited.dart` `ShopScope` |
| provider | `lib/main.dart` MultiProvider + ChangeNotifierProvider, `app_shell.dart` `context.select<CartModel,int>` (badge), `cart_page.dart` `context.watch`, `menu_page.dart` `context.read` |

- ทดสอบ: 42 เทสต์ (นับจำนวนครั้งที่แจ้งผู้ฟัง, `items` แก้จากภายนอกไม่ได้, badge อัปเดต)
- หมายเหตุ: สัปดาห์ 10 ย้าย `lib/state/*` ไปเป็น `ui/cart/cart_view_model.dart` และ `ui/settings/settings_view_model.dart` (ในเอกสารสัปดาห์ 8 ให้ยกโค้ดจากแท็ก w08)

## สัปดาห์ 10 — แท็ก `w10` สถาปัตยกรรมและการเก็บข้อมูล

ฟีเจอร์: ประวัติคำสั่งซื้อ (Drawer → `/orders`) พร้อมใบเสร็จ, รายการโปรด (หัวใจ + แท็บ), ค่าตั้งคงอยู่หลังปิดแอป, สถานะ กำลังโหลด/ผิดพลาด/ลองอีกครั้ง

| หัวข้อบรรยาย | จุดสาธิต |
|---|---|
| MVVM, Single Source of Truth | `lib/main.dart` (composition root), `lib/app_dependencies.dart` `AppDependencies`/`buildApp()`, `ui/menu/menu_view_model.dart` (loading/error/items, optimistic toggleFavorite), `ui/cart/cart_view_model.dart`, `ui/orders/order_history_view_model.dart` + `order_history_page.dart`, Repository เป็น `abstract interface class` |
| shared_preferences และไฟล์ | `data/services/prefs_service.dart`, `data/repositories/settings_repository.dart`, `ui/settings/settings_view_model.dart`; `data/services/file_service.dart` (path_provider) เขียน `receipts/{id}.txt` |
| SQLite | `data/services/database_service.dart` (ตาราง `orders`, `favorites`), `data/repositories/order_repository.dart` `LocalOrderRepository` (`toRow`/`fromRow`), `favorite_repository.dart` |

- ทดสอบ: 56 เทสต์ — ชั้นข้อมูลกับ SQLite จริงผ่าน `sqflite_common_ffi` และไฟล์ในโฟลเดอร์ชั่วคราว, ViewModel กับ Repository ปลอม (`test/fakes.dart`)
- เครื่องจำลอง: รันบน iOS แล้ว ฐานข้อมูลเปิดได้
- การเปลี่ยนเทสต์สะสม: เทสต์สัปดาห์ 8 เปลี่ยนเป็น `CartViewModel`; `cafeApp()` เป็น async และต้อง `pumpAndSettle()` รอเมนูโหลด

## สัปดาห์ 11 — แท็ก `w11` เครือข่ายและเว็บเซอร์วิส

ฟีเจอร์: เมนูและสาขามาจากเซิร์ฟเวอร์ คำสั่งซื้อส่งด้วย POST แล้วเก็บประวัติในเครื่อง

| หัวข้อบรรยาย | จุดสาธิต |
|---|---|
| HTTP/REST | `tool/mock_server.dart` (shelf): `GET /menu`, `GET /branches`, `POST /orders` (201, เซิร์ฟเวอร์คิดราคาเอง), `GET /orders/{id}`, 400/404/500, `--delay`, `--fail` |
| http + JSON | `data/services/api_service.dart` `ApiService` (`getJson`/`postJson`, ถอด UTF-8 เอง), `data/repositories/menu_repository.dart` `ApiMenuRepository`, `branch_repository.dart`, `order_repository.dart` `ApiOrderRepository`, `MenuItem.fromJson` ใน cafe_core |
| FutureBuilder, ข้อผิดพลาด, Timeout | `lib/ui/shop/shop_page.dart` `_ShopPageState` (FutureBuilder สาขา + ลองอีกครั้ง), `data/services/api_exception.dart`, `timeout()` + `TimeoutException` ใน ApiService, `lib/config.dart` (`API_BASE_URL`, 10.0.2.2 สำหรับ Android) |

- รัน: `dart run tool/mock_server.dart` แล้ว `flutter run`
- ทดสอบ: 67 เทสต์ (`test/w11_api_test.dart` ใช้ `test/server.dart` ต่อ MockClient เข้ากับ Handler ของเซิร์ฟเวอร์จำลองโดยตรง)
- เครื่องจำลอง: iOS เรียก `GET /menu` จากเซิร์ฟเวอร์จำลองสำเร็จ (`docs/screens/w11_menu_from_server.png`)
- ข้อค้นพบที่ใช้สอนได้: `setState(() => _future = ...)` คืน Future ทำให้ error (ใช้วงเล็บปีกกา); FutureBuilder ใน SliverList ถูกสร้างช้า ถ้า Future ล้มเหลวก่อนจะเป็น unhandled error จึงเรียก `future.ignore()`
- Android Emulator กับเซิร์ฟเวอร์จำลอง (`10.0.2.2:8080`) ทดสอบแล้วตอนแก้เอกสารสัปดาห์ 11 (17 พ.ย. 2569)

## สัปดาห์ 12 — แท็ก `w12` Firebase

ฟีเจอร์: ล็อกอิน/สมัครด้วยอีเมล, หลังสั่งซื้อไปหน้าติดตามสถานะเรียลไทม์, หน้าบาริสต้า (บัญชี `@barista.test`), ออกจากระบบ

| หัวข้อบรรยาย | จุดสาธิต |
|---|---|
| BaaS และ Firebase | `firebase.json` (auth 9199, firestore 8180, ui 4100), `.firebaserc` (`demo-cafe-order`), `data/services/firebase_setup.dart` `initFirebase()` (demoProjectId + useAuthEmulator/useFirestoreEmulator) — ไม่ใช้ FlutterFire CLI/บัญชีจริง (อธิบายเชิงแนวคิด) |
| การยืนยันตัวตน | `data/services/auth_service.dart` (`AuthService`, `FirebaseAuthService`, `authMessage()`), `ui/auth/auth_view_model.dart`, `ui/auth/login_page.dart`, AuthGate = `redirect` + `refreshListenable` ใน `lib/router.dart` |
| Firestore, StreamBuilder, Security Rules | `data/repositories/firestore_order_repository.dart` (set/snapshots/where/update), `live_order_repository.dart`, `ui/orders/order_status_page.dart`, `ui/barista/barista_page.dart`, `firestore.rules`, `tool/rules_check.dart` |

- รัน: `firebase emulators:start --project demo-cafe-order` (+ เซิร์ฟเวอร์จำลอง) แล้ว `flutter run`
- ทดสอบ: 77 เทสต์ (`fake_cloud_firestore`, `FakeAuthService`), `firebase emulators:exec --project demo-cafe-order "dart run tool/rules_check.dart"` ผ่าน 11/11 กรณี, `integration_test/emulator_test.dart` ผ่านบน iOS 27.2 (ลูกค้าสั่ง → ลูกค้าแก้สถานะเองไม่ได้ → บาริสต้าแก้ → ลูกค้าเห็น)
- ข้อค้นพบ: `Order` ชื่อชนกับคลาสใน cloud_firestore → `hide Order`; `flutter test integration_test` เขียนทับ Runner.app ต้อง build ใหม่ก่อนเปิดแอปเอง; ผู้ใช้ค้างใน keychain ของ Simulator ข้ามการรีสตาร์ต Emulator
- ยังไม่ได้ทดสอบ: Firebase จริงบนคลาวด์ (ข้อห้าม), Android กับ Emulator ของ Firebase (มี network_security_config สำหรับ debug แล้ว), Custom Claims
- หมายเหตุออกแบบ: บาริสต้ากำหนดจากโดเมนอีเมล (สาธิต) ระบบจริงใช้ Custom Claims; สถานะในประวัติ SQLite ไม่อัปเดตตาม Firestore

## สัปดาห์ 13 — แท็ก `w13` ฮาร์ดแวร์และแพลตฟอร์ม

ฟีเจอร์: ร้าน → หาสาขาใกล้ฉัน, ประวัติ → รีวิวพร้อมภาพ, เครื่องสั่นเมื่อคำสั่งซื้อพร้อมรับ

| หัวข้อบรรยาย | จุดสาธิต |
|---|---|
| แพ็กเกจจาก pub.dev | `pubspec.yaml` (geolocator, image_picker, sensors_plus) — เกณฑ์เลือกเป็นเนื้อหาเชิงแนวคิด |
| สิทธิ์และความเป็นส่วนตัว | `android/app/src/main/AndroidManifest.xml` (FINE/COARSE_LOCATION, VIBRATE), `ios/Runner/Info.plist` (NSLocationWhenInUse, NSCamera, NSPhotoLibrary, NSMotion), `data/services/location_service.dart` (ตรวจบริการ → ขอสิทธิ์ → deniedForever → `openAppSettings`), `photo_service.dart` (`requestFullMetadata: false` ไม่เอา EXIF พิกัด) |
| กล้อง ตำแหน่ง เซนเซอร์ | `ui/branches/nearest_branch_view_model.dart` + `nearest_branch_page.dart`, `cafe_core/src/geo.dart` (Haversine, Record), `ui/review/review_page.dart` + `data/repositories/review_repository.dart` (คัดลอกภาพมาเก็บถาวร), `lib/demos/w13_sensors.dart` `SensorsDemo` |
| Platform Channels | `data/services/device_channel.dart` `CafeDeviceChannel` (`vibrate`, `batteryLevel`), `android/.../MainActivity.kt`, `ios/Runner/AppDelegate.swift` (ลงทะเบียนใน `didInitializeImplicitFlutterEngine`), `lib/demos/w13_device_channel.dart`, ใช้จริงใน `order_status_page.dart` |

- รัน (iOS): `xcrun simctl location booted set 18.8030,98.9510`; (Android): `adb emu geo fix 98.9510 18.8030`
- ทดสอบ: 88 เทสต์ (`setMockMethodCallHandler`, FakeLocationService, FakePhotoService, Stream เซนเซอร์ปลอม), `integration_test/device_test.dart` ผ่านบน iOS 27.2 (ได้ "สาขาหอพักนักศึกษา 24 ม.", vibrate = true, แบตเตอรี่ = null บน Simulator), `flutter build apk --debug` ผ่าน (Kotlin คอมไพล์ได้)
- ยังไม่ได้ทดสอบ: กล้อง/คลังภาพจริง (ผ่าน Service ปลอมเท่านั้น), เซนเซอร์บนเครื่อง (iOS Simulator ไม่มี), MethodChannel บน Android Emulator, การสั่นบนเครื่องจริง
- ข้อค้นพบ: ReviewPage ที่เปิดตรงจากลิงก์แล้ว pop หน้าสุดท้าย → ใช้ `context.canPop() ? pop() : go('/orders')`

## สัปดาห์ 14 — แท็ก `w14` ดีบักและทดสอบ

ฟีเจอร์: ไม่มีฟีเจอร์ผู้ใช้ใหม่ (แก้บั๊ก SnackBar บังปุ่มสั่งซื้อ)

| หัวข้อบรรยาย | จุดสาธิต |
|---|---|
| เครื่องจำลอง, Breakpoint, Logging, DevTools | `lib/demos/w14_debugging.dart` `BuggyCart` (บั๊กฝัง 2 จุด พร้อมตำแหน่งตั้ง Breakpoint) + สวิตช์ `debugPaintSizeEnabled`; `developer.log` ชื่อ `cafe.api` (`api_service.dart` เวลา/รหัสสถานะ) และ `cafe.cart` (`cart_view_model.dart`) |
| Unit/Widget Test และ Mock | `test/w14_mock_test.dart` (mocktail: `when`/`verify`/`registerFallbackValue`, กดสั่งซ้ำส่งครั้งเดียว, rollback รายการโปรด), ชุดเทสต์ทั้งหมด `test/` |
| Integration Test | `integration_test/app_test.dart` (ล็อกอิน → ลาเต้ L → ตะกร้า → สั่งซื้อ → สถานะพร้อมรับ) ใช้ Repository ปลอม ไม่ต้องมีเซิร์ฟเวอร์ |

- รัน: `flutter test integration_test/app_test.dart -d <เครื่องจำลอง>`
- ทดสอบ: 96 เทสต์; Integration Test ผ่านทั้ง iPhone 18 Pro (iOS 27.2) และ Android Emulator (emulator-5554)
- บั๊กจริงที่ Integration Test เจอ (ใช้เป็นตัวอย่างในบทเรียนได้): SnackBar "เพิ่มลงตะกร้าแล้ว" ค้างบังปุ่มสั่งซื้อเมื่อสลับแท็บ — Widget Test เดิมไม่เจอเพราะรอ 5 วินาที → แก้ด้วย `hideCurrentSnackBar()` ใน `AppShell._go` + เทสต์ป้องกันใน `w14_mock_test.dart`
- ยังไม่ได้ทดสอบ: การใช้ DevTools/Breakpoint แบบโต้ตอบ (ต้องใช้ IDE), `binding.takeScreenshot` (ต้อง `flutter drive`)

## สัปดาห์ 15 — แท็ก `w15` ประสิทธิภาพ ความปลอดภัย การเผยแพร่

ฟีเจอร์: แต้มสะสมในหน้าร้าน, ชื่อแอป "Café Order", version 1.0.0

| หัวข้อบรรยาย | จุดสาธิต |
|---|---|
| Profile mode, Jank | `lib/demos/w15_jank.dart` `SlowRow` (ภาพเต็ม 800 px, งานหนักใน build, Opacity) vs `FastRow` + Performance Overlay; ในแอป `menu_image.dart` ใช้ `cacheWidth` (216 px แทน 800) |
| OWASP MASVS, secure storage, HTTPS, ไม่ฝังคีย์ | `data/services/token_store.dart` (`SecureTokenStore` = flutter_secure_storage), `ApiService.getJsonAuthorized()` (ลงทะเบียนเครื่อง `POST /devices` → Bearer token, 401 → ขอใหม่), `data/repositories/loyalty_repository.dart`, `lib/config.dart` (`--dart-define=API_BASE_URL=https://...`) |
| APK/AAB/IPA และการลงนาม | `android/app/build.gradle.kts` (signingConfigs อ่าน `key.properties`), `android/key.properties.example`, `.gitignore` (`*.jks`, `key.properties`), INTERNET permission ใน manifest หลัก |

- รัน: `flutter build apk --release --obfuscate --split-debug-info=build/symbols`
- ทดสอบ: 103 เทสต์; release APK 56.1 MB ลงนามด้วย keystore ทดสอบ (สร้างด้วย keytool นอก repo, ตรวจด้วย `apksigner verify --print-certs`: CN=ENGCE307 Test) ติดตั้งและเปิดบน Android Emulator ถึงหน้าล็อกอิน (`docs/screens/w15_release_android_login.png`)
- ยังไม่ได้ทดสอบ: Profile mode/DevTools Performance (ต้องใช้เครื่องจริง), AAB, IPA และการลงนาม iOS (ต้องมีบัญชี Apple Developer), การอัปโหลดขึ้นสโตร์
- ข้อจำกัด: release ยังชี้ Firebase Emulator และ HTTP ในเครื่อง (Android release บล็อก cleartext) — ใช้สาธิตขั้นตอน build/ลงนามเท่านั้น

## สัปดาห์ 16 — แท็ก `w16` แนวโน้มและการบูรณาการ

ฟีเจอร์: การ์ด "แนะนำสำหรับคุณ" บนหน้าเมนู (AI จำลอง พร้อมเหตุผล), README พร้อมขั้นตอนสาธิตและรายการตรวจ Usability

| หัวข้อบรรยาย | จุดสาธิต |
|---|---|
| แนวโน้ม (AI ในแอป) | `data/services/recommender.dart`: อินเทอร์เฟซ `MenuRecommender`, `FakeRecommender` (กฎ ไม่มีเครือข่าย ไม่มีคีย์), `ApiRecommender` (รูปแบบที่ถูกต้อง: แอป → เซิร์ฟเวอร์ของเรา `POST /recommend` → ผู้ให้บริการ AI), `buildRecommendationPrompt()` (บทบาท ข้อจำกัด รูปแบบ JSON ไม่ส่งข้อมูลส่วนตัว); `cafe_core/src/recommendation.dart` `recommendByRules()` |
| การบูรณาการองค์ประกอบ | `ui/recommendation/recommendation_card.dart` รวม REST (เมนู) + SQLite (ประวัติ รายการโปรด) + AI + provider; AI ล้มเหลว → ซ่อนการ์ด แอปยังใช้ได้ |
| การนำเสนอและประเมิน | `README.md` (สถาปัตยกรรม ขั้นตอนสาธิต 6 ขั้น รายการตรวจ Usability), แท็ก Git รายสัปดาห์ |

- ทดสอบ: 109 เทสต์ + cafe_core 16; Integration Test (`app_test.dart`) ผ่านบน iOS อีกครั้ง; รันบน iOS กับเซิร์ฟเวอร์จำลองแล้ว (`docs/screens/w16_recommendation.png`)
- ยังไม่ได้ทดสอบ: โมเดล AI จริง (ข้อห้าม: ไม่ใช้คีย์ API จริง)

---

## ข้อเสนอแนะที่กระทบการออกแบบ (สำหรับการแก้เอกสารรายสัปดาห์)

1. สัปดาห์ 5 ต้องเปิดหน้าปรับแต่งด้วย `Navigator.push` ก่อนสอนการนำทางในสัปดาห์ 6 — ในเอกสารสัปดาห์ 5 ให้บอกว่าเป็นตัวอย่างล่วงหน้า หรือสาธิตฟอร์มในหน้าเดี่ยวก็ได้
2. สัปดาห์ 6 ไม่มี badge ตามแบบ แต่ตะกร้าที่ส่งผ่าน router ทำให้ "ลบในตะกร้าแล้วหน้าอื่นไม่รู้" — ใช้เป็นแรงจูงใจของสัปดาห์ 8 ได้ดี
3. สัปดาห์ 8 → 10 เปลี่ยนชื่อ/ตำแหน่งไฟล์ (`lib/state/cart_model.dart` → `ui/cart/cart_view_model.dart`) เอกสารสัปดาห์ 8 ต้องยกโค้ดจากแท็ก w08 ไม่ใช่ w16
4. สัปดาห์ 11 แบบเดิมเขียนว่า "POST คำสั่งซื้อ" แต่สัปดาห์ 12 ย้ายคำสั่งซื้อไป Firestore (`ApiOrderRepository` ยังอยู่และมีเทสต์) — เป็นตัวอย่างที่ดีของการสลับ Repository ใน composition root บรรทัดเดียว ควรเน้นในเอกสารสัปดาห์ 12
5. พอร์ต Firebase Emulator ของแอปนี้ (9199/8180/4100) ต่างจาก campus_chat เดิม (9099/8080) เพื่อไม่ชนกับเซิร์ฟเวอร์จำลอง REST ที่ 8080 — แอปใบงานควรเลือกพอร์ตให้ไม่ชนเช่นกัน
6. หลายข้อความ (ท็อปปิง สถานะ ใบเสร็จ validator) อยู่ใน cafe_core เป็นภาษาไทย จึงไม่แปลเมื่อเลือก English — เป็นแบบฝึกหัดสัปดาห์ 7 ได้ หรือย้ายข้อความออกจาก core
7. เทสต์สะสมต้องปรับเมื่อโครงสร้างเปลี่ยนจริง (w04 ตัวหาโลโก้, w06 ย้ายหน้าร้าน, w08 ใช้ `cafeApp()`, w10 Repository ปลอม) — พฤติกรรมเดิมยังถูกตรวจทุกสัปดาห์ แต่ใบงาน "refactor" ควรบอกนักศึกษาว่าต้องแก้เทสต์ในจุดใด
8. Dart 3.13 lint `prefer_initializing_formals` แนะนำ private named parameter ซึ่งใหม่มาก โค้ดนี้ใช้พารามิเตอร์ตามตำแหน่งแทน (`MenuViewModel(this._menu, this._favoriteRepo)`)
9. ตัวอย่างที่ใช้สอนได้ซึ่งเกิดขึ้นจริงระหว่างพัฒนา: Form ใน ListView ไม่ validate ช่องนอกจอ (w05), InfoRow ล้น (w06), setState คืน Future และ Future ไม่มีผู้ฟังใน Sliver (w11), pop หน้าสุดท้ายจาก deep link (w13), SnackBar บังปุ่ม (w14)
10. แก้ย้อนหลัง 17 พ.ย. 2569 (แก้ใน commit ของสัปดาห์นั้นแล้ว rebase ย้ายแท็ก; สำรองเดิมที่ `weekly/_archive/*.bundle` ของโครงการเอกสาร):
    - w06: แท็บร้านซ่อน AppBar ของเชลล์ (`AppShell` เมื่อ `_index == 2`) เพราะ `SliverAppBar.large` ของ `ShopPage` เป็นแถบหัวอยู่แล้ว — เดิมซ้อนกันสองชั้น (`test/w03_home_test.dart` ตรวจว่ามี AppBar เดียว)
    - w07: `CupertinoDemo` ห่อเนื้อหาด้วย `DefaultTextStyle` ของ `CupertinoTheme` — เดิมข้อความใน segmented control เป็นตัวแดงขีดเส้นใต้เหลือง
    - w10: รหัสคำสั่งซื้อจาก `DatabaseService.maxOrderNumber()` แทน `countOrders()` (ไม่ซ้ำเมื่อมีการลบ), `save` เขียนใบเสร็จก่อน insert, ใบเสร็จแสดงวันเวลา `d/M/yyyy HH:mm` (intl), `OrderHistoryViewModel` มี `error` และหน้าแสดง `historyError`, ลบ `updateOrderStatus` ที่ไม่มีผู้เรียกในทุกแท็ก (+2 เทสต์)
    - w12 (แก้ 18 พ.ย. 2569): รหัสคำสั่งซื้อจากเวลาเต็มฐาน 36 (`C` + `millisecondsSinceEpoch.toRadixString(36)`) แทน `% 100000` ที่วนซ้ำทุก 100 วินาที, `CartPage` เปิดหน้าสถานะด้วย `context.push` (ย้อนกลับได้), `firestore.rules` ตรวจ `total is int && total > 0` (+1 กรณีใน rules_check; ราคายังมาจากแอป ระบบจริงควรคำนวณฝั่งเซิร์ฟเวอร์)
    - w13 (แก้ 18 พ.ย. 2569): `ReviewRepository` เก็บชื่อไฟล์ภาพ (`reviews/<id>.jpg`) ไม่ใช่พาธเต็ม และแปลงเป็นพาธตอนอ่านด้วย `FileService.pathOf`, `ReviewPage` จับ `PlatformException` จาก image_picker แล้วแสดง `photoError`, `NearestBranchPage` มีปุ่มลองใหม่สำหรับข้อผิดพลาดอื่น (+1 เทสต์)
    - w14 (แก้ 18 พ.ย. 2569): `DebuggingDemo` เรียก `reassembleApplication()` ผ่าน `addPostFrameCallback` (เดิมเรียกใน `onChanged` ระหว่างจัดการการแตะ → `Failed assertion: '!locked'`) +1 เทสต์, ลำดับ import ใน `cart_view_model.dart`, คอมเมนต์ใน pubspec ของ `fake_cloud_firestore`/`mocktail`
    - w15 (แก้ 18 พ.ย. 2569): `SlowRow` วนลูป 3,000,000 รอบ (เดิม 200,000 ไม่เห็นผลบนเครื่องจำลอง), `flutter_secure_storage` ^11.2.0 ให้ตรงกับ Campus Activity และคอมเมนต์ `SecureTokenStore` ไม่อ้าง EncryptedSharedPreferences ที่รุ่นใหม่เลิกใช้
    - w05 (แก้ 18 พ.ย. 2569): `CustomizePage` มี `_nameFocus` เมื่อกดใส่ตะกร้าแต่ชื่อบนแก้วไม่ผ่าน จะโฟกัสช่องชื่อ (Flutter เลื่อนช่องขึ้นมาให้เห็น) แทนที่ข้อความแจ้งจะอยู่นอกจอ และช่องชื่อตั้ง `scrollPadding` ด้านล่าง 64 ให้บรรทัดข้อความแจ้งพ้นปุ่มด้านล่าง (ยืนยันบน iPhone 18 Pro Simulator; เทสต์ w05 ตรวจโฟกัสและตำแหน่ง)
    - w12 (แก้ 18 พ.ย. 2569): `FirestoreOrderRepository.placeOrder` มี `.timeout(writeTimeout)` (ค่าเริ่มต้น 10 วินาที) ไม่ให้ปุ่มสั่งซื้อค้างเมื่อเซิร์ฟเวอร์ไม่ตอบ, `OrderStatusPage` แสดง `orderStatusError` แทนข้อความดิบของ error (+1 เทสต์)
    - w16 (แก้ 18 พ.ย. 2569): `RecommendationCard` ใช้เมนูจริงของร้านตามรหัสที่แนะนำ ถ้าไม่มีในเมนูจะซ่อนการ์ด (+1 เทสต์)
