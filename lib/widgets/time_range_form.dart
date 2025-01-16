import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/style.dart';

class TimeRangeForm extends StatelessWidget {
  final String startedTime;
  final Function() startedOnTap;
  final String endedTime;
  final Function() endedOnTap;

  const TimeRangeForm({
    required this.startedTime,
    required this.startedOnTap,
    required this.endedTime,
    required this.endedOnTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: kBorderColor)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: startedOnTap,
                  child: Text(
                    startedTime,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const FaIcon(
                  FontAwesomeIcons.arrowRight,
                  color: kDisabledColor,
                  size: 18,
                ),
                GestureDetector(
                  onTap: endedOnTap,
                  child: Text(
                    endedTime,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SourceHanSansJP-Bold',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
