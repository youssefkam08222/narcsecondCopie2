import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:narcsecond/Models/voitureModel.dart';
import 'package:narcsecond/Views/AlertDialog/AfterActionAlertDialog.dart';

import '../../Services/voitureService.dart';
import '../VoitureView/VoitureMain.dart';

class ConfirmAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoitureModel voiture;
  final BuildContext voitureContext;
  final Icon icon;
  final List<Widget> actions;

  const ConfirmAlertDialog({
    required this.title,
    required this.content,
    required this.voiture,
    required this.voitureContext,
    required this.icon,

    this.actions = const [],
  });


  @override
  Widget build(BuildContext context) {
    return AlertDialog(

      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            icon,

      ],),

      content: Text(
        content,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () async {
              int status = await deleteVoiture(voiture,voitureContext);
              if(status==200){
                Navigator.push(context, MaterialPageRoute(builder: (context) => VoitureMain()));
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext dialogContext) {
                    return  AfterActionAlertDialog(
                      title: "Suppression",
                      content: "Votre voiture a été supprimer avec success !",
                      status:status,
                    );
                  },
                );
              }else{
                Navigator.pop(context);
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext dialogContext) {
                    return  AfterActionAlertDialog(
                        title: "Probleme du suppression",
                        content: "Réessayer plus tard !",
                      status:status,
                    );
                  },
                );


              }

              },
            child: const Text('Confirmer')
        ),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler')
        ),
      ],
    );
  }
}