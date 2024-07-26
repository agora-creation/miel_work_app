import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply.dart';
import 'package:miel_work_app/providers/apply.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/link_text.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ApplyModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyModel apply;

  const ApplyModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.apply,
    super.key,
  });

  @override
  State<ApplyModScreen> createState() => _ApplyModScreenState();
}

class _ApplyModScreenState extends State<ApplyModScreen> {
  TextEditingController numberController = TextEditingController();
  String type = kApplyTypes.first;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  TextEditingController priceController = TextEditingController(text: '0');

  @override
  void initState() {
    numberController.text = widget.apply.number;
    type = widget.apply.type;
    titleController.text = widget.apply.title;
    contentController.text = widget.apply.content;
    priceController.text = widget.apply.price.toString();
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
          '申請情報の編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DelApplyDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                apply: widget.apply,
              ),
            ),
            icon: const FaIcon(
              FontAwesomeIcons.trash,
              color: kRedColor,
            ),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: widget.apply.file != ''
                      ? LinkText(
                          label: '確認する',
                          color: kBlueColor,
                          onTap: () {
                            String ext = widget.apply.fileExt;
                            if (imageExtensions.contains(ext)) {
                              showDialog(
                                context: context,
                                builder: (context) => ImageDialog(
                                  file: widget.apply.file,
                                ),
                              );
                            }
                            if (pdfExtensions.contains(ext)) {
                              showDialog(
                                context: context,
                                builder: (context) => PdfDialog(
                                  file: widget.apply.file,
                                ),
                              );
                            }
                          },
                        )
                      : Container(),
                ),
                const SizedBox(height: 8),
                FormLabel(
                  '添付ファイル2',
                  child: widget.apply.file2 != ''
                      ? LinkText(
                          label: '確認する',
                          color: kBlueColor,
                          onTap: () {
                            String ext = widget.apply.file2Ext;
                            if (imageExtensions.contains(ext)) {
                              showDialog(
                                context: context,
                                builder: (context) => ImageDialog(
                                  file: widget.apply.file2,
                                ),
                              );
                            }
                            if (pdfExtensions.contains(ext)) {
                              showDialog(
                                context: context,
                                builder: (context) => PdfDialog(
                                  file: widget.apply.file2,
                                ),
                              );
                            }
                          },
                        )
                      : Container(),
                ),
                const SizedBox(height: 8),
                FormLabel(
                  '添付ファイル3',
                  child: widget.apply.file3 != ''
                      ? LinkText(
                          label: '確認する',
                          color: kBlueColor,
                          onTap: () {
                            String ext = widget.apply.file3Ext;
                            if (imageExtensions.contains(ext)) {
                              showDialog(
                                context: context,
                                builder: (context) => ImageDialog(
                                  file: widget.apply.file3,
                                ),
                              );
                            }
                            if (pdfExtensions.contains(ext)) {
                              showDialog(
                                context: context,
                                builder: (context) => PdfDialog(
                                  file: widget.apply.file3,
                                ),
                              );
                            }
                          },
                        )
                      : Container(),
                ),
                const SizedBox(height: 8),
                FormLabel(
                  '添付ファイル4',
                  child: widget.apply.file4 != ''
                      ? LinkText(
                          label: '確認する',
                          color: kBlueColor,
                          onTap: () {
                            String ext = widget.apply.file4Ext;
                            if (imageExtensions.contains(ext)) {
                              showDialog(
                                context: context,
                                builder: (context) => ImageDialog(
                                  file: widget.apply.file4,
                                ),
                              );
                            }
                            if (pdfExtensions.contains(ext)) {
                              showDialog(
                                context: context,
                                builder: (context) => PdfDialog(
                                  file: widget.apply.file4,
                                ),
                              );
                            }
                          },
                        )
                      : Container(),
                ),
                const SizedBox(height: 8),
                FormLabel(
                  '添付ファイル5',
                  child: widget.apply.file5 != ''
                      ? LinkText(
                          label: '確認する',
                          color: kBlueColor,
                          onTap: () {
                            String ext = widget.apply.file5Ext;
                            if (imageExtensions.contains(ext)) {
                              showDialog(
                                context: context,
                                builder: (context) => ImageDialog(
                                  file: widget.apply.file5,
                                ),
                              );
                            }
                            if (pdfExtensions.contains(ext)) {
                              showDialog(
                                context: context,
                                builder: (context) => PdfDialog(
                                  file: widget.apply.file5,
                                ),
                              );
                            }
                          },
                        )
                      : Container(),
                ),
                const SizedBox(height: 80),
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
          String? error = await applyProvider.update(
            apply: widget.apply,
            number: numberController.text,
            type: type,
            title: titleController.text,
            content: contentController.text,
            price: price,
            loginUser: widget.loginProvider.user,
          );
          if (error != null) {
            if (!mounted) return;
            showMessage(context, error, false);
            return;
          }
          if (!mounted) return;
          showMessage(context, '申請情報が変更されました', true);
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

class ImageDialog extends StatelessWidget {
  final String file;

  const ImageDialog({
    required this.file,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: InteractiveViewer(
                minScale: 0.1,
                maxScale: 5,
                child: Image.network(File(file).path),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              color: Colors.transparent,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const FaIcon(
                  FontAwesomeIcons.xmark,
                  color: kWhiteColor,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class PdfDialog extends StatelessWidget {
  final String file;

  const PdfDialog({
    required this.file,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: InteractiveViewer(
                minScale: 0.1,
                maxScale: 5,
                child: SfPdfViewer.network(File(file).path),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Material(
              color: Colors.transparent,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const FaIcon(
                  FontAwesomeIcons.xmark,
                  color: kWhiteColor,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DelApplyDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyModel apply;

  const DelApplyDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.apply,
    super.key,
  });

  @override
  State<DelApplyDialog> createState() => _DelApplyDialogState();
}

class _DelApplyDialogState extends State<DelApplyDialog> {
  @override
  Widget build(BuildContext context) {
    final applyProvider = Provider.of<ApplyProvider>(context);
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
            String? error = await applyProvider.delete(
              apply: widget.apply,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '申請を削除しました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
