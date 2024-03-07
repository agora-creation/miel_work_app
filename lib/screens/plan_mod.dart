import 'package:flutter/material.dart';
import 'package:miel_work_app/common/custom_date_time_picker.dart';
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
import 'package:miel_work_app/widgets/custom_button_sm.dart';
import 'package:miel_work_app/widgets/custom_text_form_field.dart';
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
  String? selectedCategory;
  TextEditingController subjectController = TextEditingController();
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();
  bool allDay = false;
  String color = kPlanColors.first.value.toRadixString(16);
  TextEditingController memoController = TextEditingController();

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
    selectedCategory = plan.category;
    subjectController.text = plan.subject;
    startedAt = plan.startedAt;
    endedAt = plan.endedAt;
    allDay = plan.allDay;
    color = plan.color.value.toRadixString(16);
    memoController.text = plan.memo;
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
        child: Text('グループ未選択'),
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
            child: const Text('削除'),
          ),
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
                color: color,
                memo: memoController.text,
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
              DropdownButton<OrganizationGroupModel?>(
                isExpanded: true,
                value: selectedGroup,
                items: groupItems,
                onChanged: (value) {
                  setState(() {
                    selectedGroup = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              DropdownButton<String?>(
                isExpanded: true,
                value: selectedCategory,
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category.name,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: subjectController,
                textInputType: TextInputType.name,
                maxLines: 1,
                label: '件名',
                color: kBlackColor,
                prefix: Icons.short_text,
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomButtonSm(
                    label: dateText('yyyy/MM/dd', startedAt),
                    labelColor: kWhiteColor,
                    backgroundColor: kGrey600Color,
                    onPressed: () async {
                      final result =
                          await CustomDateTimePicker().showDateChange(
                        context: context,
                        value: startedAt,
                      );
                      setState(() {
                        startedAt = result;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  CustomButtonSm(
                    label: dateText('HH:mm', startedAt),
                    labelColor: kWhiteColor,
                    backgroundColor: kGrey600Color,
                    onPressed: () async {
                      final result =
                          await CustomDateTimePicker().showTimeChange(
                        context: context,
                        value: startedAt,
                      );
                      setState(() {
                        startedAt = result;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomButtonSm(
                    label: dateText('yyyy/MM/dd', endedAt),
                    labelColor: kWhiteColor,
                    backgroundColor: kGrey600Color,
                    onPressed: () async {
                      final result =
                          await CustomDateTimePicker().showDateChange(
                        context: context,
                        value: endedAt,
                      );
                      setState(() {
                        endedAt = result;
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  CustomButtonSm(
                    label: dateText('HH:mm', endedAt),
                    labelColor: kWhiteColor,
                    backgroundColor: kGrey600Color,
                    onPressed: () async {
                      final result =
                          await CustomDateTimePicker().showTimeChange(
                        context: context,
                        value: endedAt,
                      );
                      setState(() {
                        endedAt = result;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                value: allDay,
                onChanged: _allDayChange,
                title: const Text('終日'),
              ),
              const SizedBox(height: 8),
              DropdownButton<String>(
                isExpanded: true,
                value: color,
                items: kPlanColors.map((Color value) {
                  return DropdownMenuItem(
                    value: value.value.toRadixString(16),
                    child: Container(
                      color: value,
                      width: double.infinity,
                      height: 25,
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    color = value!;
                  });
                },
              ),
              const SizedBox(height: 8),
              CustomTextFormField(
                controller: memoController,
                textInputType: TextInputType.multiline,
                maxLines: null,
                label: 'メモ',
                color: kBlackColor,
                prefix: Icons.short_text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
