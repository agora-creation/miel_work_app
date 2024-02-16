import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class UserInfoList extends StatelessWidget {
  final String headingLabel;
  final List<String> values;
  final Function()? onTap;

  const UserInfoList({
    required this.headingLabel,
    required this.values,
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
              headingLabel,
              style: const TextStyle(color: kGrey600Color),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: values.map((value) {
                return Text(
                  value,
                  style: const TextStyle(color: kBlackColor),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
