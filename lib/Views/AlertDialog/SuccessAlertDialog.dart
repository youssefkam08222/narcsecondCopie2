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
    desc:desc,
    btnOkOnPress: () {
      Navigator.pop(context);
    },
    autoHide: const Duration(seconds: 10),
    btnOkIcon: Icons.check_circle,
    onDismissCallback: (type) {
      debugPrint('Dialog Dissmiss from callback $type');
    },
  ).show();

}
