import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/login.dart';
import 'package:miel_work_app/widgets/custom_button_sm.dart';
import 'package:miel_work_app/widgets/custom_setting_list.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/link_text.dart';

class UserSettingScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const UserSettingScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<UserSettingScreen> createState() => _UserSettingScreenState();
}

class _UserSettingScreenState extends State<UserSettingScreen> {
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
        '名前を変更',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: nameController,
            textInputType: TextInputType.name,
            maxLines: 1,
            label: '名前',
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
        'メールアドレスを変更',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: emailController,
            textInputType: TextInputType.emailAddress,
            maxLines: 1,
            label: 'メールアドレス',
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
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      title: const Text(
        'パスワードを変更',
        style: TextStyle(fontSize: 18),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            controller: passwordController,
            textInputType: TextInputType.visiblePassword,
            maxLines: 1,
            label: 'パスワード',
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
            style: TextStyle(
              color: kBlackColor,
              fontSize: 16,
            ),
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
