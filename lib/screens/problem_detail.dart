import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/problem.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/problem_mod.dart';
import 'package:miel_work_app/services/problem.dart';
import 'package:miel_work_app/widgets/form_label.dart';

class ProblemDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final ProblemModel problem;

  const ProblemDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.problem,
    super.key,
  });

  @override
  State<ProblemDetailScreen> createState() => _ProblemDetailScreenState();
}

class _ProblemDetailScreenState extends State<ProblemDetailScreen> {
  ProblemService problemService = ProblemService();

  void _init() async {
    UserModel? user = widget.loginProvider.user;
    List<String> readUserIds = widget.problem.readUserIds;
    if (!readUserIds.contains(user?.id)) {
      readUserIds.add(user?.id ?? '');
      problemService.update({
        'id': widget.problem.id,
        'readUserIds': readUserIds,
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
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
          'クレーム／要望詳細',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () => pushScreen(
              context,
              ProblemModScreen(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                problem: widget.problem,
              ),
            ),
            icon: const Icon(Icons.edit, color: kBlueColor),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '報告日時: ${dateText('yyyy/MM/dd HH:mm', widget.problem.createdAt)}',
                style: const TextStyle(color: kGrey600Color),
              ),
              Text('対応項目: ${widget.problem.type}'),
              const SizedBox(height: 8),
              Text('対応者: ${widget.problem.picName}'),
              const SizedBox(height: 8),
              Text('相手の名前: ${widget.problem.targetName}'),
              Text('相手の年齢: ${widget.problem.targetAge}'),
              Text('相手の連絡先: ${widget.problem.targetTel}'),
              Text('相手の住所: ${widget.problem.targetAddress}'),
              const SizedBox(height: 8),
              FormLabel(
                label: '詳細',
                child: Text(widget.problem.details),
              ),
              const SizedBox(height: 8),
              FormLabel(
                label: '添付写真',
                child: widget.problem.image != ''
                    ? Image.network(
                        widget.problem.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : Container(),
              ),
              const SizedBox(height: 8),
              FormLabel(
                label: '対応状態',
                child: Text(
                  widget.problem.stateText(),
                  style: const TextStyle(color: kRedColor),
                ),
              ),
              const SizedBox(height: 8),
              Text('同じような注意(対応)をした回数: ${widget.problem.count}'),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
