import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/models/comment.dart';
import 'package:miel_work_app/models/request_facility.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/request_facility.dart';
import 'package:miel_work_app/screens/request_facility_mod.dart';
import 'package:miel_work_app/services/request_facility.dart';
import 'package:miel_work_app/widgets/approval_user_list.dart';
import 'package:miel_work_app/widgets/attached_file_list.dart';
import 'package:miel_work_app/widgets/comment_list.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
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

class RequestFacilityDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestFacilityModel facility;

  const RequestFacilityDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.facility,
    super.key,
  });

  @override
  State<RequestFacilityDetailScreen> createState() =>
      _RequestFacilityDetailScreenState();
}

class _RequestFacilityDetailScreenState
    extends State<RequestFacilityDetailScreen> {
  RequestFacilityService facilityService = RequestFacilityService();
  List<CommentModel> comments = [];

  void _reloadComments() async {
    RequestFacilityModel? tmpFacility = await facilityService.selectData(
      id: widget.facility.id,
    );
    if (tmpFacility == null) return;
    comments = tmpFacility.comments;
    setState(() {});
  }

  void _init() async {
    comments = widget.facility.comments;
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final facilityProvider = Provider.of<RequestFacilityProvider>(context);
    bool isApproval = true;
    bool isReject = true;
    if (widget.facility.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in widget.facility.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
          isReject = false;
        }
      }
    }
    if (widget.facility.approval == 1 || widget.facility.approval == 9) {
      isApproval = false;
      isReject = false;
    }
    List<ApprovalUserModel> approvalUsers = widget.facility.approvalUsers;
    List<ApprovalUserModel> reApprovalUsers = approvalUsers.reversed.toList();
    int useAtDaysPrice = 0;
    if (!widget.facility.useAtPending) {
      int useAtDays = widget.facility.useEndedAt
          .difference(widget.facility.useStartedAt)
          .inDays;
      int price = 1200;
      useAtDaysPrice = price * useAtDays;
    }
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
          '施設使用申込：申請詳細',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DelRequestFacilityDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                facility: widget.facility,
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
                  child: RequestFacilityModScreen(
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
                    facility: widget.facility,
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
                '申込日時: ${dateText('yyyy/MM/dd HH:mm', widget.facility.createdAt)}',
                style: const TextStyle(
                  color: kGreyColor,
                  fontSize: 14,
                ),
              ),
              widget.facility.approval == 1
                  ? Text(
                      '承認日時: ${dateText('yyyy/MM/dd HH:mm', widget.facility.approvedAt)}',
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
                '店舗名',
                child: FormValue(widget.facility.companyName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗責任者名',
                child: FormValue(widget.facility.companyUserName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗責任者メールアドレス',
                child: FormValue(widget.facility.companyUserEmail),
              ),
              LinkText(
                label: 'メールソフトを起動する',
                color: kBlueColor,
                onTap: () async {
                  final url = Uri.parse(
                    'mailto:${widget.facility.companyUserEmail}',
                  );
                  await launchUrl(url);
                },
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗責任者電話番号',
                child: FormValue(widget.facility.companyUserTel),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                '旧梵屋跡の倉庫を使用します (貸出面積：約12㎡)',
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
                  widget.facility.useAtPending
                      ? '未定'
                      : '${dateText('yyyy年MM月dd日 HH:mm', widget.facility.useStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', widget.facility.useEndedAt)}',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用料合計(税抜)',
                child: FormValue(
                  '${NumberFormat("#,###").format(useAtDaysPrice)}円',
                ),
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
                      children: widget.facility.attachedFiles.map((file) {
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
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                        await facilityProvider.addComment(
                                      facility: widget.facility,
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          isReject
              ? FloatingActionButton.extended(
                  heroTag: 'reject',
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => RejectRequestFacilityDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      facility: widget.facility,
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
                    builder: (context) => ApprovalRequestFacilityDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      facility: widget.facility,
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

class DelRequestFacilityDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestFacilityModel facility;

  const DelRequestFacilityDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.facility,
    super.key,
  });

  @override
  State<DelRequestFacilityDialog> createState() =>
      _DelRequestFacilityDialogState();
}

class _DelRequestFacilityDialogState extends State<DelRequestFacilityDialog> {
  @override
  Widget build(BuildContext context) {
    final facilityProvider = Provider.of<RequestFacilityProvider>(context);
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
            String? error = await facilityProvider.delete(
              facility: widget.facility,
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

class ApprovalRequestFacilityDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestFacilityModel facility;

  const ApprovalRequestFacilityDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.facility,
    super.key,
  });

  @override
  State<ApprovalRequestFacilityDialog> createState() =>
      _ApprovalRequestFacilityDialogState();
}

class _ApprovalRequestFacilityDialogState
    extends State<ApprovalRequestFacilityDialog> {
  @override
  Widget build(BuildContext context) {
    final facilityProvider = Provider.of<RequestFacilityProvider>(context);
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
            String? error = await facilityProvider.approval(
              facility: widget.facility,
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

class RejectRequestFacilityDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestFacilityModel facility;

  const RejectRequestFacilityDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.facility,
    super.key,
  });

  @override
  State<RejectRequestFacilityDialog> createState() =>
      _RejectRequestFacilityDialogState();
}

class _RejectRequestFacilityDialogState
    extends State<RejectRequestFacilityDialog> {
  @override
  Widget build(BuildContext context) {
    final facilityProvider = Provider.of<RequestFacilityProvider>(context);
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
            String? error = await facilityProvider.reject(
              facility: widget.facility,
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
