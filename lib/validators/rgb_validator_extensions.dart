import 'package:flutter/material.dart';
import '../rgb_validator.dart';

/// Extension methods for [FormFieldValidator].
extension RgbValidatorExtensions<T> on FormFieldValidator<T> {
  /// Combines the current validator with another validator using logical AND.
  FormFieldValidator<T> and(FormFieldValidator<T> other) {
    return RgbValidators.compose(<FormFieldValidator<T>>[this, other]);
  }

  /// Combines the current validator with another validator using logical OR.
  FormFieldValidator<T> or(FormFieldValidator<T> other) {
    return RgbValidators.or(<FormFieldValidator<T>>[this, other]);
  }

  /// Adds a condition to apply the validator only if the condition is met.
  FormFieldValidator<T> when(bool Function(T? value) condition) {
    return RgbValidators.conditional(condition, this);
  }

  /// Adds a condition to apply the validator only if the condition is not met.
  FormFieldValidator<T> unless(bool Function(T? value) condition) {
    return RgbValidators.conditional(
      (T? value) => !condition(value),
      this,
    );
  }

  /// Transforms the value before applying the validator.
  FormFieldValidator<T> transform(T Function(T? value) transformer) {
    return RgbValidators.transform(transformer, this);
  }

  /// Skips the validator if the condition is met.
  FormFieldValidator<T> skipWhen(bool Function(T? value) condition) {
    return RgbValidators.skipWhen(condition, this);
  }

  /// Overrides the error message of the current validator.
  FormFieldValidator<T> withErrorMessage(String errorMessage) {
    return (T? valueCandidate) {
      final String? result = this(valueCandidate);
      return result != null ? errorMessage : null;
    };
  }
}
