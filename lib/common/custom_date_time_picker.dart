import 'package:flutter/material.dart';
import 'package:miel_work_app/common/functions.dart';
import 'package:miel_work_app/common/style.dart';

class CustomDateTimePicker {
  Future<DateTime> showDateChange({
    required BuildContext context,
    required DateTime value,
  }) async {
    DateTime ret = value;
    final selected = await showDatePicker(
      context: context,
      initialDate: value,
      firstDate: kFirstDate,
      lastDate: kLastDate,
    );
    if (selected != null) {
      ret = rebuildDate(selected, ret);
    }
    return ret;
  }

  Future<DateTime> showTimeChange({
    required BuildContext context,
    required DateTime value,
  }) async {
    DateTime ret = value;
    String initTime = dateText('HH:mm', value);
    List<String> hourMinute = initTime.split(':');
    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(hourMinute.first),
        minute: int.parse(hourMinute.last),
      ),
    );
    if (selected != null) {
      String selectedTime = selected.format(context);
      ret = rebuildTime(context, value, selectedTime);
    }
    return ret;
  }
}
