import 'package:flutter/material.dart';

class ReportTableTh extends StatelessWidget {
  final String label;

  const ReportTableTh(
    this.label, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(label),
    );
  }
}
