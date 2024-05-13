import 'package:flutter/material.dart';

class PopupIconButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Function()? onTap;

  const PopupIconButton({
    required this.icon,
    required this.label,
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
            color: Colors.white,
          ),
          Container(
            margin: const EdgeInsets.only(top: 2),
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
