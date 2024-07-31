import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class LinkText extends StatelessWidget {
  final String label;
  final Color color;
  final Function()? onTap;
  final bool enabled;

  const LinkText({
    required this.label,
    required this.color,
    this.onTap,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        decoration: enabled
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: color),
                ),
              )
            : null,
        child: Text(
          label,
          style: TextStyle(
            color: enabled ? color : kDisabledColor,
            fontSize: 16,
            decoration: enabled ? null : TextDecoration.lineThrough,
          ),
        ),
      ),
    );
  }
}
