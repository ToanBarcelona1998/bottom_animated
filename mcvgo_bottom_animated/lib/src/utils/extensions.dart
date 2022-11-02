import 'package:flutter/material.dart';

extension ContextX on BuildContext {
  Size get s => MediaQuery.of(this).size;

  double get w => s.width;

  double get h => s.height;

  double get keyBoardHeight => MediaQuery.of(this).viewInsets.bottom;

  double get devicePixelRatio => h / w;
}

extension SupportImageExtension on String {
  bool get defaultImage => [
    'JPG'.toLowerCase(),
    'JPEG'.toLowerCase(),
    'PNG'.toLowerCase()
  ].contains(toLowerCase());

  bool get svgImage => 'SVG'.toLowerCase() == toLowerCase();
}