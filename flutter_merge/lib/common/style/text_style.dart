import 'package:flutter/material.dart';

class TextStyles {

  static TextStyle normalStyle() {
    return sizeStyle(14.0);
  }

  static TextStyle sizeStyle(double size) {
    return TextStyle(
      fontSize: size,
    );
  }
}