import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../Models/firebase_file.dart';

class FirebaseApi {
  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<FirebaseFile>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
      final ref = result.items[index];
      final name = ref.name;
      final file = FirebaseFile(ref: ref, name: name, url: url);


      return MapEntry(index, file);
    })
        .values
        .toList();
  }

  static Future downloadFile(Reference ref) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/${ref.name}');

    await ref.writeToFile(file);
  }

  static Future<void> moveFolderContent(String sourceFolder, String destinationFolder) async {
    final Reference sourceRef = FirebaseStorage.instance.ref().child(sourceFolder);
    final Reference destinationRef = FirebaseStorage.instance.ref().child(destinationFolder);

    final ListResult listResult = await sourceRef.listAll();

    await Future.forEach(listResult.items, (Reference item) async {
      final String itemName = item.name;
      //final String itemPath = item.fullPath;

      final String downloadURL = await item.getDownloadURL();
      final http.Response response = await http.get(Uri.parse(downloadURL));

      if (response.statusCode == 200) {
        final String tempFilePath = '${Directory.systemTemp.path}/$itemName';
        final File tempFile = File(tempFilePath);
        await tempFile.writeAsBytes(response.bodyBytes);

        final Reference destinationItemRef = destinationRef.child(itemName);
        final UploadTask uploadTask = destinationItemRef.putFile(tempFile);
        await uploadTask;

        // Delete the source item after moving
        await item.delete();
      }
    });
  }

  static
  Future<void> deleteFolder(String folderPath) async {
    final Reference folderRef = FirebaseStorage.instance.ref().child(folderPath);
    final ListResult listResult = await folderRef.listAll();

    // Delete all items within the folder and its subfolders
    await Future.forEach(listResult.items, (Reference item) async {
      if (item.fullPath.endsWith('/')) {
        // It's a subfolder
        await deleteFolder(item.fullPath);
      } else {
        // It's a file
        await item.delete();
      }
    });

    // Delete the folder itself
    await folderRef.delete();
  }

  static Future<String?> firebaseUploadImage(File file,String imageName,String directoryName) async {
    String imageUrl="";
    Firebase.initializeApp();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child(directoryName);
    String filename = imageName;
    Reference referenceImageToUpload = referenceDirImages.child(filename);
    try{
      await referenceImageToUpload.putFile(File(file.path));
      imageUrl= await referenceImageToUpload.getDownloadURL();

    }catch(error){
      "error";
    }
    return imageUrl;
  }

  static Future<String?> firebaseDeleteImage(String imageName,String directoryName) async {
    String imageUrl="";
    Firebase.initializeApp();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child(directoryName);
    String filename = imageName;
    Reference referenceImageToUpload = referenceDirImages.child(filename);
    try{
      await referenceImageToUpload.delete();


    }catch(error){
      "error";
    }
    return imageUrl;
  }

}