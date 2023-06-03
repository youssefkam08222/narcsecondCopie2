import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

Future showInfoDialog(BuildContext context) {

  return AwesomeDialog(
    context: context,
    animType: AnimType.scale,
    dialogType: DialogType.info,
    keyboardAware: true,
    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            'Form Data',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            height: 10,
          ),
          Material(
            elevation: 0,
            color: Colors.blueGrey.withAlpha(40),
            child: TextFormField(
              autofocus: true,
              minLines: 1,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Title',
                prefixIcon: Icon(Icons.text_fields),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Material(
            elevation: 0,
            color: Colors.blueGrey.withAlpha(40),
            child: TextFormField(
              onChanged: (value){
                /*setState(() {
                  word =value;
                });*/
              },
              autofocus: true,
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                labelText: 'Description',
                prefixIcon: Icon(Icons.text_fields),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          AnimatedButton(
            isFixedHeight: false,
            text: 'Close',
            pressEvent: () {
              Navigator.pop(context);

            },
          )
        ],
      ),
    ),
  ).show();

}
