import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

bool result=false;
 confirmAlertDialog(String title, String desc, BuildContext context) async {

    await AwesomeDialog(
    context: context,
    keyboardAware: true,
    dismissOnBackKeyPress: false,
    dialogType: DialogType.warning,
    animType: AnimType.bottomSlide,
    btnCancelText: "Annuler",
    btnOkText: "Confirmer",
    title: title,
    desc: desc,
    btnCancelOnPress: () {
      result = false;
    },
    btnOkOnPress: () {
      result=true;
    },
  ).show();

  // Return the result of the dialog
  return result;
}
