import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/models/comment.dart';
import 'package:miel_work_app/models/request_const.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/request_const.dart';
import 'package:miel_work_app/screens/request_const_mod.dart';
import 'package:miel_work_app/services/request_const.dart';
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

class RequestConstDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestConstModel requestConst;

  const RequestConstDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.requestConst,
    super.key,
  });

  @override
  State<RequestConstDetailScreen> createState() =>
      _RequestConstDetailScreenState();
}

class _RequestConstDetailScreenState extends State<RequestConstDetailScreen> {
  RequestConstService constService = RequestConstService();
  List<CommentModel> comments = [];

  void _reloadComments() async {
    RequestConstModel? tmpRequestConst = await constService.selectData(
      id: widget.requestConst.id,
    );
    if (tmpRequestConst == null) return;
    comments = tmpRequestConst.comments;
    setState(() {});
  }

  void _init() async {
    comments = widget.requestConst.comments;
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final constProvider = Provider.of<RequestConstProvider>(context);
    bool isApproval = true;
    bool isReject = true;
    if (widget.requestConst.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in widget.requestConst.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
          isReject = false;
        }
      }
    }
    if (widget.requestConst.approval == 1 ||
        widget.requestConst.approval == 9) {
      isApproval = false;
      isReject = false;
    }
    List<ApprovalUserModel> approvalUsers = widget.requestConst.approvalUsers;
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
          '店舗工事作業申請：申請詳細',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DelRequestConstDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                requestConst: widget.requestConst,
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
                  child: RequestConstModScreen(
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
                    requestConst: widget.requestConst,
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
                '申請日時: ${dateText('yyyy/MM/dd HH:mm', widget.requestConst.createdAt)}',
                style: const TextStyle(
                  color: kGreyColor,
                  fontSize: 14,
                ),
              ),
              widget.requestConst.approval == 1
                  ? Text(
                      '承認日時: ${dateText('yyyy/MM/dd HH:mm', widget.requestConst.approvedAt)}',
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
                '申請者情報',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗名',
                child: FormValue(widget.requestConst.constName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗責任者名',
                child: FormValue(widget.requestConst.companyUserName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗責任者メールアドレス',
                child: FormValue(widget.requestConst.companyUserEmail),
              ),
              LinkText(
                label: 'メールソフトを起動する',
                color: kBlueColor,
                onTap: () async {
                  final url = Uri.parse(
                    'mailto:${widget.requestConst.companyUserEmail}',
                  );
                  await launchUrl(url);
                },
              ),
              const SizedBox(height: 8),
              FormLabel(
                '店舗責任者電話番号',
                child: FormValue(widget.requestConst.companyUserTel),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                '工事施工情報',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '工事施工会社名',
                child: FormValue(widget.requestConst.constName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '工事施工代表者名',
                child: FormValue(widget.requestConst.constUserName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '工事施工代表者電話番号',
                child: FormValue(widget.requestConst.constUserTel),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '当日担当者名',
                child: FormValue(widget.requestConst.chargeUserName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '当日担当者電話番号',
                child: FormValue(widget.requestConst.chargeUserTel),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '施工予定日時',
                child: FormValue(
                  widget.requestConst.constAtPending
                      ? '未定'
                      : '${dateText('yyyy年MM月dd日 HH:mm', widget.requestConst.constStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', widget.requestConst.constEndedAt)}',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '施工内容',
                child: FormValue(widget.requestConst.constContent),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '騒音',
                child: FormValue(widget.requestConst.noise ? '有' : '無'),
              ),
              widget.requestConst.noise
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: FormLabel(
                        '騒音対策',
                        child: FormValue(widget.requestConst.noiseMeasures),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 8),
              FormLabel(
                '粉塵',
                child: FormValue(widget.requestConst.dust ? '有' : '無'),
              ),
              widget.requestConst.dust
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: FormLabel(
                        '粉塵対策',
                        child: FormValue(widget.requestConst.dustMeasures),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 8),
              FormLabel(
                '火気の使用',
                child: FormValue(widget.requestConst.fire ? '有' : '無'),
              ),
              widget.requestConst.fire
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: FormLabel(
                        '火気対策',
                        child: FormValue(widget.requestConst.fireMeasures),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              FormLabel(
                '添付ファイル',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: widget.requestConst.attachedFiles.map((file) {
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
                                        await constProvider.addComment(
                                      requestConst: widget.requestConst,
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
                    builder: (context) => RejectRequestConstDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      requestConst: widget.requestConst,
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
                    builder: (context) => ApprovalRequestConstDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      requestConst: widget.requestConst,
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

class DelRequestConstDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestConstModel requestConst;

  const DelRequestConstDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.requestConst,
    super.key,
  });

  @override
  State<DelRequestConstDialog> createState() => _DelRequestConstDialogState();
}

class _DelRequestConstDialogState extends State<DelRequestConstDialog> {
  @override
  Widget build(BuildContext context) {
    final constProvider = Provider.of<RequestConstProvider>(context);
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
            String? error = await constProvider.delete(
              requestConst: widget.requestConst,
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

class ApprovalRequestConstDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestConstModel requestConst;

  const ApprovalRequestConstDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.requestConst,
    super.key,
  });

  @override
  State<ApprovalRequestConstDialog> createState() =>
      _ApprovalRequestConstDialogState();
}

class _ApprovalRequestConstDialogState
    extends State<ApprovalRequestConstDialog> {
  bool meeting = false;
  DateTime meetingAt = DateTime.now();
  TextEditingController cautionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final constProvider = Provider.of<RequestConstProvider>(context);
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
            '着工前の打ち合わせ',
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: kGreyColor),
                  bottom: BorderSide(color: kGreyColor),
                ),
              ),
              child: CheckboxListTile(
                value: meeting,
                onChanged: (value) {
                  setState(() {
                    meeting = value ?? false;
                  });
                },
                title: const Text('必要'),
              ),
            ),
          ),
          meeting
              ? Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: FormLabel(
                    '打ち合わせ日時',
                    child: FormValue(
                      dateText('yyyy/MM/dd HH:mm', meetingAt),
                      onTap: () => picker.DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        minTime: kFirstDate,
                        maxTime: kLastDate,
                        theme: kDatePickerTheme,
                        onConfirm: (value) {
                          setState(() {
                            meetingAt = value;
                          });
                        },
                        currentTime: meetingAt,
                        locale: picker.LocaleType.jp,
                      ),
                    ),
                  ),
                )
              : Container(),
          const SizedBox(height: 8),
          FormLabel(
            '注意事項',
            child: CustomTextField(
              controller: cautionController,
              textInputType: TextInputType.multiline,
              maxLines: 3,
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
            String? error = await constProvider.approval(
              requestConst: widget.requestConst,
              meeting: meeting,
              meetingAt: meetingAt,
              caution: cautionController.text,
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

class RejectRequestConstDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestConstModel requestConst;

  const RejectRequestConstDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.requestConst,
    super.key,
  });

  @override
  State<RejectRequestConstDialog> createState() =>
      _RejectRequestConstDialogState();
}

class _RejectRequestConstDialogState extends State<RejectRequestConstDialog> {
  @override
  Widget build(BuildContext context) {
    final constProvider = Provider.of<RequestConstProvider>(context);
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
            String? error = await constProvider.reject(
              requestConst: widget.requestConst,
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
