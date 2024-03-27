import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class CustomCheckbox extends StatelessWidget {
  final String label;
  final Color labelColor;
  final Color backgroundColor;
  final bool value;
  final void Function(bool?)? onChanged;

  const CustomCheckbox({
    required this.label,
    this.labelColor = kBlackColor,
    this.backgroundColor = Colors.transparent,
    required this.value,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      child: CheckboxListTile(
        title: Text(
          label,
          style: TextStyle(color: labelColor),
        ),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
