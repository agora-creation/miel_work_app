import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/loan.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/loan.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/form_value.dart';
import 'package:provider/provider.dart';

class LoanModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final LoanModel loan;

  const LoanModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.loan,
    super.key,
  });

  @override
  State<LoanModScreen> createState() => _LoanModScreenState();
}

class _LoanModScreenState extends State<LoanModScreen> {
  DateTime loanAt = DateTime.now();
  TextEditingController loanUserController = TextEditingController();
  TextEditingController loanCompanyController = TextEditingController();
  TextEditingController loanStaffController = TextEditingController();
  DateTime returnPlanAt = DateTime.now();
  TextEditingController itemNameController = TextEditingController();
  XFile? itemImageXFile;

  @override
  void initState() {
    loanAt = widget.loan.loanAt;
    loanUserController.text = widget.loan.loanUser;
    loanCompanyController.text = widget.loan.loanCompany;
    loanStaffController.text = widget.loan.loanStaff;
    returnPlanAt = widget.loan.returnPlanAt;
    itemNameController.text = widget.loan.itemName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loanProvider = Provider.of<LoanProvider>(context);
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
        centerTitle: true,
        title: const Text(
          '貸出情報の編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DelLoanDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                loan: widget.loan,
              ),
            ),
            icon: const FaIcon(
              FontAwesomeIcons.trash,
              color: kRedColor,
            ),
          ),
        ],
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                FormLabel(
                  '貸出日',
                  child: FormValue(
                    dateText('yyyy/MM/dd HH:mm', loanAt),
                    onTap: () async {
                      picker.DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        minTime: kFirstDate,
                        maxTime: kLastDate,
                        theme: kDatePickerTheme,
                        onConfirm: (value) {
                          setState(() {
                            loanAt = value;
                          });
                        },
                        currentTime: loanAt,
                        locale: picker.LocaleType.jp,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '貸出先',
                  child: CustomTextField(
                    controller: loanUserController,
                    textInputType: TextInputType.text,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '貸出先(会社)',
                  child: CustomTextField(
                    controller: loanCompanyController,
                    textInputType: TextInputType.text,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '対応スタッフ',
                  child: CustomTextField(
                    controller: loanStaffController,
                    textInputType: TextInputType.text,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '返却予定日',
                  child: FormValue(
                    dateText('yyyy/MM/dd HH:mm', returnPlanAt),
                    onTap: () async {
                      picker.DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        minTime: kFirstDate,
                        maxTime: kLastDate,
                        theme: kDatePickerTheme,
                        onConfirm: (value) {
                          setState(() {
                            returnPlanAt = value;
                          });
                        },
                        currentTime: returnPlanAt,
                        locale: picker.LocaleType.jp,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '品名',
                  child: CustomTextField(
                    controller: itemNameController,
                    textInputType: TextInputType.text,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '添付写真',
                  child: GestureDetector(
                    onTap: () async {
                      final result = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      setState(() {
                        itemImageXFile = result;
                      });
                    },
                    child: itemImageXFile != null
                        ? Image.file(
                            File(itemImageXFile!.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Container(
                            color: kGrey300Color,
                            width: double.infinity,
                            height: 100,
                            child: const Center(
                              child: Text('写真が選択されていません'),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          String? error = await loanProvider.update(
            organization: widget.loginProvider.organization,
            loan: widget.loan,
            loanAt: loanAt,
            loanUser: loanUserController.text,
            loanCompany: loanCompanyController.text,
            loanStaff: loanStaffController.text,
            returnPlanAt: returnPlanAt,
            itemName: itemNameController.text,
            itemImageXFile: itemImageXFile,
            loginUser: widget.loginProvider.user,
          );
          if (error != null) {
            if (!mounted) return;
            showMessage(context, error, false);
            return;
          }
          if (!mounted) return;
          showMessage(context, '貸出物情報が変更されました', true);
          Navigator.pop(context);
        },
        icon: const FaIcon(
          FontAwesomeIcons.floppyDisk,
          color: kWhiteColor,
        ),
        label: const Text(
          '保存する',
          style: TextStyle(color: kWhiteColor),
        ),
      ),
      bottomNavigationBar: CustomFooter(
        loginProvider: widget.loginProvider,
        homeProvider: widget.homeProvider,
      ),
    );
  }
}

class DelLoanDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final LoanModel loan;

  const DelLoanDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.loan,
    super.key,
  });

  @override
  State<DelLoanDialog> createState() => _DelLoanDialogState();
}

class _DelLoanDialogState extends State<DelLoanDialog> {
  @override
  Widget build(BuildContext context) {
    final loanProvider = Provider.of<LoanProvider>(context);
    return CustomAlertDialog(
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 8),
            Text(
              '本当に削除しますか？',
              style: TextStyle(color: kRedColor),
            ),
          ],
        ),
      ),
      actions: [
        CustomButton(
          type: ButtonSizeType.sm,
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '削除する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await loanProvider.delete(
              loan: widget.loan,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '貸出物が削除されました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
