import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/plan_dish_center_week.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/plan_dish_center.dart';
import 'package:miel_work_app/services/organization_group.dart';
import 'package:miel_work_app/services/user.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/form_value.dart';
import 'package:miel_work_app/widgets/link_text.dart';
import 'package:miel_work_app/widgets/plan_work_list.dart';
import 'package:miel_work_app/widgets/time_range_form.dart';
import 'package:miel_work_app/widgets/week_list.dart';
import 'package:provider/provider.dart';

class PlanDishCenterWeekScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final List<DateTime> days;

  const PlanDishCenterWeekScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.days,
    super.key,
  });

  @override
  State<PlanDishCenterWeekScreen> createState() =>
      _PlanDishCenterWeekScreenState();
}

class _PlanDishCenterWeekScreenState extends State<PlanDishCenterWeekScreen> {
  List<PlanDishCenterWeekModel> dishCenterWeeks = [];

  Future _getData() async {
    dishCenterWeeks.clear();
    List<String> result = await getPrefsList('dishCenterWeeks') ?? [];
    if (result.isNotEmpty) {
      dishCenterWeeks = result
          .map((e) => PlanDishCenterWeekModel.fromMap(json.decode(e)))
          .toList();
    }
    setState(() {});
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dishCenterProvider = Provider.of<PlanDishCenterProvider>(context);
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
          '食器センター勤務表：1週間分の予定を設定',
          style: TextStyle(color: kBlackColor),
        ),
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            WeekList(
              '日',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: dishCenterWeeks.map((e) {
                      if (e.week != '日') return Container();
                      return GestureDetector(
                        child: PlanWorkList(
                          '[${e.userName}]${e.startedTime}～${e.endedTime}',
                          labelColor: kBlackColor,
                          labelSize: 16,
                        ),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => ModDishCenterWeekDialog(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            dishCenterWeek: e,
                            dishCenterWeeks: dishCenterWeeks,
                            getData: _getData,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  LinkText(
                    label: '追加',
                    color: kBlueColor,
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AddDishCenterWeekDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                        currentWeek: '日',
                        dishCenterWeeks: dishCenterWeeks,
                        getData: _getData,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            WeekList(
              '月',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: dishCenterWeeks.map((e) {
                      if (e.week != '月') return Container();
                      return GestureDetector(
                        child: PlanWorkList(
                          '[${e.userName}]${e.startedTime}～${e.endedTime}',
                          labelColor: kBlackColor,
                          labelSize: 16,
                        ),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => ModDishCenterWeekDialog(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            dishCenterWeek: e,
                            dishCenterWeeks: dishCenterWeeks,
                            getData: _getData,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  LinkText(
                    label: '追加',
                    color: kBlueColor,
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AddDishCenterWeekDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                        currentWeek: '月',
                        dishCenterWeeks: dishCenterWeeks,
                        getData: _getData,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            WeekList(
              '火',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: dishCenterWeeks.map((e) {
                      if (e.week != '火') return Container();
                      return GestureDetector(
                        child: PlanWorkList(
                          '[${e.userName}]${e.startedTime}～${e.endedTime}',
                          labelColor: kBlackColor,
                          labelSize: 16,
                        ),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => ModDishCenterWeekDialog(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            dishCenterWeek: e,
                            dishCenterWeeks: dishCenterWeeks,
                            getData: _getData,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  LinkText(
                    label: '追加',
                    color: kBlueColor,
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AddDishCenterWeekDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                        currentWeek: '火',
                        dishCenterWeeks: dishCenterWeeks,
                        getData: _getData,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            WeekList(
              '水',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: dishCenterWeeks.map((e) {
                      if (e.week != '水') return Container();
                      return GestureDetector(
                        child: PlanWorkList(
                          '[${e.userName}]${e.startedTime}～${e.endedTime}',
                          labelColor: kBlackColor,
                          labelSize: 16,
                        ),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => ModDishCenterWeekDialog(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            dishCenterWeek: e,
                            dishCenterWeeks: dishCenterWeeks,
                            getData: _getData,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  LinkText(
                    label: '追加',
                    color: kBlueColor,
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AddDishCenterWeekDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                        currentWeek: '水',
                        dishCenterWeeks: dishCenterWeeks,
                        getData: _getData,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            WeekList(
              '木',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: dishCenterWeeks.map((e) {
                      if (e.week != '木') return Container();
                      return GestureDetector(
                        child: PlanWorkList(
                          '[${e.userName}]${e.startedTime}～${e.endedTime}',
                          labelColor: kBlackColor,
                          labelSize: 16,
                        ),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => ModDishCenterWeekDialog(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            dishCenterWeek: e,
                            dishCenterWeeks: dishCenterWeeks,
                            getData: _getData,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  LinkText(
                    label: '追加',
                    color: kBlueColor,
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AddDishCenterWeekDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                        currentWeek: '木',
                        dishCenterWeeks: dishCenterWeeks,
                        getData: _getData,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            WeekList(
              '金',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: dishCenterWeeks.map((e) {
                      if (e.week != '金') return Container();
                      return GestureDetector(
                        child: PlanWorkList(
                          '[${e.userName}]${e.startedTime}～${e.endedTime}',
                          labelColor: kBlackColor,
                          labelSize: 16,
                        ),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => ModDishCenterWeekDialog(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            dishCenterWeek: e,
                            dishCenterWeeks: dishCenterWeeks,
                            getData: _getData,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  LinkText(
                    label: '追加',
                    color: kBlueColor,
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AddDishCenterWeekDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                        currentWeek: '金',
                        dishCenterWeeks: dishCenterWeeks,
                        getData: _getData,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            WeekList(
              '土',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: dishCenterWeeks.map((e) {
                      if (e.week != '土') return Container();
                      return GestureDetector(
                        child: PlanWorkList(
                          '[${e.userName}]${e.startedTime}～${e.endedTime}',
                          labelColor: kBlackColor,
                          labelSize: 16,
                        ),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => ModDishCenterWeekDialog(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            dishCenterWeek: e,
                            dishCenterWeeks: dishCenterWeeks,
                            getData: _getData,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  LinkText(
                    label: '追加',
                    color: kBlueColor,
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => AddDishCenterWeekDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                        currentWeek: '土',
                        dishCenterWeeks: dishCenterWeeks,
                        getData: _getData,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                  type: ButtonSizeType.sm,
                  label: '『${dateText('yyyy年MM月', widget.days.first)}』に反映する',
                  labelColor: kWhiteColor,
                  backgroundColor: kCyanColor,
                  onPressed: () async {
                    String? error = await dishCenterProvider.createWeeks(
                      organization: widget.loginProvider.organization,
                      dishCenterWeeks: dishCenterWeeks,
                      days: widget.days,
                      loginUser: widget.loginProvider.user,
                    );
                    if (error != null) {
                      if (!mounted) return;
                      showMessage(context, error, false);
                      return;
                    }
                    if (!mounted) return;
                    showMessage(context, '1ヵ月分に反映しました', true);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddDishCenterWeekDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final String currentWeek;
  final List<PlanDishCenterWeekModel> dishCenterWeeks;
  final Function() getData;

  const AddDishCenterWeekDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.currentWeek,
    required this.dishCenterWeeks,
    required this.getData,
    super.key,
  });

  @override
  State<AddDishCenterWeekDialog> createState() =>
      _AddDishCenterWeekDialogState();
}

class _AddDishCenterWeekDialogState extends State<AddDishCenterWeekDialog> {
  OrganizationGroupService groupService = OrganizationGroupService();
  UserService userService = UserService();
  List<UserModel> users = [];
  UserModel? selectedUser;
  String startedTime = '09:00';
  String endedTime = '17:00';

  void _init() async {
    OrganizationGroupModel? group = await groupService.selectDataName(
      organizationId: widget.loginProvider.organization?.id ?? 'error',
      name: '食器センター',
    );
    if (group != null) {
      users = await userService.selectList(
        userIds: group.userIds,
      );
    }
    if (users.isNotEmpty) {
      selectedUser = users.first;
    }
    startedTime = '09:00';
    endedTime = '17:00';
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          FormLabel('曜日', child: FormValue(widget.currentWeek)),
          const SizedBox(height: 8),
          FormLabel(
            'スタッフ選択',
            child: DropdownButton<UserModel?>(
              isExpanded: true,
              value: selectedUser,
              items: users.map((user) {
                return DropdownMenuItem(
                  value: user,
                  child: Text(user.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedUser = value;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '予定時間',
            child: TimeRangeForm(
              startedTime: startedTime,
              startedOnTap: () => picker.DatePicker.showTimePicker(
                context,
                showTitleActions: true,
                theme: kDatePickerTheme,
                onConfirm: (value) {
                  setState(() {
                    startedTime = dateText('HH:mm', value);
                  });
                },
                currentTime: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  int.parse(startedTime.split(':')[0]),
                  int.parse(startedTime.split(':')[1]),
                ),
                locale: picker.LocaleType.jp,
              ),
              endedTime: endedTime,
              endedOnTap: () => picker.DatePicker.showTimePicker(
                context,
                showTitleActions: true,
                theme: kDatePickerTheme,
                onConfirm: (value) {
                  setState(() {
                    endedTime = dateText('HH:mm', value);
                  });
                },
                currentTime: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  int.parse(endedTime.split(':')[0]),
                  int.parse(endedTime.split(':')[1]),
                ),
                locale: picker.LocaleType.jp,
              ),
            ),
          ),
        ],
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
          label: '追加する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            List<Map> maps = [];
            if (widget.dishCenterWeeks.isNotEmpty) {
              for (final data in widget.dishCenterWeeks) {
                maps.add(data.toMap());
              }
            }
            maps.add({
              'id': dateText('yyyyMMddHHmm', DateTime.now()),
              'week': widget.currentWeek,
              'userId': selectedUser?.id,
              'userName': selectedUser?.name,
              'startedTime': startedTime,
              'endedTime': endedTime,
            });
            List<String> jsonMaps = maps.map((e) => json.encode(e)).toList();
            await setPrefsList('dishCenterWeeks', jsonMaps);
            if (!mounted) return;
            widget.getData();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ModDishCenterWeekDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final PlanDishCenterWeekModel dishCenterWeek;
  final List<PlanDishCenterWeekModel> dishCenterWeeks;
  final Function() getData;

  const ModDishCenterWeekDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.dishCenterWeek,
    required this.dishCenterWeeks,
    required this.getData,
    super.key,
  });

  @override
  State<ModDishCenterWeekDialog> createState() =>
      _ModDishCenterWeekDialogState();
}

class _ModDishCenterWeekDialogState extends State<ModDishCenterWeekDialog> {
  OrganizationGroupService groupService = OrganizationGroupService();
  UserService userService = UserService();
  List<UserModel> users = [];
  UserModel? selectedUser;
  String startedTime = '09:00';
  String endedTime = '17:00';

  void _init() async {
    OrganizationGroupModel? group = await groupService.selectDataName(
      organizationId: widget.loginProvider.organization?.id ?? 'error',
      name: '食器センター',
    );
    if (group != null) {
      users = await userService.selectList(
        userIds: group.userIds,
      );
    }
    selectedUser =
        users.singleWhere((e) => e.id == widget.dishCenterWeek.userId);
    startedTime = widget.dishCenterWeek.startedTime;
    endedTime = widget.dishCenterWeek.endedTime;
    setState(() {});
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          FormLabel('曜日', child: FormValue(widget.dishCenterWeek.week)),
          const SizedBox(height: 8),
          FormLabel(
            'スタッフ選択',
            child: DropdownButton<UserModel?>(
              isExpanded: true,
              value: selectedUser,
              items: users.map((user) {
                return DropdownMenuItem(
                  value: user,
                  child: Text(user.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedUser = value;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          FormLabel(
            '予定時間',
            child: TimeRangeForm(
              startedTime: startedTime,
              startedOnTap: () => picker.DatePicker.showTimePicker(
                context,
                showTitleActions: true,
                theme: kDatePickerTheme,
                onConfirm: (value) {
                  setState(() {
                    startedTime = dateText('HH:mm', value);
                  });
                },
                currentTime: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  int.parse(startedTime.split(':')[0]),
                  int.parse(startedTime.split(':')[1]),
                ),
                locale: picker.LocaleType.jp,
              ),
              endedTime: endedTime,
              endedOnTap: () => picker.DatePicker.showTimePicker(
                context,
                showTitleActions: true,
                theme: kDatePickerTheme,
                onConfirm: (value) {
                  setState(() {
                    endedTime = dateText('HH:mm', value);
                  });
                },
                currentTime: DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                  int.parse(endedTime.split(':')[0]),
                  int.parse(endedTime.split(':')[1]),
                ),
                locale: picker.LocaleType.jp,
              ),
            ),
          ),
        ],
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
            List<Map> maps = [];
            if (widget.dishCenterWeeks.isNotEmpty) {
              for (final dishCenterWeek in widget.dishCenterWeeks) {
                if (widget.dishCenterWeek.id == dishCenterWeek.id) {
                  continue;
                }
                maps.add(dishCenterWeek.toMap());
              }
            }
            List<String> jsonMaps = maps.map((e) => json.encode(e)).toList();
            await setPrefsList('dishCenterWeeks', jsonMaps);
            if (!mounted) return;
            widget.getData();
            Navigator.pop(context);
          },
        ),
        CustomButton(
          type: ButtonSizeType.sm,
          label: '保存する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            List<Map> maps = [];
            if (widget.dishCenterWeeks.isNotEmpty) {
              for (final dishCenterWeek in widget.dishCenterWeeks) {
                if (widget.dishCenterWeek.id == dishCenterWeek.id) {
                  dishCenterWeek.userId = selectedUser?.id ?? '';
                  dishCenterWeek.userName = selectedUser?.name ?? '';
                  dishCenterWeek.startedTime = startedTime;
                  dishCenterWeek.endedTime = endedTime;
                }
                maps.add(dishCenterWeek.toMap());
              }
            }
            List<String> jsonMaps = maps.map((e) => json.encode(e)).toList();
            await setPrefsList('dishCenterWeeks', jsonMaps);
            if (!mounted) return;
            widget.getData();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
