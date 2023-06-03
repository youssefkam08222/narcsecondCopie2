
import 'dart:async';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File> getImageFile (context) async{
  File f=File("");
  FocusManager.instance.primaryFocus?.unfocus();
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0)), //this right here
          child: SizedBox(
            height: 150,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  const Text(
                    'Select Image From !',
                    style: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {

                          f = (await selectImageFromGallery())!;

                          if (f.path != '') {
                            final String imagePath = f.path;
                            final String imageType = imagePath.split('.').last.toLowerCase();

                            if (imageType == 'jpg' || imageType == 'jpeg' || imageType == 'png' || imageType == 'gif') {
                              print('Selected image is of type "image"');
                              Navigator.pop(context);
                            } else {
                              print('Selected file is not an image');
                            }
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("No Image Selected !"),
                            ));
                          }

                        },
                        child: Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/gallery.png',
                                    height: 60,
                                    width: 60,
                                  ),
                                  const Text('Gallery'),
                                ],
                              ),
                            )),
                      ),
                      GestureDetector(
                        onTap: () async {
                          f = (await selectImageFromCamera())!;
                          if (f.path != '') {
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("No Image Captured !"),
                            ));
                          }
                        },
                        child: Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.asset(
                                    'assets/images/camera.png',
                                    height: 60,
                                    width: 60,
                                  ),
                                  const Text('Camera'),
                                ],
                              ),
                            )),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      });
  return f;
}

Future<File?> selectImageFromGallery() async {
  XFile? file = await ImagePicker()
      .pickImage(source: ImageSource.gallery, imageQuality: 100);
  final File imageFile = File(file!.path);
  if (file != null) {
    final String imagePath = imageFile.path;
    final String imageType = imagePath.split('.').last.toLowerCase();

    if (imageType == 'jpg' || imageType == 'jpeg' || imageType == 'png' || imageType == 'gif')
    {
      print('Selected image is of type "image"');
      return imageFile;
    }
    else
    {
      print('Selected file is not an image');
      return null;
    }
  }
}

Future<File?> selectImageFromCamera() async {
  XFile? file = await ImagePicker()
      .pickImage(source: ImageSource.camera, imageQuality: 10);
  final File imageFile = File(file!.path);
  if (file != null) {
    final String imagePath = imageFile.path;
    final String imageType = imagePath.split('.').last.toLowerCase();

    if (imageType == 'jpg' || imageType == 'jpeg' || imageType == 'png' || imageType == 'gif')
    {
      print('Selected image is of type "image"');
      return imageFile;
    }
    else
    {
      print('Selected file is not an image');
      return null;
    }
  }
}