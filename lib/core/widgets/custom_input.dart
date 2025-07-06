import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:traderview/core/constants/colors.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final int? minLength;
  final List<TextInputFormatter>? inputFormatters;
  final bool isCurrency;
  final int? maxLines;
  final InputDecoration? decoration;
  final bool readOnly;
  final TextAlignVertical? textAlignVertical;
  final VoidCallback? onTap;

  const CustomInput({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.minLength,
    this.inputFormatters,
    this.isCurrency = false,
    this.maxLines = 1,
    this.decoration,
    this.readOnly = false,
    this.textAlignVertical,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          readOnly: readOnly,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters ??
              (isCurrency
                  ? [
                      FilteringTextInputFormatter.digitsOnly,
                      CurrencyInputFormatter()
                    ]
                  : null),
          maxLines: maxLines,
          textAlignVertical: textAlignVertical,
          onTap: onTap,
          decoration: decoration ??
              InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Colors.black26),
                filled: true,
                fillColor: const Color(0xFFFFFFFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                suffixIcon: suffixIcon,
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: CustomColor.bgButtonPrimary,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return 'Campo requerido';
                }
                if (minLength != null && value.length < minLength!) {
                  return 'Mínimo $minLength caracteres';
                }
                return null;
              },
          style: const TextStyle(color: Colors.black87),
        ),
      ],
    );
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.currency(
    locale: 'es_MX',
    symbol: '',
    decimalDigits: 0,
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final String cleaned = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }
    try {
      final int value = int.parse(cleaned);
      final String newText = _formatter.format(value);
      return TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(offset: newText.length),
      );
    } catch (e) {
      // En caso de error, regresamos el valor anterior
      return oldValue;
    }
  }
}
