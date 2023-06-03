import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

Future<bool?> confirmAlertDialog(String title, String desc, BuildContext context) async {
  final result = await AwesomeDialog(
    context: context,
    keyboardAware: true,
    dismissOnBackKeyPress: false,
    dialogType: DialogType.warning,
    animType: AnimType.bottomSlide,
    btnCancelText: "Annuler",
    btnOkText: "Confirmer",
    title: title,
    desc: desc,
    btnCancelOnPress: () {},
    btnOkOnPress: () {},
  ).show();

  // Return the result of the dialog
  return result;
}
