import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

Future errorAlertDialog(String title, String desc,BuildContext context) {
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.error,
    animType: AnimType.rightSlide,
    headerAnimationLoop: true,
    title: title,
    desc:
    desc,
    btnOkOnPress: () {},
    btnOkIcon: Icons.cancel,
    btnOkColor: Colors.red,
  ).show();

}
