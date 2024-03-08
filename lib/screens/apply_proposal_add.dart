import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/apply_proposal.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/widgets/custom_text_form_field.dart';
import 'package:provider/provider.dart';

class ApplyProposalAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ApplyProposalAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ApplyProposalAddScreen> createState() => _ApplyProposalAddScreenState();
}

class _ApplyProposalAddScreenState extends State<ApplyProposalAddScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController priceController = TextEditingController(text: '0');

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
              String? error = await proposalProvider.create(
                organization: widget.loginProvider.organization,
                group: widget.loginProvider.group,
                title: titleController.text,
                content: contentController.text,
                price: int.parse(priceController.text),
                user: widget.loginProvider.user,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, '稟議申請を作成しました', true);
              Navigator.pop(context);
            },
            child: const Text('保存'),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              CustomTextFormField(
                controller: titleController,
                textInputType: TextInputType.name,
                maxLines: 1,
                label: '件名',
                color: kBlackColor,
                prefix: Icons.short_text,
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: contentController,
                textInputType: TextInputType.multiline,
                maxLines: null,
                label: '内容',
                color: kBlackColor,
                prefix: Icons.short_text,
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: priceController,
                textInputType: TextInputType.number,
                maxLines: 1,
                label: '金額',
                color: kBlackColor,
                prefix: Icons.money,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
