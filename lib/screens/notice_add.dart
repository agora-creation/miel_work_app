import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/notice.dart';
import 'package:miel_work_app/widgets/custom_file_field.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:provider/provider.dart';

class NoticeAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const NoticeAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<NoticeAddScreen> createState() => _NoticeAddScreenState();
}

class _NoticeAddScreenState extends State<NoticeAddScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  OrganizationGroupModel? selectedGroup;
  File? pickedFile;

  @override
  void initState() {
    super.initState();
    if (widget.loginProvider.isAllGroup()) {
      selectedGroup = widget.homeProvider.currentGroup;
    } else {
      selectedGroup = widget.loginProvider.group;
    }
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
    return MediaQuery.withNoTextScaling(
      child: Scaffold(
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
            'お知らせを追加',
            style: TextStyle(color: kBlackColor),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String? error = await noticeProvider.create(
                  organization: widget.loginProvider.organization,
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
                showMessage(context, 'お知らせを追加しました', true);
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
                  const SizedBox(height: 8),
                  CustomFileField(
                    value: pickedFile,
                    defaultValue: '',
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
