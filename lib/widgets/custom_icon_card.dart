import 'package:flutter/material.dart';

class CustomIconCard extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String label;
  final double labelFontSize;
  final Color color;
  final Color backgroundColor;
  final Function()? onTap;

  const CustomIconCard({
    required this.icon,
    this.iconSize = 60,
    required this.label,
    this.labelFontSize = 18,
    required this.color,
    required this.backgroundColor,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: backgroundColor,
        surfaceTintColor: backgroundColor,
        elevation: 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: labelFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
