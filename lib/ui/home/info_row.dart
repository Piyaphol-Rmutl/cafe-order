import 'package:flutter/material.dart';

/// แถวข้อมูล "ไอคอน + ข้อความ" ที่ใช้ซ้ำได้ (แยกเป็นวิดเจ็ตของตนเอง)
class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}
