import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:narcsecond/Views/VoitureView/RegisterVoiture.dart';

import '../VoitureView/DetailVoiture.dart';
import '../VoitureView/VoitureMain.dart';
import 'ConfirmAlertDialog.dart';

class AfterActionAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final int status;
  final List<Widget> actions;

  const AfterActionAlertDialog({
    required this.title,
    required this.content,
    required this.status,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Text(

        content,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () {


              if (status==200){
                Navigator.push(context, MaterialPageRoute(builder: (context) => VoitureMain()));
              }else {
                Navigator.pop(context);
              }


            },
            child: const Text('OK'))
      ],
    );
  }
}