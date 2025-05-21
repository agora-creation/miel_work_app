import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/models/comment.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/apply.dart';
import 'package:miel_work_app/providers/chat_message.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/apply_mod.dart';
import 'package:miel_work_app/services/apply.dart';
import 'package:miel_work_app/widgets/approval_user_list.dart';
import 'package:miel_work_app/widgets/comment_list.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/file_link.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/form_value.dart';
import 'package:miel_work_app/widgets/image_detail_dialog.dart';
import 'package:miel_work_app/widgets/pdf_detail_dialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
  ApplyService applyService = ApplyService();
  List<CommentModel> comments = [];

  void _reloadComments() async {
    ApplyModel? tmpApply = await applyService.selectData(
      id: widget.apply.id,
    );
    if (tmpApply == null) return;
    comments = tmpApply.comments;
    setState(() {});
  }

  void _read() async {
    UserModel? user = widget.loginProvider.user;
    bool commentNotRead = true;
    List<Map> comments = [];
    if (widget.apply.comments.isNotEmpty) {
      for (final comment in widget.apply.comments) {
        if (comment.readUserIds.contains(user?.id)) {
          commentNotRead = false;
        }
        List<String> commentReadUserIds = comment.readUserIds;
        if (!commentReadUserIds.contains(user?.id)) {
          commentReadUserIds.add(user?.id ?? '');
        }
        comment.readUserIds = commentReadUserIds;
        comments.add(comment.toMap());
      }
    }
    if (commentNotRead) {
      applyService.update({
        'id': widget.apply.id,
        'comments': comments,
      });
    }
  }

  void _init() async {
    _read();
    comments = widget.apply.comments;
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
    final messageProvider = Provider.of<ChatMessageProvider>(context);
    bool isApproval = true;
    bool isReject = true;
    bool isDelete = true;
    if (widget.apply.createdUserId == widget.loginProvider.user?.id) {
      isApproval = false;
      isReject = false;
      if (widget.loginProvider.user?.president == true) {
        isApproval = true;
        isReject = true;
      }
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
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.apply.approval == 1
                  ? widget.apply.pending == true
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: CustomButton(
                            type: ButtonSizeType.sm,
                            label: '保留を解除する',
                            labelColor: kBlackColor,
                            backgroundColor: kYellowColor,
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => PendingCancelApplyDialog(
                                loginProvider: widget.loginProvider,
                                homeProvider: widget.homeProvider,
                                apply: widget.apply,
                              ),
                            ),
                          ),
                        )
                      : Align(
                          alignment: Alignment.centerRight,
                          child: CustomButton(
                            type: ButtonSizeType.sm,
                            label: '保留中にする',
                            labelColor: kBlackColor,
                            backgroundColor: kYellowColor,
                            onPressed: () => showDialog(
                              context: context,
                              builder: (context) => PendingApplyDialog(
                                loginProvider: widget.loginProvider,
                                homeProvider: widget.homeProvider,
                                apply: widget.apply,
                              ),
                            ),
                          ),
                        )
                  : Container(),
              const SizedBox(height: 4),
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
              widget.apply.file != ''
                  ? FormLabel(
                      '添付ファイル',
                      child: FileLink(
                        file: widget.apply.file,
                        fileExt: widget.apply.fileExt,
                        onTap: () async {
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
                          if (etcExtensions.contains(ext)) {
                            Uri url = Uri.parse(widget.apply.file);
                            await launchUrl(url);
                          }
                        },
                      ),
                    )
                  : Container(),
              const SizedBox(height: 8),
              widget.apply.file2 != ''
                  ? FormLabel(
                      '添付ファイル2',
                      child: FileLink(
                        file: widget.apply.file2,
                        fileExt: widget.apply.file2Ext,
                        onTap: () async {
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
                          if (etcExtensions.contains(ext)) {
                            Uri url = Uri.parse(widget.apply.file2);
                            await launchUrl(url);
                          }
                        },
                      ),
                    )
                  : Container(),
              const SizedBox(height: 8),
              widget.apply.file3 != ''
                  ? FormLabel(
                      '添付ファイル3',
                      child: FileLink(
                        file: widget.apply.file3,
                        fileExt: widget.apply.file3Ext,
                        onTap: () async {
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
                          if (etcExtensions.contains(ext)) {
                            Uri url = Uri.parse(widget.apply.file3);
                            await launchUrl(url);
                          }
                        },
                      ),
                    )
                  : Container(),
              const SizedBox(height: 8),
              widget.apply.file4 != ''
                  ? FormLabel(
                      '添付ファイル4',
                      child: FileLink(
                        file: widget.apply.file4,
                        fileExt: widget.apply.file4Ext,
                        onTap: () async {
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
                          if (etcExtensions.contains(ext)) {
                            Uri url = Uri.parse(widget.apply.file4);
                            await launchUrl(url);
                          }
                        },
                      ),
                    )
                  : Container(),
              const SizedBox(height: 8),
              widget.apply.file5 != ''
                  ? FormLabel(
                      '添付ファイル5',
                      child: FileLink(
                        file: widget.apply.file5,
                        fileExt: widget.apply.file5Ext,
                        onTap: () async {
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
                          if (etcExtensions.contains(ext)) {
                            Uri url = Uri.parse(widget.apply.file5);
                            await launchUrl(url);
                          }
                        },
                      ),
                    )
                  : Container(),
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
                                        textInputType: TextInputType.multiline,
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
                                        await applyProvider.addComment(
                                      organization:
                                          widget.loginProvider.organization,
                                      apply: widget.apply,
                                      content: commentContentController.text,
                                      loginUser: widget.loginProvider.user,
                                    );
                                    String content = '''
${widget.apply.type}申請の「${widget.apply.title}」に、社内コメントを追記しました。
コメント内容:
${commentContentController.text}
                                    ''';
                                    error = await messageProvider.sendComment(
                                      organization:
                                          widget.loginProvider.organization,
                                      content: content,
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
                  backgroundColor: kRejectColor,
                  icon: const Icon(
                    Icons.error_outline,
                    color: kWhiteColor,
                  ),
                  label: const Text(
                    '否決する',
                    style: TextStyle(color: kWhiteColor),
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
                  backgroundColor: kApprovalColor,
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

class PendingApplyDialog extends StatelessWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyModel apply;

  const PendingApplyDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.apply,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final applyProvider = Provider.of<ApplyProvider>(context);
    return CustomAlertDialog(
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8),
          Text(
            '本当に保留中にしますか？',
            style: TextStyle(color: kRedColor),
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
          label: '保留中にする',
          labelColor: kBlackColor,
          backgroundColor: kYellowColor,
          onPressed: () async {
            String? error = await applyProvider.pending(
              apply: apply,
            );
            if (error != null) {
              showMessage(context, error, false);
              return;
            }
            showMessage(context, '保留中にしました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class PendingCancelApplyDialog extends StatelessWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyModel apply;

  const PendingCancelApplyDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.apply,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final applyProvider = Provider.of<ApplyProvider>(context);
    return CustomAlertDialog(
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8),
          Text(
            '本当に保留中にしますか？',
            style: TextStyle(color: kRedColor),
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
          label: '保留中にする',
          labelColor: kBlackColor,
          backgroundColor: kYellowColor,
          onPressed: () async {
            String? error = await applyProvider.pendingCancel(
              apply: apply,
            );
            if (error != null) {
              showMessage(context, error, false);
              return;
            }
            showMessage(context, '保留中にしました', true);
            Navigator.pop(context);
          },
        ),
      ],
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
          backgroundColor: kApprovalColor,
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
          labelColor: kWhiteColor,
          backgroundColor: kRejectColor,
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
