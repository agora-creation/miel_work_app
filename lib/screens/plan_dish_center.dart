import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/plan_dish_center.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/providers/plan_dish_center.dart';
import 'package:miel_work_app/screens/plan_dish_center_timeline.dart';
import 'package:miel_work_app/services/plan_dish_center.dart';
import 'package:miel_work_app/services/user.dart';
import 'package:miel_work_app/widgets/custom_alert_dialog.dart';
import 'package:miel_work_app/widgets/custom_button.dart';
import 'package:miel_work_app/widgets/custom_calendar.dart';
import 'package:miel_work_app/widgets/custom_footer.dart';
import 'package:miel_work_app/widgets/datetime_range_form.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:miel_work_app/widgets/month_picker_button.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class PlanDishCenterScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const PlanDishCenterScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<PlanDishCenterScreen> createState() => _PlanDishCenterScreenState();
}

class _PlanDishCenterScreenState extends State<PlanDishCenterScreen> {
  EventController controller = EventController();
  PlanDishCenterService dishCenterService = PlanDishCenterService();
  DateTime searchMonth = DateTime.now();
  List<DateTime> days = [];

  void _changeMonth(DateTime value) {
    searchMonth = value;
    days = generateDays(value);
    setState(() {});
  }

  void _init() async {
    days = generateDays(searchMonth);
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
        automaticallyImplyLeading: false,
        backgroundColor: kWhiteColor,
        title: const Text(
          '食器センター予定表',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.xmark,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
        shape: Border(bottom: BorderSide(color: kBorderColor)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            MonthPickerButton(
              value: searchMonth,
              onTap: () async {
                DateTime? selected = await showMonthPicker(
                  context: context,
                  initialDate: searchMonth,
                  locale: const Locale('ja'),
                );
                if (selected == null) return;
                _changeMonth(selected);
              },
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: dishCenterService.streamList(
                  organizationId: widget.loginProvider.organization?.id,
                  searchStart: days.first,
                  searchEnd: days.last,
                ),
                builder: (context, snapshot) {
                  List<PlanDishCenterModel> dishCenters = [];
                  if (snapshot.hasData) {
                    dishCenters = dishCenterService.generateList(
                      data: snapshot.data,
                    );
                  }
                  if (dishCenters.isNotEmpty) {
                    List<CalendarEventData> events = [];
                    for (final dishCenter in dishCenters) {
                      events.add(CalendarEventData(
                        title:
                            '[${dishCenter.userName}]${dateText('HH:mm', dishCenter.startedAt)}〜${dateText('HH:mm', dishCenter.endedAt)}',
                        date: dishCenter.startedAt,
                        startTime: dishCenter.startedAt,
                        endTime: dishCenter.endedAt,
                      ));
                    }
                    controller.addAll(events);
                  }
                  return CustomCalendar(
                    controller: controller,
                    initialMonth: searchMonth,
                    onPageChange: (month, page) {
                      _changeMonth(month);
                    },
                    onCellTap: (events, day) {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: PlanDishCenterTimelineScreen(
                            loginProvider: widget.loginProvider,
                            homeProvider: widget.homeProvider,
                            day: day,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddDishCenterDialog(
            loginProvider: widget.loginProvider,
            homeProvider: widget.homeProvider,
            day: DateTime.now(),
          ),
        ),
        icon: const FaIcon(
          FontAwesomeIcons.pen,
          color: kWhiteColor,
        ),
        label: const Text(
          '追加する',
          style: TextStyle(color: kWhiteColor),
        ),
      ),
      bottomNavigationBar: CustomFooter(
        loginProvider: widget.loginProvider,
        homeProvider: widget.homeProvider,
      ),
    );
  }
}

class AddDishCenterDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final DateTime day;

  const AddDishCenterDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.day,
    super.key,
  });

  @override
  State<AddDishCenterDialog> createState() => _AddDishCenterDialogState();
}

class _AddDishCenterDialogState extends State<AddDishCenterDialog> {
  UserService userService = UserService();
  List<UserModel> users = [];
  UserModel? selectedUser;
  DateTime startedAt = DateTime.now();
  DateTime endedAt = DateTime.now();

  void _getUsers() async {
    if (widget.homeProvider.currentGroup == null) {
      users = await userService.selectList(
        userIds: widget.loginProvider.organization?.userIds ?? [],
      );
    } else {
      users = await userService.selectList(
        userIds: widget.homeProvider.currentGroup?.userIds ?? [],
      );
    }
    setState(() {});
  }

  @override
  void initState() {
    _getUsers();
    startedAt = DateTime(
      widget.day.year,
      widget.day.month,
      widget.day.day,
      8,
    );
    endedAt = DateTime(
      widget.day.year,
      widget.day.month,
      widget.day.day,
      20,
    );
    if (users.isNotEmpty) {
      selectedUser = users.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dishCenterProvider = Provider.of<PlanDishCenterProvider>(context);
    return CustomAlertDialog(
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            FormLabel(
              'スタッフ選択',
              child: DropdownButton<UserModel>(
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
              '予定日時',
              child: DatetimeRangeForm(
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
              ),
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
          label: '追加する',
          labelColor: kWhiteColor,
          backgroundColor: kBlueColor,
          onPressed: () async {
            String? error = await dishCenterProvider.create(
              organization: widget.loginProvider.organization,
              user: selectedUser,
              startedAt: startedAt,
              endedAt: endedAt,
            );
            if (error != null) {
              if (!mounted) return;
              showMessage(context, error, false);
              return;
            }
            if (!mounted) return;
            showMessage(context, '食器センター予定が追加されました', true);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}