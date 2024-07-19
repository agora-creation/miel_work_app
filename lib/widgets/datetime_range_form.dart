import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';

class DatetimeRangeForm extends StatelessWidget {
  final DateTime startedAt;
  final Function() startedOnTap;
  final DateTime endedAt;
  final Function() endedOnTap;
  final bool allDay;
  final Function(bool?) allDayOnChanged;

  const DatetimeRangeForm({
    required this.startedAt,
    required this.startedOnTap,
    required this.endedAt,
    required this.endedOnTap,
    required this.allDay,
    required this.allDayOnChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: kGrey600Color)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: startedOnTap,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateText('yyyy年MM月dd日(E)', startedAt),
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        dateText('HH:mm', startedAt),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const FaIcon(
                  FontAwesomeIcons.arrowRight,
                  color: kGrey600Color,
                  size: 18,
                ),
                GestureDetector(
                  onTap: endedOnTap,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateText('yyyy年MM月dd日(E)', endedAt),
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        dateText('HH:mm', endedAt),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: kGrey600Color)),
            ),
            child: CheckboxListTile(
              value: allDay,
              onChanged: allDayOnChanged,
              title: const Text('終日'),
            ),
          ),
        ],
      ),
    );
  }
}
