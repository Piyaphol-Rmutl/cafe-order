# Café Order

แอปสั่งเครื่องดื่มร้านกาแฟของคณะ — แอปประกอบการบรรยายรายวิชา ENGCE307 การพัฒนาโปรแกรมประยุกต์สำหรับอุปกรณ์เคลื่อนที่ (Flutter) มทร.ล้านนา

แอปนี้พัฒนาต่อยอดทีละสัปดาห์ ทุกสัปดาห์มีแท็ก Git (`w01`–`w08`, `w10`–`w16`) รายละเอียดว่าแต่ละสัปดาห์เพิ่มอะไรและโค้ดใดเป็นจุดสาธิตของหัวข้อบรรยายใด อยู่ใน [WEEKS.md](WEEKS.md)

![หน้าเมนู](docs/screens/w16_recommendation.png)

## โค้ดประจำสัปดาห์ (สำหรับผู้เรียน)

แต่ละสัปดาห์คือแท็ก Git หนึ่งแท็ก โค้ด ณ แท็กนั้นคือแอปที่ใช้สาธิตในคาบเรียนสัปดาห์นั้น (สัปดาห์ 9 และ 17 เป็นสัปดาห์สอบ ไม่มีแท็ก)

| สัปดาห์ | หัวข้อ | โค้ด | ดาวน์โหลด | เปลี่ยนจากสัปดาห์ก่อน |
|---|---|---|---|---|
| 1 | เครื่องมือ: โปรเจกต์ Flutter, Hot Reload, วงจรชีวิตแอป | [ดูโค้ด](../../tree/w01) | [zip](../../archive/refs/tags/w01.zip) | – |
| 2 | ภาษา Dart: แพ็กเกจ cafe_core, Future/Stream, dart test | [ดูโค้ด](../../tree/w02) | [zip](../../archive/refs/tags/w02.zip) | [w01 → w02](../../compare/w01...w02) |
| 3 | วิดเจ็ตพื้นฐานและแอสเซต: หน้าแรกของร้าน | [ดูโค้ด](../../tree/w03) | [zip](../../archive/refs/tags/w03.zip) | [w02 → w03](../../compare/w02...w03) |
| 4 | เลย์เอาต์: ListView.builder, การ์ด/กริด, Constraints | [ดูโค้ด](../../tree/w04) | [zip](../../archive/refs/tags/w04.zip) | [w03 → w04](../../compare/w03...w04) |
| 5 | รับข้อมูลและ StatefulWidget: ฟอร์มปรับแต่งเครื่องดื่ม, Gesture | [ดูโค้ด](../../tree/w05) | [zip](../../archive/refs/tags/w05.zip) | [w04 → w05](../../compare/w04...w05) |
| 6 | นำทางและ Responsive: go_router, ตะกร้า, NavigationBar/Rail | [ดูโค้ด](../../tree/w06) | [zip](../../archive/refs/tags/w06.zip) | [w05 → w06](../../compare/w05...w06) |
| 7 | ธีม แอนิเมชัน การเข้าถึง: Material 3, th/en, Hero, Semantics | [ดูโค้ด](../../tree/w07) | [zip](../../archive/refs/tags/w07.zip) | [w06 → w07](../../compare/w06...w07) |
| 8 | การจัดการสถานะ: ChangeNotifier + provider | [ดูโค้ด](../../tree/w08) | [zip](../../archive/refs/tags/w08.zip) | [w07 → w08](../../compare/w07...w08) |
| 10 | สถาปัตยกรรมและการเก็บข้อมูล: MVVM, SQLite, shared_preferences | [ดูโค้ด](../../tree/w10) | [zip](../../archive/refs/tags/w10.zip) | [w08 → w10](../../compare/w08...w10) |
| 11 | เครือข่ายและเว็บเซอร์วิส: REST ด้วย http + เซิร์ฟเวอร์จำลอง | [ดูโค้ด](../../tree/w11) | [zip](../../archive/refs/tags/w11.zip) | [w10 → w11](../../compare/w10...w11) |
| 12 | Firebase: Auth, Firestore เรียลไทม์ (Emulator) | [ดูโค้ด](../../tree/w12) | [zip](../../archive/refs/tags/w12.zip) | [w11 → w12](../../compare/w11...w12) |
| 13 | ฮาร์ดแวร์และแพลตฟอร์ม: ตำแหน่ง กล้อง MethodChannel เซนเซอร์ | [ดูโค้ด](../../tree/w13) | [zip](../../archive/refs/tags/w13.zip) | [w12 → w13](../../compare/w12...w13) |
| 14 | ดีบักและทดสอบ: logging, Mock, Integration Test | [ดูโค้ด](../../tree/w14) | [zip](../../archive/refs/tags/w14.zip) | [w13 → w14](../../compare/w13...w14) |
| 15 | ประสิทธิภาพ ความปลอดภัย การเผยแพร่: secure storage, release APK | [ดูโค้ด](../../tree/w15) | [zip](../../archive/refs/tags/w15.zip) | [w14 → w15](../../compare/w14...w15) |
| 16 | แนวโน้มและการบูรณาการ: ฟีเจอร์ AI, สาธิตและประเมินการใช้งาน | [ดูโค้ด](../../tree/w16) | [zip](../../archive/refs/tags/w16.zip) | [w15 → w16](../../compare/w15...w16) |

