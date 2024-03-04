import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/login.dart';
import 'package:miel_work_app/services/user.dart';
import 'package:miel_work_app/widgets/custom_button_sm.dart';
import 'package:miel_work_app/widgets/custom_checkbox.dart';
import 'package:miel_work_app/widgets/custom_setting_list.dart';
import 'package:miel_work_app/widgets/custom_text_form_field.dart';
import 'package:miel_work_app/widgets/link_text.dart';

class UserSettingScreen extends StatefulWidget {
  final LoginProvider loginProvider;

  const UserSettingScreen({
    required this.loginProvider,
    super.key,
  });

  @override
  State<UserSettingScreen> createState() => _UserSettingScreenState();
}

class _UserSettingScreenState extends State<UserSettingScreen> {
  UserService userService = UserService();
  List<UserModel> users = [];
  String usersText = '';

  void _init() async {
    users = await userService.selectList(
      userIds: widget.loginProvider.organization?.userIds ?? [],
    );
    for (UserModel user in users) {
      List<String> adminUserIds =
          widget.loginProvider.organization?.adminUserIds ?? [];
      if (adminUserIds.contains(user.id)) {
        if (usersText != '') usersText += ',';
        usersText += user.name;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'スタッフ設定',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: Column(
        children: [
          widget.loginProvider.isAdmin()
              ? const ListTile(
                  title: Text(
                    'あなたは管理者です',
                    style: TextStyle(color: kWhiteColor),
                  ),
                  tileColor: kRedColor,
                )
              : Container(),
          CustomSettingList(
            label: '名前',
            value: widget.loginProvider.user?.name ?? '',
            onTap: () => showDialog(
              context: context,
              builder: (context) => ModNameDialog(
                loginProvider: widget.loginProvider,
              ),
            ),
          ),
          CustomSettingList(
            label: 'メールアドレス',
            value: widget.loginProvider.user?.email ?? '',
            onTap: () => showDialog(
              context: context,
              builder: (context) => ModEmailDialog(
                loginProvider: widget.loginProvider,
              ),
            ),
          ),
          CustomSettingList(
            label: 'パスワード',
            value: '********',
            onTap: () => showDialog(
              context: context,
              builder: (context) => ModPasswordDialog(
                loginProvider: widget.loginProvider,
              ),
            ),
          ),
          widget.loginProvider.isAdmin()
              ? CustomSettingList(
                  label: '現在の管理者',
                  value: usersText,
                  onTap: () => showDialog(
                    context: context,
                    builder: (context) => ModAdminDialog(
                      loginProvider: widget.loginProvider,
                      users: users,
                    ),
                  ),
                )
              : Container(),
          const SizedBox(height: 24),
          LinkText(
            label: 'この端末からログアウトする',
            color: kRedColor,
            onTap: () => showDialog(
              context: context,
              builder: (context) => LogoutDialog(
                loginProvider: widget.loginProvider,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ModNameDialog extends StatefulWidget {
  final LoginProvider loginProvider;

  const ModNameDialog({
    required this.loginProvider,
    super.key,
  });

  @override
  State<ModNameDialog> createState() => _ModNameDialogState();
}

class _ModNameDialogState extends State<ModNameDialog> {
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.loginProvider.user?.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      title: const Text(
        '名前を変更する',
        style: TextStyle(fontSize: 16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: nameController,
            textInputType: TextInputType.name,
            maxLines: 1,
            label: '名前',
            color: kBlackColor,
            prefix: Icons.person,
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        CustomButtonSm(
          label: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButtonSm(
          label: '入力内容を保存',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await widget.loginProvider.updateName(
              name: nameController.text,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            widget.loginProvider.reload();
            if (!mounted) return;
            showMessage(context, '名前を変更しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ModEmailDialog extends StatefulWidget {
  final LoginProvider loginProvider;

  const ModEmailDialog({
    required this.loginProvider,
    super.key,
  });

  @override
  State<ModEmailDialog> createState() => _ModEmailDialogState();
}

class _ModEmailDialogState extends State<ModEmailDialog> {
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.text = widget.loginProvider.user?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      title: const Text(
        'メールアドレスを変更する',
        style: TextStyle(fontSize: 16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: emailController,
            textInputType: TextInputType.emailAddress,
            maxLines: 1,
            label: 'メールアドレス',
            color: kBlackColor,
            prefix: Icons.email,
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        CustomButtonSm(
          label: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButtonSm(
          label: '入力内容を保存',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await widget.loginProvider.updateEmail(
              email: emailController.text,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            widget.loginProvider.reload();
            if (!mounted) return;
            showMessage(context, 'メールアドレスを変更しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ModPasswordDialog extends StatefulWidget {
  final LoginProvider loginProvider;

  const ModPasswordDialog({
    required this.loginProvider,
    super.key,
  });

  @override
  State<ModPasswordDialog> createState() => _ModPasswordDialogState();
}

class _ModPasswordDialogState extends State<ModPasswordDialog> {
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    passwordController.text = widget.loginProvider.user?.password ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      title: const Text(
        'パスワードを変更する',
        style: TextStyle(fontSize: 16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            controller: passwordController,
            obscureText: true,
            textInputType: TextInputType.visiblePassword,
            maxLines: 1,
            label: 'パスワード',
            color: kBlackColor,
            prefix: Icons.password,
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        CustomButtonSm(
          label: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButtonSm(
          label: '入力内容を保存',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await widget.loginProvider.updatePassword(
              password: passwordController.text,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            widget.loginProvider.reload();
            if (!mounted) return;
            showMessage(context, 'パスワードを変更しました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ModAdminDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final List<UserModel> users;

  const ModAdminDialog({
    required this.loginProvider,
    required this.users,
    super.key,
  });

  @override
  State<ModAdminDialog> createState() => _ModAdminDialogState();
}

class _ModAdminDialogState extends State<ModAdminDialog> {
  List<UserModel> selectedUsers = [];

  void _init() {
    List<String> adminUserIds =
        widget.loginProvider.organization?.adminUserIds ?? [];
    for (UserModel user in widget.users) {
      if (adminUserIds.contains(user.id)) {
        selectedUsers.add(user);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      title: const Text(
        '管理者を変更する',
        style: TextStyle(fontSize: 16),
      ),
      content: Container(
        decoration: BoxDecoration(border: Border.all(color: kGrey600Color)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.users.map((user) {
              return CustomCheckbox(
                label: user.name,
                value: selectedUsers.contains(user),
                onChanged: (value) {
                  if (selectedUsers.contains(user)) {
                    selectedUsers.remove(user);
                  } else {
                    selectedUsers.add(user);
                  }
                  setState(() {});
                },
              );
            }).toList(),
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        CustomButtonSm(
          label: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButtonSm(
          label: '選択内容を保存',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await widget.loginProvider.updateAdminUserIds(
              selectedUsers: selectedUsers,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            await widget.loginProvider.logout();
            if (!mounted) return;
            showMessage(context, '管理者を変更しました', true);
            pushReplacementScreen(context, const LoginScreen());
          },
        ),
      ],
    );
  }
}

class LogoutDialog extends StatefulWidget {
  final LoginProvider loginProvider;

  const LogoutDialog({
    required this.loginProvider,
    super.key,
  });

  @override
  State<LogoutDialog> createState() => _LogoutDialogState();
}

class _LogoutDialogState extends State<LogoutDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8),
          Text(
            '本当にログアウトしますか？',
            style: TextStyle(color: kBlackColor),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        CustomButtonSm(
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButtonSm(
          label: 'ログアウト',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            await widget.loginProvider.logout();
            if (!mounted) return;
            pushReplacementScreen(context, const LoginScreen());
          },
        ),
      ],
    );
  }
}
