import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class PlanWorkList extends StatelessWidget {
  final String label;
  final Color labelColor;
  final double labelSize;

  const PlanWorkList(
    this.label, {
    this.labelColor = Colors.transparent,
    this.labelSize = 8,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        color: kLightBlueColor.withOpacity(0.8),
        child: Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: labelSize,
            fontWeight: FontWeight.bold,
            fontFamily: 'SourceHanSansJP-Bold',
          ),
        ),
      ),
    );
  }
}
