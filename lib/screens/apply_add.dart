import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply.dart';
import 'package:miel_work_app/providers/apply.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/widgets/custom_file_field.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:provider/provider.dart';

class ApplyAddScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final String type;
  final ApplyModel? apply;

  const ApplyAddScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.type,
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
  TextEditingController priceController = TextEditingController();
  File? pickedFile;

  void _init() async {
    type = widget.type;
    if (widget.apply == null) return;
    numberController.text = widget.apply?.number ?? '';
    titleController.text = widget.apply?.title ?? '';
    contentController.text = widget.apply?.content ?? '';
    priceController.text = widget.apply?.price.toString() ?? '';
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final applyProvider = Provider.of<ApplyProvider>(context);
    return MediaQuery.withNoTextScaling(
      child: Scaffold(
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
            '新規申請',
            style: TextStyle(color: kBlackColor),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                int price = 0;
                if (type == '稟議') {
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
              child: const Text('送信する'),
            ),
          ],
          shape: const Border(bottom: BorderSide(color: kGrey600Color)),
        ),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          behavior: HitTestBehavior.opaque,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  CustomTextField(
                    controller: numberController,
                    textInputType: TextInputType.number,
                    maxLines: 1,
                    label: '申請番号',
                  ),
                  const SizedBox(height: 8),
                  FormLabel(
                    label: '申請種別',
                    child: DropdownButton<String>(
                      underline: Container(),
                      isExpanded: true,
                      value: type,
                      items: kApplyTypes.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text('$e申請'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          type = value ?? kApplyTypes.first;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: titleController,
                    textInputType: TextInputType.text,
                    maxLines: 1,
                    label: '件名',
                  ),
                  const SizedBox(height: 8),
                  type == '稟議'
                      ? CustomTextField(
                          controller: priceController,
                          textInputType: TextInputType.number,
                          inputFormatters: [
                            CurrencyTextInputFormatter(
                              locale: 'ja',
                              decimalDigits: 0,
                              symbol: '',
                            ),
                          ],
                          maxLines: 1,
                          label: '金額',
                          prefix: const Text('¥ '),
                        )
                      : Container(),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: contentController,
                    textInputType: TextInputType.multiline,
                    maxLines: 15,
                    label: '内容',
                  ),
                  const SizedBox(height: 8),
                  CustomFileField(
                    value: pickedFile,
                    defaultValue: '',
                    onTap: () async {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.any,
                      );
                      if (result == null) return;
                      setState(() {
                        pickedFile = File(result.files.single.path!);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
