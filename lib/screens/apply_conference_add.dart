import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply_conference.dart';
import 'package:miel_work_app/providers/apply_conference.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/widgets/custom_file_field.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class ApplyConferenceAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyConferenceModel? conference;

  const ApplyConferenceAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    this.conference,
    super.key,
  });

  @override
  State<ApplyConferenceAddScreen> createState() =>
      _ApplyConferenceAddScreenState();
}

class _ApplyConferenceAddScreenState extends State<ApplyConferenceAddScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  File? pickedFile;

  void _init() async {
    if (widget.conference == null) return;
    titleController.text = widget.conference?.title ?? '';
    contentController.text = widget.conference?.content ?? '';
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final conferenceProvider = Provider.of<ApplyConferenceProvider>(context);
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
          '協議・報告申請を作成',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String? error = await conferenceProvider.create(
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
              showMessage(context, '協議・報告申請を提出しました', true);
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
