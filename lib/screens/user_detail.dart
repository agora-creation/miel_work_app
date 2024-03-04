import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/user.dart';
import 'package:miel_work_app/widgets/custom_text_form_field.dart';
import 'package:miel_work_app/widgets/link_text.dart';
import 'package:provider/provider.dart';

class UserDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final UserModel user;
  final OrganizationGroupModel? userInGroup;
  final Function() getUsers;

  const UserDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.user,
    required this.userInGroup,
    required this.getUsers,
    super.key,
  });

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  OrganizationGroupModel? selectedGroup;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.user.name;
    emailController.text = widget.user.email;
    passwordController.text = widget.user.password;
    selectedGroup = widget.userInGroup;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    List<DropdownMenuItem<OrganizationGroupModel?>> groupItems = [];
    if (widget.homeProvider.groups.isNotEmpty) {
      groupItems.add(const DropdownMenuItem(
        value: null,
        child: Text('グループ未選択'),
      ));
      for (OrganizationGroupModel group in widget.homeProvider.groups) {
        groupItems.add(DropdownMenuItem(
          value: group,
          child: Text(group.name),
        ));
      }
    }
    bool deleteDisabled = false;
    List<String> adminUserIds =
        widget.loginProvider.organization?.adminUserIds ?? [];
    if (adminUserIds.contains(widget.user.id)) {
      deleteDisabled = true;
    }
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
          'スタッフ情報の編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String? error = await userProvider.update(
                user: widget.user,
                name: nameController.text,
                email: emailController.text,
                password: passwordController.text,
                befGroup: widget.userInGroup,
                aftGroup: selectedGroup,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              await widget.loginProvider.reload();
              widget.homeProvider.setGroups(
                organizationId:
                    widget.loginProvider.organization?.id ?? 'error',
              );
              widget.getUsers();
              if (!mounted) return;
              showMessage(context, 'スタッフ情報を変更しました', true);
              Navigator.pop(context);
            },
            child: const Text('保存'),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextFormField(
              controller: nameController,
              textInputType: TextInputType.name,
              maxLines: 1,
              label: 'スタッフ名',
              color: kBlackColor,
              prefix: Icons.short_text,
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              controller: emailController,
              textInputType: TextInputType.emailAddress,
              maxLines: 1,
              label: 'メールアドレス',
              color: kBlackColor,
              prefix: Icons.email,
            ),
            const SizedBox(height: 8),
            CustomTextFormField(
              controller: passwordController,
              textInputType: TextInputType.visiblePassword,
              maxLines: 1,
              label: 'パスワード',
              color: kBlackColor,
              prefix: Icons.password,
            ),
            const SizedBox(height: 8),
            DropdownButton<OrganizationGroupModel?>(
              isExpanded: true,
              value: selectedGroup,
              items: groupItems,
              onChanged: (value) {
                setState(() {
                  selectedGroup = value;
                });
              },
            ),
            const SizedBox(height: 24),
            !deleteDisabled
                ? LinkText(
                    label: 'このスタッフを削除する',
                    color: kRedColor,
                    onTap: () async {
                      String? error = await userProvider.delete(
                        organization: widget.loginProvider.organization,
                        user: widget.user,
                        group: widget.userInGroup,
                      );
                      if (error != null) {
                        if (!mounted) return;
                        showMessage(context, error, false);
                        return;
                      }
                      await widget.loginProvider.reload();
                      widget.homeProvider.setGroups(
                        organizationId:
                            widget.loginProvider.organization?.id ?? 'error',
                      );
                      widget.getUsers();
                      if (!mounted) return;
                      showMessage(context, 'スタッフを削除しました', true);
                      Navigator.pop(context);
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
