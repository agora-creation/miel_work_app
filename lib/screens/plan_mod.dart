import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/category.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/plan.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/plan.dart';
import 'package:miel_work_app/services/category.dart';
import 'package:miel_work_app/services/plan.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/datetime_range_form.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/link_text.dart';
import 'package:provider/provider.dart';

class PlanModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final String planId;

  const PlanModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.planId,
    super.key,
  });

  @override
  State<PlanModScreen> createState() => _PlanModScreenState();
}

class _PlanModScreenState extends State<PlanModScreen> {
  PlanService planService = PlanService();
  CategoryService categoryService = CategoryService();
  OrganizationGroupModel? selectedGroup;
  List<CategoryModel> categories = [];
  CategoryModel? selectedCategory;
  TextEditingController subjectController = TextEditingController();
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();
  bool allDay = false;
  TextEditingController memoController = TextEditingController();
  int alertMinute = 0;

  void _init() async {
    PlanModel? plan = await planService.selectData(id: widget.planId);
    if (plan == null) {
      if (!mounted) return;
      showMessage(context, '予定データの取得に失敗しました', false);
      Navigator.pop(context);
      return;
    }
    for (OrganizationGroupModel group in widget.homeProvider.groups) {
      if (group.id == plan.groupId) {
        selectedGroup = group;
      }
    }
    categories = await categoryService.selectList(
      organizationId: widget.loginProvider.organization?.id,
    );
    selectedCategory = categories.firstWhere((e) => e.name == plan.category);
    subjectController.text = plan.subject;
    startedAt = plan.startedAt;
    endedAt = plan.endedAt;
    allDay = plan.allDay;
    memoController.text = plan.memo;
    alertMinute = plan.alertMinute;
    setState(() {});
  }

  void _allDayChange(bool? value) {
    allDay = value ?? false;
    if (allDay) {
      startedAt = DateTime(
        startedAt.year,
        startedAt.month,
        startedAt.day,
        0,
        0,
        0,
      );
      endedAt = DateTime(
        endedAt.year,
        endedAt.month,
        endedAt.day,
        23,
        59,
        59,
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    final planProvider = Provider.of<PlanProvider>(context);
    List<DropdownMenuItem<OrganizationGroupModel?>> groupItems = [];
    if (widget.homeProvider.groups.isNotEmpty) {
      groupItems.add(const DropdownMenuItem(
        value: null,
        child: Text(
          'グループの指定なし',
          style: TextStyle(color: kGreyColor),
        ),
      ));
      for (OrganizationGroupModel group in widget.homeProvider.groups) {
        groupItems.add(DropdownMenuItem(
          value: group,
          child: Text(group.name),
        ));
      }
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
          '予定を編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String? error = await planProvider.update(
                planId: widget.planId,
                organization: widget.loginProvider.organization,
                group: selectedGroup,
                category: selectedCategory,
                subject: subjectController.text,
                startedAt: startedAt,
                endedAt: endedAt,
                allDay: allDay,
                repeat: false,
                repeatInterval: '',
                repeatEvery: 0,
                repeatWeeks: [],
                memo: memoController.text,
                alertMinute: alertMinute,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, '予定を編集しました', true);
              Navigator.pop(context);
            },
            child: const Text('保存'),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormLabel(
                label: '公開グループ',
                child: widget.loginProvider.isAllGroup()
                    ? DropdownButton<OrganizationGroupModel?>(
                        hint: const Text(
                          'グループの指定なし',
                          style: TextStyle(color: kGreyColor),
                        ),
                        underline: Container(),
                        isExpanded: true,
                        value: selectedGroup,
                        items: groupItems,
                        onChanged: (value) {
                          setState(() {
                            selectedGroup = value;
                          });
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          '${selectedGroup?.name}',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
              ),
              const SizedBox(height: 8),
              FormLabel(
                label: 'カテゴリ',
                child: DropdownButton<CategoryModel?>(
                  hint: const Text(
                    'カテゴリ未選択',
                    style: TextStyle(color: kGreyColor),
                  ),
                  underline: Container(),
                  isExpanded: true,
                  value: selectedCategory,
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Container(
                        color: category.color,
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        width: double.infinity,
                        child: Text(
                          category.name,
                          style: const TextStyle(color: kWhiteColor),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: subjectController,
                textInputType: TextInputType.name,
                maxLines: 1,
                label: '件名',
              ),
              const SizedBox(height: 8),
              DatetimeRangeForm(
                startedAt: startedAt,
                startedOnTap: () => picker.DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  minTime: kFirstDate,
                  maxTime: kLastDate,
                  theme: kDatePickerTheme,
                  onConfirm: (value) {
                    setState(() {
                      startedAt = value;
                      endedAt = startedAt.add(const Duration(hours: 1));
                    });
                  },
                  currentTime: startedAt,
                  locale: picker.LocaleType.jp,
                ),
                endedAt: endedAt,
                endedOnTap: () => picker.DatePicker.showDateTimePicker(
                  context,
                  showTitleActions: true,
                  minTime: kFirstDate,
                  maxTime: kLastDate,
                  theme: kDatePickerTheme,
                  onConfirm: (value) {
                    setState(() {
                      endedAt = value;
                    });
                  },
                  currentTime: endedAt,
                  locale: picker.LocaleType.jp,
                ),
                allDay: allDay,
                allDayOnChanged: _allDayChange,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: memoController,
                textInputType: TextInputType.multiline,
                maxLines: null,
                label: 'メモ',
              ),
              const SizedBox(height: 8),
              FormLabel(
                label: '事前アラート通知',
                child: DropdownButton<int>(
                  underline: Container(),
                  isExpanded: true,
                  value: alertMinute,
                  items: kAlertMinutes.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: value == 0 ? const Text('無効') : Text('$value分前'),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      alertMinute = value!;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              LinkText(
                label: 'この予定を削除',
                color: kRedColor,
                onTap: () async {
                  String? error = await planProvider.delete(
                    planId: widget.planId,
                  );
                  if (error != null) {
                    if (!mounted) return;
                    showMessage(context, error, false);
                    return;
                  }
                  if (!mounted) return;
                  showMessage(context, '予定を削除しました', true);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              const Text(
                '※『公開グループ』が未選択の場合、全てのスタッフが対象になります。',
                style: TextStyle(
                  color: kRedColor,
                  fontSize: 12,
                ),
              ),
              const Text(
                '※『公開グループ』を指定した場合、そのグループのスタッフのみ閲覧が可能になります。',
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
    );
  }
}
