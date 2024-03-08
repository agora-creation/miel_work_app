import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/plan.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/plan_shift_add.dart';
import 'package:miel_work_app/screens/plan_shift_mod.dart';
import 'package:miel_work_app/services/plan.dart';
import 'package:miel_work_app/services/plan_shift.dart';
import 'package:miel_work_app/services/user.dart';
import 'package:miel_work_app/widgets/custom_calendar_shift.dart';
import 'package:miel_work_app/widgets/form_label.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class PlanShiftScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const PlanShiftScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<PlanShiftScreen> createState() => _PlanShiftScreenState();
}

class _PlanShiftScreenState extends State<PlanShiftScreen> {
  PlanService planService = PlanService();
  PlanShiftService planShiftService = PlanShiftService();
  UserService userService = UserService();
  List<sfc.CalendarResource> resourceColl = [];

  void _calendarTap(sfc.CalendarTapDetails details) {
    sfc.CalendarElement element = details.targetElement;
    switch (element) {
      case sfc.CalendarElement.appointment:
      case sfc.CalendarElement.agenda:
        sfc.Appointment appointmentDetails = details.appointments![0];
        String type = appointmentDetails.notes ?? '';
        if (type == 'plan') {
          showDialog(
            context: context,
            builder: (context) => PlanDialog(
              loginProvider: widget.loginProvider,
              homeProvider: widget.homeProvider,
              planId: '${appointmentDetails.id}',
            ),
          );
        } else if (type == 'planShift') {
          pushScreen(
            context,
            PlanShiftModScreen(
              loginProvider: widget.loginProvider,
              homeProvider: widget.homeProvider,
              planShiftId: '${appointmentDetails.id}',
            ),
          );
        }
        break;
      case sfc.CalendarElement.calendarCell:
        final userId = details.resource?.id;
        if (userId == null) return;
        pushScreen(
          context,
          PlanShiftAddScreen(
            loginProvider: widget.loginProvider,
            homeProvider: widget.homeProvider,
            userId: '$userId',
            date: details.date ?? DateTime.now(),
          ),
        );
        break;
      default:
        break;
    }
  }

  void _getUsers() async {
    List<UserModel> users = [];
    if (widget.homeProvider.currentGroup == null) {
      users = await userService.selectList(
        userIds: widget.loginProvider.organization?.userIds ?? [],
      );
    } else {
      users = await userService.selectList(
        userIds: widget.homeProvider.currentGroup?.userIds ?? [],
      );
    }
    if (users.isNotEmpty) {
      for (UserModel user in users) {
        resourceColl.add(sfc.CalendarResource(
          displayName: user.name,
          id: user.id,
          color: kGrey300Color,
        ));
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  @override
  Widget build(BuildContext context) {
    var stream1 = planService.streamList(
      organizationId: widget.loginProvider.organization?.id,
    );
    var stream2 = planShiftService.streamList(
      organizationId: widget.loginProvider.organization?.id,
    );
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
          'シフト表',
          style: TextStyle(color: kBlackColor),
        ),
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: SafeArea(
        child: StreamBuilder2<QuerySnapshot<Map<String, dynamic>>,
            QuerySnapshot<Map<String, dynamic>>>(
          streams: StreamTuple2(stream1!, stream2!),
          builder: (context, snapshot) {
            List<sfc.Appointment> source = [];
            if (snapshot.snapshot1.hasData) {
              source = planService.generateListAppointment(
                data: snapshot.snapshot1.data,
                currentGroup: widget.homeProvider.currentGroup,
                shift: true,
              );
            }
            if (snapshot.snapshot2.hasData) {
              source.addAll(planShiftService.generateList(
                data: snapshot.snapshot2.data,
                currentGroup: widget.homeProvider.currentGroup,
              ));
            }
            return CustomCalendarShift(
              dataSource: _ShiftDataSource(source, resourceColl),
              onTap: _calendarTap,
            );
          },
        ),
      ),
    );
  }
}

class _ShiftDataSource extends sfc.CalendarDataSource {
  _ShiftDataSource(
    List<sfc.Appointment> source,
    List<sfc.CalendarResource> resourceColl,
  ) {
    appointments = source;
    resources = resourceColl;
  }
}

class PlanDialog extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final String planId;

  const PlanDialog({
    required this.loginProvider,
    required this.homeProvider,
    required this.planId,
    super.key,
  });

  @override
  State<PlanDialog> createState() => _PlanDialogState();
}

class _PlanDialogState extends State<PlanDialog> {
  PlanService planService = PlanService();
  String titleText = '';
  String groupText = '';
  String dateTimeText = '';
  Color color = Colors.transparent;
  String memoText = '';

  void _init() async {
    PlanModel? plan = await planService.selectData(id: widget.planId);
    if (plan == null) {
      if (!mounted) return;
      showMessage(context, '予定データの取得に失敗しました', false);
      Navigator.pop(context);
      return;
    }
    titleText = '[${plan.category}]${plan.subject}';
    for (OrganizationGroupModel group in widget.homeProvider.groups) {
      if (group.id == plan.groupId) {
        groupText = group.name;
      }
    }
    dateTimeText =
        '${dateText('yyyy/MM/dd HH:mm', plan.startedAt)}〜${dateText('yyyy/MM/dd HH:mm', plan.endedAt)}';
    color = plan.color;
    memoText = plan.memo;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(8),
      backgroundColor: color,
      surfaceTintColor: color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      title: Text(
        titleText,
        style: const TextStyle(
          color: kWhiteColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormLabel(
            label: '公開グループ',
            color: kWhiteColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                groupText,
                style: const TextStyle(
                  color: kWhiteColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          FormLabel(
            label: '予定期間',
            color: kWhiteColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                dateTimeText,
                style: const TextStyle(
                  color: kWhiteColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          FormLabel(
            label: 'メモ',
            color: kWhiteColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                memoText,
                style: const TextStyle(
                  color: kWhiteColor,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
