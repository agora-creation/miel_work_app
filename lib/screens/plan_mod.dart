import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_text_field.dart';
import 'package:miel_work_app/widgets/datetime_range_form.dart';
import 'package:miel_work_app/widgets/form_label.dart';
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
    if (widget.loginProvider.isAllGroup()) {
      for (OrganizationGroupModel group in widget.homeProvider.groups) {
        if (group.id == plan.groupId) {
          selectedGroup = group;
        }
      }
    } else {
      selectedGroup = widget.loginProvider.group;
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
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final planProvider = Provider.of<PlanProvider>(context);
    List<DropdownMenuItem<OrganizationGroupModel?>> groupItems = [];
    groupItems.add(const DropdownMenuItem(
      value: null,
      child: Text(
        'グループの指定なし',
        style: TextStyle(color: kGreyColor),
      ),
    ));
    if (widget.loginProvider.isAllGroup()) {
      if (widget.homeProvider.groups.isNotEmpty) {
        for (OrganizationGroupModel group in widget.homeProvider.groups) {
          groupItems.add(DropdownMenuItem(
            value: group,
            child: Text(group.name),
          ));
        }
      }
    } else {
      groupItems.add(DropdownMenuItem(
        value: widget.loginProvider.group,
        child: Text(widget.loginProvider.group?.name ?? ''),
      ));
    }
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
          '予定の編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => DelPlanDialog(
                loginProvider: widget.loginProvider,
                homeProvider: widget.homeProvider,
                planId: widget.planId,
              ),
            ),
            icon: const FaIcon(
              FontAwesomeIcons.trash,
              color: kRedColor,
            ),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormLabel(
                  '公開グループ',
                  child: DropdownButton<OrganizationGroupModel?>(
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
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  'カテゴリ',
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
                const SizedBox(height: 16),
                FormLabel(
                  '件名',
                  child: CustomTextField(
                    controller: subjectController,
                    textInputType: TextInputType.name,
                    maxLines: 1,
                  ),
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 18),
                FormLabel(
                  'メモ',
                  child: CustomTextField(
                    controller: memoController,
                    textInputType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
                const SizedBox(height: 16),
                FormLabel(
                  '事前アラート通知',
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
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
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
          showMessage(context, '予定が編集されました', true);
          Navigator.pop(context);
        },
        icon: const FaIcon(
          FontAwesomeIcons.floppyDisk,
          color: kWhiteColor,
        ),
        label: const Text(
          '保存する',
          style: TextStyle(color: kWhiteColor),
        ),
      ),
    );
  }
}

class DelPlanDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final String planId;

  const DelPlanDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.planId,
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
              planId: widget.planId,
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
