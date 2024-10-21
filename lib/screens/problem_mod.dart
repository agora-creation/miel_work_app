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
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/file_link.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/form_value.dart';
import 'package:provider/provider.dart';

class ProblemModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ProblemModel problem;

  const ProblemModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.problem,
    super.key,
  });

  @override
  State<ProblemModScreen> createState() => _ProblemModScreenState();
}

class _ProblemModScreenState extends State<ProblemModScreen> {
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
  XFile? image2XFile;
  XFile? image3XFile;
  List<String> states = [];

  @override
  void initState() {
    type = widget.problem.type;
    createdAt = widget.problem.createdAt;
    titleController.text = widget.problem.title;
    picNameController.text = widget.problem.picName;
    targetNameController.text = widget.problem.targetName;
    targetAgeController.text = widget.problem.targetAge;
    targetTelController.text = widget.problem.targetTel;
    targetAddressController.text = widget.problem.targetAddress;
    detailsController.text = widget.problem.details;
    states = widget.problem.states;
    countController.text = widget.problem.count.toString();
    super.initState();
  }

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
        centerTitle: true,
        title: const Text(
          'クレーム／要望情報の編集',
          style: TextStyle(color: kBlackColor),
        ),
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
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
                          : widget.problem.image != ''
                              ? FileLink(file: widget.problem.image)
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
                  const SizedBox(height: 8),
                  FormLabel(
                    '添付写真2',
                    child: GestureDetector(
                      onTap: () async {
                        final result = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        setState(() {
                          image2XFile = result;
                        });
                      },
                      child: image2XFile != null
                          ? Image.file(
                              File(image2XFile!.path),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : widget.problem.image2 != ''
                              ? FileLink(file: widget.problem.image2)
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
                  const SizedBox(height: 8),
                  FormLabel(
                    '添付写真3',
                    child: GestureDetector(
                      onTap: () async {
                        final result = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );
                        setState(() {
                          image3XFile = result;
                        });
                      },
                      child: image3XFile != null
                          ? Image.file(
                              File(image3XFile!.path),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                          : widget.problem.image3 != ''
                              ? FileLink(file: widget.problem.image3)
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
                          child: Container(),
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
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          String? error = await problemProvider.update(
            organization: widget.loginProvider.organization,
            problem: widget.problem,
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
            image2XFile: image2XFile,
            image3XFile: image3XFile,
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
          showMessage(context, 'クレーム／要望情報が変更されました', true);
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
