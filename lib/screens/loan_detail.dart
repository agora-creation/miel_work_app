import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/comment.dart';
import 'package:miel_work_app/models/loan.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/loan.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/loan_mod.dart';
import 'package:miel_work_app/services/loan.dart';
import 'package:miel_work_app/widgets/comment_list.dart';
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

class LoanDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final LoanModel loan;

  const LoanDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.loan,
    super.key,
  });

  @override
  State<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen> {
  LoanService loanService = LoanService();
  DateTime returnAt = DateTime.now();
  TextEditingController returnUserController = TextEditingController();
  SignatureController signImageController = SignatureController(
    penStrokeWidth: 2,
    exportBackgroundColor: kWhiteColor,
  );
  List<CommentModel> comments = [];

  void _reloadComments() async {
    LoanModel? tmpLoan = await loanService.selectData(
      id: widget.loan.id,
    );
    if (tmpLoan == null) return;
    comments = tmpLoan.comments;
    setState(() {});
  }

  @override
  void initState() {
    comments = widget.loan.comments;
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
        title: const Text(
          '貸出情報の詳細',
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
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: LoanModScreen(
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
                    loan: widget.loan,
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
                  '貸出日',
                  child: FormValue(
                    dateText('yyyy/MM/dd HH:mm', widget.loan.loanAt),
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '貸出先',
                  child: FormValue(widget.loan.loanUser),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '貸出先(会社)',
                  child: FormValue(widget.loan.loanCompany),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '対応スタッフ',
                  child: FormValue(widget.loan.loanStaff),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '返却予定日',
                  child: FormValue(
                    dateText('yyyy/MM/dd HH:mm', widget.loan.returnPlanAt),
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '品名',
                  child: FormValue(widget.loan.itemName),
                ),
                const SizedBox(height: 16),
                widget.loan.itemImage != ''
                    ? FormLabel(
                        '添付写真',
                        child: FileLink(
                          file: widget.loan.itemImage,
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => ImageDetailDialog(
                              File(widget.loan.itemImage).path,
                              onPressedClose: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      )
                    : Container(),
                const SizedBox(height: 24),
                Divider(color: kBorderColor),
                const SizedBox(height: 24),
                FormLabel(
                  '返却日',
                  child: FormValue(
                    dateText('yyyy/MM/dd HH:mm', returnAt),
                    onTap: widget.loan.status == 0
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
                  child: widget.loan.status == 0
                      ? CustomTextField(
                          controller: returnUserController,
                          textInputType: TextInputType.text,
                          maxLines: 1,
                        )
                      : FormValue(widget.loan.returnUser),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '署名',
                  child: widget.loan.status == 0
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
                          widget.loan.signImage,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 16),
                widget.loan.status == 0
                    ? CustomButton(
                        type: ButtonSizeType.lg,
                        label: '返却処理をする',
                        labelColor: kWhiteColor,
                        backgroundColor: kReturnColor,
                        onPressed: () async {
                          String? error = await loanProvider.updateReturn(
                            organization: widget.loginProvider.organization,
                            loan: widget.loan,
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
                const SizedBox(height: 8),
                Container(
                  color: kGreyColor.withOpacity(0.2),
                  padding: const EdgeInsets.all(16),
                  child: FormLabel(
                    '社内コメント',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        comments.isNotEmpty
                            ? Column(
                                children: comments.map((comment) {
                                  return CommentList(comment: comment);
                                }).toList(),
                              )
                            : const ListTile(title: Text('コメントがありません')),
                        const SizedBox(height: 8),
                        CustomButton(
                          type: ButtonSizeType.sm,
                          label: 'コメント追加',
                          labelColor: kWhiteColor,
                          backgroundColor: kBlueColor,
                          onPressed: () {
                            TextEditingController commentContentController =
                                TextEditingController();
                            showDialog(
                              context: context,
                              builder: (context) => CustomAlertDialog(
                                content: SizedBox(
                                  width: 600,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(height: 8),
                                        CustomTextField(
                                          controller: commentContentController,
                                          textInputType:
                                              TextInputType.multiline,
                                          maxLines: null,
                                        ),
                                      ],
                                    ),
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
                                    label: '追記する',
                                    labelColor: kWhiteColor,
                                    backgroundColor: kBlueColor,
                                    onPressed: () async {
                                      String? error =
                                          await loanProvider.addComment(
                                        organization:
                                            widget.loginProvider.organization,
                                        loan: widget.loan,
                                        content: commentContentController.text,
                                        loginUser: widget.loginProvider.user,
                                      );
                                      if (error != null) {
                                        if (!mounted) return;
                                        showMessage(context, error, false);
                                        return;
                                      }
                                      _reloadComments();
                                      if (!mounted) return;
                                      showMessage(
                                          context, '社内コメントが追記されました', true);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
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
            showMessage(context, '貸出情報が削除されました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
