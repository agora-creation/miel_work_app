import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/apply_project.dart';
import 'package:miel_work_app/models/approval_user.dart';
import 'package:miel_work_app/providers/apply_project.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/widgets/custom_approval_user_list.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/link_text.dart';
import 'package:provider/provider.dart';

class ApplyProjectDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ApplyProjectModel project;

  const ApplyProjectDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.project,
    super.key,
  });

  @override
  State<ApplyProjectDetailScreen> createState() =>
      _ApplyProjectDetailScreenState();
}

class _ApplyProjectDetailScreenState extends State<ApplyProjectDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ApplyProjectProvider>(context);
    bool isApproval = true;
    bool isDelete = true;
    if (widget.project.createdUserId == widget.loginProvider.user?.id) {
      isApproval = false;
    } else {
      isDelete = false;
    }
    if (widget.project.approvalUsers.isNotEmpty) {
      for (ApprovalUserModel user in widget.project.approvalUsers) {
        if (user.userId == widget.loginProvider.user?.id) {
          isApproval = false;
        }
      }
    }
    if (widget.project.approval) {
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
          '企画申請詳細',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          isDelete
              ? TextButton(
                  onPressed: () async {
                    String? error = await projectProvider.delete(
                      project: widget.project,
                    );
                    if (error != null) {
                      if (!mounted) return;
                      showMessage(context, error, false);
                      return;
                    }
                    if (!mounted) return;
                    showMessage(context, '企画申請を削除しました', true);
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
                      '提出日時: ${dateText('yyyy/MM/dd HH:mm', widget.project.createdAt)}',
                      style: const TextStyle(color: kGreyColor),
                    ),
                    widget.project.approval
                        ? Text(
                            '承認日時: ${dateText('yyyy/MM/dd HH:mm', widget.project.approvedAt)}',
                            style: const TextStyle(
                              color: kRedColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Container(),
                    Text(
                      '作成者: ${widget.project.createdUserName}',
                      style: const TextStyle(color: kGreyColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              widget.project.approvalUsers.isNotEmpty
                  ? FormLabel(
                      label: '承認者一覧',
                      child: Column(
                        children:
                            widget.project.approvalUsers.map((approvalUser) {
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
                    widget.project.title,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                label: '内容',
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(widget.project.content),
                ),
              ),
              const SizedBox(height: 16),
              widget.project.file != ''
                  ? LinkText(
                      label: '添付ファイル',
                      color: kBlueColor,
                      onTap: () async {
                        if (await saveFile(
                          widget.project.file,
                          '${widget.project.id}${widget.project.fileExt}',
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
                String? error = await projectProvider.update(
                  project: widget.project,
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
