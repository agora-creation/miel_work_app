import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/plan_garbageman.dart';

class PlanGarbagemanList extends StatelessWidget {
  final PlanGarbagemanModel garbageman;
  final Function()? onTap;

  const PlanGarbagemanList({
    required this.garbageman,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: kBlueColor,
            borderRadius: BorderRadius.circular(4),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                garbageman.content,
                style: const TextStyle(
                  color: kWhiteColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                dateText('yyyy/MM/dd', garbageman.eventAt),
                style: const TextStyle(
                  color: kWhiteColor,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