### วิธีนำโค้ดไปใช้

**แบบไม่ใช้ Git:** กด zip ของสัปดาห์ที่ต้องการ (หรือดูที่หน้า [Releases](../../releases)) แตกไฟล์ แล้วเปิดโฟลเดอร์ด้วย VS Code

**แบบใช้ Git (แนะนำ สลับสัปดาห์ได้ในโฟลเดอร์เดียว):**

```bash
git clone <URL ของ repo นี้> cafe_order
cd cafe_order
git checkout w07          # สลับไปโค้ดของสัปดาห์ 7
git checkout main         # กลับมาโค้ดล่าสุด
```

**ดูว่าสัปดาห์นี้เปลี่ยนอะไร:** กดลิงก์ในคอลัมน์สุดท้าย GitHub จะแสดงไฟล์ที่เพิ่ม/ลบ/แก้ทีละบรรทัด หรือใช้คำสั่ง `git diff w06 w07 --stat`

**รันแอป:**

```bash
flutter pub get
(cd packages/cafe_core && dart pub get)   # ตั้งแต่สัปดาห์ 2: ถ้าไม่รัน แท็บ Problems จะขึ้น error ในเทสต์ของ cafe_core
flutter run
```

- ทุกสัปดาห์ผ่าน `flutter analyze` และ `flutter test` ด้วย Flutter 3.50.1 (Dart 3.14)
- ตั้งแต่สัปดาห์ 11 ต้องเปิดเซิร์ฟเวอร์จำลอง และสัปดาห์ 12 ต้องเปิด Firebase Emulator ก่อน (ดูหัวข้อ "การรัน" ด้านล่าง)
- แท็บ Problems ของ VS Code จะไม่เตือนเรื่อง `package:flutter/material.dart` ถูกเลิกใช้ เพราะปิดไว้ใน `analysis_options.yaml` (เนื้อหารายวิชายังใช้ material.dart) **ถ้าเห็นหน้า Refactor Preview ให้กด Discard อย่ากด Apply**
- โค้ดสาธิตที่ไม่ใช่ส่วนของแอปจริงอยู่ใน `lib/demos/` เปิดจากปุ่ม "เมนูผู้พัฒนา" บนแถบด้านบน
- รายละเอียดว่าแต่ละหัวข้อบรรยายใช้โค้ดไฟล์ใด อยู่ใน [WEEKS.md](WEEKS.md)

## ความสามารถ

- เมนูแบบรายการ/กริด แยกหมวด รายการโปรด และการ์ด "แนะนำสำหรับคุณ" (AI จำลอง)
- ปรับแต่งเครื่องดื่ม (ขนาด ความหวาน ท็อปปิง ชื่อบนแก้ว) → ตะกร้า → สั่งซื้อ
- ติดตามสถานะคำสั่งซื้อแบบเรียลไทม์ และหน้าบาริสต้าเปลี่ยนสถานะ (Cloud Firestore)
- ประวัติคำสั่งซื้อและใบเสร็จในเครื่อง (SQLite + ไฟล์) รีวิวพร้อมภาพ
- หาสาขาที่ใกล้ที่สุดจากตำแหน่งของเครื่อง แต้มสะสม (โทเค็นใน secure storage)
- ธีมสว่าง/มืด ภาษาไทย/อังกฤษ รองรับโปรแกรมอ่านหน้าจอ จอแท็บเล็ตแบบสองบาน

## สถาปัตยกรรม

```
View (ui/<feature>/*_page.dart)
  │  context.watch / read (provider)
ViewModel (ui/<feature>/*_view_model.dart, ChangeNotifier)
  │
Repository (data/repositories/) ← Single Source of Truth, เป็นอินเทอร์เฟซ สลับ implementation ได้
  │
Service (data/services/): SQLite, shared_preferences, ไฟล์, REST (http), Firebase,
                          geolocator, image_picker, MethodChannel, secure storage, AI
```

