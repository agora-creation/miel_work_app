import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/plan_shift.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/plan_shift.dart';
import 'package:miel_work_app/services/plan_shift.dart';
import 'package:miel_work_app/services/user.dart';
import 'package:miel_work_app/widgets/custom_checkbox.dart';
import 'package:miel_work_app/widgets/datetime_range_form.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/link_text.dart';
import 'package:provider/provider.dart';

class PlanShiftModScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final String planShiftId;

  const PlanShiftModScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.planShiftId,
    super.key,
  });

  @override
  State<PlanShiftModScreen> createState() => _PlanShiftModScreenState();
}

class _PlanShiftModScreenState extends State<PlanShiftModScreen> {
  PlanShiftService planShiftService = PlanShiftService();
  UserService userService = UserService();
  OrganizationGroupModel? selectedGroup;
  List<UserModel> users = [];
  List<String> selectedUserIds = [];
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();
  bool allDay = false;
  int alertMinute = 0;

  void _init() async {
    PlanShiftModel? planShift = await planShiftService.selectData(
      id: widget.planShiftId,
    );
    if (planShift == null) {
      if (!mounted) return;
      showMessage(context, '勤務予定データの取得に失敗しました', false);
      Navigator.pop(context);
      return;
    }
    for (OrganizationGroupModel group in widget.homeProvider.groups) {
      if (group.id == planShift.groupId) {
        selectedGroup = group;
      }
    }
    _groupChange(selectedGroup);
    selectedUserIds = planShift.userIds;
    startedAt = planShift.startedAt;
    endedAt = planShift.endedAt;
    allDay = planShift.allDay;
    alertMinute = planShift.alertMinute;
    setState(() {});
  }

  void _groupChange(OrganizationGroupModel? value) async {
    selectedGroup = value;
    if (selectedGroup != null) {
      users = await userService.selectList(
        userIds: selectedGroup?.userIds ?? [],
      );
    } else {
      users = await userService.selectList(
        userIds: widget.loginProvider.organization?.userIds ?? [],
      );
    }
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
    final planShiftProvider = Provider.of<PlanShiftProvider>(context);
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
          '勤務予定を編集',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String? error = await planShiftProvider.update(
                planShiftId: widget.planShiftId,
                organization: widget.loginProvider.organization,
                group: selectedGroup,
                userIds: selectedUserIds,
                startedAt: startedAt,
                endedAt: endedAt,
                allDay: allDay,
                alertMinute: alertMinute,
              );
              if (error != null) {
                if (!mounted) return;
                showMessage(context, error, false);
                return;
              }
              if (!mounted) return;
              showMessage(context, '勤務予定を編集しました', true);
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
                label: '働くスタッフを選択',
                child: widget.loginProvider.isAdmin()
                    ? DropdownButton<OrganizationGroupModel?>(
                        hint: const Text('グループ未選択'),
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
                          selectedGroup?.name ?? '',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
              ),
              Container(
                height: 200,
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: kGrey600Color),
                    left: BorderSide(color: kGrey600Color),
                    bottom: BorderSide(color: kGrey600Color),
                  ),
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    UserModel user = users[index];
                    return CustomCheckbox(
                      label: user.name,
                      value: selectedUserIds.contains(user.id),
                      onChanged: (value) {
                        if (selectedUserIds.contains(user.id)) {
                          selectedUserIds.remove(user.id);
                        } else {
                          selectedUserIds.add(user.id);
                        }
                        setState(() {});
                      },
                    );
                  },
                ),
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
                      endedAt = startedAt.add(const Duration(hours: 8));
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
                label: 'この勤務予定を削除',
                color: kRedColor,
                onTap: () async {
                  String? error = await planShiftProvider.delete(
                    planShiftId: widget.planShiftId,
                  );
                  if (error != null) {
                    if (!mounted) return;
                    showMessage(context, error, false);
                    return;
                  }
                  if (!mounted) return;
                  showMessage(context, '勤務予定を削除しました', true);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
