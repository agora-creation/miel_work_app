import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';

class MonthPickerButton extends StatelessWidget {
  final DateTime value;
  final Function() onTap;

  const MonthPickerButton({
    required this.value,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: kGrey300Color,
          border: Border(bottom: BorderSide(color: kGreyColor)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dateText('yyyy年MM月', value)),
              const FaIcon(FontAwesomeIcons.calendar, color: kGrey600Color),
            ],
          ),
        ),
      ),
    );
  }
}
