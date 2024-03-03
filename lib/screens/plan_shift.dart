import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/models/organization_group.dart';
import 'package:miel_work_app/models/plan.dart';
import 'package:miel_work_app/models/plan_shift.dart';
import 'package:miel_work_app/models/user.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/services/plan.dart';
import 'package:miel_work_app/services/plan_shift.dart';
import 'package:miel_work_app/services/user.dart';
import 'package:miel_work_app/widgets/custom_calendar_shift.dart';
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

  void _getUsers() async {
    List<UserModel> tmpUsers = [];
    if (widget.homeProvider.currentGroup == null) {
      tmpUsers = await userService.selectList(
        userIds: widget.loginProvider.organization?.userIds ?? [],
      );
    } else {
      tmpUsers = await userService.selectList(
        userIds: widget.homeProvider.currentGroup?.userIds ?? [],
      );
    }
    if (tmpUsers.isNotEmpty) {
      for (UserModel user in tmpUsers) {
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
              for (DocumentSnapshot<Map<String, dynamic>> doc
                  in snapshot.snapshot1.data!.docs) {
                PlanModel plan = PlanModel.fromSnapshot(doc);
                OrganizationGroupModel? group =
                    widget.homeProvider.currentGroup;
                if (group == null) {
                  source.add(sfc.Appointment(
                    id: plan.id,
                    resourceIds: plan.userIds,
                    subject: '[${plan.category}]${plan.subject}',
                    startTime: plan.startedAt,
                    endTime: plan.endedAt,
                    isAllDay: plan.allDay,
                    color: plan.color.withOpacity(0.5),
                    notes: 'plan',
                  ));
                } else if (plan.groupId == group.id || plan.groupId == '') {
                  source.add(sfc.Appointment(
                    id: plan.id,
                    resourceIds: plan.userIds,
                    subject: '[${plan.category}]${plan.subject}',
                    startTime: plan.startedAt,
                    endTime: plan.endedAt,
                    isAllDay: plan.allDay,
                    color: plan.color.withOpacity(0.5),
                    notes: 'plan',
                  ));
                }
              }
            }
            if (snapshot.snapshot2.hasData) {
              for (DocumentSnapshot<Map<String, dynamic>> doc
                  in snapshot.snapshot2.data!.docs) {
                PlanShiftModel planShift = PlanShiftModel.fromSnapshot(doc);
                OrganizationGroupModel? group =
                    widget.homeProvider.currentGroup;
                if (group == null) {
                  source.add(sfc.Appointment(
                    id: planShift.id,
                    resourceIds: planShift.userIds,
                    subject: '勤務予定',
                    startTime: planShift.startedAt,
                    endTime: planShift.endedAt,
                    isAllDay: planShift.allDay,
                    color: kBlueColor,
                    notes: 'planShift',
                  ));
                } else if (planShift.groupId == group.id ||
                    planShift.groupId == '') {
                  source.add(sfc.Appointment(
                    id: planShift.id,
                    resourceIds: planShift.userIds,
                    subject: '勤務予定',
                    startTime: planShift.startedAt,
                    endTime: planShift.endedAt,
                    isAllDay: planShift.allDay,
                    color: kBlueColor,
                    notes: 'planShift',
                  ));
                }
              }
            }
            return CustomCalendarShift(
              dataSource: _ShiftDataSource(source, resourceColl),
              onTap: (details) {},
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
