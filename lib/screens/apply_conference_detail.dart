import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply_conference.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/providers/apply_conference.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/widgets/custom_approval_user_list.dart';
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
    final conferenceProvider = Provider.of<ApplyConferenceProvider>(context);
    bool isApproval = true;
    bool isDelete = true;
    if (widget.conference.createdUserId == widget.loginProvider.user?.id) {
      isApproval = false;
    } else {
      isDelete = false;
    }
    if (widget.conference.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in widget.conference.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
        }
      }
    }
    if (widget.conference.approval) {
      isApproval = false;
      isDelete = false;
    }
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
                  },
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
                    widget.conference.approval
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
              widget.conference.approvalUsers.isNotEmpty
                  ? FormLabel(
                      label: '承認者一覧',
                      child: Column(
                        children:
                            widget.conference.approvalUsers.map((approvalUser) {
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
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      floatingActionButton: isApproval
          ? FloatingActionButton.extended(
              onPressed: () async {
                String? error = await conferenceProvider.update(
                  conference: widget.conference,
                  approval: widget.loginProvider.isAdmin(),
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
              },
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
    );
  }
}