import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

Future showInfoDialog(BuildContext context) {
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.infoReverse,
    headerAnimationLoop: true,
    animType: AnimType.bottomSlide,
    title: 'A propos des documents !',
    reverseBtnOrder: true,
    btnOkOnPress: () {},
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "C'est une partie optionnelle où vous pouvez ajouter les images de vos documents.",
          style: TextStyle(color: Colors.blueAccent),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.only(left: 16), // Add padding to the left
          child: Text(
            "En fait, cela va vous aider à:",
            style: TextStyle(color: Colors.black),
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          text: const TextSpan(
            text: "- ",
            style: TextStyle(color: Colors.lightBlueAccent),
            children: [
              TextSpan(
                text: "Avoir des copies de vos documents en cas de perte",
              ),
            ],
          ),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 10),
        RichText(
          text: const TextSpan(
            text: "- ",
            style: TextStyle(color: Colors.lightBlueAccent),
            children: [
              TextSpan(
                text: "Recevoir des alertes concernant la date de paiement de vos papiers",
              ),
            ],
          ),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(height: 10),
        RichText(
          text: const TextSpan(
            text: "- ",
            style: TextStyle(color: Colors.lightBlueAccent),
            children: [
              TextSpan(
                text: "Présenter vos papiers en cas d'oubli",
              ),
            ],
          ),
          textAlign: TextAlign.justify,
        ),
      ],
    ),
  ).show();

}
