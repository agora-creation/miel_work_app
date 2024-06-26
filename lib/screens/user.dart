import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/user_add.dart';
import 'package:miel_work_app/screens/user_mod.dart';
import 'package:miel_work_app/services/user.dart';
import 'package:miel_work_app/widgets/custom_user_list.dart';

class UserScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const UserScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  UserService userService = UserService();
  List<UserModel> users = [];

  void _getUsers() async {
    if (widget.homeProvider.currentGroup == null) {
      users = await userService.selectList(
        userIds: widget.loginProvider.organization?.userIds ?? [],
      );
    } else {
      users = await userService.selectList(
        userIds: widget.homeProvider.currentGroup?.userIds ?? [],
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: kBlackColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'スタッフ一覧',
          style: TextStyle(color: kBlackColor),
        ),
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: users.isNotEmpty
          ? ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                UserModel user = users[index];
                OrganizationGroupModel? userInGroup;
                if (widget.homeProvider.groups.isNotEmpty) {
                  for (OrganizationGroupModel group
                      in widget.homeProvider.groups) {
                    if (group.userIds.contains(user.id)) {
                      userInGroup = group;
                    }
                  }
                }
                return CustomUserList(
                  user: user,
                  userInGroup: userInGroup,
                  onTap: () => pushScreen(
                    context,
                    UserModScreen(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      user: user,
                      userInGroup: userInGroup,
                      getUsers: _getUsers,
                    ),
                  ),
                );
              },
            )
          : const Center(child: Text('スタッフはいません')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => pushScreen(
          context,
          UserAddScreen(
            loginProvider: widget.loginProvider,
            homeProvider: widget.homeProvider,
            getUsers: _getUsers,
          ),
        ),
        icon: const Icon(
          Icons.add,
          color: kWhiteColor,
        ),
        label: const Text(
          '新規追加',
          style: TextStyle(color: kWhiteColor),
        ),
      ),
    );
  }
}
