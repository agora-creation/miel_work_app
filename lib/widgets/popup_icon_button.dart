import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class PopupIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Function()? onTap;

  const PopupIconButton({
    required this.icon,
    required this.label,
    this.color = kWhiteColor,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: color,
          ),
          Container(
            margin: const EdgeInsets.only(top: 2),
            child: Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
