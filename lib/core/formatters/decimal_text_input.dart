import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;
  DecimalTextInputFormatter({this.decimalRange = 2});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final regExp = RegExp(r'^\d*\.?\d{0,' + decimalRange.toString() + r'}$');
    if (regExp.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
