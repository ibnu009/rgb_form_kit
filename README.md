# rgb_form_kit

A Flutter form component kit built on top of
[`flutter_form_builder`](https://pub.dev/packages/flutter_form_builder).

This package provides reusable widgets for common form patterns (text-with-suffix,
dropdowns, checkboxes, yes/no choices, and date pickers), plus helper APIs to
improve validation UX.

## Features

- Form widgets ready to use inside `FormBuilder`
- Built-in validation support and error rendering
- Custom date picker field with optional prefill behavior
- `Formable<T>` for building your own `FormBuilderField` wrappers
- Extension helper: auto-scroll and auto-focus first invalid field on submit

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  rgb_form_kit: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick start

```dart
import 'package:flutter/material.dart';
import 'package:rgb_form_kit/rgb_form_kit.dart';

final _formKey = GlobalKey<FormBuilderState>();

class MyFormScreen extends StatelessWidget {
  const MyFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RgbFormKitConfig.setConfig(RgbFormKitConfig.fallback());

    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          SuffixTextField(
            name: 'weight',
            title: 'Weight',
            suffixText: 'kg',
            isRequired: true,
            validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () async {
              final form = _formKey.currentState;
              if (form == null) return;

              final isValid = await form.saveAndValidateWithAutoFocusOnError();
              if (!isValid) return;

              debugPrint('Form value: ${form.value}');
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }
}
```

## Included widgets

- `SuffixTextField`
- `DropdownField`
- `DropdownSelectionWidget`
- `BasicCheckBox`
- `CheckBoxField`
- `ChoiceInputField`
- `YesAndNoField`
- `DatePickerField`
- `CustomDatePickerField`
- `Formable<T>`
- `DividerWithText`

## Validation helper

Use this extension on `FormBuilderState` for better UX:

```dart
final isValid = await form.saveAndValidateWithAutoFocusOnError();
```

When invalid, it automatically:

1. Finds the first field with an error
2. Scrolls to that field
3. Requests focus (when possible)

## Example app

See `example/lib/main.dart` for a full runnable screen that demonstrates all
widgets and validation patterns.

Run the example:

```bash
flutter pub get
flutter run -t example/lib/main.dart
```

## Usage guide

For a fuller, end-to-end guide, see:

- [`docs/usage_guide.md`](docs/usage_guide.md)
