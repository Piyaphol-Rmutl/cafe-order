import 'dart:convert';

import '../services/file_service.dart';

/// รีวิวคำสั่งซื้อ: คะแนน ความเห็น และภาพ (เก็บในเครื่องเท่านั้น)
class Review {
  const Review({required this.rating, this.comment = '', this.photoPath});

  final int rating; // 1–5
  final String comment;
  final String? photoPath;

  Map<String, Object?> toJson() => {
    'rating': rating,
    'comment': comment,
    'photoPath': photoPath,
  };

  factory Review.fromJson(Map<String, dynamic> j) => Review(
    rating: j['rating'] as int,
    comment: j['comment'] as String? ?? '',
    photoPath: j['photoPath'] as String?,
  );
}

class ReviewRepository {
  ReviewRepository(this._files);

  final FileService _files;

  Future<void> save(String orderId, Review review) async {
    // คัดลอกภาพจากโฟลเดอร์ชั่วคราวของ image_picker มาเก็บถาวร
    // และบันทึกเพียงชื่อไฟล์ (ไม่ใช่พาธเต็ม) ลง JSON
    String? photo;
    if (review.photoPath != null) {
      photo = 'reviews/$orderId.jpg';
      await _files.copyIn(review.photoPath!, photo);
    }
    final saved = Review(
      rating: review.rating,
      comment: review.comment,
      photoPath: photo,
    );
    await _files.writeText('reviews/$orderId.json', jsonEncode(saved.toJson()));
  }

  Future<Review?> load(String orderId) async {
    final text = await _files.readText('reviews/$orderId.json');
    if (text == null) return null;
    final review = Review.fromJson(jsonDecode(text) as Map<String, dynamic>);
    final name = review.photoPath;
    // แปลงชื่อไฟล์กลับเป็นพาธเต็มตอนอ่าน
    return name == null
        ? review
        : Review(
            rating: review.rating,
            comment: review.comment,
            photoPath: await _files.pathOf(name),
          );
  }
}
