import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/providers/apply.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/apply_mod.dart';
import 'package:miel_work_app/widgets/approval_user_list.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/form_value.dart';
import 'package:miel_work_app/widgets/image_detail_dialog.dart';
import 'package:miel_work_app/widgets/link_text.dart';
import 'package:miel_work_app/widgets/pdf_detail_dialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ApplyDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyModel apply;

  const ApplyDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.apply,
    super.key,
  });

  @override
  State<ApplyDetailScreen> createState() => _ApplyDetailScreenState();
}

class _ApplyDetailScreenState extends State<ApplyDetailScreen> {
  @override
  Widget build(BuildContext context) {
    bool isApproval = true;
    bool isReject = true;
    bool isDelete = true;
    if (widget.apply.createdUserId == widget.loginProvider.user?.id) {
      isApproval = false;
      isReject = false;
    } else {
      isDelete = false;
    }
    if (widget.apply.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in widget.apply.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
          isReject = false;
        }
      }
    }
    if (widget.apply.approval == 1 || widget.apply.approval == 9) {
      isApproval = false;
      isReject = false;
      isDelete = false;
    }
    List<ApprovalUserModel> approvalUsers = widget.apply.approvalUsers;
    List<ApprovalUserModel> reApprovalUsers = approvalUsers.reversed.toList();
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
          '申請詳細',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: ApplyModScreen(
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
                    apply: widget.apply,
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
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '申請日時: ${dateText('yyyy/MM/dd HH:mm', widget.apply.createdAt)}',
                      style: const TextStyle(
                        color: kGreyColor,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '申請番号: ${widget.apply.number}',
                      style: const TextStyle(
                        color: kGreyColor,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '申請者: ${widget.apply.createdUserName}',
                      style: const TextStyle(
                        color: kGreyColor,
                        fontSize: 14,
                      ),
                    ),
                    widget.apply.approval == 1
                        ? Text(
                            '承認日時: ${dateText('yyyy/MM/dd HH:mm', widget.apply.approvedAt)}',
                            style: const TextStyle(
                              color: kRedColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Container(),
                    widget.apply.approval == 1
                        ? Text(
                            '承認番号: ${widget.apply.approvalNumber}',
                            style: const TextStyle(
                              color: kRedColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              FormLabel(
                '承認者一覧',
                child: Column(
                  children: reApprovalUsers.map((approvalUser) {
                    return CustomApprovalUserList(
                      approvalUser: approvalUser,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申請種別',
                child: Chip(
                  label: Text('${widget.apply.type}申請'),
                  backgroundColor: widget.apply.typeColor(),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '件名',
                child: FormValue(widget.apply.title),
              ),
              const SizedBox(height: 8),
              widget.apply.type == '稟議' || widget.apply.type == '支払伺い'
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: FormLabel(
                        '金額',
                        child: FormValue('¥ ${widget.apply.formatPrice()}'),
                      ),
                    )
                  : Container(),
              FormLabel(
                '内容',
                child: FormValue(widget.apply.content),
              ),
              const SizedBox(height: 8),
              widget.apply.approvalReason != ''
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: FormLabel(
                        '承認理由',
                        child: FormValue(widget.apply.approvalReason),
                      ),
                    )
                  : Container(),
              widget.apply.reason != ''
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: FormLabel(
                        '否決理由',
                        child: FormValue(widget.apply.reason),
                      ),
                    )
                  : Container(),
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
                              builder: (context) => ImageDetailDialog(
                                File(widget.apply.file).path,
                                onPressedClose: () => Navigator.pop(context),
                              ),
                            );
                          }
                          if (pdfExtensions.contains(ext)) {
                            showDialog(
                              context: context,
                              builder: (context) => PdfDetailDialog(
                                File(widget.apply.file).path,
                                onPressedClose: () => Navigator.pop(context),
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
                              builder: (context) => ImageDetailDialog(
                                File(widget.apply.file2).path,
                                onPressedClose: () => Navigator.pop(context),
                              ),
                            );
                          }
                          if (pdfExtensions.contains(ext)) {
                            showDialog(
                              context: context,
                              builder: (context) => PdfDetailDialog(
                                File(widget.apply.file2).path,
                                onPressedClose: () => Navigator.pop(context),
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
                              builder: (context) => ImageDetailDialog(
                                File(widget.apply.file3).path,
                                onPressedClose: () => Navigator.pop(context),
                              ),
                            );
                          }
                          if (pdfExtensions.contains(ext)) {
                            showDialog(
                              context: context,
                              builder: (context) => PdfDetailDialog(
                                File(widget.apply.file3).path,
                                onPressedClose: () => Navigator.pop(context),
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
                              builder: (context) => ImageDetailDialog(
                                File(widget.apply.file4).path,
                                onPressedClose: () => Navigator.pop(context),
                              ),
                            );
                          }
                          if (pdfExtensions.contains(ext)) {
                            showDialog(
                              context: context,
                              builder: (context) => PdfDetailDialog(
                                File(widget.apply.file4).path,
                                onPressedClose: () => Navigator.pop(context),
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
                              builder: (context) => ImageDetailDialog(
                                File(widget.apply.file5).path,
                                onPressedClose: () => Navigator.pop(context),
                              ),
                            );
                          }
                          if (pdfExtensions.contains(ext)) {
                            showDialog(
                              context: context,
                              builder: (context) => PdfDetailDialog(
                                File(widget.apply.file5).path,
                                onPressedClose: () => Navigator.pop(context),
                              ),
                            );
                          }
                        },
                      )
                    : Container(),
              ),
              const SizedBox(height: 16),
              const Text(
                '※『承認』は、承認状況が「承認待ち」で、作成者・既承認者以外のスタッフが実行できます。',
                style: TextStyle(
                  color: kRedColor,
                  fontSize: 12,
                ),
              ),
              const Text(
                '※『否決』は、承認状況が「承認待ち」で、管理者権限のスタッフのみ実行できます。',
                style: TextStyle(
                  color: kRedColor,
                  fontSize: 12,
                ),
              ),
              const Text(
                '※『再申請』は、承認状況が「否決」で、作成者のスタッフのみ実行できます。',
                style: TextStyle(
                  color: kRedColor,
                  fontSize: 12,
                ),
              ),
              const Text(
                '※『削除』は、承認状況が「承認待ち」で、作成者のスタッフのみ実行できます。',
                style: TextStyle(
                  color: kRedColor,
                  fontSize: 12,
                ),
              ),
              const Text(
                '※管理者権限のスタッフが承認した場合のみ、承認状況が『承認済み』になります。',
                style: TextStyle(
                  color: kRedColor,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          isReject && widget.loginProvider.user?.president == true
              ? FloatingActionButton.extended(
                  heroTag: 'reject',
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => RejectApplyDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      apply: widget.apply,
                    ),
                  ),
                  backgroundColor: kRed100Color,
                  icon: const Icon(
                    Icons.error_outline,
                    color: kRedColor,
                  ),
                  label: const Text(
                    '否決する',
                    style: TextStyle(color: kRedColor),
                  ),
                )
              : Container(),
          const SizedBox(height: 8),
          isApproval
              ? FloatingActionButton.extended(
                  heroTag: 'approval',
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => ApprovalApplyDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      apply: widget.apply,
                    ),
                  ),
                  backgroundColor: kRedColor,
                  icon: const Icon(
                    Icons.check,
                    color: kWhiteColor,
                  ),
                  label: const Text(
                    '承認する',
                    style: TextStyle(color: kWhiteColor),
                  ),
                )
              : Container(),
        ],
      ),
      bottomNavigationBar: CustomFooter(
        loginProvider: widget.loginProvider,
        homeProvider: widget.homeProvider,
      ),
    );
  }
}

class ApprovalApplyDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyModel apply;

  const ApprovalApplyDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.apply,
    super.key,
  });

  @override
  State<ApprovalApplyDialog> createState() => _ApprovalApplyDialogState();
}

class _ApprovalApplyDialogState extends State<ApprovalApplyDialog> {
  TextEditingController approvalNumberController = TextEditingController();
  TextEditingController approvalReasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final applyProvider = Provider.of<ApplyProvider>(context);
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          const Text(
            '本当に承認しますか？',
            style: TextStyle(color: kRedColor),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '承認番号',
            child: CustomTextField(
              controller: approvalNumberController,
              textInputType: TextInputType.number,
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '承認理由',
            child: CustomTextField(
              controller: approvalReasonController,
              textInputType: TextInputType.multiline,
              maxLines: 5,
            ),
          ),
        ],
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
          label: '承認する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await applyProvider.approval(
              apply: widget.apply,
              loginUser: widget.loginProvider.user,
              approvalNumber: approvalNumberController.text,
              approvalReason: approvalReasonController.text,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '承認しました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class RejectApplyDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyModel apply;

  const RejectApplyDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.apply,
    super.key,
  });

  @override
  State<RejectApplyDialog> createState() => _RejectApplyDialogState();
}

class _RejectApplyDialogState extends State<RejectApplyDialog> {
  TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final applyProvider = Provider.of<ApplyProvider>(context);
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          const Text(
            '本当に否決しますか？',
            style: TextStyle(color: kRedColor),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '否決理由',
            child: CustomTextField(
              controller: reasonController,
              textInputType: TextInputType.multiline,
              maxLines: 5,
            ),
          ),
        ],
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
          label: '否決する',
          labelColor: kRedColor,
          backgroundColor: kRed100Color,
          onPressed: () async {
            String? error = await applyProvider.reject(
              apply: widget.apply,
              reason: reasonController.text,
              loginUser: widget.loginProvider.user,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '否決しました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
