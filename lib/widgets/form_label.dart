import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class FormLabel extends StatelessWidget {
  final String label;
  final Color color;
  final Widget child;

  const FormLabel({
    required this.label,
    this.color = kGrey600Color,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: color)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: color),
          ),
          child,
        ],
      ),
    );
  }
}
