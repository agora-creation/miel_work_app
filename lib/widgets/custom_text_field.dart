import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final int? maxLines;
  final String? label;
  final bool enabled;

  const CustomTextField({
    this.controller,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.label,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
        fillColor: kGrey200Color,
        enabled: enabled,
      ),
    );
  }
}
