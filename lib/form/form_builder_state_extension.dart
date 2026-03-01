import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

extension FormBuilderStateValidationExt on FormBuilderState {
  /// Saves + validates the form and, if invalid, scrolls to and focuses
  /// the first field that has an error.
  Future<bool> saveAndValidateWithAutoFocusOnError({
    Duration animationDuration = const Duration(milliseconds: 300),
    Curve animationCurve = Curves.easeInOut,
    double alignment = 0.2,
    bool requestFocus = true,
  }) async {
    final isValid = saveAndValidate();
    if (isValid) return true;

    dynamic firstInvalidField;
    for (final field in fields.values) {
      if (field.hasError) {
        firstInvalidField = field;
        break;
      }
    }

    if (firstInvalidField == null) return false;

    await WidgetsBinding.instance.endOfFrame;

    final BuildContext fieldContext = firstInvalidField.context;
    if (fieldContext.mounted) {
      await Scrollable.ensureVisible(
        fieldContext,
        duration: animationDuration,
        curve: animationCurve,
        alignment: alignment,
      );
    }

    if (requestFocus) {
      firstInvalidField.focus();
    }

    return false;
  }
}
