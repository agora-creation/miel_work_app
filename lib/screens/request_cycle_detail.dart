import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/models/request_cycle.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/request_cycle.dart';
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

class RequestCycleDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestCycleModel cycle;

  const RequestCycleDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.cycle,
    super.key,
  });

  @override
  State<RequestCycleDetailScreen> createState() =>
      _RequestCycleDetailScreenState();
}

class _RequestCycleDetailScreenState extends State<RequestCycleDetailScreen> {
  @override
  Widget build(BuildContext context) {
    bool isApproval = true;
    bool isReject = true;
    if (widget.cycle.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in widget.cycle.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
          isReject = false;
        }
      }
    }
    if (widget.cycle.approval == 1 || widget.cycle.approval == 9) {
      isApproval = false;
      isReject = false;
    }
    List<ApprovalUserModel> approvalUsers = widget.cycle.approvalUsers;
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
          '自転車置き場使用申込：申請詳細',
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
                '申込日時: ${dateText('yyyy/MM/dd HH:mm', widget.cycle.createdAt)}',
                style: const TextStyle(
                  color: kGreyColor,
                  fontSize: 14,
                ),
              ),
              widget.cycle.approval == 1
                  ? Text(
                      '承認日時: ${dateText('yyyy/MM/dd HH:mm', widget.cycle.approvedAt)}',
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
                child: FormValue(widget.cycle.companyName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用者名',
                child: FormValue(widget.cycle.companyUserName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用者メールアドレス',
                child: FormValue(widget.cycle.companyUserEmail),
              ),
              LinkText(
                label: 'メールソフトを起動する',
                color: kBlueColor,
                onTap: () async {
                  final url = Uri.parse(
                    'mailto:${widget.cycle.companyUserEmail}',
                  );
                  await launchUrl(url);
                },
              ),
              const SizedBox(height: 8),
              FormLabel(
                '使用者電話番号',
                child: FormValue(widget.cycle.companyUserTel),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '住所',
                child: FormValue(widget.cycle.companyAddress),
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
          isReject && widget.loginProvider.user?.president == true
              ? FloatingActionButton.extended(
                  heroTag: 'reject',
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => ApprovalRequestCycleDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      cycle: widget.cycle,
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
                    builder: (context) => RejectRequestCycleDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      cycle: widget.cycle,
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

class ApprovalRequestCycleDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestCycleModel cycle;

  const ApprovalRequestCycleDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.cycle,
    super.key,
  });

  @override
  State<ApprovalRequestCycleDialog> createState() =>
      _ApprovalRequestCycleDialogState();
}

class _ApprovalRequestCycleDialogState
    extends State<ApprovalRequestCycleDialog> {
  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<RequestCycleProvider>(context);
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
            String? error = await cycleProvider.approval(
              cycle: widget.cycle,
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

class RejectRequestCycleDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final RequestCycleModel cycle;

  const RejectRequestCycleDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.cycle,
    super.key,
  });

  @override
  State<RejectRequestCycleDialog> createState() =>
      _RejectRequestCycleDialogState();
}

class _RejectRequestCycleDialogState extends State<RejectRequestCycleDialog> {
  @override
  Widget build(BuildContext context) {
    final cycleProvider = Provider.of<RequestCycleProvider>(context);
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
            String? error = await cycleProvider.reject(
              cycle: widget.cycle,
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
