import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/manual.dart';
import 'package:miel_work_app/models/user.dart';

class CustomManualList extends StatelessWidget {
  final ManualModel manual;
  final UserModel? user;
  final Function()? onTap;

  const CustomManualList({
    required this.manual,
    required this.user,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: kGrey600Color),
        ),
      ),
      child: ListTile(
        title: Text(manual.title),
        trailing: const Icon(Icons.chevron_right),
        tileColor:
            !manual.readUserIds.contains(user?.id) ? kRed100Color : kWhiteColor,
        onTap: onTap,
      ),
    );
  }
}
