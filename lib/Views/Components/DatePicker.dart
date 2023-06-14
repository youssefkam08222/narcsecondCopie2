import 'package:flutter/material.dart';

Future<DateTime?> showDatePickerDialog(DateTime initial, BuildContext context) async {
  final initialDate = initial;
  final newDate = await showDatePicker(
    locale: const Locale("fr", "FR"),
    context: context,
    initialDate: initialDate,
    cancelText: 'Annuler',
    confirmText: 'Confirmer',
    initialEntryMode: DatePickerEntryMode.calendarOnly,
    //helpText: '',
    firstDate: DateTime(DateTime.now().year - 10),
    lastDate: DateTime(DateTime.now().year + 1),
    builder: (context, child) => Theme(
      data: ThemeData().copyWith(
        colorScheme: const ColorScheme.light(
          primary: Colors.lightBlueAccent,
          onPrimary: Colors.white,
          onSurface: Colors.black,
        ),
        dialogBackgroundColor: Colors.white,
      ),

      child:SizedBox(
        width: 150,
        height: 150,
        child: child ?? const Text(''),
      )
    ),
  );

  return newDate;
}
