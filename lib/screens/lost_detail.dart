import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/lost.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/lost.dart';
import 'package:miel_work_app/screens/lost_mod.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/file_link.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/form_value.dart';
import 'package:miel_work_app/widgets/image_detail_dialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

class LostDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final LostModel lost;

  const LostDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.lost,
    super.key,
  });

  @override
  State<LostDetailScreen> createState() => _LostDetailScreenState();
}

class _LostDetailScreenState extends State<LostDetailScreen> {
  DateTime returnAt = DateTime.now();
  TextEditingController returnUserController = TextEditingController();
  SignatureController signImageController = SignatureController(
    penStrokeWidth: 2,
    exportBackgroundColor: kWhiteColor,
  );

  @override
  Widget build(BuildContext context) {
    final lostProvider = Provider.of<LostProvider>(context);
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
          '落とし物情報の詳細',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DelLostDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                lost: widget.lost,
              ),
            ),
            icon: const FaIcon(
              FontAwesomeIcons.trash,
              color: kRedColor,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: LostModScreen(
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
                    lost: widget.lost,
                  ),
                ),
              );
            },
            icon: const FaIcon(
              FontAwesomeIcons.pen,
              color: kBlueColor,
            ),
          ),
        ],
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormLabel(
                  '発見日',
                  child: FormValue(
                    dateText('yyyy/MM/dd HH:mm', widget.lost.discoveryAt),
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '発見場所',
                  child: FormValue(widget.lost.discoveryPlace),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '発見者',
                  child: FormValue(widget.lost.discoveryUser),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '落とし物No',
                  child: FormValue(widget.lost.itemNumber),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '品名',
                  child: FormValue(widget.lost.itemName),
                ),
                const SizedBox(height: 16),
                widget.lost.itemImage != ''
                    ? FormLabel(
                        '添付写真',
                        child: FileLink(
                          file: widget.lost.itemImage,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => ImageDetailDialog(
                              File(widget.lost.itemImage).path,
                              onPressedClose: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                const SizedBox(height: 16),
                FormLabel(
                  '備考',
                  child: FormValue(widget.lost.remarks),
                ),
                const SizedBox(height: 24),
                Divider(color: kBorderColor),
                const SizedBox(height: 24),
                FormLabel(
                  '返却日',
                  child: FormValue(
                    dateText('yyyy/MM/dd HH:mm', returnAt),
                    onTap: widget.lost.status == 0
                        ? () async {
                            picker.DatePicker.showDateTimePicker(
                              context,
                              showTitleActions: true,
                              minTime: kFirstDate,
                              maxTime: kLastDate,
                              theme: kDatePickerTheme,
                              onConfirm: (value) {
                                setState(() {
                                  returnAt = value;
                                });
                              },
                              currentTime: returnAt,
                              locale: picker.LocaleType.jp,
                            );
                          }
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '返却スタッフ',
                  child: widget.lost.status == 0
                      ? CustomTextField(
                          controller: returnUserController,
                          textInputType: TextInputType.text,
                          maxLines: 1,
                        )
                      : FormValue(widget.lost.returnUser),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '署名',
                  child: widget.lost.status == 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: kBorderColor),
                              ),
                              child: Signature(
                                controller: signImageController,
                                backgroundColor: kWhiteColor,
                                width: double.infinity,
                                height: 200,
                              ),
                            ),
                            const SizedBox(height: 4),
                            CustomButton(
                              type: ButtonSizeType.sm,
                              label: '書き直す',
                              labelColor: kBlackColor,
                              backgroundColor: kGreyColor.withOpacity(0.3),
                              onPressed: () => signImageController.clear(),
                            ),
                          ],
                        )
                      : Image.network(
                          widget.lost.signImage,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 16),
                widget.lost.status == 0
                    ? CustomButton(
                        type: ButtonSizeType.lg,
                        label: '返却処理をする',
                        labelColor: kWhiteColor,
                        backgroundColor: kReturnColor,
                        onPressed: () async {
                          String? error = await lostProvider.updateReturn(
                            organization: widget.loginProvider.organization,
                            lost: widget.lost,
                            returnAt: returnAt,
                            returnUser: returnUserController.text,
                            signImageController: signImageController,
                            loginUser: widget.loginProvider.user,
                          );
                          if (error != null) {
                            if (!mounted) return;
                            showMessage(context, error, false);
                            return;
                          }
                          if (!mounted) return;
                          showMessage(context, '返却されました', true);
                          Navigator.pop(context);
                        },
                      )
                    : Container(),
                const SizedBox(height: 100),
              ],
            ),
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

class DelLostDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final LostModel lost;

  const DelLostDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.lost,
    super.key,
  });

  @override
  State<DelLostDialog> createState() => _DelLostDialogState();
}

class _DelLostDialogState extends State<DelLostDialog> {
  @override
  Widget build(BuildContext context) {
    final lostProvider = Provider.of<LostProvider>(context);
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
            String? error = await lostProvider.delete(
              lost: widget.lost,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '落とし物情報が削除されました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
