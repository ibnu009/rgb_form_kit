import 'package:flutter_test/flutter_test.dart';

import 'package:rgb_form_kit/rgb_form_kit.dart';

void main() {
  test('can set global config', () {
    RgbFormKitConfig.setConfig(RgbFormKitConfig.fallback());
    expect(RgbFormKitConfig.instance.colors.primary500, isNotNull);
  });
}
