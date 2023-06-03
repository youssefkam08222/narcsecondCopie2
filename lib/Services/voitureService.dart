import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';
import 'package:narcsecond/Views/AlertDialog/SuccessAlertDialog.dart';
import '../Globals/globals.dart';
import '../Models/voitureModel.dart';
import '../Views/AlertDialog/ErrorAlertDialog.dart';
import '../Views/VoitureView/DetailVoiture.dart';
import '../Views/VoitureView/VoitureMain.dart';
import 'firebase_api.dart';

Future<List<VoitureModel>> getAllVoituresfromDB() async {
  var data = await http.get(Uri.parse("$url/voitures/all"));
  var myData = utf8.decode(data.bodyBytes);
  var jsonData = jsonDecode(myData);
  List<VoitureModel> voitures = [];
  try {
    for (var v in jsonData) {
      VoitureModel voiture = VoitureModel(voitureId: v["voitureId"], imgVoitureUrl: v["imgVoitureUrl"], voitureMake: v["voitureMake"],
        voitureMakeYear: v["voitureMakeYear"], voitureModele: v["voitureModele"], voitureTypeSerie: v["voitureTypeSerie"],
        voitureSerie: v["voitureSerie"], voitureCarburant: v["voitureCarburant"], voitureKilometrage: v["voitureKilometrage"],
        voitureNotes: v["voitureNotes"], imgFaceCarteGriseUrl: v["imgFaceCarteGriseUrl"], imgDosCarteGriseUrl: v["imgDosCarteGriseUrl"],
        imgAssuranceUrl: v["imgAssuranceUrl"], imgTaxUrl: v["imgTaxUrl"], imgVisiteUrl: v["imgVisiteUrl"],
      );
      voitures.add(voiture);
    }
  } catch (e) {
    print("error creating model: $e");
  }
  return voitures;
}

Future<String> registerVoitures(String imgVoitureUrl, String voitureMake, String voitureMakeYear, String voitureModele, String voitureTypeSerie,
    String voitureSerie, String voitureCarburant, int voitureKilometrage, String voitureNotes, String imgFaceCarteGriseUrl,
    String imgDosCarteGriseUrl, String imgAssuranceUrl, String imgTaxUrl, String imgVisiteUrl,
    BuildContext context) async {
  try {
    var res = await http.post(Uri.parse("$url/voitures/create"),
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, dynamic>{
          "imgVoitureUrl": imgVoitureUrl, "voitureMake": voitureMake, "voitureMakeYear": voitureMakeYear,
          "voitureModele": voitureModele, "voitureTypeSerie": voitureTypeSerie, "voitureSerie": voitureSerie,
          "voitureCarburant": voitureCarburant, "voitureKilometrage": voitureKilometrage,
          "voitureNotes": voitureNotes, "imgFaceCarteGriseUrl": imgFaceCarteGriseUrl, "imgDosCarteGriseUrl": imgDosCarteGriseUrl,
          "imgAssuranceUrl": imgAssuranceUrl, "imgTaxUrl": imgTaxUrl, "imgVisiteUrl": imgVisiteUrl
        }));
    if (res.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => VoitureMain()));
      await successAlertDialog("Ajout d'une nouvelle voiture", "Votre nouvelle voiture a été enregistrer avec success !", context);
    } else {
      errorAlertDialog("Un problème est survenu", "Réessayer plus tard !", context);
    }
  }catch(error) {
    if (error is TimeoutException) {
      errorAlertDialog("Erreur de connexion", "Temps de connexion dépassé.", context);
    } else {
      errorAlertDialog("Un problème est survenu", "Réessayez plus tard!", context);
    }
  }
  return "Unable to RegisterVoitures.";
}


deleteVoiture (VoitureModel voiture,BuildContext context)  async {
  /*voiture.imgFaceCarteGriseUrl= (voiture.imgFaceCarteGriseUrl.isNotEmpty ?  await firebaseDeleteImage("ImageFaceCarteGrise.jpeg", "${voiture.voitureSerie}${voiture.voitureTypeSerie}/documents") :"")!;
  voiture.imgDosCarteGriseUrl= (voiture.imgDosCarteGriseUrl.isNotEmpty ?  await firebaseDeleteImage("ImageDosCarteGrise.jpeg", "${voiture.voitureSerie}${voiture.voitureTypeSerie}/documents") :"")!;
  voiture.imgAssuranceUrl= (voiture.imgAssuranceUrl.isNotEmpty ?  await firebaseDeleteImage("ImageAssurance.jpeg", "${voiture.voitureSerie}${voiture.voitureTypeSerie}/documents") :"")!;
  voiture.imgTaxUrl= (voiture.imgTaxUrl.isNotEmpty ?  await firebaseDeleteImage("ImageTax.jpeg", "${voiture.voitureSerie}${voiture.voitureTypeSerie}/documents") :"")!;
  voiture.imgVisiteUrl= (voiture.imgVisiteUrl.isNotEmpty ?  await firebaseDeleteImage("ImageVisite.jpeg", "${voiture.voitureSerie}${voiture.voitureTypeSerie}/documents") :"")!;
  voiture.imgVoitureUrl= (voiture.imgVoitureUrl.isNotEmpty ?  await firebaseDeleteImage("ImageVoiture.jpeg", "${voiture.voitureSerie}${voiture.voitureTypeSerie}") :"")!;
  */
  try {
    final request = http.Request("DELETE", Uri.parse("$url/voitures/delete/${voiture.voitureId}"));
    request.headers.addAll(<String, String>{"Content-Type": "application/json"});
    request.body=jsonEncode(voiture.voitureId);
    final response = await request.send();
    if (response.statusCode == 200) {
      await FirebaseApi.deleteFolder("${voiture.voitureSerie}${voiture.voitureTypeSerie}/documents");
      await FirebaseApi.deleteFolder("${voiture.voitureSerie}${voiture.voitureTypeSerie}");
      Navigator.push(context, MaterialPageRoute(builder: (context) => VoitureMain()));
      await successAlertDialog("Suppression du voiture", "Votre voiture a été supprimer avec success !", context);
    } else {
      errorAlertDialog(
          "Un problème est survenu", "Réessayer plus tard !", context);
    }
  } on Exception catch (error) {
    if (error is TimeoutException) {
      errorAlertDialog(
          "Erreur de connexion", "Temps de connexion dépassé.", context);
    } else {
      errorAlertDialog(
          "Un problème est survenu", "Réessayez plus tard!", context);
    }
  }

}

