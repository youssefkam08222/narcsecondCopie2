

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart' as pathProvider;
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../Globals/globals.dart';
import 'Toast.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  Future<Directory?>? getSaveDirectory() {
    if (Platform.isAndroid) {
      return getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      return getApplicationDocumentsDirectory();
    }
    return null;
  }

  const FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              onPressed: () async{
                List<String> segments = imageUrl.split('/');
                String lastSegment = segments.last;
                List<String> nameSegments = lastSegment.split('?');
                String imageName = nameSegments.first;

                  //final String fileName= DateTime.now().microsecondsSinceEpoch.toString();
                  Directory? saveDir = await getSaveDirectory();
                  String savePath = '${saveDir?.path}/image.jpeg';


                  final response = await await Dio().get(imageUrl,
                      options: Options(responseType: ResponseType.bytes));
                  final File file = File(savePath);
                  await file.writeAsBytes(response.data);

                await GallerySaver.saveImage(imageUrl,albumName: "Narc Images").then((success){
                  Navigator.pop(context);
                  if(success != null && success){
                    fToast.showToast(
                      child: toastM(
                          "L'image est enregistrer avec success !",Colors.green),
                      gravity:
                      ToastGravity
                          .BOTTOM,
                      toastDuration:
                      const Duration(
                          seconds:
                          2),
                    );
                  }else{
                    fToast.showToast(
                      child: toastM(
                          "L'image n'est enregistré!",Colors.green),
                      gravity:
                      ToastGravity
                          .BOTTOM,
                      toastDuration:
                      const Duration(
                          seconds:
                          2),
                    );
                  }
                });


                  //final filePath='${directory.path}/$fileName.png';
                  print("saved ="+imageName);

                  /*Navigator.pop(context);
                  fToast.showToast(
                    child: toastM(
                        "L'image est enregistrer avec success !",Colors.green),
                    gravity:
                    ToastGravity
                        .BOTTOM,
                    toastDuration:
                    const Duration(
                        seconds:
                        2),
                  );*/
              }
              , icon: const Icon(Icons.download),
          ),

        ],
        // Customize the app bar as needed
        // You can add buttons, titles, etc.
        // Here, I'm just displaying a close button
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: InteractiveViewer(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain, // Adjust the image to fit within the container
            ),
          ),
        ),
      ),
    );
  }
}
/*
await GallerySaver.saveImage(tempFile.path,albumName: "Narc Images").then((success){
                  Navigator.pop(context);
                  if(success != null && success){
                    fToast.showToast(
                      child: toastM(
                          "L'image est enregistrer avec success !",Colors.green),
                      gravity:
                      ToastGravity
                          .BOTTOM,
                      toastDuration:
                      const Duration(
                          seconds:
                          2),
                    );
                  }
                });
 */