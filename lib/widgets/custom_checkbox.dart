import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class CustomCheckbox extends StatelessWidget {
  final String label;
  final String? subLabel;
  final Color labelColor;
  final Color backgroundColor;
  final bool value;
  final Function(bool?)? onChanged;
  final Widget child;

  const CustomCheckbox({
    required this.label,
    this.subLabel,
    this.labelColor = kBlackColor,
    this.backgroundColor = Colors.transparent,
    required this.value,
    required this.onChanged,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: const Border(
          bottom: BorderSide(color: kDisabledColor),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: CheckboxListTile(
              title: Text(
                label,
                style: TextStyle(color: labelColor),
              ),
              subtitle: subLabel != null ? Text(subLabel!) : null,
              value: value,
              onChanged: onChanged,
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
          SizedBox(
            width: 100,
            child: child,
          ),
        ],
      ),
    );
  }
}
