import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
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
  void initState() {
    super.initState();
    type = widget.problem.type;
    createdAt = widget.problem.createdAt;
    picNameController.text = widget.problem.picName;
    targetNameController.text = widget.problem.targetName;
    targetAgeController.text = widget.problem.targetAge;
    targetTelController.text = widget.problem.targetTel;
    targetAddressController.text = widget.problem.targetAddress;
    detailsController.text = widget.problem.details;
    states = widget.problem.states;
    countController.text = widget.problem.count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final problemProvider = Provider.of<ProblemProvider>(context);
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
          'クレーム／要望の編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String? error = await problemProvider.update(
                organization: widget.loginProvider.organization,
                problem: widget.problem,
                type: type,
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
              showMessage(context, 'クレーム／要望を変更しました', true);
              Navigator.pop(context);
            },
            child: const Text('保存'),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormLabel(
                  label: '報告日時',
                  child: GestureDetector(
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(dateText('yyyy/MM/dd HH:mm', createdAt)),
                          const Icon(
                            Icons.calendar_month,
                            color: kGreyColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FormLabel(
                  label: '対応項目',
                  child: DropdownButton<String>(
                    underline: Container(),
                    isExpanded: true,
                    value: type,
                    items: kProblemTypes.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() {
                        type = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 8),
                FormLabel(
                  label: '対応者',
                  child: CustomTextField(
                    controller: picNameController,
                    textInputType: TextInputType.name,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 8),
                FormLabel(
                  label: '相手の名前',
                  child: CustomTextField(
                    controller: targetNameController,
                    textInputType: TextInputType.name,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 8),
                FormLabel(
                  label: '相手の年齢',
                  child: CustomTextField(
                    controller: targetAgeController,
                    textInputType: TextInputType.name,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 8),
                FormLabel(
                  label: '相手の連絡先',
                  child: CustomTextField(
                    controller: targetTelController,
                    textInputType: TextInputType.name,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 8),
                FormLabel(
                  label: '相手の住所',
                  child: CustomTextField(
                    controller: targetAddressController,
                    textInputType: TextInputType.name,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 8),
                FormLabel(
                  label: '詳細',
                  child: CustomTextField(
                    controller: detailsController,
                    textInputType: TextInputType.multiline,
                    maxLines: 15,
                  ),
                ),
                const SizedBox(height: 8),
                FormLabel(
                  label: '添付写真',
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
                            ? Image.network(
                                widget.problem.image,
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
                const SizedBox(height: 8),
                FormLabel(
                  label: '対応状態',
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
                const SizedBox(height: 8),
                FormLabel(
                  label: '同じような注意(対応)をした回数',
                  child: CustomTextField(
                    controller: countController,
                    textInputType: TextInputType.number,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
