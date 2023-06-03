import 'package:flutter/cupertino.dart';
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
      const Icon(
        Icons.add_a_photo_outlined,
        size: 50,
        color: Colors.black,
      ),
    ],
  );
}