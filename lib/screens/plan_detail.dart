import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/category.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/plan.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/plan.dart';
import 'package:miel_work_app/screens/plan_mod.dart';
import 'package:miel_work_app/services/category.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/form_value.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PlanDetailScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final PlanModel plan;

  const PlanDetailScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.plan,
    super.key,
  });

  @override
  State<PlanDetailScreen> createState() => _PlanDetailScreenState();
}

class _PlanDetailScreenState extends State<PlanDetailScreen> {
  CategoryService categoryService = CategoryService();
  OrganizationGroupModel? selectedGroup;
  List<CategoryModel> categories = [];
  CategoryModel? selectedCategory;

  void _init() async {
    if (widget.loginProvider.isAllGroup()) {
      for (OrganizationGroupModel group in widget.homeProvider.groups) {
        if (group.id == widget.plan.groupId) {
          selectedGroup = group;
        }
      }
    } else {
      selectedGroup = widget.loginProvider.group;
    }
    categories = await categoryService.selectList(
      organizationId: widget.loginProvider.organization?.id,
    );
    selectedCategory =
        categories.firstWhere((e) => e.name == widget.plan.category);
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          '予定の詳細',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DelPlanDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                plan: widget.plan,
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
                  child: PlanModScreen(
                    loginProvider: widget.loginProvider,
                    homeProvider: widget.homeProvider,
                    plan: widget.plan,
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormLabel(
                  '公開グループ',
                  child: FormValue(selectedGroup?.name ?? 'グループの指定なし'),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  'カテゴリ',
                  child: FormValue('${selectedCategory?.name}'),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '件名',
                  child: FormValue(widget.plan.subject),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '開始日時～終了日時',
                  child: FormValue(
                    '${dateText('yyyy/MM/dd HH:mm', widget.plan.startedAt)}～${dateText('yyyy/MM/dd HH:mm', widget.plan.endedAt)}',
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  'メモ',
                  child: FormValue(widget.plan.memo),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '事前アラート通知',
                  child: FormValue('${widget.plan.alertMinute}'),
                ),
                const SizedBox(height: 24),
                const Text(
                  '※『公開グループ』が未選択の場合、全てのスタッフが対象になります。',
                  style: TextStyle(
                    color: kRedColor,
                    fontSize: 14,
                  ),
                ),
                const Text(
                  '※『公開グループ』を指定した場合、そのグループのスタッフのみ閲覧が可能になります。',
                  style: TextStyle(
                    color: kRedColor,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomFooter(
        loginProvider: widget.loginProvider,
        homeProvider: widget.homeProvider,
      ),
    );
  }
}

class DelPlanDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final PlanModel plan;

  const DelPlanDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.plan,
    super.key,
  });

  @override
  State<DelPlanDialog> createState() => _DelPlanDialogState();
}

class _DelPlanDialogState extends State<DelPlanDialog> {
  @override
  Widget build(BuildContext context) {
    final planProvider = Provider.of<PlanProvider>(context);
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
            String? error = await planProvider.delete(
              plan: widget.plan,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '予定が削除されました', true);
            Navigator.pop(context);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
