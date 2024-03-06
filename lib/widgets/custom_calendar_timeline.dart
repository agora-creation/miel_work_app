import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class CustomCalendarTimeline extends StatelessWidget {
  final sfc.CalendarDataSource<Object?>? dataSource;
  final Function(sfc.CalendarTapDetails)? onTap;

  const CustomCalendarTimeline({
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
      dataSource: dataSource,
      view: sfc.CalendarView.day,
      onTap: onTap,
      cellBorderColor: kGrey600Color,
    );
  }
}
