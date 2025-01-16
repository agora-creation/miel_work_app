import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class WeekList extends StatelessWidget {
  final String label;
  final Widget child;

  const WeekList(
    this.label, {
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              label,
              style: const TextStyle(
                color: kBlackColor,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Expanded(child: child),
          ),
        ],
      ),
    );
  }
}
