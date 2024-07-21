import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/login.dart';

class CustomAppbar extends StatelessWidget {
  final LoginProvider loginProvider;
  final List<Widget> actions;

  const CustomAppbar({
    required this.loginProvider,
    required this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String userName = loginProvider.user?.name ?? '';
    String orgName = loginProvider.organization?.name ?? '';
    String groupName = loginProvider.group?.name ?? '';
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              Row(
                children: [
                  Text(
                    '$orgName $groupName',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 4),
                  loginProvider.user?.admin == true
                      ? const Text(
                          '管理者',
                          style: TextStyle(
                            color: kRedColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
          Row(children: actions),
        ],
      ),
    );
  }
}
