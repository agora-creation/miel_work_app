import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class AlertChip extends StatelessWidget {
  final String label;

  const AlertChip(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          color: kWhiteColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      padding: const EdgeInsets.all(4),
      backgroundColor: kRedColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
