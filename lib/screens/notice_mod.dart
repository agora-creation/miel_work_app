import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/notice.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/notice.dart';
import 'package:miel_work_app/widgets/custom_file_field.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/link_text.dart';
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
    super.initState();
    titleController.text = widget.notice.title;
    contentController.text = widget.notice.content;
    selectedGroup = widget.homeProvider.currentGroup;
  }

  @override
  Widget build(BuildContext context) {
    final noticeProvider = Provider.of<NoticeProvider>(context);
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
          'お知らせ情報の編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          TextButton(
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
              showMessage(context, 'お知らせ情報を変更しました', true);
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
                  controller: titleController,
                  textInputType: TextInputType.name,
                  maxLines: 1,
                  label: 'タイトル',
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: contentController,
                  textInputType: TextInputType.multiline,
                  maxLines: 15,
                  label: 'お知らせ内容',
                ),
                const SizedBox(height: 8),
                FormLabel(
                  label: '送信先グループ',
                  child: widget.loginProvider.isAllGroup()
                      ? DropdownButton<OrganizationGroupModel?>(
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
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '${selectedGroup?.name}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                ),
                const SizedBox(height: 8),
                CustomFileField(
                  value: pickedFile,
                  defaultValue: widget.notice.file,
                  onTap: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.any,
                    );
                    if (result == null) return;
                    setState(() {
                      pickedFile = File(result.files.single.path!);
                    });
                  },
                ),
                const SizedBox(height: 24),
                LinkText(
                  label: 'このお知らせを削除する',
                  color: kRedColor,
                  onTap: () async {
                    String? error = await noticeProvider.delete(
                      notice: widget.notice,
                    );
                    if (error != null) {
                      if (!mounted) return;
                      showMessage(context, error, false);
                      return;
                    }
                    if (!mounted) return;
                    showMessage(context, 'お知らせを削除しました', true);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
