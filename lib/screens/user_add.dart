import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/user.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:provider/provider.dart';

class UserAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final Function() getUsers;

  const UserAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.getUsers,
    super.key,
  });

  @override
  State<UserAddScreen> createState() => _UserAddScreenState();
}

class _UserAddScreenState extends State<UserAddScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  OrganizationGroupModel? selectedGroup;
  bool admin = false;

  @override
  void initState() {
    super.initState();
    selectedGroup = widget.homeProvider.currentGroup;
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
          'スタッフを追加',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String? error = await userProvider.create(
                organization: widget.loginProvider.organization,
                name: nameController.text,
                email: emailController.text,
                password: passwordController.text,
                group: selectedGroup,
                admin: admin,
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
              showMessage(context, 'スタッフを追加しました', true);
              Navigator.pop(context);
            },
            child: const Text('保存'),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextField(
                  controller: nameController,
                  textInputType: TextInputType.name,
                  maxLines: 1,
                  label: 'スタッフ名',
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: emailController,
                  textInputType: TextInputType.emailAddress,
                  maxLines: 1,
                  label: 'メールアドレス',
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: passwordController,
                  textInputType: TextInputType.visiblePassword,
                  maxLines: 1,
                  label: 'パスワード',
                ),
                const SizedBox(height: 8),
                FormLabel(
                  label: '所属グループ',
                  child: DropdownButton<OrganizationGroupModel?>(
                    hint: const Text('グループ未選択'),
                    underline: Container(),
                    isExpanded: true,
                    value: selectedGroup,
                    items: groupItems,
                    onChanged: (value) {
                      setState(() {
                        selectedGroup = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                FormLabel(
                  label: '権限',
                  child: CheckboxListTile(
                    value: admin,
                    onChanged: (value) {
                      setState(() {
                        admin = value ?? false;
                      });
                    },
                    title: const Text('このスタッフを管理者とする'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
