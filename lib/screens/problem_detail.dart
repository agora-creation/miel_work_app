import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/problem.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/problem.dart';
import 'package:miel_work_app/screens/problem_mod.dart';
import 'package:miel_work_app/services/problem.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/form_value.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

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
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final problemProvider = Provider.of<ProblemProvider>(context);
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
        centerTitle: true,
        title: const Text(
          'クレーム／要望詳細',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          !widget.problem.processed
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: ProblemModScreen(
                          loginProvider: widget.loginProvider,
                          homeProvider: widget.homeProvider,
                          problem: widget.problem,
                        ),
                      ),
                    );
                  },
                  icon: const FaIcon(
                    FontAwesomeIcons.pen,
                    color: kBlueColor,
                  ),
                )
              : Container(),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '報告日時: ${dateText('yyyy/MM/dd HH:mm', widget.problem.createdAt)}',
                style: const TextStyle(color: kGrey600Color),
              ),
              const SizedBox(height: 4),
              FormLabel(
                '対応項目',
                child: Chip(
                  label: Text(widget.problem.type),
                  backgroundColor: widget.problem.typeColor(),
                ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                'タイトル',
                child: FormValue(widget.problem.title),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '対応者',
                child: FormValue(widget.problem.picName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '相手の名前',
                child: FormValue(widget.problem.targetName),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '相手の年齢',
                child: FormValue(widget.problem.targetAge),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '相手の連絡先',
                child: FormValue(widget.problem.targetTel),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '相手の住所',
                child: FormValue(widget.problem.targetAddress),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '詳細',
                child: FormValue(widget.problem.details),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '添付写真',
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
                '対応状態',
                child: FormValue(widget.problem.stateText()),
              ),
              const SizedBox(height: 8),
              FormLabel(
                '同じような注意(対応)をした回数',
                child: FormValue(widget.problem.count.toString()),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: !widget.problem.processed
          ? FloatingActionButton.extended(
              onPressed: () async {
                String? error = await problemProvider.process(
                  problem: widget.problem,
                );
                if (error != null) {
                  if (!mounted) return;
                  showMessage(context, error, false);
                  return;
                }
                if (!mounted) return;
                showMessage(context, 'クレーム／要望の処理済にしました', true);
                Navigator.pop(context);
              },
              backgroundColor: kGreenColor,
              icon: const FaIcon(
                FontAwesomeIcons.check,
                color: kWhiteColor,
              ),
              label: const Text(
                '処理済みにする',
                style: TextStyle(color: kWhiteColor),
              ),
            )
          : Container(),
      bottomNavigationBar: CustomFooter(
        loginProvider: widget.loginProvider,
        homeProvider: widget.homeProvider,
      ),
    );
  }
}
