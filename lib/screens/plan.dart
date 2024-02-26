import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  List<sfc.Appointment> appointments = [];

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
        shape: const Border(
          bottom: BorderSide(color: kGrey600Color),
        ),
      ),
      body: sfc.SfCalendar(
        view: sfc.CalendarView.month,
        showNavigationArrow: true,
        showDatePickerButton: true,
        headerDateFormat: 'yyyy年MM月',
        onTap: (calendarTapDetails) {
          print(calendarTapDetails.date);
        },
        onViewChanged: (viewChangedDetails) {
          // print(viewChangedDetails.visibleDates);
        },
        monthViewSettings: const sfc.MonthViewSettings(
          appointmentDisplayMode: sfc.MonthAppointmentDisplayMode.appointment,
          monthCellStyle: sfc.MonthCellStyle(
            textStyle: TextStyle(fontSize: 16),
          ),
        ),
        cellBorderColor: kGrey600Color,
        dataSource: _DataSource(appointments),
      ),
    );
  }
}

class _DataSource extends sfc.CalendarDataSource {
  _DataSource(List<sfc.Appointment> source) {
    appointments = source;
  }
}
