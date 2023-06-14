import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

Future<DateTime?> showDatePicker2Dialog(DateTime initial, BuildContext context) async {
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [
    DateTime.now(),
  ];
  DateTime? selectedDate;
  Size screenSize = MediaQuery.of(context).size;
  double dialogWidth = screenSize.width * 0.8;
  double dialogHeight = 0;
  DateTime? _getValueText(

      List<DateTime?> values,
      ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    //var valueText = (values.isNotEmpty ? values[0] : null).toString();

    return values[0] ?? DateTime.now();
  }

    final config = CalendarDatePicker2WithActionButtonsConfig(
      selectedDayHighlightColor: Colors.lightBlueAccent,
      //weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      firstDayOfWeek: 1,
      controlsHeight: 50,
      controlsTextStyle: const TextStyle(
        color: Colors.blue,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),

      dayTextStyle: const TextStyle(
        color: Colors.indigo,
        fontWeight: FontWeight.bold,
      ),
      disabledDayTextStyle: const TextStyle(
        color: Colors.grey,
      ),
      selectableDayPredicate: (day) => !day.difference(DateTime.now().subtract(const Duration(days: 900))).isNegative,
      //calendarViewMode: DatePickerMode.year

    );
  var results = await showCalendarDatePicker2Dialog(
    context: context,
    config: config,
    dialogSize:  Size(dialogWidth, dialogHeight),
    value: _singleDatePickerValueWithDefaultValue,
    borderRadius: BorderRadius.circular(15),

  );
  selectedDate = _getValueText(

     results!,
  ) ;
return selectedDate;
}
