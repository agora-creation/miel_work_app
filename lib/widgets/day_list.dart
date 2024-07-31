import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';

class DayList extends StatelessWidget {
  final DateTime day;
  final Widget child;

  const DayList(
    this.day, {
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundColor: dateText('E', day) == '土'
                  ? kSaturdayColor.withOpacity(0.3)
                  : dateText('E', day) == '日'
                      ? kSundayColor.withOpacity(0.3)
                      : Colors.transparent,
              radius: 24,
              child: Text(
                dateText('dd(E)', day),
                style: const TextStyle(
                  color: kBlackColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}
