import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class CustomCalendar extends StatelessWidget {
  final EventController<Object?> controller;
  final DateTime? initialMonth;
  final double cellAspectRatio;
  final Function(DateTime, int)? onPageChange;
  final Function(List<CalendarEventData<Object?>>, DateTime)? onCellTap;

  const CustomCalendar({
    required this.controller,
    required this.initialMonth,
    this.cellAspectRatio = 0.55,
    this.onPageChange,
    required this.onCellTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: controller,
      child: MonthView(
        borderColor: kBorderColor,
        controller: controller,
        initialMonth: initialMonth,
        cellAspectRatio: cellAspectRatio,
        headerBuilder: MonthHeader.hidden,
        weekDayBuilder: (day) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              kWeeks[day],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'SourceHanSansJP-Bold',
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
        onPageChange: onPageChange,
        onCellTap: onCellTap,
        startDay: WeekDays.sunday,
        hideDaysNotInMonth: true,
      ),
    );
  }
}
