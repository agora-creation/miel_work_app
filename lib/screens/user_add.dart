import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/user.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
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
  bool president = false;

  @override
  void initState() {
    selectedGroup = widget.homeProvider.currentGroup;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    List<DropdownMenuItem<OrganizationGroupModel?>> groupItems = [];
    if (widget.homeProvider.groups.isNotEmpty) {
      groupItems.add(const DropdownMenuItem(
        value: null,
        child: Text(
          '未所属',
          style: TextStyle(color: kGreyColor),
        ),
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
          icon: const FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: kBlackColor,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'スタッフを追加',
          style: TextStyle(color: kBlackColor),
        ),
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  FormLabel(
                    'スタッフ名',
                    child: CustomTextField(
                      controller: nameController,
                      textInputType: TextInputType.name,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FormLabel(
                    'メールアドレス',
                    child: CustomTextField(
                      controller: emailController,
                      textInputType: TextInputType.emailAddress,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FormLabel(
                    'パスワード',
                    child: CustomTextField(
                      controller: passwordController,
                      textInputType: TextInputType.visiblePassword,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FormLabel(
                    '所属グループ',
                    child: DropdownButton<OrganizationGroupModel?>(
                      hint: const Text(
                        '未所属',
                        style: TextStyle(color: kGreyColor),
                      ),
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
                  const SizedBox(height: 16),
                  FormLabel(
                    '管理者権限',
                    child: CheckboxListTile(
                      value: admin,
                      onChanged: (value) {
                        setState(() {
                          admin = value ?? false;
                        });
                      },
                      title: const Text('管理者にする'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FormLabel(
                    '社長権限',
                    child: CheckboxListTile(
                      value: president,
                      onChanged: (value) {
                        setState(() {
                          president = value ?? false;
                        });
                      },
                      title: const Text('社長にする'),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          String? error = await userProvider.create(
            organization: widget.loginProvider.organization,
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text,
            group: selectedGroup,
            admin: admin,
            president: president,
          );
          if (error != null) {
            if (!mounted) return;
            showMessage(context, error, false);
            return;
          }
          await widget.loginProvider.reload();
          widget.homeProvider.setGroups(
            organizationId: widget.loginProvider.organization?.id ?? 'error',
          );
          widget.getUsers();
          if (!mounted) return;
          showMessage(context, 'スタッフが追加されました', true);
          Navigator.pop(context);
        },
        icon: const FaIcon(
          FontAwesomeIcons.floppyDisk,
          color: kWhiteColor,
        ),
        label: const Text(
          '保存する',
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
