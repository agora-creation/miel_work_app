import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/how_to.dart';
import 'package:miel_work_app/screens/login.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/link_text.dart';
import 'package:miel_work_app/widgets/setting_list.dart';
import 'package:page_transition/page_transition.dart';

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
          '設定',
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
      body: Column(
        children: [
          SettingList(
            label: '名前',
            value: widget.loginProvider.user?.name ?? '',
            onTap: () => showDialog(
              context: context,
              builder: (context) => ModNameDialog(
                loginProvider: widget.loginProvider,
              ),
            ),
          ),
          SettingList(
            label: 'メールアドレス',
            value: widget.loginProvider.user?.email ?? '',
            onTap: () => showDialog(
              context: context,
              builder: (context) => ModEmailDialog(
                loginProvider: widget.loginProvider,
              ),
            ),
          ),
          SettingList(
            label: 'パスワード',
            value: '********',
            onTap: () => showDialog(
              context: context,
              builder: (context) => ModPasswordDialog(
                loginProvider: widget.loginProvider,
              ),
            ),
          ),
          SettingList(
            label: 'このアプリの使い方',
            value: '',
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const HowToScreen(),
                ),
              );
            },
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
      bottomNavigationBar: CustomFooter(
        loginProvider: widget.loginProvider,
        homeProvider: widget.homeProvider,
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
    nameController.text = widget.loginProvider.user?.name ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
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
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '保存する',
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
            showMessage(context, '名前が変更されました', true);
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
    emailController.text = widget.loginProvider.user?.email ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
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
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '保存する',
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
            showMessage(context, 'メールアドレスが変更されました', true);
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
    return CustomAlertDialog(
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
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: '閉じる',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '保存する',
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
            showMessage(context, 'パスワードが変更されました', true);
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
    return CustomAlertDialog(
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8),
          Text(
            '本当にログアウトしますか？',
            style: TextStyle(
              color: kRedColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: 'ログアウト',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            await widget.loginProvider.logout();
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.topToBottom,
                child: const LoginScreen(),
              ),
            );
          },
        ),
      ],
    );
  }
}
