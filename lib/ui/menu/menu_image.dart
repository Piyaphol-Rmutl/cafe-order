import 'package:cafe_core/cafe_core.dart';
import 'package:flutter/material.dart';

/// รูปของเมนูจากแอสเซต `assets/menu/{id}.png`
class MenuImage extends StatelessWidget {
  const MenuImage({super.key, required this.item, this.size});

  final MenuItem item;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/menu/${item.id}.png',
      width: size,
      height: size,
      fit: BoxFit.cover,
    );
  }
}
