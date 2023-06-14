import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:narcsecond/Views/AlertDialog/SuccessAlertDialog.dart';
import 'package:narcsecond/Views/VoitureView/CarburantDetail.dart';
import '../Globals/globals.dart';
import '../Models/fillUpModel.dart';
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
        imgAssuranceUrl: v["imgAssuranceUrl"], imgTaxUrl: v["imgTaxUrl"], imgVisiteUrl: v["imgVisiteUrl"]
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
          "imgAssuranceUrl": imgAssuranceUrl, "imgTaxUrl": imgTaxUrl, "imgVisiteUrl": imgVisiteUrl,"voitureFillUps": []
        }));
    if (res.statusCode == 200) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => VoitureMain()));
      await successAlertDialog("Ajout d'une nouvelle voiture", "Votre nouvelle voiture a été enregistrer avec success !", context);
      return "Success to RegisterVoitures.";
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
Future<String> deleteVoiture (VoitureModel voiture,BuildContext context)  async {
  try {
    final request = http.Request("DELETE", Uri.parse("$url/voitures/delete/${voiture.voitureId}"));
    request.headers.addAll(<String, String>{"Content-Type": "application/json"});
    request.body=jsonEncode(voiture.voitureId);
    final response = await request.send();
    if (response.statusCode == 200) {
      await FirebaseApi.deleteFolder("${voiture.voitureSerie}${voiture.voitureTypeSerie}/documents");
      await FirebaseApi.deleteFolder("${voiture.voitureSerie}${voiture.voitureTypeSerie}/fillup");
      await FirebaseApi.deleteFolder("${voiture.voitureSerie}${voiture.voitureTypeSerie}");
      Navigator.push(context, MaterialPageRoute(builder: (context) => VoitureMain()));
      await successAlertDialog("Suppression du voiture", "Votre voiture a été supprimer avec success!", context);
      return "Success to DeleteVoitures.";
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
  return "Unable to DeleteVoitures.";
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
        imgAssuranceUrl: v["imgAssuranceUrl"], imgTaxUrl: v["imgTaxUrl"], imgVisiteUrl: v["imgVisiteUrl"]
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


addVoitureFillUp(VoitureModel voiture,String dateFillUp, int costFillUp,
    String imgFillUpName, String imgFillUpUrl,String fillUpNotes, BuildContext context) async {

  try {
    var response = await http.post(Uri.parse("$url/fillup/create/${voiture.voitureId}"),
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(<String, dynamic>{
          "dateFillUp": dateFillUp, "costFillUp": costFillUp,
          "imgFillUpName": imgFillUpName, "imgFillUpUrl": imgFillUpUrl,
          "fillUpNotes": fillUpNotes
        }));

      if (response.statusCode == 200) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailVoiture(voiture)));
        await successAlertDialog("Ajouter cout carburant", "Votre operation a ete enregistrer avec success !", context);
      } else {
        errorAlertDialog("Un problème est survenu", "Réessayer plus tard !", context);
      }

  } catch (error) {
    if (error is TimeoutException) {
      errorAlertDialog("Erreur de connexion", "Temps de connexion dépassé.", context);
    } else {
      errorAlertDialog("Un problème est survenu", "Réessayez plus tard!", context);
    }
  }
}

updateVoitureFillUpByVoiture(VoitureModel voiture,FillUpModel fillUpModel, BuildContext context) async {
  var Url = "$url/fillup/update/${voiture.voitureId}";
  try {
    var response = await http.put(Uri.parse(Url),
        headers: <String, String>{"Content-Type": "application/json"},
        body: jsonEncode(fillUpModel));
    if (response.statusCode == 200) {
      /*var myData = utf8.decode(response.bodyBytes);
      var v = jsonDecode(myData);
      FillUpModel savedfillup = fillUpModelJson(response.body);
      VoitureModel voiture = VoitureModel(voitureId: v["voitureId"],
        imgVoitureUrl: v["imgVoitureUrl"], voitureMake: v["voitureMake"], voitureMakeYear: v["voitureMakeYear"],
        voitureModele: v["voitureModele"], voitureTypeSerie: v["voitureTypeSerie"], voitureSerie: v["voitureSerie"],
        voitureCarburant: v["voitureCarburant"], voitureKilometrage: v["voitureKilometrage"], voitureNotes: v["voitureNotes"],
        imgFaceCarteGriseUrl: v["imgFaceCarteGriseUrl"], imgDosCarteGriseUrl: v["imgDosCarteGriseUrl"],
        imgAssuranceUrl: v["imgAssuranceUrl"], imgTaxUrl: v["imgTaxUrl"], imgVisiteUrl: v["imgVisiteUrl"],
      );*/
      if (response.statusCode == 200) {
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UpdateFillUpVoiture(voiture,savedfillup)));
        successAlertDialog("Modification remplissage carburant", "Votre operation a été modifier avec success !", context);
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

Future<String> deleteVoitureFillUpByVoiture (VoitureModel voiture,FillUpModel fillUpModel,BuildContext context)  async {
  try {
    final request = http.Request("DELETE", Uri.parse("$url/fillup/delete/${voiture.voitureId}/${fillUpModel.fillUpId}"));
    final response = await request.send();
    if (response.statusCode == 200) {
      await FirebaseApi.firebaseDeleteImage("${fillUpModel.imgFillUpName}.jpeg", "${voiture.voitureSerie}${voiture.voitureTypeSerie}/fillup");
      Navigator.push(context, MaterialPageRoute(builder: (context) => CarburantDetail(voiture)));
      await successAlertDialog("Suppression de l'operation", "Votre operation des données de carburant a été supprimer avec success!", context);
      return "Success to DeleteFillUp.";
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
  return "Unable to DeleteFillUp.";
}

Future<List<FillUpModel>> getAllCarburantByVoitureId(String voitureId) async {
  var data = await http.get(Uri.parse("$url/fillup/getfillupbyvoitureid/$voitureId"));
  var myData = utf8.decode(data.bodyBytes);
  var jsonData = jsonDecode(myData);
  List<FillUpModel> fillUps = [];
  try {
    for (var f in jsonData) {
      FillUpModel fillUpModel=FillUpModel(fillUpId: f["fillUpId"],
          dateFillUp: f["dateFillUp"], costFillUp: f["costFillUp"],
          imgFillUpName: f["imgFillUpName"], imgFillUpUrl: f["imgFillUpUrl"]
          , fillUpNotes: f["fillUpNotes"]);
      fillUps.add(fillUpModel);
    }
  } catch (e) {
    print("error creating model: $e");
  }
  return fillUps;
}






















/*
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
        headers: {"accept": "*/ /* " , "Content-Type": "multipart/form-data"},
      ));
  if (response.statusCode == 200) {
    print("Uploaded" + response.toString());

    return response.toString();
  }
  return "errer";
}


*/