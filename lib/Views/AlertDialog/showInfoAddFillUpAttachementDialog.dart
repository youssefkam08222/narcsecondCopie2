import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

Future showInfoAddFillUpAttachementDialog(BuildContext context) {
  return AwesomeDialog(
    context: context,
    dialogType: DialogType.infoReverse,
    headerAnimationLoop: true,
    animType: AnimType.bottomSlide,
    title: 'A propos des documents !',
    reverseBtnOrder: true,
    btnOkOnPress: () {},
    barrierColor: Colors.blueGrey.withOpacity(0.7),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "C'est une partie optionnelle où vous pouvez ajouter un fichier join comme une photo.",
          style: TextStyle(color: Colors.blueGrey),
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
        Padding(
          padding: const EdgeInsets.only(right: 25.0,left: 25),
          child: RichText(
            text: const TextSpan(
              text: "- ",
              style: TextStyle(color: Colors.brown),
              children: [
                TextSpan(
                  text: "Avoir des copies de vos fichiers joints en cas de perte",
                ),
              ],
            ),
            textAlign: TextAlign.justify,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(right: 25.0,left: 25),
          child: RichText(
            text: const TextSpan(
              text: "- ",
              style: TextStyle(color: Colors.brown),
              children: [
                TextSpan(
                  text: "Telecharger vos fichiers joint a partir de l'application",
                ),
              ],
            ),
            textAlign: TextAlign.justify,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(right: 25.0,left: 25),
          child: RichText(
            text: const TextSpan(
              text: "- ",
              style: TextStyle(color: Colors.brown),
              children: [
                TextSpan(
                  text: "Verification du montant en cas d'une erreur de saisie",
                ),
              ],
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    ),
  ).show();

}
