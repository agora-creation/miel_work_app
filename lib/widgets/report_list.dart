import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';

class ReportList extends StatelessWidget {
  final DateTime day;

  const ReportList({
    required this.day,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: kGreyColor),
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundColor: dateText('E', day) == '土'
                  ? kLightBlueColor.withOpacity(0.3)
                  : dateText('E', day) == '日'
                      ? kDeepOrangeColor.withOpacity(0.3)
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
          const Expanded(
            child: ListTile(
              title: Text(''),
              trailing: FaIcon(
                FontAwesomeIcons.pen,
                color: kBlueColor,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
