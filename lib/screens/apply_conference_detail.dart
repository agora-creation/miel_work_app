import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply_conference.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/providers/apply_conference.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/apply_conference_add.dart';
import 'package:miel_work_app/widgets/custom_approval_user_list.dart';
import 'package:miel_work_app/widgets/custom_button_sm.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/link_text.dart';
import 'package:provider/provider.dart';

class ApplyConferenceDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyConferenceModel conference;

  const ApplyConferenceDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.conference,
    super.key,
  });

  @override
  State<ApplyConferenceDetailScreen> createState() =>
      _ApplyConferenceDetailScreenState();
}

class _ApplyConferenceDetailScreenState
    extends State<ApplyConferenceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    bool isApproval = true;
    bool isReject = true;
    bool isApply = false;
    bool isDelete = true;
    if (widget.conference.createdUserId == widget.loginProvider.user?.id) {
      isApproval = false;
      isReject = false;
      if (widget.conference.approval == 9) {
        isApply = true;
      }
    } else {
      isDelete = false;
    }
    if (widget.conference.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in widget.conference.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
          isReject = false;
        }
      }
    }
    if (widget.conference.approval == 1 || widget.conference.approval == 9) {
      isApproval = false;
      isReject = false;
      isDelete = false;
    }
    List<ApprovalUserModel> approvalUsers = widget.conference.approvalUsers;
    List<ApprovalUserModel> reApprovalUsers = approvalUsers.reversed.toList();
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: kBlackColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          '協議・報告申請詳細',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          isDelete
              ? TextButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => DelApplyConferenceDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      conference: widget.conference,
                    ),
                  ),
                  child: const Text(
                    '削除する',
                    style: TextStyle(color: kRedColor),
                  ),
                )
              : Container(),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '提出日時: ${dateText('yyyy/MM/dd HH:mm', widget.conference.createdAt)}',
                      style: const TextStyle(color: kGreyColor),
                    ),
                    widget.conference.approval == 1
                        ? Text(
                            '承認日時: ${dateText('yyyy/MM/dd HH:mm', widget.conference.approvedAt)}',
                            style: const TextStyle(
                              color: kRedColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Container(),
                    Text(
                      '作成者: ${widget.conference.createdUserName}',
                      style: const TextStyle(color: kGreyColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              reApprovalUsers.isNotEmpty
                  ? FormLabel(
                      label: '承認者一覧',
                      child: Column(
                        children: reApprovalUsers.map((approvalUser) {
                          return CustomApprovalUserList(
                            approvalUser: approvalUser,
                          );
                        }).toList(),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 8),
              FormLabel(
                label: '件名',
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    widget.conference.title,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                label: '内容',
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(widget.conference.content),
                ),
              ),
              const SizedBox(height: 8),
              widget.conference.reason != ''
                  ? FormLabel(
                      label: '否決理由',
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(widget.conference.reason),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 16),
              widget.conference.file != ''
                  ? LinkText(
                      label: '添付ファイル',
                      color: kBlueColor,
                      onTap: () async {
                        if (await saveFile(
                          widget.conference.file,
                          '${widget.conference.id}${widget.conference.fileExt}',
                        )) {
                          if (!mounted) return;
                          showMessage(
                            context,
                            'ファイルのダウンロードが完了しました',
                            true,
                          );
                        } else {
                          if (!mounted) return;
                          showMessage(
                            context,
                            'ファイルのダウンロードに失敗しました',
                            false,
                          );
                        }
                      },
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
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          isReject && widget.loginProvider.isAdmin()
              ? FloatingActionButton.extended(
                  heroTag: 'reject',
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => RejectApplyConferenceDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      conference: widget.conference,
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
                    builder: (context) => ApprovalApplyConferenceDialog(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      conference: widget.conference,
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
          const SizedBox(height: 8),
          isApply
              ? FloatingActionButton.extended(
                  heroTag: 'add',
                  onPressed: () => pushScreen(
                    context,
                    ApplyConferenceAddScreen(
                      loginProvider: widget.loginProvider,
                      homeProvider: widget.homeProvider,
                      conference: widget.conference,
                    ),
                  ),
                  backgroundColor: kBlueColor,
                  icon: const Icon(
                    Icons.add,
                    color: kWhiteColor,
                  ),
                  label: const Text(
                    '再申請する',
                    style: TextStyle(color: kWhiteColor),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class DelApplyConferenceDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyConferenceModel conference;

  const DelApplyConferenceDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.conference,
    super.key,
  });

  @override
  State<DelApplyConferenceDialog> createState() =>
      _DelApplyConferenceDialogState();
}

class _DelApplyConferenceDialogState extends State<DelApplyConferenceDialog> {
  @override
  Widget build(BuildContext context) {
    final conferenceProvider = Provider.of<ApplyConferenceProvider>(context);

    return AlertDialog(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8),
          Text(
            '本当に削除しますか？',
            style: TextStyle(color: kBlackColor),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        CustomButtonSm(
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButtonSm(
          label: '削除する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await conferenceProvider.delete(
              conference: widget.conference,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '協議・報告申請を削除しました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ApprovalApplyConferenceDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyConferenceModel conference;

  const ApprovalApplyConferenceDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.conference,
    super.key,
  });

  @override
  State<ApprovalApplyConferenceDialog> createState() =>
      _ApprovalApplyConferenceDialogState();
}

class _ApprovalApplyConferenceDialogState
    extends State<ApprovalApplyConferenceDialog> {
  @override
  Widget build(BuildContext context) {
    final conferenceProvider = Provider.of<ApplyConferenceProvider>(context);

    return AlertDialog(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8),
          Text(
            '本当に承認しますか？',
            style: TextStyle(color: kBlackColor),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        CustomButtonSm(
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButtonSm(
          label: '承認する',
          labelColor: kWhiteColor,
          backgroundColor: kRedColor,
          onPressed: () async {
            String? error = await conferenceProvider.approval(
              conference: widget.conference,
              loginUser: widget.loginProvider.user,
              isAdmin: widget.loginProvider.isAdmin(),
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

class RejectApplyConferenceDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyConferenceModel conference;

  const RejectApplyConferenceDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.conference,
    super.key,
  });

  @override
  State<RejectApplyConferenceDialog> createState() =>
      _RejectApplyConferenceDialogState();
}

class _RejectApplyConferenceDialogState
    extends State<RejectApplyConferenceDialog> {
  TextEditingController reasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final conferenceProvider = Provider.of<ApplyConferenceProvider>(context);

    return AlertDialog(
      backgroundColor: kWhiteColor,
      surfaceTintColor: kWhiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          const Text(
            '本当に否決しますか？',
            style: TextStyle(color: kBlackColor),
          ),
          const SizedBox(height: 8),
          CustomTextField(
            controller: reasonController,
            textInputType: TextInputType.multiline,
            maxLines: null,
            label: '否決理由',
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        CustomButtonSm(
          label: 'キャンセル',
          labelColor: kWhiteColor,
          backgroundColor: kGreyColor,
          onPressed: () => Navigator.pop(context),
        ),
        CustomButtonSm(
          label: '否決する',
          labelColor: kRedColor,
          backgroundColor: kRed100Color,
          onPressed: () async {
            String? error = await conferenceProvider.reject(
              conference: widget.conference,
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
