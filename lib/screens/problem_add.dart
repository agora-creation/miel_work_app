import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/problem.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/problem.dart';
import 'package:miel_work_app/widgets/custom_checkbox.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/form_value.dart';
import 'package:provider/provider.dart';

class ProblemAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const ProblemAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<ProblemAddScreen> createState() => _ProblemAddScreenState();
}

class _ProblemAddScreenState extends State<ProblemAddScreen> {
  String type = kProblemTypes.first;
  DateTime createdAt = DateTime.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController picNameController = TextEditingController();
  TextEditingController targetNameController = TextEditingController();
  TextEditingController targetAgeController = TextEditingController();
  TextEditingController targetTelController = TextEditingController();
  TextEditingController targetAddressController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController countController = TextEditingController(text: '0');
  XFile? imageXFile;
  List<String> states = [];

  @override
  Widget build(BuildContext context) {
    final problemProvider = Provider.of<ProblemProvider>(context);
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
          'クレーム／要望を追加',
          style: TextStyle(color: kBlackColor),
        ),
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                FormLabel(
                  '報告日時',
                  child: FormValue(
                    dateText('yyyy/MM/dd HH:mm', createdAt),
                    onTap: () async {
                      picker.DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        minTime: kFirstDate,
                        maxTime: kLastDate,
                        theme: kDatePickerTheme,
                        onConfirm: (value) {
                          setState(() {
                            createdAt = value;
                          });
                        },
                        currentTime: createdAt,
                        locale: picker.LocaleType.jp,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '対応項目',
                  child: Column(
                    children: kProblemTypes.map((e) {
                      return RadioListTile(
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: Chip(
                            label: Text(e),
                            backgroundColor: generateProblemColor(e),
                          ),
                        ),
                        value: e,
                        groupValue: type,
                        onChanged: (value) {
                          if (value == null) return;
                          setState(() {
                            type = value;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  'タイトル',
                  child: CustomTextField(
                    controller: titleController,
                    textInputType: TextInputType.text,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '対応者',
                  child: CustomTextField(
                    controller: picNameController,
                    textInputType: TextInputType.name,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '相手の名前',
                  child: CustomTextField(
                    controller: targetNameController,
                    textInputType: TextInputType.name,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '相手の年齢',
                  child: CustomTextField(
                    controller: targetAgeController,
                    textInputType: TextInputType.name,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '相手の連絡先',
                  child: CustomTextField(
                    controller: targetTelController,
                    textInputType: TextInputType.name,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '相手の住所',
                  child: CustomTextField(
                    controller: targetAddressController,
                    textInputType: TextInputType.name,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '詳細',
                  child: CustomTextField(
                    controller: detailsController,
                    textInputType: TextInputType.multiline,
                    maxLines: 15,
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
                        imageXFile = result;
                      });
                    },
                    child: imageXFile != null
                        ? Image.file(
                            File(imageXFile!.path),
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
                const SizedBox(height: 16),
                FormLabel(
                  '対応状態',
                  child: Column(
                    children: kProblemStates.map((e) {
                      return CustomCheckbox(
                        label: e,
                        value: states.contains(e),
                        onChanged: (value) {
                          if (states.contains(e)) {
                            states.remove(e);
                          } else {
                            states.add(e);
                          }
                          setState(() {});
                        },
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '同じような注意(対応)をした回数',
                  child: CustomTextField(
                    controller: countController,
                    textInputType: TextInputType.number,
                    maxLines: 1,
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
          String? error = await problemProvider.create(
            organization: widget.loginProvider.organization,
            type: type,
            title: titleController.text,
            createdAt: createdAt,
            picName: picNameController.text,
            targetName: targetNameController.text,
            targetAge: targetAgeController.text,
            targetTel: targetTelController.text,
            targetAddress: targetAddressController.text,
            details: detailsController.text,
            imageXFile: imageXFile,
            states: states,
            count: int.parse(countController.text),
            loginUser: widget.loginProvider.user,
          );
          if (error != null) {
            if (!mounted) return;
            showMessage(context, error, false);
            return;
          }
          if (!mounted) return;
          showMessage(context, 'クレーム／要望が追加されました', true);
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
    );
  }
}
