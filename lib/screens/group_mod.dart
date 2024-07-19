import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/form_label.dart';

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
    nameController.text = widget.group.name;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          'グループ情報の編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DelGroupDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                group: widget.group,
                getGroups: widget.getGroups,
              ),
            ),
            icon: const FaIcon(
              FontAwesomeIcons.trash,
              color: kRedColor,
            ),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                FormLabel(
                  'グループ名',
                  child: CustomTextField(
                    controller: nameController,
                    textInputType: TextInputType.name,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
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
          showMessage(context, 'グループ名が変更されました', true);
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
    );
  }
}

class DelGroupDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final OrganizationGroupModel group;
  final Function() getGroups;

  const DelGroupDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.group,
    required this.getGroups,
    super.key,
  });

  @override
  State<DelGroupDialog> createState() => _DelGroupDialogState();
}

class _DelGroupDialogState extends State<DelGroupDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text(
              '本当に削除しますか？',
              style: TextStyle(color: kRedColor),
            ),
          ],
        ),
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
          label: '削除する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
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
            showMessage(context, 'グループが削除されました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
