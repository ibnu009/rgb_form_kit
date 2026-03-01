class CheckBoxModel {
  String identifier;
  String title;
  String? subTitle;
  bool isSelected;
  String? value;

  CheckBoxModel({
    required this.title,
    this.subTitle,
    this.value,
    this.isSelected = false,
    required this.identifier,
  });

  CheckBoxModel copyWith({
    String? identifier,
    String? title,
    String? value,
    String? subTitle,
    bool? isSelected,
  }) {
    return CheckBoxModel(
      identifier: identifier ?? this.identifier,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      isSelected: isSelected ?? this.isSelected,
      value: value ?? this.value,
    );
  }

  CheckBoxModel.copy(CheckBoxModel original)
      : title = original.title,
        identifier = original.identifier,
        subTitle = original.subTitle,
        isSelected = original.isSelected,
        value = original.value;
}
