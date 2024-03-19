import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply_proposal.dart';
import 'package:miel_work_app/providers/apply_proposal.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/widgets/custom_file_field.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class ApplyProposalAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyProposalModel? proposal;

  const ApplyProposalAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    this.proposal,
    super.key,
  });

  @override
  State<ApplyProposalAddScreen> createState() => _ApplyProposalAddScreenState();
}

class _ApplyProposalAddScreenState extends State<ApplyProposalAddScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  File? pickedFile;

  void _init() async {
    if (widget.proposal == null) return;
    titleController.text = widget.proposal?.title ?? '';
    contentController.text = widget.proposal?.content ?? '';
    priceController.text = widget.proposal?.price.toString() ?? '';
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final proposalProvider = Provider.of<ApplyProposalProvider>(context);
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
          '稟議申請を作成',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String priceText = priceController.text.replaceAll(',', '');
              int price = int.parse(priceText);
              String? error = await proposalProvider.create(
                organization: widget.loginProvider.organization,
                group: widget.loginProvider.group,
                title: titleController.text,
                content: contentController.text,
                price: price,
                pickedFile: pickedFile,
                loginUser: widget.loginProvider.user,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, '稟議申請を提出しました', true);
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
                  controller: priceController,
                  textInputType: TextInputType.number,
                  inputFormatters: [
                    CurrencyTextInputFormatter(
                      locale: 'ja',
                      decimalDigits: 0,
                      symbol: '',
                    ),
                  ],
                  maxLines: 1,
                  label: '金額',
                  prefix: const Text('¥ '),
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
