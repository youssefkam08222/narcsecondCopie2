import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

Future successAlertDialog(String title, String desc,BuildContext context) {
  return AwesomeDialog(
    context: context,
    animType: AnimType.leftSlide,
    headerAnimationLoop: false,
    dialogType: DialogType.success,
    showCloseIcon: true,
    title: title,
    titleTextStyle: TextStyle(),
    alignment: Alignment.center,
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        desc,
        textAlign: TextAlign.justify,
        style: const TextStyle(),
      ),
    ),
    btnOkOnPress: () {
    },
    autoHide: const Duration(seconds: 5),
    btnOkIcon: Icons.check_circle,
    onDismissCallback: (type) {
      debugPrint('Dialog Dissmiss from callback $type');
    },
  ).show();

}
