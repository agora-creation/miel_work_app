import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as sfc;

class CustomCalendar extends StatelessWidget {
  final sfc.CalendarDataSource<Object?>? dataSource;
  final Function(sfc.CalendarLongPressDetails)? onLongPress;
  final sfc.CalendarController controller;

  const CustomCalendar({
    required this.dataSource,
    required this.onLongPress,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return sfc.SfCalendar(
      headerStyle: const sfc.CalendarHeaderStyle(
        backgroundColor: kWhiteColor,
      ),
      dataSource: dataSource,
      view: sfc.CalendarView.month,
      showNavigationArrow: true,
      showDatePickerButton: true,
      headerDateFormat: 'yyyy年MM月',
      onLongPress: onLongPress,
      controller: controller,
      monthViewSettings: const sfc.MonthViewSettings(
        showAgenda: true,
        monthCellStyle: sfc.MonthCellStyle(
          textStyle: TextStyle(fontSize: 20),
        ),
        agendaItemHeight: 50,
        agendaStyle: sfc.AgendaStyle(
          appointmentTextStyle: TextStyle(fontSize: 16),
          dayTextStyle: TextStyle(fontSize: 20),
        ),
      ),
      cellBorderColor: kGrey600Color,
    );
  }
}