updateVoitureById(VoitureModel voiture, BuildContext context) async {
  var Url = "$url/voitures/update/${voiture.voitureId}";
  try {
    var response = await http.put(Uri.parse(Url),
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(voiture));
    if (response.statusCode == 200) {
      var myData = utf8.decode(response.bodyBytes);
      var v = jsonDecode(myData);
      VoitureModel voiture = VoitureModel(voitureId: v["voitureId"],
        imgVoitureUrl: v["imgVoitureUrl"], voitureMake: v["voitureMake"], voitureMakeYear: v["voitureMakeYear"],
        voitureModele: v["voitureModele"], voitureTypeSerie: v["voitureTypeSerie"], voitureSerie: v["voitureSerie"],
        voitureCarburant: v["voitureCarburant"], voitureKilometrage: v["voitureKilometrage"], voitureNotes: v["voitureNotes"],
        imgFaceCarteGriseUrl: v["imgFaceCarteGriseUrl"], imgDosCarteGriseUrl: v["imgDosCarteGriseUrl"],
        imgAssuranceUrl: v["imgAssuranceUrl"], imgTaxUrl: v["imgTaxUrl"], imgVisiteUrl: v["imgVisiteUrl"],
      );
      if (response.statusCode == 200) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailVoiture(voiture)));
        await successAlertDialog("Modification voiture", "Votre voiture a été modifier avec success !", context);
      } else {
        errorAlertDialog(
            "Un problème est survenu", "Réessayer plus tard !", context);
      }
    }
    } catch (error) {
    if (error is TimeoutException) {
      errorAlertDialog(
          "Erreur de connexion", "Temps de connexion dépassé.", context);
    } else {
      errorAlertDialog(
          "Un problème est survenu", "Réessayez plus tard!", context);
    }
  }



}

Future<bool> checkVoitureSerie(String voitureTypeSerie, String voitureSerie) async {
  String encodedWord = Uri.encodeComponent(voitureTypeSerie);
  var Url = "$url/voitures/checkvoitureserie/$encodedWord/$voitureSerie";
  var data = await http.get(Uri.parse(Url));
  var jsonData=jsonDecode(data.body);
  if(jsonData is bool){
    return (jsonData);
  }else {
    throw Exception('invalid response: $jsonData');
  }
}

Future<List<String>> getAllMakes () async {
  var Url = "$url/make/all";
  var data = await http.get(Uri.parse(Url));
  return (jsonDecode(data.body)as List<dynamic>).cast<String>();
}
Future<List<String>> getAllMakeyears (MakeValue) async {
  var Url = "$url/make/allmakeyearbymakename/$MakeValue";
  var data = await http.get(Uri.parse(Url));
  return (jsonDecode(data.body)as List<dynamic>).cast<String>();
}
Future<List<String>> getAllModels (MakeValue,MakeYearValue) async {
  var Url = "$url/make/allcarmodelbymakeyearandmakename/$MakeValue/$MakeYearValue";
  var data = await http.get(Uri.parse(Url));
  return (jsonDecode(data.body)as List<dynamic>).cast<String>();

}


// these methods below are not used
getFileById(String id) async {
  var Url = "http://$url/file/getfile/$id";
  var data = await http.get(Uri.parse(Url));
  var jsonData = data.body;
  return jsonData.toString();
}

Future<String?> registerFile(File file, BuildContext context) async {
  String fileName = file.path.split('/').last;
  print(file.path);
  FormData formData = FormData.fromMap({
    "file": await MultipartFile.fromFile(file.path,
        filename: fileName, contentType: MediaType('file', 'jpg')),
    "type": "image/jpg"
  });

  Dio dio = new Dio();

  Response response = await dio.post("http://$url/file/upload",
      data: formData,
      options: Options(
        headers: {"accept": "*/*", "Content-Type": "multipart/form-data"},
      ));
  if (response.statusCode == 200) {
    print("Uploaded" + response.toString());

    return response.toString();
  }
  return "errer";
}


