import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class CustomCalendarTimeline extends StatelessWidget {
  final DateTime initialDisplayDate;
  final sfc.CalendarDataSource<Object?>? dataSource;
  final Function(sfc.CalendarTapDetails)? onTap;

  const CustomCalendarTimeline({
    required this.initialDisplayDate,
    required this.dataSource,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return sfc.SfCalendar(
      headerHeight: 0,
      viewHeaderHeight: 0,
      viewNavigationMode: sfc.ViewNavigationMode.none,
      initialDisplayDate: initialDisplayDate,
      dataSource: dataSource,
      view: sfc.CalendarView.day,
      onTap: onTap,
      cellBorderColor: kGrey600Color,
      appointmentTextStyle: const TextStyle(
        color: kWhiteColor,
        fontSize: 14,
      ),
      timeSlotViewSettings: sfc.TimeSlotViewSettings(
        timeIntervalHeight: 50,
        timelineAppointmentHeight: 50,
        timeTextStyle: TextStyle(fontSize: 14),
        timeInterval: Duration(minutes: 30),
        timeFormat: 'h:mm',
      ),
    );
  }
}
