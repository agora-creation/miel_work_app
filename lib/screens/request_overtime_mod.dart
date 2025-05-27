import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/request_overtime.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/request_overtime.dart';
import 'package:miel_work_app/widgets/attached_file_list.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/datetime_range_form.dart';
import 'package:miel_work_app/widgets/dotted_divider.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/image_detail_dialog.dart';
import 'package:miel_work_app/widgets/pdf_detail_dialog.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

class RequestOvertimeModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestOvertimeModel overtime;

  const RequestOvertimeModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.overtime,
    super.key,
  });

  @override
  State<RequestOvertimeModScreen> createState() =>
      _RequestOvertimeModScreenState();
}

class _RequestOvertimeModScreenState extends State<RequestOvertimeModScreen> {
  TextEditingController companyName = TextEditingController();
  TextEditingController companyUserName = TextEditingController();
  TextEditingController companyUserEmail = TextEditingController();
  TextEditingController companyUserTel = TextEditingController();
  DateTime useStartedAt = DateTime.now();
  DateTime useEndedAt = DateTime.now();
  bool useAtPending = false;
  TextEditingController useContent = TextEditingController();

  @override
  void initState() {
    companyName.text = widget.overtime.companyName;
    companyUserName.text = widget.overtime.companyUserName;
    companyUserEmail.text = widget.overtime.companyUserEmail;
    companyUserTel.text = widget.overtime.companyUserTel;
    useStartedAt = widget.overtime.useStartedAt;
    useEndedAt = widget.overtime.useEndedAt;
    useAtPending = false;
    useContent.text = widget.overtime.useContent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final overtimeProvider = Provider.of<RequestOvertimeProvider>(context);
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
          '夜間居残り作業申請：申請編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String? error = await overtimeProvider.update(
                organization: widget.loginProvider.organization,
                overtime: widget.overtime,
                companyName: companyName.text,
                companyUserName: companyUserName.text,
                companyUserEmail: companyUserEmail.text,
                companyUserTel: companyUserTel.text,
                useStartedAt: useStartedAt,
                useEndedAt: useEndedAt,
                useAtPending: useAtPending,
                useContent: useContent.text,
                loginUser: widget.loginProvider.user,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, '夜間居残り作業申請情報が変更されました', true);
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
                '申請者情報',
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
                '店舗責任者名',
                child: CustomTextField(
                  controller: companyUserName,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）田中太郎',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗責任者メールアドレス',
                child: CustomTextField(
                  controller: companyUserEmail,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）tanaka@hirome.co.jp',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗責任者電話番号',
                child: CustomTextField(
                  controller: companyUserTel,
                  textInputType: TextInputType.text,
                  maxLines: 1,
                  hintText: '例）090-0000-0000',
                ),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                '作業情報',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '作業予定日時',
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
                '作業内容',
                child: CustomTextField(
                  controller: useContent,
                  textInputType: TextInputType.multiline,
                  maxLines: 5,
                ),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              FormLabel(
                '添付ファイル',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: widget.overtime.attachedFiles.map((file) {
                        String fileName = getFileNameFromUrl(file);
                        return AttachedFileList(
                          fileName: fileName,
                          onTap: () {
                            String ext = p.extension(fileName);
                            if (imageExtensions.contains(ext)) {
                              showDialog(
                                context: context,
                                builder: (context) => ImageDetailDialog(
                                  File(file).path,
                                  onPressedClose: () => Navigator.pop(context),
                                ),
                              );
                            }
                            if (pdfExtensions.contains(ext)) {
                              showDialog(
                                context: context,
                                builder: (context) => PdfDetailDialog(
                                  File(file).path,
                                  onPressedClose: () => Navigator.pop(context),
                                ),
                              );
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
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
