import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/models/request_square.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/request_square.dart';
import 'package:miel_work_app/screens/request_square_mod.dart';
import 'package:miel_work_app/widgets/approval_user_list.dart';
import 'package:miel_work_app/widgets/attached_file_list.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/dotted_divider.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/form_value.dart';
import 'package:miel_work_app/widgets/image_detail_dialog.dart';
import 'package:miel_work_app/widgets/link_text.dart';
import 'package:miel_work_app/widgets/pdf_detail_dialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestSquareDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestSquareModel square;

  const RequestSquareDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.square,
    super.key,
  });

  @override
  State<RequestSquareDetailScreen> createState() =>
      _RequestSquareDetailScreenState();
}

class _RequestSquareDetailScreenState extends State<RequestSquareDetailScreen> {
  @override
  Widget build(BuildContext context) {
    bool isApproval = true;
    bool isReject = true;
    if (widget.square.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in widget.square.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
          isReject = false;
        }
      }
    }
    if (widget.square.approval == 1 || widget.square.approval == 9) {
      isApproval = false;
      isReject = false;
    }
    List<ApprovalUserModel> approvalUsers = widget.square.approvalUsers;
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
          'よさこい広場使用申込：申請詳細',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DelRequestSquareDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                square: widget.square,
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
                  child: RequestSquareModScreen(
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
                    square: widget.square,
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
              Text(
                '申込日時: ${dateText('yyyy/MM/dd HH:mm', widget.square.createdAt)}',
                style: const TextStyle(
                  color: kGreyColor,
                  fontSize: 14,
                ),
              ),
              widget.square.approval == 1
                  ? Text(
                      '承認日時: ${dateText('yyyy/MM/dd HH:mm', widget.square.approvedAt)}',
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
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                '申込者情報',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込会社名(又は店名)',
                child: FormValue(widget.square.companyName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者名',
                child: FormValue(widget.square.companyUserName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者メールアドレス',
                child: FormValue(widget.square.companyUserEmail),
              ),
              LinkText(
                label: 'メールソフトを起動する',
                color: kBlueColor,
                onTap: () async {
                  final url = Uri.parse(
                    'mailto:${widget.square.companyUserEmail}',
                  );
                  await launchUrl(url);
                },
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者電話番号',
                child: FormValue(widget.square.companyUserTel),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '住所',
                child: FormValue(widget.square.companyAddress),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                '使用者情報 (申込者情報と異なる場合のみ)',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用会社名(又は店名)',
                child: FormValue(widget.square.useCompanyName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用者名',
                child: FormValue(widget.square.useCompanyUserName),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                '使用情報',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用予定日時',
                child: FormValue(
                  widget.square.useAtPending
                      ? '未定'
                      : '${dateText('yyyy年MM月dd日 HH:mm', widget.square.useStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', widget.square.useEndedAt)}',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用区分',
                child: Column(
                  children: [
                    widget.square.useFull
                        ? const ListTile(
                            title: Text('全面使用'),
                          )
                        : Container(),
                    widget.square.useChair
                        ? ListTile(
                            title:
                                Text('折りたたみイス：${widget.square.useChairNum}脚'),
                            subtitle: const Text('150円(税抜)／1脚・1日'),
                          )
                        : Container(),
                    widget.square.useDesk
                        ? ListTile(
                            title: Text('折りたたみ机：${widget.square.useDeskNum}台'),
                            subtitle: const Text('300円(税抜)／1台・1日'),
                          )
                        : Container(),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用内容',
                child: FormValue(widget.square.useContent),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              FormLabel(
                '添付ファイル',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: widget.square.attachedFiles.map((file) {
                        return AttachedFileList(
                          fileName: p.basename(file),
                          onTap: () {
                            String ext = p.extension(file);
                            if (imageExtensions.contains(ext)) {
                              showDialog(
                                context: context,
                                builder: (context) => ImageDetailDialog(
                                  File(file).path,
                                  onPressedClose: () => Navigator.pop(context),
                                ),
                              );
                            }
                            if (pdfExtensions.contains(ext)) {
                              showDialog(
                                context: context,
                                builder: (context) => PdfDetailDialog(
                                  File(file).path,
                                  onPressedClose: () => Navigator.pop(context),
                                ),
                              );
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          isReject
              ? FloatingActionButton.extended(
                  heroTag: 'reject',
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => RejectRequestSquareDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      square: widget.square,
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
                    builder: (context) => ApprovalRequestSquareDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      square: widget.square,
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

class DelRequestSquareDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestSquareModel square;

  const DelRequestSquareDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.square,
    super.key,
  });

  @override
  State<DelRequestSquareDialog> createState() => _DelRequestSquareDialogState();
}

class _DelRequestSquareDialogState extends State<DelRequestSquareDialog> {
  @override
  Widget build(BuildContext context) {
    final squareProvider = Provider.of<RequestSquareProvider>(context);
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
            String? error = await squareProvider.delete(
              square: widget.square,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '申請情報が削除されました', true);
            Navigator.pop(context);
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
  }
}

class ApprovalRequestSquareDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestSquareModel square;

  const ApprovalRequestSquareDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.square,
    super.key,
  });

  @override
  State<ApprovalRequestSquareDialog> createState() =>
      _ApprovalRequestSquareDialogState();
}

class _ApprovalRequestSquareDialogState
    extends State<ApprovalRequestSquareDialog> {
  @override
  Widget build(BuildContext context) {
    final squareProvider = Provider.of<RequestSquareProvider>(context);
    return CustomAlertDialog(
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8),
          Text(
            '本当に承認しますか？',
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
          label: '承認する',
          labelColor: kWhiteColor,
          backgroundColor: kApprovalColor,
          onPressed: () async {
            String? error = await squareProvider.approval(
              square: widget.square,
              loginUser: widget.loginProvider.user,
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

class RejectRequestSquareDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestSquareModel square;

  const RejectRequestSquareDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.square,
    super.key,
  });

  @override
  State<RejectRequestSquareDialog> createState() =>
      _RejectRequestSquareDialogState();
}

class _RejectRequestSquareDialogState extends State<RejectRequestSquareDialog> {
  @override
  Widget build(BuildContext context) {
    final squareProvider = Provider.of<RequestSquareProvider>(context);
    return CustomAlertDialog(
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8),
          Text(
            '本当に否決しますか？',
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
          label: '否決する',
          labelColor: kWhiteColor,
          backgroundColor: kRejectColor,
          onPressed: () async {
            String? error = await squareProvider.reject(
              square: widget.square,
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