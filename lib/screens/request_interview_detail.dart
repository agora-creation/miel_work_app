import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/models/request_interview.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/request_interview.dart';
import 'package:miel_work_app/widgets/approval_user_list.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/dotted_divider.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/form_value.dart';
import 'package:miel_work_app/widgets/link_text.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class RequestInterviewDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestInterviewModel interview;

  const RequestInterviewDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.interview,
    super.key,
  });

  @override
  State<RequestInterviewDetailScreen> createState() =>
      _RequestInterviewDetailScreenState();
}

class _RequestInterviewDetailScreenState
    extends State<RequestInterviewDetailScreen> {
  @override
  Widget build(BuildContext context) {
    bool isApproval = true;
    bool isReject = true;
    if (widget.interview.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in widget.interview.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
          isReject = false;
        }
      }
    }
    if (widget.interview.approval == 1 || widget.interview.approval == 9) {
      isApproval = false;
      isReject = false;
    }
    List<ApprovalUserModel> approvalUsers = widget.interview.approvalUsers;
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
          '取材申込：申請詳細',
          style: TextStyle(color: kBlackColor),
        ),
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '申込日時: ${dateText('yyyy/MM/dd HH:mm', widget.interview.createdAt)}',
                style: const TextStyle(
                  color: kGreyColor,
                  fontSize: 14,
                ),
              ),
              widget.interview.approval == 1
                  ? Text(
                      '承認日時: ${dateText('yyyy/MM/dd HH:mm', widget.interview.approvedAt)}',
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
                '申込会社名',
                child: FormValue(widget.interview.companyName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者名',
                child: FormValue(widget.interview.companyUserName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者メールアドレス',
                child: FormValue(widget.interview.companyUserEmail),
              ),
              LinkText(
                label: 'メールソフトを起動する',
                color: kBlueColor,
                onTap: () async {
                  final url = Uri.parse(
                    'mailto:${widget.interview.companyUserEmail}',
                  );
                  await launchUrl(url);
                },
              ),
              const SizedBox(height: 8),
              FormLabel(
                '申込担当者電話番号',
                child: FormValue(widget.interview.companyUserTel),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '媒体名',
                child: FormValue(widget.interview.mediaName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '番組・雑誌名',
                child: FormValue(widget.interview.programName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '出演者情報',
                child: FormValue(widget.interview.castInfo),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '特集内容・備考',
                child: FormValue(widget.interview.featureContent),
              ),
              const SizedBox(height: 8),
              FormLabel(
                'OA・掲載予定日',
                child: FormValue(widget.interview.publishedAt),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              const Text(
                '取材当日情報',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SourceHanSansJP-Bold',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '取材予定日時',
                child: FormValue(
                  widget.interview.interviewedAtPending
                      ? '未定'
                      : '${dateText('yyyy年MM月dd日 HH:mm', widget.interview.interviewedStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', widget.interview.interviewedEndedAt)}',
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '取材担当者名',
                child: FormValue(widget.interview.interviewedUserName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '取材担当者電話番号',
                child: FormValue(widget.interview.interviewedUserTel),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '席の予約',
                child:
                    FormValue(widget.interview.interviewedReserved ? '必要' : ''),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '取材店舗',
                child: FormValue(widget.interview.interviewedShopName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                'いらっしゃる人数',
                child: FormValue(widget.interview.interviewedVisitors),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '取材内容・備考',
                child: FormValue(widget.interview.interviewedContent),
              ),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              widget.interview.location
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          'ロケハン情報',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          'ロケハン予定日時',
                          child: FormValue(
                            widget.interview.locationAtPending
                                ? '未定'
                                : '${dateText('yyyy年MM月dd日 HH:mm', widget.interview.locationStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', widget.interview.locationEndedAt)}',
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          'ロケハン担当者名',
                          child: FormValue(widget.interview.locationUserName),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          'ロケハン担当者電話番号',
                          child: FormValue(widget.interview.locationUserTel),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          'いらっしゃる人数',
                          child: FormValue(widget.interview.locationVisitors),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          'ロケハン内容・備考',
                          child: FormValue(widget.interview.locationContent),
                        ),
                      ],
                    )
                  : Container(),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              widget.interview.insert
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        const Text(
                          'インサート撮影情報',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceHanSansJP-Bold',
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          '撮影予定日時',
                          child: FormValue(
                            widget.interview.insertedAtPending
                                ? '未定'
                                : '${dateText('yyyy年MM月dd日 HH:mm', widget.interview.insertedStartedAt)}〜${dateText('yyyy年MM月dd日 HH:mm', widget.interview.insertedEndedAt)}',
                          ),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          '撮影担当者名',
                          child: FormValue(widget.interview.insertedUserName),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          '撮影担当者電話番号',
                          child: FormValue(widget.interview.insertedUserTel),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          '席の予約',
                          child: FormValue(
                              widget.interview.insertedReserved ? '必要' : ''),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          '撮影店舗',
                          child: FormValue(widget.interview.insertedShopName),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          'いらっしゃる人数',
                          child: FormValue(widget.interview.insertedVisitors),
                        ),
                        const SizedBox(height: 8),
                        FormLabel(
                          '撮影内容・備考',
                          child: FormValue(widget.interview.insertedContent),
                        ),
                      ],
                    )
                  : Container(),
              const SizedBox(height: 16),
              const DottedDivider(),
              const SizedBox(height: 16),
              FormLabel(
                'その他連絡事項',
                child: FormValue(widget.interview.remarks),
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
                    builder: (context) => RejectRequestInterviewDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      interview: widget.interview,
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
                    builder: (context) => ApprovalRequestInterviewDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      interview: widget.interview,
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

class ApprovalRequestInterviewDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestInterviewModel interview;

  const ApprovalRequestInterviewDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.interview,
    super.key,
  });

  @override
  State<ApprovalRequestInterviewDialog> createState() =>
      _ApprovalRequestInterviewDialogState();
}

class _ApprovalRequestInterviewDialogState
    extends State<ApprovalRequestInterviewDialog> {
  @override
  Widget build(BuildContext context) {
    final interviewProvider = Provider.of<RequestInterviewProvider>(context);
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
            String? error = await interviewProvider.approval(
              interview: widget.interview,
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

class RejectRequestInterviewDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestInterviewModel interview;

  const RejectRequestInterviewDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.interview,
    super.key,
  });

  @override
  State<RejectRequestInterviewDialog> createState() =>
      _RejectRequestInterviewDialogState();
}

class _RejectRequestInterviewDialogState
    extends State<RejectRequestInterviewDialog> {
  @override
  Widget build(BuildContext context) {
    final interviewProvider = Provider.of<RequestInterviewProvider>(context);
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
            String? error = await interviewProvider.reject(
              interview: widget.interview,
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
