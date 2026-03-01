# rgb_form_kit Usage Guide

This guide shows how to integrate `rgb_form_kit` into a real form flow.

## 1) Install and import

```yaml
dependencies:
  rgb_form_kit: ^1.0.0
```

```dart
import 'package:flutter/material.dart';
import 'package:rgb_form_kit/model/check_box_model.dart';
import 'package:rgb_form_kit/model/dropdown_selection_model.dart';
import 'package:rgb_form_kit/rgb_form_kit.dart';
```

## 2) Configure the package (once)

Set config before building your app (or before form screens):

```dart
void main() {
  RgbFormKitConfig.setConfig(RgbFormKitConfig.fallback());
  runApp(const MyApp());
}
```

## 3) Create a FormBuilder key

```dart
final _formKey = GlobalKey<FormBuilderState>();
```

## 4) Build a form screen

```dart
class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  final _checkBoxItem = CheckBoxModel(
    identifier: 'accept_terms',
    title: 'Accept Terms & Conditions',
  );

  final _contactChoices = [
    CheckBoxModel(identifier: 'email', title: 'Email'),
    CheckBoxModel(identifier: 'phone', title: 'Phone'),
  ];

  final _identityOptions = [
    DropdownSelectionModel(identifier: 'id', title: 'ID Card'),
    DropdownSelectionModel(identifier: 'passport', title: 'Passport'),
  ];

  String? _identityValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration Form')),
      body: SafeArea(
        child: FormBuilder(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SuffixTextField(
                name: 'weight',
                title: 'Weight',
                suffixText: 'kg',
                isRequired: true,
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              DropdownField(
                name: 'status',
                label: 'Status',
                options: const ['Single', 'Married', 'Other'],
                isRequired: true,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Please select status' : null,
              ),
              const SizedBox(height: 12),
              DropdownSelectionWidget(
                name: 'identity_type',
                title: 'Identity Type',
                placeholder: 'Choose one',
                selectedValue: _identityValue,
                options: _identityOptions,
                displayText: (e) => e.title,
                isRequired: true,
                validator: (v) => v == null ? 'Please choose identity type' : null,
                onSelect: (option) {
                  _identityValue = option.identifier;
                },
              ),
              const SizedBox(height: 12),
              BasicCheckBox(
                item: _checkBoxItem,
                isRequired: true,
                validatorErrorMessage: 'Please accept terms first',
              ),
              const SizedBox(height: 12),
              ChoiceInputField(
                name: 'preferred_channel',
                title: 'Preferred Contact Channel',
                isRequired: true,
                validatorErrorMessage: 'Please select one option',
                choices: _contactChoices,
              ),
              const SizedBox(height: 12),
              YesAndNoField(
                name: 'has_allergy',
                title: 'Do you have allergies?',
                isRequired: true,
              ),
              const SizedBox(height: 12),
              DatePickerField(
                name: 'visit_date',
                title: 'Visit Date',
                hintText: 'Pick date',
                isRequired: true,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Please choose a date' : null,
              ),
              const SizedBox(height: 12),
              CustomDatePickerField(
                name: 'birth_date',
                title: 'Birth Date',
                isRequired: true,
                useDefaultValue: false,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _submit,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null) return;

    final isValid = await form.saveAndValidateWithAutoFocusOnError();
    if (!isValid) return;

    debugPrint('Submitted value: ${form.value}');
  }
}
```

## 5) Building custom fields with `Formable<T>`

Use `Formable<T>` when you need your own UI but still want full `FormBuilder`
integration.

```dart
Formable<String>(
  name: 'custom_note',
  validator: (v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    return null;
  },
  builder: (field, onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(onChanged: onChanged),
        if (field.hasError)
          Text(
            field.errorText ?? '',
            style: const TextStyle(color: Colors.red),
          ),
      ],
    );
  },
)
```

## 6) Validation and error focus behavior

For better submit UX:

```dart
final isValid = await form.saveAndValidateWithAutoFocusOnError();
```

This method:

1. Saves and validates the form
2. Finds the first invalid field
3. Scrolls to it
4. Requests focus when possible

## 7) Access values manually

You can read values by field name:

```dart
final value = _formKey.currentState?.fields['status']?.value;
```

Or read all values after successful validation:

```dart
final allValues = _formKey.currentState?.value;
```

## 8) Run full package example

A complete sample is available at:

- `example/lib/main.dart`

Run it:

```bash
flutter pub get
flutter run -t example/lib/main.dart
```
