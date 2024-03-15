import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/apply_project.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/widgets/custom_file_field.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class ApplyProjectAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ApplyProjectAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ApplyProjectAddScreen> createState() => _ApplyProjectAddScreenState();
}

class _ApplyProjectAddScreenState extends State<ApplyProjectAddScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  File? pickedFile;

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ApplyProjectProvider>(context);
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
          '企画申請を作成',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String? error = await projectProvider.create(
                organization: widget.loginProvider.organization,
                group: widget.loginProvider.group,
                title: titleController.text,
                content: contentController.text,
                pickedFile: pickedFile,
                loginUser: widget.loginProvider.user,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, '企画申請を提出しました', true);
              Navigator.pop(context);
            },
            child: const Text('提出する'),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                CustomTextField(
                  controller: titleController,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  label: '件名',
                ),
                const SizedBox(height: 8),
                CustomTextField(
                  controller: contentController,
                  textInputType: TextInputType.multiline,
                  maxLines: 15,
                  label: '内容',
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
    );
  }
}
