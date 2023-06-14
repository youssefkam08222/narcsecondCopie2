import 'package:flutter/material.dart';

Widget buildImageWithAddIcon(String imagePath) {
  return Stack(
    alignment: Alignment.center,
    children: [
      Ink.image(
        image: AssetImage(imagePath),
        height: 100,
        width: double.infinity,
        fit: BoxFit.fill,
      ),
       Image.asset(
         'assets/images/cameragif.gif',
        colorBlendMode: BlendMode.dstIn,
        width: 50,
        height: 50,
        color: Colors.white,
      ),
    ],
  );
}