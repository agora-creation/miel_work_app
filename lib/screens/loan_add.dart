import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/loan.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/form_value.dart';
import 'package:provider/provider.dart';

class LoanAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const LoanAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<LoanAddScreen> createState() => _LostAddScreenState();
}

class _LostAddScreenState extends State<LoanAddScreen> {
  DateTime loanAt = DateTime.now();
  TextEditingController loanUserController = TextEditingController();
  TextEditingController loanCompanyController = TextEditingController();
  TextEditingController loanStaffController = TextEditingController();
  DateTime returnPlanAt = DateTime.now();
  TextEditingController itemNameController = TextEditingController();
  XFile? itemImageXFile;

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
        title: const Text(
          '貸出情報を追加',
          style: TextStyle(color: kBlackColor),
        ),
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
                            color: kGreyColor.withOpacity(0.3),
                            width: double.infinity,
                            height: 100,
                            child: const Center(
                              child: Text('写真が選択されていません'),
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          String? error = await loanProvider.create(
            organization: widget.loginProvider.organization,
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
          showMessage(context, '貸出情報が追加されました', true);
          Navigator.pop(context);
        },
        icon: const FaIcon(
          FontAwesomeIcons.floppyDisk,
          color: kWhiteColor,
        ),
        label: const Text(
          '追加する',
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
