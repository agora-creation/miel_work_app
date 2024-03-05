import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/providers/home.dart';
import 'package:miel_work_app/providers/login.dart';
import 'package:miel_work_app/screens/category.dart';
import 'package:miel_work_app/screens/plan_timeline.dart';
import 'package:miel_work_app/services/plan.dart';
import 'package:miel_work_app/widgets/custom_calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class PlanScreen extends StatefulWidget {
  final LoginProvider loginProvider;
  final HomeProvider homeProvider;

  const PlanScreen({
    required this.loginProvider,
    required this.homeProvider,
    super.key,
  });

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  PlanService planService = PlanService();

  void _calendarTap(sfc.CalendarTapDetails details) {
    showBottomUpScreen(
      context,
      const PlanTimelineScreen(),
    );
    sfc.CalendarElement element = details.targetElement;
    switch (element) {
      case sfc.CalendarElement.appointment:
      case sfc.CalendarElement.agenda:
        sfc.Appointment appointmentDetails = details.appointments![0];
        // showBottomUpScreen(
        //   context,
        //   PlanModScreen(
        //     loginProvider: widget.loginProvider,
        //     homeProvider: widget.homeProvider,
        //     planId: '${appointmentDetails.id}',
        //   ),
        // );
        break;
      case sfc.CalendarElement.calendarCell:
        // showBottomUpScreen(
        //   context,
        //   PlanAddScreen(
        //     loginProvider: widget.loginProvider,
        //     homeProvider: widget.homeProvider,
        //     date: details.date ?? DateTime.now(),
        //   ),
        // );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'スケジュールカレンダー',
          style: TextStyle(color: kBlackColor),
        ),
        actions: [
          IconButton(
            onPressed: () => pushReplacementScreen(
              context,
              CategoryScreen(organization: widget.loginProvider.organization),
            ),
            icon: const Icon(Icons.settings),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: kGrey600Color)),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: planService.streamList(
            organizationId: widget.loginProvider.organization?.id,
          ),
          builder: (context, snapshot) {
            List<sfc.Appointment> appointments = [];
            if (snapshot.hasData) {
              appointments = planService.generateList(
                data: snapshot.data,
                currentGroup: widget.homeProvider.currentGroup,
              );
            }
            return CustomCalendar(
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
