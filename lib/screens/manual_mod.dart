import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/manual.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/manual.dart';
import 'package:miel_work_app/widgets/custom_button_sm.dart';
import 'package:miel_work_app/widgets/custom_text_form_field.dart';
import 'package:miel_work_app/widgets/link_text.dart';
import 'package:provider/provider.dart';

class ManualModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ManualModel manual;

  const ManualModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.manual,
    super.key,
  });

  @override
  State<ManualModScreen> createState() => _ManualModScreenState();
}

class _ManualModScreenState extends State<ManualModScreen> {
  TextEditingController titleController = TextEditingController();
  PlatformFile? pickedFile;
  OrganizationGroupModel? selectedGroup;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.manual.title;
    selectedGroup = widget.homeProvider.currentGroup;
  }

  @override
  Widget build(BuildContext context) {
    final manualProvider = Provider.of<ManualProvider>(context);
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
          '業務マニュアル情報の編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String? error = await manualProvider.update(
                manual: widget.manual,
                title: titleController.text,
                pickedFile: pickedFile,
                group: selectedGroup,
                user: widget.loginProvider.user,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, '業務マニュアル情報を変更しました', true);
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
              controller: titleController,
              textInputType: TextInputType.name,
              maxLines: 1,
              label: 'タイトル',
              color: kBlackColor,
              prefix: Icons.short_text,
            ),
            const SizedBox(height: 8),
            CustomButtonSm(
              label: 'PDFファイル選択',
              labelColor: kWhiteColor,
              backgroundColor: kGreyColor,
              onPressed: () async {
                final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf'],
                );
                if (result == null) return;
                setState(() {
                  pickedFile = result.files.first;
                });
              },
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
            LinkText(
              label: 'この業務マニュアルを削除する',
              color: kRedColor,
              onTap: () async {
                String? error = await manualProvider.delete(
                  manual: widget.manual,
                );
                if (error != null) {
                  if (!mounted) return;
                  showMessage(context, error, false);
                  return;
                }
                if (!mounted) return;
                showMessage(context, '業務マニュアルを削除しました', true);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}