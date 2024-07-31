import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/user_add.dart';
import 'package:miel_work_app/screens/user_mod.dart';
import 'package:miel_work_app/services/user.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/user_list.dart';
import 'package:page_transition/page_transition.dart';

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
    _getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        title: const Text(
          'スタッフ一覧',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.xmark,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
        shape: Border(bottom: BorderSide(color: kBorderColor)),
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
                return UserList(
                  user: user,
                  userInGroup: userInGroup,
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: UserModScreen(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                          user: user,
                          userInGroup: userInGroup,
                          getUsers: _getUsers,
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : const Center(child: Text('スタッフはいません')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: UserAddScreen(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                getUsers: _getUsers,
              ),
            ),
          );
        },
        icon: const FaIcon(
          FontAwesomeIcons.plus,
          color: kWhiteColor,
        ),
        label: const Text(
          '追加する',
          style: TextStyle(color: kWhiteColor),
        ),
      ),
      bottomNavigationBar: CustomFooter(
        loginProvider: widget.loginProvider,
        homeProvider: widget.homeProvider,
      ),
    );
  }
}
