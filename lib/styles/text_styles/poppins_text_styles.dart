import 'package:flutter/material.dart';

import '../../config/rgb_form_kit_config.dart';

class PoppinsTextStyles {
  static TextStyle get label => RgbFormKitConfig.instance.textStyles.label;

  static TextStyle get textSm => RgbFormKitConfig.instance.textStyles.textSm;

  static TextStyle get textMd => RgbFormKitConfig.instance.textStyles.textMd;

  static TextStyle get bodyRegular =>
      RgbFormKitConfig.instance.textStyles.bodyRegular;

  static TextStyle get bodySmall => RgbFormKitConfig.instance.textStyles.bodySmall;
}

extension RgbTextStyleWeights on TextStyle {
  TextStyle textRegular() => copyWith(fontWeight: FontWeight.w400);

  TextStyle textMedium() => copyWith(fontWeight: FontWeight.w500);

  TextStyle textSemiBold() => copyWith(fontWeight: FontWeight.w600);
}
