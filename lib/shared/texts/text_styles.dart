import 'package:flutter/material.dart';

abstract class AppTextStyles {
  // 通常のフォント
  static TextStyle xxs({Color? color}) => TextStyle(fontSize: 12, color: color);
  static TextStyle xs({Color? color}) => TextStyle(fontSize: 14, color: color);
  static TextStyle s({Color? color}) => TextStyle(fontSize: 16, color: color);
  static TextStyle m({Color? color}) => TextStyle(fontSize: 18, color: color);
  static TextStyle l({Color? color}) => TextStyle(fontSize: 20, color: color);
  static TextStyle xl({Color? color}) => TextStyle(fontSize: 24, color: color);

  // 太字（bold）のフォント
  static TextStyle xxsBold({Color? color}) =>
      TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color);
  static TextStyle xsBold({Color? color}) =>
      TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color);
  static TextStyle sBold({Color? color}) =>
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color);
  static TextStyle mBold({Color? color}) =>
      TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color);
  static TextStyle lBold({Color? color}) =>
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color);
  static TextStyle xlBold({Color? color}) =>
      TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color);
} 