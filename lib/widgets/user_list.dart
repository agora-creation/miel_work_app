import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: kBorderColor)),
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
                      fontFamily: 'SourceHanSansJP-Bold',
                    ),
                  )
                : Container(),
          ],
        ),
        trailing: const FaIcon(
          FontAwesomeIcons.chevronRight,
          color: kDisabledColor,
          size: 16,
        ),
        onTap: onTap,
      ),
    );
  }
}
