import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class CustomHomeIconCard extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String label;
  final double labelFontSize;
  final Color color;
  final Color backgroundColor;
  final bool alert;
  final Function()? onTap;

  const CustomHomeIconCard({
    required this.icon,
    this.iconSize = 60,
    required this.label,
    this.labelFontSize = 18,
    required this.color,
    required this.backgroundColor,
    this.alert = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: alert ? kRedColor : Colors.transparent,
            width: 4,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        color: alert ? kRed100Color : backgroundColor,
        surfaceTintColor: alert ? kRed100Color : backgroundColor,
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
            alert
                ? const Text(
                    '未読あり',
                    style: TextStyle(
                      color: kRedColor,
                      fontSize: 12,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
