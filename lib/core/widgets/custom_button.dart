import 'package:flutter/material.dart';
import 'package:traderview/core/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final IconData? icon;
  final Color? colorText;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.icon,
    this.colorText,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? CustomColor.bgButtonPrimary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0,
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null && text == 'Regresar') ...[
            Icon(icon, size: 20, color: Colors.black),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorText ?? Colors.white,
            ),
          ),
          if (icon != null && text != 'Regresar') ...[
            const SizedBox(width: 8),
            Icon(icon, size: 20),
          ],
        ],
      ),
    );
  }
}