- `lib/main.dart` คือ composition root: สร้าง Service → Repository แล้วส่งให้ `buildApp()` ใน `lib/app_dependencies.dart`
- `packages/cafe_core/` โมเดลและตรรกะ (Dart ล้วน) ใช้ร่วมกันทั้งแอปและเซิร์ฟเวอร์จำลอง
- `lib/router.dart` เส้นทางทั้งหมด (go_router) และ AuthGate (`redirect`)
- `lib/demos/` จุดสาธิตในชั้นเรียน เปิดจากปุ่มเมนูผู้พัฒนา

## การรัน (แท็ก w16)

ต้องมี Flutter 3.50 ขึ้นไป และ Firebase CLI (ใช้กับ Emulator เท่านั้น ไม่ต้องมีบัญชี Firebase)

```bash
flutter pub get
dart run tool/mock_server.dart                                   # เทอร์มินัล 1: REST API ที่ :8080
firebase emulators:start --project demo-cafe-order               # เทอร์มินัล 2: Auth :9199, Firestore :8180, UI :4100
flutter run                                                      # เทอร์มินัล 3
```

- บัญชีบาริสต้า: สมัครด้วยอีเมลที่ลงท้าย `@barista.test` แล้วเปิดเมนู "บาริสต้า" ใน Drawer
- เครื่องจริงในเครือข่ายเดียวกัน: `flutter run --dart-define=API_BASE_URL=http://<IP>:8080 --dart-define=EMULATOR_HOST=<IP>`

## การทดสอบ

```bash
flutter test                                        # Unit + Widget (ไม่ต้องมีเซิร์ฟเวอร์)
(cd packages/cafe_core && dart test)
flutter test integration_test/app_test.dart -d <เครื่องจำลอง>        # ทั้งแอป ใช้ Repository ปลอม
firebase emulators:exec --project demo-cafe-order "dart run tool/rules_check.dart"
```

`integration_test/emulator_test.dart` และ `integration_test/device_test.dart` ต้องเปิด Emulator/เซิร์ฟเวอร์จำลองก่อน (ดูคอมเมนต์หัวไฟล์)

## สาธิตในชั้นเรียน (สัปดาห์ 16: การนำเสนอและประเมิน)

1. เปิดแอป → สมัครบัญชีลูกค้า (AuthGate) → การ์ดแนะนำ → "ลองเลย"
2. ปรับแต่งลาเต้ L หวาน 50% → ใส่ตะกร้า (badge) → สั่งซื้อ → หน้าติดตามสถานะ
3. อีกเครื่องหนึ่ง (หรือ Emulator UI ที่ http://localhost:4100) ล็อกอินบาริสต้า → เปลี่ยนสถานะ → ลูกค้าเห็นทันทีและเครื่องสั่น
4. ร้าน → หาสาขาใกล้ฉัน (จำลองพิกัดของเครื่องจำลอง) → แต้มสะสม
5. ประวัติ → ใบเสร็จ → รีวิวพร้อมภาพ; ตั้งค่า → โหมดมืด/English
6. ประเมินการใช้งาน (Usability) ด้วยรายการตรวจด้านล่าง

### รายการตรวจการใช้งาน (ใช้ประเมินแอปของตนเองและของเพื่อน)

| ด้าน | คำถาม |
|---|---|
| ทำงานสำเร็จ | ผู้ใช้ใหม่สั่งเครื่องดื่มได้ภายใน 1 นาทีโดยไม่มีคนช่วยหรือไม่ |
| สถานะของระบบ | ทุกการรอ (โหลดเมนู ส่งคำสั่งซื้อ หาตำแหน่ง) มีตัวบอกสถานะหรือไม่ |
| ข้อผิดพลาด | ข้อความผิดพลาดบอกสาเหตุและทางแก้ (ลองอีกครั้ง/เปิดการตั้งค่า) หรือไม่ |
| การเข้าถึง | ใช้ VoiceOver/TalkBack และตัวอักษรขนาด 200% ได้หรือไม่ |
| ความเป็นส่วนตัว | ขอสิทธิ์เมื่อจำเป็นเท่านั้น และอธิบายเหตุผลหรือไม่ |
| AI | บอกผู้ใช้ว่าเป็นผลจาก AI พร้อมเหตุผล และแอปยังใช้ได้เมื่อ AI ล้มเหลวหรือไม่ |

## การสร้างไฟล์เผยแพร่ (สัปดาห์ 15)

```bash
cp android/key.properties.example android/key.properties    # แก้ค่าให้ชี้ keystore ของตนเอง (ห้าม commit)
flutter build apk --release --obfuscate --split-debug-info=build/symbols
flutter build appbundle --release                            # สำหรับ Google Play
```

แท็ก w16 ยังชี้ไป Firebase Emulator และเซิร์ฟเวอร์ HTTP ในเครื่อง ใช้สาธิตได้เท่านั้น การเผยแพร่จริงต้องมี API แบบ HTTPS และโปรเจกต์ Firebase จริง
