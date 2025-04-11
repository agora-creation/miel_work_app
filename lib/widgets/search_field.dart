import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;

  const SearchField({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(),
      decoration: InputDecoration(
        hintText: 'キーワード検索',
        prefixIcon: const Icon(Icons.search),
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        filled: true,
        fillColor: controller.text != ''
            ? kLightBlueColor.withOpacity(0.3)
            : kGreyColor.withOpacity(0.3),
      ),
    );
  }
}
