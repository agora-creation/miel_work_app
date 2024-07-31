import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class FormLabel extends StatelessWidget {
  final String label;
  final Widget child;

  const FormLabel(
    this.label, {
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: kBlackColor,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 2),
        child,
      ],
    );
  }
}
