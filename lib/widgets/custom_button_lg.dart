import 'package:flutter/material.dart';

class CustomButtonLg extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Color backgroundColor;
  final Function()? onPressed;

  const CustomButtonLg({
    required this.label,
    required this.labelColor,
    required this.backgroundColor,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 24,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: labelColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
