import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';
import 'package:miel_work_app/widgets/plan_work_list.dart';

class CustomCalendar extends StatelessWidget {
  final EventController<Object?> controller;
  final GlobalKey<MonthViewState> globalKey;
  final DateTime? initialMonth;
  final double cellAspectRatio;
  final Function(DateTime, int)? onPageChange;
  final Function(List<CalendarEventData<Object?>>, DateTime)? onCellTap;

  const CustomCalendar({
    required this.controller,
    required this.globalKey,
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
        key: globalKey,
        borderColor: kBorderColor,
        cellBuilder: (day, events, isToday, isInMonth, isInYear) {
          if (!isInMonth) {
            return Container(color: kGreyColor.withOpacity(0.2));
          }
          return Container(
            decoration: isToday
                ? BoxDecoration(
                    border: Border.all(
                      color: kLightBlueColor,
                      width: 2,
                    ),
                  )
                : null,
            padding: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(dateText('dd', day)),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: events.map((event) {
                        return const PlanWorkList('予定あり');
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
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
