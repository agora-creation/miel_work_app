import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/notice.dart';
import 'package:miel_work_app/widgets/custom_text_form_field.dart';
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

  @override
  void initState() {
    super.initState();
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
                user: widget.loginProvider.user,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                '※追加時、送信先グループに所属しているスタッフアプリに通知します。',
                style: TextStyle(color: kRedColor),
              ),
              const Text(
                '※グループ未選択の場合、全てのスタッフアプリに通知します。',
                style: TextStyle(color: kRedColor),
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: titleController,
                textInputType: TextInputType.name,
                maxLines: 1,
                label: 'タイトル',
                color: kBlackColor,
                prefix: Icons.short_text,
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: contentController,
                textInputType: TextInputType.multiline,
                maxLines: null,
                label: 'お知らせ内容',
                color: kBlackColor,
                prefix: Icons.short_text,
              ),
              const SizedBox(height: 8),
              FormLabel(
                label: '送信先グループ',
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
            ],
          ),
        ),
      ),
    );
  }
}
