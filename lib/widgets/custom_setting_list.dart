import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class CustomSettingList extends StatelessWidget {
  final String label;
  final String value;
  final Function()? onTap;

  const CustomSettingList({
    required this.label,
    required this.value,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: kGrey600Color),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: kGrey600Color,
                fontSize: 18,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: kBlackColor,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
