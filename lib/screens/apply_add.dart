import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply.dart';
import 'package:miel_work_app/providers/apply.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/file_picker_button.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:provider/provider.dart';

class ApplyAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyModel? apply;

  const ApplyAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    this.apply,
    super.key,
  });

  @override
  State<ApplyAddScreen> createState() => _ApplyAddScreenState();
}

class _ApplyAddScreenState extends State<ApplyAddScreen> {
  TextEditingController numberController = TextEditingController();
  String type = kApplyTypes.first;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController priceController = TextEditingController(text: '0');
  File? pickedFile;
  File? pickedFile2;
  File? pickedFile3;
  File? pickedFile4;
  File? pickedFile5;
  TextEditingController memoController = TextEditingController();

  void _init() async {
    if (widget.apply == null) return;
    numberController.text = widget.apply?.number ?? '';
    titleController.text = widget.apply?.title ?? '';
    contentController.text = widget.apply?.content ?? '';
    priceController.text = widget.apply?.price.toString() ?? '';
    memoController.text = widget.apply?.memo ?? '';
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final applyProvider = Provider.of<ApplyProvider>(context);
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
          '新規申請',
          style: TextStyle(color: kBlackColor),
        ),
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        behavior: HitTestBehavior.opaque,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                FormLabel(
                  '申請番号',
                  child: CustomTextField(
                    controller: numberController,
                    textInputType: TextInputType.number,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '申請種別',
                  child: Column(
                    children: kApplyTypes.map((e) {
                      return RadioListTile(
                        title: Align(
                          alignment: Alignment.centerLeft,
                          child: Chip(
                            label: Text('$e申請'),
                            backgroundColor: generateApplyColor(e),
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
                  '件名',
                  child: CustomTextField(
                    controller: titleController,
                    textInputType: TextInputType.text,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 16),
                type == '稟議' || type == '支払伺い'
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: FormLabel(
                          '金額',
                          child: CustomTextField(
                            controller: priceController,
                            textInputType: TextInputType.number,
                            inputFormatters: [
                              CurrencyTextInputFormatter.currency(
                                locale: 'ja',
                                decimalDigits: 0,
                                symbol: '',
                              ),
                            ],
                            maxLines: 1,
                            prefix: const Text('¥ '),
                          ),
                        ),
                      )
                    : Container(),
                FormLabel(
                  '内容',
                  child: CustomTextField(
                    controller: contentController,
                    textInputType: TextInputType.multiline,
                    maxLines: 15,
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '添付ファイル',
                  child: FilePickerButton(
                    value: pickedFile,
                    defaultValue: '',
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.any,
                      );
                      if (result == null) return;
                      setState(() {
                        pickedFile = File(result.files.single.path!);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '添付ファイル2',
                  child: FilePickerButton(
                    value: pickedFile2,
                    defaultValue: '',
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.any,
                      );
                      if (result == null) return;
                      setState(() {
                        pickedFile2 = File(result.files.single.path!);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '添付ファイル3',
                  child: FilePickerButton(
                    value: pickedFile3,
                    defaultValue: '',
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.any,
                      );
                      if (result == null) return;
                      setState(() {
                        pickedFile3 = File(result.files.single.path!);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '添付ファイル4',
                  child: FilePickerButton(
                    value: pickedFile4,
                    defaultValue: '',
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.any,
                      );
                      if (result == null) return;
                      setState(() {
                        pickedFile4 = File(result.files.single.path!);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '添付ファイル5',
                  child: FilePickerButton(
                    value: pickedFile5,
                    defaultValue: '',
                    onPressed: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.any,
                      );
                      if (result == null) return;
                      setState(() {
                        pickedFile5 = File(result.files.single.path!);
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  'メモ',
                  child: CustomTextField(
                    controller: memoController,
                    textInputType: TextInputType.multiline,
                    maxLines: 5,
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
          int price = 0;
          if (type == '稟議' || type == '支払伺い') {
            String priceText = priceController.text.replaceAll(',', '');
            price = int.parse(priceText);
          }
          String? error = await applyProvider.create(
            organization: widget.loginProvider.organization,
            group: null,
            number: numberController.text,
            type: type,
            title: titleController.text,
            content: contentController.text,
            price: price,
            pickedFile: pickedFile,
            pickedFile2: pickedFile2,
            pickedFile3: pickedFile3,
            pickedFile4: pickedFile4,
            pickedFile5: pickedFile5,
            memo: memoController.text,
            loginUser: widget.loginProvider.user,
          );
          if (error != null) {
            if (!mounted) return;
            showMessage(context, error, false);
            return;
          }
          if (!mounted) return;
          showMessage(context, '新規申請を送信しました', true);
          Navigator.pop(context);
        },
        icon: const FaIcon(
          FontAwesomeIcons.floppyDisk,
          color: kWhiteColor,
        ),
        label: const Text(
          '申請する',
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
