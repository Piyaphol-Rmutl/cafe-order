import 'package:image_picker/image_picker.dart';

abstract interface class PhotoService {
  /// คืนพาธของไฟล์ภาพ หรือ null เมื่อผู้ใช้ยกเลิก
  Future<String?> pick({required bool fromCamera});
}

/// ห่อแพ็กเกจ image_picker (กล้องหรือคลังภาพ)
class ImagePickerPhotoService implements PhotoService {
  ImagePickerPhotoService([ImagePicker? picker])
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<String?> pick({required bool fromCamera}) async {
    final file = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1200, // ย่อภาพก่อนเก็บ ประหยัดพื้นที่และหน่วยความจำ
      imageQuality: 80,
      requestFullMetadata: false, // ไม่ขอ EXIF ซึ่งอาจมีพิกัด (ความเป็นส่วนตัว)
    );
    return file?.path;
  }
}
