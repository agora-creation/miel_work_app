import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/style.dart';

class HomeIconCard extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final String label;
  final double labelFontSize;
  final Color color;
  final Color backgroundColor;
  final bool alert;
  final String alertMessage;
  final Function()? onTap;

  const HomeIconCard({
    required this.icon,
    this.iconSize = 60,
    required this.label,
    this.labelFontSize = 20,
    required this.color,
    required this.backgroundColor,
    this.alert = false,
    this.alertMessage = '未読あり',
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
        color: alert ? Colors.red.shade300 : backgroundColor,
        surfaceTintColor: alert ? Colors.red.shade300 : backgroundColor,
        elevation: 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FaIcon(
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
                fontFamily: 'SourceHanSansJP-Bold',
              ),
            ),
            alert
                ? Text(
                    alertMessage,
                    style: const TextStyle(
                      color: kRedColor,
                      fontSize: 14,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
