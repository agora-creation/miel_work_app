import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/login.dart';

class CustomAppbarTitle extends StatelessWidget {
  final LoginProvider loginProvider;

  const CustomAppbarTitle({
    required this.loginProvider,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String userName = loginProvider.user?.name ?? '';
    String orgName = loginProvider.organization?.name ?? '';
    String groupName = loginProvider.group?.name ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(userName),
        Row(
          children: [
            Text(
              '$orgName $groupName',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 4),
            loginProvider.isAdmin()
                ? const Text(
                    '管理者',
                    style: TextStyle(
                      color: kRedColor,
                      fontSize: 14,
                    ),
                  )
                : Container(),
          ],
        ),
      ],
    );
  }
}
