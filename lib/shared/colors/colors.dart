import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFFFA62A);
  static const Color primaryLight = Color(0xFFFFDFC2);
  static const Color primaryLightest = Color(0xFFFFFAF6);
  static const Color primaryLighter = Color(0xFFFFF5EC);
  static const Color primaryDark = Color(0xFF573F1D);

  // Black & Gray Shades
  static const Color black = Color(0xFF2A2A2A);
  static const Color gray = Color(0xFF868686);
  static const Color lightGray = Color(0xFFABABAB);
  static const Color lighterGray = Color(0xFFD9D9D9);
  static const Color lightestGray = Color.fromARGB(255, 239, 239, 239);
  static const Color white = Color(0xFFFFFFFF);

  // Secondary Colors
  static const Color secondaryLighter = Color(0xFFD1F4FF);
  static const Color secondaryLight = Color(0xFF7CE0FF);
  static const Color secondary = Color(0xFF36C0EB);
  static const Color secondaryDark = Color(0xFF074457);

  // Error Colors
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFEF5350);
  static const Color errorLighter = Color(0xFFE57373);
}

// 基本的な線形グラデーション
LinearGradient primaryGradient = LinearGradient(
  colors: [
    AppColors.primary,
    adjustBrightness(AppColors.primary, 0.1),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

// 他の方向のグラデーション
LinearGradient homeBackgroundGradiednt = LinearGradient(
  colors: [
    adjustBrightness(AppColors.primaryLight, 0.03),
    AppColors.primaryLight,
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);

// 他の方向のグラデーション
LinearGradient textBoxGradiednt = LinearGradient(
  colors: [
    adjustBrightness(AppColors.primaryLight, 0.07),
    AppColors.primaryLight,
  ],
);

RadialGradient radialGradient = RadialGradient(
  colors: [
    AppColors.primary,
    adjustBrightness(AppColors.primary, 0.1),
  ],
);

// 明度（明るさ）を調整
Color adjustBrightness(Color color, double amount) {
  final hsl = HSLColor.fromColor(color);
  final adjustedLightness = (hsl.lightness + amount).clamp(0.0, 1.0);
  return hsl.withLightness(adjustedLightness).toColor();
}

// 彩度を調整
Color adjustSaturation(Color color, double amount) {
  final hsl = HSLColor.fromColor(color);
  final adjustedSaturation = (hsl.saturation + amount).clamp(0.0, 1.0);
  return hsl.withSaturation(adjustedSaturation).toColor();
}

// 彩度と明度を同時に調整
Color adjustSaturationAndBrightness(
  Color color,
  double saturationAmount,
  double brightnessAmount,
) {
  final hsl = HSLColor.fromColor(color);
  final adjustedSaturation =
      (hsl.saturation + saturationAmount).clamp(0.0, 1.0);
  final adjustedLightness = (hsl.lightness + brightnessAmount).clamp(0.0, 1.0);
  return hsl
      .withSaturation(adjustedSaturation)
      .withLightness(adjustedLightness)
      .toColor();
} 