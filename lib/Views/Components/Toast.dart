import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget toastM (String msg,Color color) {

  Widget toastMail = Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50.0),
      color: color,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children:   [
        const Icon(Icons.error_outline,size: 30,),
        const SizedBox(
          width: 12.0,
        ),
        /*Expanded(
          child: FittedBox(
            child: Text(
              msg+" aaaaaa aaa  vvvvv aaaa",
              style: const TextStyle(fontSize: 58),
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.fade,
            ),
          ),
        ),*/
        Expanded(
            child: Text(msg,style:
            const TextStyle(fontWeight: FontWeight.bold,fontSize: 15,),
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
            ),
        )

      ],
    ),
  );
  return toastMail;
}