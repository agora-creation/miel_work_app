import 'package:flutter/material.dart';

class ReportTableTd extends StatelessWidget {
  final Widget child;

  const ReportTableTd(
    this.child, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: child,
    );
  }
}
