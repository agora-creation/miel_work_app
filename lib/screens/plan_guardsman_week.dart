import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/plan_guardsman_week.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/plan_guardsman.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/form_value.dart';
import 'package:miel_work_app/widgets/link_text.dart';
import 'package:miel_work_app/widgets/plan_work_list.dart';
import 'package:miel_work_app/widgets/time_range_form.dart';
import 'package:miel_work_app/widgets/week_list.dart';
import 'package:provider/provider.dart';

class PlanGuardsmanWeekScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final List<DateTime> days;

  const PlanGuardsmanWeekScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.days,
    super.key,
  });

  @override
  State<PlanGuardsmanWeekScreen> createState() =>
      _PlanGuardsmanWeekScreenState();
}

class _PlanGuardsmanWeekScreenState extends State<PlanGuardsmanWeekScreen> {
  List<PlanGuardsmanWeekModel> guardsmanWeeks = [];

  Future _getData() async {
    guardsmanWeeks.clear();
    List<String> result = await getPrefsList('guardsmanWeeks') ?? [];
    if (result.isNotEmpty) {
      guardsmanWeeks = result
          .map((e) => PlanGuardsmanWeekModel.fromMap(json.decode(e)))
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
    final guardsmanProvider = Provider.of<PlanGuardsmanProvider>(context);
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
          '警備員勤務表：1週間分の予定を設定',
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
                    children: guardsmanWeeks.map((e) {
                      if (e.week != '日') return Container();
                      return GestureDetector(
                        child: PlanWorkList(
                          '${e.startedTime}～${e.endedTime}',
                          labelColor: kBlackColor,
                          labelSize: 16,
                        ),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => ModGuardsmanWeekDialog(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            guardsmanWeek: e,
                            guardsmanWeeks: guardsmanWeeks,
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
                      builder: (context) => AddGuardsmanWeekDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                        currentWeek: '日',
                        guardsmanWeeks: guardsmanWeeks,
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
                    children: guardsmanWeeks.map((e) {
                      if (e.week != '月') return Container();
                      return GestureDetector(
                        child: PlanWorkList(
                          '${e.startedTime}～${e.endedTime}',
                          labelColor: kBlackColor,
                          labelSize: 16,
                        ),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => ModGuardsmanWeekDialog(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            guardsmanWeek: e,
                            guardsmanWeeks: guardsmanWeeks,
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
                      builder: (context) => AddGuardsmanWeekDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                        currentWeek: '月',
                        guardsmanWeeks: guardsmanWeeks,
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
                    children: guardsmanWeeks.map((e) {
                      if (e.week != '火') return Container();
                      return GestureDetector(
                        child: PlanWorkList(
                          '${e.startedTime}～${e.endedTime}',
                          labelColor: kBlackColor,
                          labelSize: 16,
                        ),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => ModGuardsmanWeekDialog(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            guardsmanWeek: e,
                            guardsmanWeeks: guardsmanWeeks,
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
                      builder: (context) => AddGuardsmanWeekDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                        currentWeek: '火',
                        guardsmanWeeks: guardsmanWeeks,
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
                    children: guardsmanWeeks.map((e) {
                      if (e.week != '水') return Container();
                      return GestureDetector(
                        child: PlanWorkList(
                          '${e.startedTime}～${e.endedTime}',
                          labelColor: kBlackColor,
                          labelSize: 16,
                        ),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => ModGuardsmanWeekDialog(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            guardsmanWeek: e,
                            guardsmanWeeks: guardsmanWeeks,
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
                      builder: (context) => AddGuardsmanWeekDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                        currentWeek: '水',
                        guardsmanWeeks: guardsmanWeeks,
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
                    children: guardsmanWeeks.map((e) {
                      if (e.week != '木') return Container();
                      return GestureDetector(
                        child: PlanWorkList(
                          '${e.startedTime}～${e.endedTime}',
                          labelColor: kBlackColor,
                          labelSize: 16,
                        ),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => ModGuardsmanWeekDialog(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            guardsmanWeek: e,
                            guardsmanWeeks: guardsmanWeeks,
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
                      builder: (context) => AddGuardsmanWeekDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                        currentWeek: '木',
                        guardsmanWeeks: guardsmanWeeks,
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
                    children: guardsmanWeeks.map((e) {
                      if (e.week != '金') return Container();
                      return GestureDetector(
                        child: PlanWorkList(
                          '${e.startedTime}～${e.endedTime}',
                          labelColor: kBlackColor,
                          labelSize: 16,
                        ),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => ModGuardsmanWeekDialog(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            guardsmanWeek: e,
                            guardsmanWeeks: guardsmanWeeks,
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
                      builder: (context) => AddGuardsmanWeekDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                        currentWeek: '金',
                        guardsmanWeeks: guardsmanWeeks,
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
                    children: guardsmanWeeks.map((e) {
                      if (e.week != '土') return Container();
                      return GestureDetector(
                        child: PlanWorkList(
                          '${e.startedTime}～${e.endedTime}',
                          labelColor: kBlackColor,
                          labelSize: 16,
                        ),
                        onTap: () => showDialog(
                          context: context,
                          builder: (context) => ModGuardsmanWeekDialog(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            guardsmanWeek: e,
                            guardsmanWeeks: guardsmanWeeks,
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
                      builder: (context) => AddGuardsmanWeekDialog(
                        loginProvider: widget.loginProvider,
                        homeProvider: widget.homeProvider,
                        currentWeek: '土',
                        guardsmanWeeks: guardsmanWeeks,
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
                    String? error = await guardsmanProvider.createWeeks(
                      organization: widget.loginProvider.organization,
                      guardsmanWeeks: guardsmanWeeks,
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

class AddGuardsmanWeekDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final String currentWeek;
  final List<PlanGuardsmanWeekModel> guardsmanWeeks;
  final Function() getData;

  const AddGuardsmanWeekDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.currentWeek,
    required this.guardsmanWeeks,
    required this.getData,
    super.key,
  });

  @override
  State<AddGuardsmanWeekDialog> createState() => _AddGuardsmanWeekDialogState();
}

class _AddGuardsmanWeekDialogState extends State<AddGuardsmanWeekDialog> {
  String startedTime = '09:00';
  String endedTime = '23:00';

  void _init() async {
    startedTime = '09:00';
    endedTime = '23:00';
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
            if (widget.guardsmanWeeks.isNotEmpty) {
              for (final data in widget.guardsmanWeeks) {
                maps.add(data.toMap());
              }
            }
            maps.add({
              'id': dateText('yyyyMMddHHmm', DateTime.now()),
              'week': widget.currentWeek,
              'startedTime': startedTime,
              'endedTime': endedTime,
            });
            List<String> jsonMaps = maps.map((e) => json.encode(e)).toList();
            await setPrefsList('guardsmanWeeks', jsonMaps);
            if (!mounted) return;
            widget.getData();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ModGuardsmanWeekDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final PlanGuardsmanWeekModel guardsmanWeek;
  final List<PlanGuardsmanWeekModel> guardsmanWeeks;
  final Function() getData;

  const ModGuardsmanWeekDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.guardsmanWeek,
    required this.guardsmanWeeks,
    required this.getData,
    super.key,
  });

  @override
  State<ModGuardsmanWeekDialog> createState() => _ModGuardsmanWeekDialogState();
}

class _ModGuardsmanWeekDialogState extends State<ModGuardsmanWeekDialog> {
  String startedTime = '09:00';
  String endedTime = '23:00';

  void _init() async {
    startedTime = widget.guardsmanWeek.startedTime;
    endedTime = widget.guardsmanWeek.endedTime;
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
          FormLabel('曜日', child: FormValue(widget.guardsmanWeek.week)),
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
            if (widget.guardsmanWeeks.isNotEmpty) {
              for (final guardsmanWeek in widget.guardsmanWeeks) {
                if (widget.guardsmanWeek.id == guardsmanWeek.id) {
                  continue;
                }
                maps.add(guardsmanWeek.toMap());
              }
            }
            List<String> jsonMaps = maps.map((e) => json.encode(e)).toList();
            await setPrefsList('guardsmanWeeks', jsonMaps);
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
            if (widget.guardsmanWeeks.isNotEmpty) {
              for (final guardsmanWeek in widget.guardsmanWeeks) {
                if (widget.guardsmanWeek.id == guardsmanWeek.id) {
                  guardsmanWeek.startedTime = startedTime;
                  guardsmanWeek.endedTime = endedTime;
                }
                maps.add(guardsmanWeek.toMap());
              }
            }
            List<String> jsonMaps = maps.map((e) => json.encode(e)).toList();
            await setPrefsList('guardsmanWeeks', jsonMaps);
            if (!mounted) return;
            widget.getData();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
