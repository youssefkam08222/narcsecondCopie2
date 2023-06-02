import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:narcsecond/Models/voitureModel.dart';
import '../VoitureView/DetailVoiture.dart';
import 'AfterActionAlertDialog.dart';

class AfterUpdateAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final int status;
  final VoitureModel voiture;
  final List<Widget> actions;

  const AfterUpdateAlertDialog({
    required this.title,
    required this.content,
    required this.status,
    required this.voiture,
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailVoiture(voiture)));
              }else {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext dialogContext) {
                    return  AfterActionAlertDialog(
                      title: "Probleme du mise a jour",
                      content: "Réessayer plus tard !",
                      status:status,
                    );
                  },
                );
              }
            },
            child: const Text('OK'))
      ],
    );
  }
}