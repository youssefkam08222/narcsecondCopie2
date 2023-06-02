

import 'package:flutter/material.dart';

Future<void> showInfoDialog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('A propos des documents !',style: TextStyle(color: Colors.indigo),),
        content:  SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text("C'est une partie optionnelle d'ou vous pouvez ajouter les images de vos documents." ,style: TextStyle(color: Colors.blueAccent),),
              SizedBox(height: 5,),
              Text("En faite, cela va vous aider a:\n",style: TextStyle(color: Colors.blue), ),
              Text("  - Avoir des copies sur vos documents en cas de les perdres" ,style: TextStyle(color: Colors.lightBlueAccent),),
              SizedBox(height: 5,),
              Text("  - L'application va vous envoyer des alertes a propos la date du paiements de vos papiers" ,style: TextStyle(color: Colors.lightBlueAccent),),
              SizedBox(height: 5,),
              Text("  - Presenter vos papiers en cas ou vous avez les oublier de les prendre" ,style: TextStyle(color: Colors.lightBlueAccent),),


            ],
          ),
        ),
        actions: <Widget>[
          Center(
            child:ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  side: const BorderSide(width: 2, color: Colors.black), backgroundColor: Colors.blueAccent,
                  padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 30)),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          )
        ],
      );
    },
  );
}