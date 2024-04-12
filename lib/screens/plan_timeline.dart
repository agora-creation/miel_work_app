import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/plan_add.dart';
import 'package:miel_work_app/screens/plan_mod.dart';
import 'package:miel_work_app/services/config.dart';
import 'package:miel_work_app/services/plan.dart';
import 'package:miel_work_app/widgets/custom_calendar_timeline.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class PlanTimelineScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;
  final DateTime date;

  const PlanTimelineScreen({
    required this.loginProvider,
    required this.homeProvider,
    required this.date,
    super.key,
  });

  @override
  State<PlanTimelineScreen> createState() => _PlanTimelineScreenState();
}

class _PlanTimelineScreenState extends State<PlanTimelineScreen> {
  PlanService planService = PlanService();
  List<String> searchCategories = [];

  void _init() async {
    await ConfigService().checkReview();
  }

  void _searchCategoriesChange() async {
    searchCategories = await getPrefsList('categories') ?? [];
    setState(() {});
  }

  void _calendarTap(sfc.CalendarTapDetails details) {
    sfc.CalendarElement element = details.targetElement;
    switch (element) {
      case sfc.CalendarElement.appointment:
      case sfc.CalendarElement.agenda:
        sfc.Appointment appointmentDetails = details.appointments![0];
        pushScreen(
          context,
          PlanModScreen(
            loginProvider: widget.loginProvider,
            homeProvider: widget.homeProvider,
            planId: '${appointmentDetails.id}',
          ),
        );
        break;
      case sfc.CalendarElement.calendarCell:
        pushScreen(
          context,
          PlanAddScreen(
            loginProvider: widget.loginProvider,
            homeProvider: widget.homeProvider,
            date: details.date ?? DateTime.now(),
          ),
        );
        break;
      default:
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    _searchCategoriesChange();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        automaticallyImplyLeading: false,
        title: Text(
          dateText('yyyy年MM月dd日(E)', widget.date),
          style: const TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: kBlackColor,
            ),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: planService.streamListDate(
            organizationId: widget.loginProvider.organization?.id,
            date: widget.date,
            categories: searchCategories,
          ),
          builder: (context, snapshot) {
            List<sfc.Appointment> appointments = [];
            if (snapshot.hasData) {
              appointments = planService.generateListAppointment(
                data: snapshot.data,
                currentGroup: widget.homeProvider.currentGroup,
              );
            }
            return CustomCalendarTimeline(
              initialDisplayDate: widget.date,
              dataSource: _DataSource(appointments),
              onTap: _calendarTap,
            );
          },
        ),
      ),
    );
  }
}

class _DataSource extends sfc.CalendarDataSource {
  _DataSource(List<sfc.Appointment> source) {
    appointments = source;
  }
}
