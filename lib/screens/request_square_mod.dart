import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/request_square.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/request_square.dart';
import 'package:miel_work_app/widgets/custom_checkbox.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/datetime_range_form.dart';
import 'package:miel_work_app/widgets/dotted_divider.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:provider/provider.dart';

class RequestSquareModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestSquareModel square;

  const RequestSquareModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.square,
    super.key,
  });

  @override
  State<RequestSquareModScreen> createState() => _RequestSquareModScreenState();
}

class _RequestSquareModScreenState extends State<RequestSquareModScreen> {
  TextEditingController companyName = TextEditingController();
  TextEditingController companyUserName = TextEditingController();
  TextEditingController companyUserEmail = TextEditingController();
  TextEditingController companyUserTel = TextEditingController();
  TextEditingController companyAddress = TextEditingController();
  TextEditingController useCompanyName = TextEditingController();
  TextEditingController useCompanyUserName = TextEditingController();
  DateTime useStartedAt = DateTime.now();
  DateTime useEndedAt = DateTime.now();
  bool useAtPending = false;
  bool useFull = false;
  bool useChair = false;
  TextEditingController useChairNum = TextEditingController(text: '0');
  bool useDesk = false;
  TextEditingController useDeskNum = TextEditingController(text: '0');
  TextEditingController useContent = TextEditingController();

  @override
  void initState() {
    companyName.text = widget.square.companyName;
    companyUserName.text = widget.square.companyUserName;
    companyUserEmail.text = widget.square.companyUserEmail;
    companyUserTel.text = widget.square.companyUserTel;
    companyAddress.text = widget.square.companyAddress;
    useCompanyName.text = widget.square.useCompanyName;
    useCompanyUserName.text = widget.square.useCompanyUserName;
    useStartedAt = widget.square.useStartedAt;
    useEndedAt = widget.square.useEndedAt;
    useAtPending = false;
    useFull = widget.square.useFull;
    useChair = widget.square.useChair;
    useChairNum.text = widget.square.useChairNum.toString();
    useDesk = widget.square.useDesk;
    useDeskNum.text = widget.square.useDeskNum.toString();
    useContent.text = widget.square.useContent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final squareProvider = Provider.of<RequestSquareProvider>(context);
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
          'よさこい広場使用申込：申請編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String? error = await squareProvider.update(
                square: widget.square,
                companyName: companyName.text,
                companyUserName: companyUserName.text,
                companyUserEmail: companyUserEmail.text,
                companyUserTel: companyUserTel.text,
                companyAddress: companyAddress.text,
                useCompanyName: useCompanyName.text,
                useCompanyUserName: useCompanyUserName.text,
                useStartedAt: useStartedAt,
                useEndedAt: useEndedAt,
                useAtPending: useAtPending,
                useFull: useFull,
                useChair: useChair,
                useChairNum: int.parse(useChairNum.text),
                useDesk: useDesk,
                useDeskNum: int.parse(useDeskNum.text),
                useContent: useContent.text,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, 'よさこい広場使用申込情報が変更されました', true);
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
                '申込会社名(又は店名)',
                child: CustomTextField(
                  controller: companyName,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）ひろめカンパニー',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者名',
                child: CustomTextField(
                  controller: companyUserName,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）田中太郎',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者メールアドレス',
                child: CustomTextField(
                  controller: companyUserEmail,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）tanaka@hirome.co.jp',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者電話番号',
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
              const SizedBox(height: 16),
              const Text(
                '使用者情報 (申込者情報と異なる場合のみ)',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用会社名(又は店名)',
                child: CustomTextField(
                  controller: useCompanyName,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）明神水産',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用者名',
                child: CustomTextField(
                  controller: useCompanyUserName,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）田中二郎',
                ),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                '使用情報',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用予定日時',
                child: DatetimeRangeForm(
                  startedAt: useStartedAt,
                  startedOnTap: () => picker.DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    minTime: kFirstDate,
                    maxTime: kLastDate,
                    theme: kDatePickerTheme,
                    onConfirm: (value) {
                      setState(() {
                        useStartedAt = value;
                      });
                    },
                    currentTime: useStartedAt,
                    locale: picker.LocaleType.jp,
                  ),
                  endedAt: useEndedAt,
                  endedOnTap: () => picker.DatePicker.showDateTimePicker(
                    context,
                    showTitleActions: true,
                    minTime: kFirstDate,
                    maxTime: kLastDate,
                    theme: kDatePickerTheme,
                    onConfirm: (value) {
                      setState(() {
                        useEndedAt = value;
                      });
                    },
                    currentTime: useEndedAt,
                    locale: picker.LocaleType.jp,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用区分',
                child: Column(
                  children: [
                    CustomCheckbox(
                      label: '全面使用',
                      value: useFull,
                      onChanged: (value) {
                        setState(() {
                          useFull = value ?? false;
                        });
                      },
                      child: Container(),
                    ),
                    CustomCheckbox(
                      label: '折りたたみイス',
                      subLabel: '150円(税抜)／1脚・1日',
                      value: useChair,
                      onChanged: (value) {
                        setState(() {
                          useChair = value ?? false;
                        });
                      },
                      child: CustomTextField(
                        label: '脚数',
                        controller: useChairNum,
                        textInputType: TextInputType.text,
                        maxLines: 1,
                        enabled: useChair,
                      ),
                    ),
                    CustomCheckbox(
                      label: '折りたたみ机',
                      subLabel: '300円(税抜)／1台・1日',
                      value: useDesk,
                      onChanged: (value) {
                        setState(() {
                          useDesk = value ?? false;
                        });
                      },
                      child: CustomTextField(
                        label: '台数',
                        controller: useDeskNum,
                        textInputType: TextInputType.text,
                        maxLines: 1,
                        enabled: useDesk,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用内容',
                child: CustomTextField(
                  controller: useContent,
                  textInputType: TextInputType.multiline,
                  maxLines: 5,
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
