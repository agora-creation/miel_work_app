import 'package:flutter/material.dart';

class ReportTableButton extends StatelessWidget {
  final String label;
  final Color color;
  final Function()? onPressed;

  const ReportTableButton({
    required this.label,
    required this.color,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      child: Text(label),
    );
  }
}
