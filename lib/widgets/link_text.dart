import 'package:flutter/material.dart';

class LinkText extends StatelessWidget {
  final String label;
  final Color color;
  final Function()? onTap;

  const LinkText({
    required this.label,
    required this.color,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: color),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(color: color),
        ),
      ),
    );
  }
}
