import 'package:flutter/material.dart';
import 'package:rgb_form_kit/model/check_box_model.dart';
import 'package:rgb_form_kit/model/dropdown_selection_model.dart';
import 'package:rgb_form_kit/rgb_form_kit.dart';

void main() {
  RgbFormKitConfig.setConfig(RgbFormKitConfig.fallback());
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RGB Form Kit Example',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      home: const ExampleFormScreen(),
    );
  }
}

class ExampleFormScreen extends StatefulWidget {
  const ExampleFormScreen({super.key});

  @override
  State<ExampleFormScreen> createState() => _ExampleFormScreenState();
}

class _ExampleFormScreenState extends State<ExampleFormScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _customNoteFieldKey = GlobalKey<FormFieldState<String>>();

  final _basicCheckBoxItem = CheckBoxModel(
    identifier: 'accept_terms',
    title: 'Accept Terms & Conditions',
  );

  final _checkBoxFieldItem = CheckBoxModel(
    identifier: 'newsletter',
    title: 'Receive Newsletter',
    subTitle: 'Get product updates and release notes.',
  );

  final _choiceOptions = [
    CheckBoxModel(identifier: 'email', title: 'Email'),
    CheckBoxModel(identifier: 'phone', title: 'Phone'),
    CheckBoxModel(identifier: 'whatsapp', title: 'WhatsApp'),
  ];

  final _selectionOptions = [
    DropdownSelectionModel(identifier: 'id', title: 'ID Card'),
    DropdownSelectionModel(identifier: 'passport', title: 'Passport'),
    DropdownSelectionModel(identifier: 'driver_license', title: 'Driver License'),
  ];

  String? _dropdownValue;
  String? _selectionValue;
  Map<String, dynamic>? _submittedValue;
  Map<String, dynamic>? _independentValues;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RGB Form Kit - All Forms Example')),
      body: SafeArea(
        child: FormBuilder(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const _SectionTitle('1) SuffixTextField'),
              SuffixTextField(
                name: 'weight',
                title: 'Weight',
                suffixText: 'kg',
                isRequired: true,
                hintText: 'Type your weight',
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Weight is required';
                  return null;
                },
              ),

              const _SectionTitle('2) DropdownField'),
              DropdownField(
                name: 'status',
                label: 'Status',
                hint: 'Select status',
                options: const ['Single', 'Married', 'Other'],
                initialValue: _dropdownValue,
                isRequired: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please select status';
                  return null;
                },
                onChanged: (v) => _dropdownValue = v,
              ),

              const _SectionTitle('3) DropdownSelectionWidget'),
              DropdownSelectionWidget(
                name: 'identity_type',
                title: 'Identity Type',
                placeholder: 'Choose one',
                selectedValue: _selectionValue,
                options: _selectionOptions,
                displayText: (option) => option.title,
                isRequired: true,
                validator: (v) {
                  if (v == null) return 'Please choose identity type';
                  return null;
                },
                onSelect: (option) => _selectionValue = option.identifier,
              ),

              const _SectionTitle('4) BasicCheckBox'),
              BasicCheckBox(
                item: _basicCheckBoxItem,
                isRequired: true,
                validatorErrorMessage: 'Please accept Terms & Conditions',
              ),
              const SizedBox(height: 8),

              const _SectionTitle('5) CheckBoxField'),
              CheckBoxField(
                item: _checkBoxFieldItem,
                isRequired: true,
                validatorErrorMessage: 'Please confirm newsletter preference',
              ),

              const _SectionTitle('6) ChoiceInputField'),
              ChoiceInputField(
                name: 'preferred_channel',
                title: 'Preferred Contact Channel',
                isRequired: true,
                validatorErrorMessage: 'Please select one contact channel',
                choices: _choiceOptions,
              ),

              const _SectionTitle('7) YesAndNoField'),
              YesAndNoField(
                name: 'has_allergy',
                title: 'Do you have allergies?',
                isRequired: true,
                validatorErrorMessage: 'Please choose yes or no first',
                description: 'Choose yes/no',
              ),

              const _SectionTitle('8) DatePickerField'),
              DatePickerField(
                name: 'visit_date',
                title: 'Visit Date',
                hintText: 'Pick date',
                isRequired: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please choose a date';
                  return null;
                },
              ),

              const _SectionTitle('9) CustomDatePickerField'),
              CustomDatePickerField(
                name: 'birth_date',
                title: 'Birth Date',
                isRequired: true,
                useDefaultValue: false,
                errorMessage: 'Birth date is required',
              ),

              const _SectionTitle('10) Formable'),
              Formable<String>(
                key: _customNoteFieldKey,
                name: 'custom_note',
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Custom note is required';
                  }
                  return null;
                },
                builder: (field, onChanged) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Custom Note (via Formable)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: onChanged,
                      ),
                      if (field.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            field.errorText ?? '',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  );
                },
              ),

              const _SectionTitle('11) DividerWithText (helper widget)'),
              const DividerWithText(text: 'This is a divider helper from form kit'),
              const SizedBox(height: 16),

              FilledButton(
                onPressed: _submit,
                child: const Text('Submit Form'),
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: _validateIndependently,
                child: const Text('Validate Independently'),
              ),
              const SizedBox(height: 12),
              FilledButton.tonal(
                onPressed: _retrieveValuesIndependently,
                child: const Text('Retrieve Values Independently'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _reset,
                child: const Text('Reset Form'),
              ),
              const SizedBox(height: 16),

              if (_submittedValue != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _submittedValue.toString(),
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              if (_independentValues != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _independentValues.toString(),
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ],
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

    setState(() {
      _submittedValue = Map<String, dynamic>.from(form.value);
    });
  }

  void _validateIndependently() {
    final form = _formKey.currentState;
    if (form == null) return;

    final statusValid = form.fields['status']?.validate() ?? false;
    final visitDateValid = form.fields['visit_date']?.validate() ?? false;
    final customNoteValid = _customNoteFieldKey.currentState?.validate() ?? false;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'status=$statusValid, visit_date=$visitDateValid, custom_note=$customNoteValid',
        ),
      ),
    );
  }

  void _retrieveValuesIndependently() {
    final form = _formKey.currentState;
    if (form == null) return;

    final statusByName = form.fields['status']?.value;
    final identityTypeByName = form.fields['identity_type']?.value;
    final birthDateByName = form.fields['birth_date']?.value;
    final customNoteByFieldKey = _customNoteFieldKey.currentState?.value;

    setState(() {
      _independentValues = {
        'byName.status': statusByName,
        'byName.identity_type': identityTypeByName,
        'byName.birth_date': birthDateByName,
        'byFieldKey.custom_note': customNoteByFieldKey,
      };
    });
  }

  void _reset() {
    _formKey.currentState?.reset();
    setState(() {
      _submittedValue = null;
      _independentValues = null;
      _dropdownValue = null;
      _selectionValue = null;
    });
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
