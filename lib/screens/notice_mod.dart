import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/notice.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/notice.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/file_picker_button.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:provider/provider.dart';

class NoticeModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final NoticeModel notice;

  const NoticeModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.notice,
    super.key,
  });

  @override
  State<NoticeModScreen> createState() => _ManualModScreenState();
}

class _ManualModScreenState extends State<NoticeModScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  OrganizationGroupModel? selectedGroup;
  File? pickedFile;

  @override
  void initState() {
    titleController.text = widget.notice.title;
    contentController.text = widget.notice.content;
    if (widget.loginProvider.isAllGroup()) {
      selectedGroup = widget.homeProvider.currentGroup;
    } else {
      selectedGroup = widget.loginProvider.group;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final noticeProvider = Provider.of<NoticeProvider>(context);
    List<DropdownMenuItem<OrganizationGroupModel?>> groupItems = [];
    groupItems.add(const DropdownMenuItem(
      value: null,
      child: Text(
        'グループの指定なし',
        style: TextStyle(color: kGreyColor),
      ),
    ));
    if (widget.loginProvider.isAllGroup()) {
      if (widget.homeProvider.groups.isNotEmpty) {
        for (OrganizationGroupModel group in widget.homeProvider.groups) {
          groupItems.add(DropdownMenuItem(
            value: group,
            child: Text(group.name),
          ));
        }
      }
    } else {
      groupItems.add(DropdownMenuItem(
        value: widget.loginProvider.group,
        child: Text(widget.loginProvider.group?.name ?? ''),
      ));
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
          'お知らせ情報の編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DelNoticeDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                notice: widget.notice,
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
                  'タイトル',
                  child: CustomTextField(
                    controller: titleController,
                    textInputType: TextInputType.name,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  'お知らせ内容',
                  child: CustomTextField(
                    controller: contentController,
                    textInputType: TextInputType.multiline,
                    maxLines: 15,
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '送信先グループ',
                  child: DropdownButton<OrganizationGroupModel?>(
                    hint: const Text(
                      'グループの指定なし',
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
                  '添付ファイル',
                  child: FilePickerButton(
                    value: pickedFile,
                    defaultValue: widget.notice.file,
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.any,
                      );
                      if (result == null) return;
                      setState(() {
                        pickedFile = File(result.files.single.path!);
                      });
                    },
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
          String? error = await noticeProvider.update(
            organization: widget.loginProvider.organization,
            notice: widget.notice,
            title: titleController.text,
            content: contentController.text,
            group: selectedGroup,
            pickedFile: pickedFile,
            loginUser: widget.loginProvider.user,
          );
          if (error != null) {
            if (!mounted) return;
            showMessage(context, error, false);
            return;
          }
          if (!mounted) return;
          showMessage(context, 'お知らせ情報が変更されました', true);
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

class DelNoticeDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final NoticeModel notice;

  const DelNoticeDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.notice,
    super.key,
  });

  @override
  State<DelNoticeDialog> createState() => _DelNoticeDialogState();
}

class _DelNoticeDialogState extends State<DelNoticeDialog> {
  @override
  Widget build(BuildContext context) {
    final noticeProvider = Provider.of<NoticeProvider>(context);
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
            String? error = await noticeProvider.delete(
              notice: widget.notice,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, 'お知らせが削除されました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
