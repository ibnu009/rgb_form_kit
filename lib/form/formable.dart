import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

typedef FormableFieldBuilder<T> = Widget Function(
  FormFieldState<T> field,
  ValueChanged<T?> onChanged,
);

class Formable<T> extends FormBuilderField<T> {
  Formable({
    super.key,
    required super.name,
    required FormableFieldBuilder<T> builder,
    super.initialValue,
    super.enabled,
    super.validator,
    super.valueTransformer,
    super.autovalidateMode,
    super.onChanged,
    super.onSaved,
  }) : super(
          builder: (FormFieldState<T> field) {
            return builder(field, field.didChange);
          },
        );
}
