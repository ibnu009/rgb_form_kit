import 'package:flutter/material.dart';

class RgbFormKitConfig {
  final RgbFormKitColors colors;
  final RgbFormKitTextStyles textStyles;

  const RgbFormKitConfig({
    required this.colors,
    required this.textStyles,
  });

  static RgbFormKitConfig _instance = RgbFormKitConfig.fallback();

  static RgbFormKitConfig get instance => _instance;

  static void setConfig(RgbFormKitConfig config) {
    _instance = config;
  }

  factory RgbFormKitConfig.fallback() {
    const colors = RgbFormKitColors();

    return RgbFormKitConfig(
      colors: colors,
      textStyles: const RgbFormKitTextStyles(),
    );
  }
}

class RgbFormKitColors {
  final Color primary500;
  final Color black500;
  final Color black300;
  final Color black200;
  final Color black100;
  final Color alert700;
  final Color brightRed;
  final Color white;

  const RgbFormKitColors({
    this.primary500 = const Color(0xFF00A69C),
    this.black500 = const Color(0xFF1F2937),
    this.black300 = const Color(0xFF6B7280),
    this.black200 = const Color(0xFFE5E7EB),
    this.black100 = const Color(0xFFF3F4F6),
    this.alert700 = const Color(0xFFB91C1C),
    this.brightRed = const Color(0xFFEF4444),
    this.white = const Color(0xFFFFFFFF),
  });
}

class RgbFormKitTextStyles {
  final TextStyle label;
  final TextStyle textSm;
  final TextStyle textMd;
  final TextStyle bodyRegular;
  final TextStyle bodySmall;

  const RgbFormKitTextStyles({
    this.label = const TextStyle(fontSize: 14),
    this.textSm = const TextStyle(fontSize: 12),
    this.textMd = const TextStyle(fontSize: 16),
    this.bodyRegular = const TextStyle(fontSize: 14),
    this.bodySmall = const TextStyle(fontSize: 12),
  });
}
