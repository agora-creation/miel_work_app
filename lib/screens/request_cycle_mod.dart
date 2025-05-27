import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/request_cycle.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/request_cycle.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/dotted_divider.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:provider/provider.dart';

class RequestCycleModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestCycleModel cycle;

  const RequestCycleModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.cycle,
    super.key,
  });

  @override
  State<RequestCycleModScreen> createState() => _RequestCycleModScreenState();
}

class _RequestCycleModScreenState extends State<RequestCycleModScreen> {
  TextEditingController companyName = TextEditingController();
  TextEditingController companyUserName = TextEditingController();
  TextEditingController companyUserEmail = TextEditingController();
  TextEditingController companyUserTel = TextEditingController();
  TextEditingController companyAddress = TextEditingController();

  @override
  void initState() {
    companyName.text = widget.cycle.companyName;
    companyUserName.text = widget.cycle.companyUserName;
    companyUserEmail.text = widget.cycle.companyUserEmail;
    companyUserTel.text = widget.cycle.companyUserTel;
    companyAddress.text = widget.cycle.companyAddress;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<RequestCycleProvider>(context);
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
          '自転車置き場使用申込：申請編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String? error = await cycleProvider.update(
                organization: widget.loginProvider.organization,
                cycle: widget.cycle,
                companyName: companyName.text,
                companyUserName: companyUserName.text,
                companyUserEmail: companyUserEmail.text,
                companyUserTel: companyUserTel.text,
                companyAddress: companyAddress.text,
                loginUser: widget.loginProvider.user,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, '自転車置き場使用申込情報が変更されました', true);
              Navigator.pop(context);
            },
            child: const Text('保存'),
          ),
        ],
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                '申込者情報',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗名',
                child: CustomTextField(
                  controller: companyName,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）明神水産',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用者名',
                child: CustomTextField(
                  controller: companyUserName,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）田中太郎',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用者メールアドレス',
                child: CustomTextField(
                  controller: companyUserEmail,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）tanaka@hirome.co.jp',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用者電話番号',
                child: CustomTextField(
                  controller: companyUserTel,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）090-0000-0000',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '住所',
                child: CustomTextField(
                  controller: companyAddress,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                ),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomFooter(
        loginProvider: widget.loginProvider,
        homeProvider: widget.homeProvider,
      ),
    );
  }
}
