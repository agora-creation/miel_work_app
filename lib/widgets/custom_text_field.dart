import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miel_work_app/common/style.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final String? label;
  final String? hintText;
  final Widget? prefix;
  final bool enabled;
  final Function(String)? onChanged;

  const CustomTextField({
    this.controller,
    this.textInputType = TextInputType.text,
    this.inputFormatters,
    this.maxLines,
    this.label,
    this.hintText,
    this.prefix,
    this.enabled = true,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: textInputType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
        fillColor: kGrey200Color,
        prefix: prefix,
        enabled: enabled,
      ),
      onChanged: onChanged,
    );
  }
}
