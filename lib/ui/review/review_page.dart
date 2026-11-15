import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/review_repository.dart';
import '../../data/services/photo_service.dart';
import '../l10n_ext.dart';

/// รีวิวคำสั่งซื้อพร้อมภาพจากกล้องหรือคลังภาพ (image_picker)
class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key, required this.orderId});

  final String orderId;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final _comment = TextEditingController();
  int _rating = 5;
  String? _photo;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _pick(bool fromCamera) async {
    try {
      final path = await context.read<PhotoService>().pick(
        fromCamera: fromCamera,
      );
      if (path != null) setState(() => _photo = path); // null = ผู้ใช้ยกเลิก
    } on PlatformException {
      // เช่น ผู้ใช้ปฏิเสธสิทธิ์กล้อง (camera_access_denied) หรือไม่มีกล้อง
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.photoError)));
    }
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    await context.read<ReviewRepository>().save(
      widget.orderId,
      Review(rating: _rating, comment: _comment.text, photoPath: _photo),
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.reviewSaved)));
    // เปิดตรงจากลิงก์ (deep link) จะไม่มีหน้าก่อนหน้าให้ pop
    context.canPop() ? context.pop() : context.go('/orders');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text('${l10n.review} ${widget.orderId}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  tooltip: '$i',
                  icon: Icon(i <= _rating ? Icons.star : Icons.star_border),
                  onPressed: () => setState(() => _rating = i),
                ),
            ],
          ),
          if (_photo != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(File(_photo!), height: 200, fit: BoxFit.cover),
            ),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => _pick(true),
                icon: const Icon(Icons.photo_camera),
                label: Text(l10n.takePhoto),
              ),
              OutlinedButton.icon(
                onPressed: () => _pick(false),
                icon: const Icon(Icons.photo_library),
                label: Text(l10n.pickPhoto),
              ),
            ],
          ),
          TextField(
            controller: _comment,
            decoration: InputDecoration(labelText: l10n.comment),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: _save, child: Text(l10n.saveReview)),
        ],
      ),
    );
  }
}
