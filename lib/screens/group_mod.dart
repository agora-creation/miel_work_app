import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/widgets/custom_text_form_field.dart';
import 'package:miel_work_app/widgets/link_text.dart';

class GroupModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final OrganizationGroupModel group;
  final Function() getGroups;

  const GroupModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.group,
    required this.getGroups,
    super.key,
  });

  @override
  State<GroupModScreen> createState() => _GroupModScreenState();
}

class _GroupModScreenState extends State<GroupModScreen> {
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.group.name;
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
          'グループ情報の編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String? error = await widget.homeProvider.groupUpdate(
                organization: widget.loginProvider.organization,
                group: widget.group,
                name: nameController.text,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              widget.getGroups();
              if (!mounted) return;
              showMessage(context, 'グループ名を変更しました', true);
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextFormField(
              controller: nameController,
              textInputType: TextInputType.name,
              maxLines: 1,
              label: 'グループ名',
              color: kBlackColor,
              prefix: Icons.short_text,
            ),
            const SizedBox(height: 16),
            LinkText(
              label: 'このグループを削除する',
              color: kRedColor,
              onTap: () async {
                String? error = await widget.homeProvider.groupDelete(
                  organization: widget.loginProvider.organization,
                  group: widget.group,
                );
                if (error != null) {
                  if (!mounted) return;
                  showMessage(context, error, false);
                  return;
                }
                widget.homeProvider.currentGroupClear();
                widget.getGroups();
                if (!mounted) return;
                showMessage(context, 'グループを削除しました', true);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
