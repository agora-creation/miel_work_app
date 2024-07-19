import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/user.dart';

class UserList extends StatelessWidget {
  final UserModel user;
  final OrganizationGroupModel? userInGroup;
  final Function()? onTap;

  const UserList({
    required this.user,
    required this.userInGroup,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      child: ListTile(
        title: Text(
          user.name,
          style: const TextStyle(fontSize: 20),
        ),
        subtitle: Row(
          children: [
            userInGroup != null
                ? Text(
                    userInGroup?.name ?? '',
                    style: const TextStyle(fontSize: 14),
                  )
                : const Text(
                    '未所属',
                    style: TextStyle(fontSize: 14),
                  ),
            const SizedBox(width: 4),
            user.admin
                ? const Text(
                    '管理者',
                    style: TextStyle(
                      color: kRedColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Container(),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
