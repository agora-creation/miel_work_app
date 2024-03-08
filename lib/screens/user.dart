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
          'スタッフ管理',
          style: TextStyle(color: kBlackColor),
        ),
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          UserModel user = users[index];
          OrganizationGroupModel? userInGroup;
          if (widget.homeProvider.groups.isNotEmpty) {
            for (OrganizationGroupModel group in widget.homeProvider.groups) {
              if (group.userIds.contains(user.id)) {
                userInGroup = group;
              }
            }
          }
          return Container(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: kGrey600Color)),
            ),
            child: ListTile(
              title: Text(user.name),
              subtitle: Text(userInGroup?.name ?? ''),
              trailing: const Icon(Icons.chevron_right),
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
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => pushScreen(
          context,
          UserAddScreen(
            loginProvider: widget.loginProvider,
            homeProvider: widget.homeProvider,
            getUsers: _getUsers,
          ),
        ),
        child: const Icon(Icons.add, color: kWhiteColor),
      ),
    );
  }
}
