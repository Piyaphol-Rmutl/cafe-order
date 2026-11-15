import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Service อ่าน/เขียนไฟล์ข้อความในโฟลเดอร์เอกสารของแอป (path_provider)
class FileService {
  /// [directory] เปลี่ยนเป็นโฟลเดอร์ชั่วคราวได้ตอนทดสอบ
  FileService({Future<Directory> Function()? directory})
    : _directory = directory ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _directory;

  Future<File> _file(String name) async =>
      File(p.join((await _directory()).path, name));

  Future<File> writeText(String name, String text) async {
    final file = await _file(name);
    await file.parent.create(recursive: true);
    return file.writeAsString(text);
  }

  /// คืน null ถ้ายังไม่มีไฟล์
  Future<String?> readText(String name) async {
    final file = await _file(name);
    return await file.exists() ? file.readAsString() : null;
  }

  /// คัดลอกไฟล์ (เช่น ภาพจาก image_picker ซึ่งอยู่ในโฟลเดอร์ชั่วคราว) มาเก็บถาวร
  /// พาธเต็มของไฟล์ [name] ในโฟลเดอร์เอกสาร ณ ตอนนี้
  /// (พาธของโฟลเดอร์เปลี่ยนได้เมื่อติดตั้งหรืออัปเดตแอปบน iOS จึงควรเก็บเพียงชื่อ)
  Future<String> pathOf(String name) async => (await _file(name)).path;

  Future<String> copyIn(String sourcePath, String name) async {
    final target = await _file(name);
    await target.parent.create(recursive: true);
    return (await File(sourcePath).copy(target.path)).path;
  }
}
