import 'package:flutter/widgets.dart';

extension NumSpacingExtensions on num {
  double get w => toDouble();
  double get h => toDouble();
  double get r => toDouble();

  SizedBox get verticalSpace => SizedBox(height: toDouble());
  SizedBox get horizontalSpace => SizedBox(width: toDouble());
}

extension StringTrExtension on String {
  String get tr => this;
}

extension ObjectLogExtension on Object {
  void printError([StackTrace? stackTrace]) {
    debugPrint(toString());
    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }
}
