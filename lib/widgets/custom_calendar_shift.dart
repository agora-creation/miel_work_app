import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class CustomCalendarShift extends StatelessWidget {
  final sfc.CalendarDataSource<Object?>? dataSource;
  final Function(sfc.CalendarTapDetails)? onTap;

  const CustomCalendarShift({
    required this.dataSource,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return sfc.SfCalendar(
      dataSource: dataSource,
      view: sfc.CalendarView.timelineMonth,
      showNavigationArrow: true,
      showDatePickerButton: true,
      headerDateFormat: 'yyyy年MM月',
      onTap: onTap,
      resourceViewSettings: const sfc.ResourceViewSettings(
        visibleResourceCount: 5,
        showAvatar: false,
        displayNameTextStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      cellBorderColor: kGrey600Color,
    );
  }
}
