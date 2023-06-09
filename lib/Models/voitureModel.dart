


import 'dart:convert';

VoitureModel voitureModelJson(String str) =>
    VoitureModel.fromJson(json.decode(str));

String voitureModelToJson(VoitureModel data) => json.encode(data.toJson());

class VoitureModel {
  String voitureId ;
  String imgVoitureUrl ;
  String voitureMake ;
  String voitureMakeYear ;
  String voitureModele;
  String voitureTypeSerie ;
  String voitureSerie ;
  String voitureCarburant ;
  int voitureKilometrage ;
  String voitureNotes ;
  String imgFaceCarteGriseUrl ;
  String imgDosCarteGriseUrl ;
  String imgAssuranceUrl ;
  String imgTaxUrl ;
  String imgVisiteUrl ;


  VoitureModel(
      {required this.voitureId,
      required this.imgVoitureUrl,
      required this.voitureMake,
      required this.voitureMakeYear,
      required this.voitureModele,
      required this.voitureTypeSerie,
      required this.voitureSerie,
      required this.voitureCarburant,
      required this.voitureNotes,
      required this.voitureKilometrage,
      required this.imgFaceCarteGriseUrl,
      required this.imgDosCarteGriseUrl,
      required this.imgAssuranceUrl,
      required this.imgTaxUrl,
      required this.imgVisiteUrl,

      });

  factory VoitureModel.fromJson(Map<String, dynamic> json) => VoitureModel(
        voitureId: json["voitureId"],
        imgVoitureUrl: json["imgVoitureUrl"],
        voitureMake: json["voitureMake"],
        voitureMakeYear: json["voitureMakeYear"],
        voitureModele: json["voitureModele"],
        voitureTypeSerie: json["voitureTypeSerie"],
        voitureSerie: json["voitureSerie"],
        voitureCarburant: json["voitureCarburant"],
        voitureKilometrage: json["voitureKilometrage"],
        voitureNotes: json["voitureNotes"],
        imgFaceCarteGriseUrl: json["imgFaceCarteGriseUrl"],
        imgDosCarteGriseUrl: json["imgDosCarteGriseUrl"],
        imgAssuranceUrl: json["imgAssuranceUrl"],
        imgTaxUrl: json["imgTaxUrl"],
        imgVisiteUrl: json["imgVisiteUrl"],

      );

  Map<String, dynamic> toJson() => {
        "voitureId": voitureId,
        "imgVoitureUrl": imgVoitureUrl,
        "voitureMake": voitureMake,
        "voitureMakeYear": voitureMakeYear,
        "voitureModele": voitureModele,
        "voitureTypeSerie": voitureTypeSerie,
        "voitureSerie": voitureSerie,
        "voitureCarburant": voitureCarburant,
        "voitureKilometrage": voitureKilometrage,
        "voitureNotes": voitureNotes,
        "imgFaceCarteGriseUrl": imgFaceCarteGriseUrl,
        "imgDosCarteGriseUrl": imgDosCarteGriseUrl,
        "imgAssuranceUrl": imgAssuranceUrl,
        "imgTaxUrl": imgTaxUrl,
        "imgVisiteUrl": imgVisiteUrl,


      };

  static VoitureModel empty() {
    return VoitureModel(
      voitureId: '',
      imgVoitureUrl: '',
      voitureMake: '',
      voitureMakeYear: '',
      voitureModele: '',
      voitureTypeSerie: '',
      voitureSerie: '',
      voitureCarburant: '',
      voitureKilometrage: 0,
      voitureNotes: '',
      imgFaceCarteGriseUrl: '',
      imgDosCarteGriseUrl: '',
      imgAssuranceUrl: '',
      imgTaxUrl: '',
      imgVisiteUrl: '',

    );
  }



  String get imgvoitureurl => imgVoitureUrl;
  String get voituremake => voitureMake;
  String get voituremakeyear => voitureMakeYear;
  String get voituremodele => voitureModele;
  String get voituretypeserie => voitureTypeSerie;
  String get voitureserie => voitureSerie;
  String get voiturecarburant => voitureCarburant;
  int get voiturekilometrage => voitureKilometrage;
  String get voiturenotes => voitureNotes;
  String get imgfacecartegriseurl => imgFaceCarteGriseUrl;
  String get imgdoscartegriseurl => imgDosCarteGriseUrl;
  String get imgassuranceurl => imgAssuranceUrl;
  String get imgtaxurl => imgTaxUrl;
  String get imgvisiteurl => imgVisiteUrl;

}

/*void updateVoiture(VoitureModel existingVoiture, {
    String? imgVoitureUrl,
    String? voitureMake,
    String? voitureMakeYear,
    String? voitureModele,
    String? voitureTypeSerie,
    String? voitureSerie,
    String? voitureCarburant,
    int? voitureKilometrage,
    String? voitureNotes,
    String? imgFaceCarteGriseUrl,
    String? imgDosCarteGriseUrl,
    String? imgAssuranceUrl,
    String? imgTaxUrl,
    String? imgVisiteUrl,
    List<FillUpModel>? voitureFillUps,
  }) {
    if (imgVoitureUrl != null) existingVoiture.imgVoitureUrl = imgVoitureUrl;
    if (voitureMake != null) existingVoiture.voitureMake = voitureMake;
    if (voitureMakeYear != null) existingVoiture.voitureMakeYear = voitureMakeYear;
    if (voitureModele != null) existingVoiture.voitureModele = voitureModele;
    if (voitureTypeSerie != null) existingVoiture.voitureTypeSerie = voitureTypeSerie;
    if (voitureSerie != null) existingVoiture.voitureSerie = voitureSerie;
    if (voitureCarburant != null) existingVoiture.voitureCarburant = voitureCarburant;
    if (voitureKilometrage != null) existingVoiture.voitureKilometrage = voitureKilometrage;
    if (voitureNotes != null) existingVoiture.voitureNotes = voitureNotes;
    if (imgFaceCarteGriseUrl != null) existingVoiture.imgFaceCarteGriseUrl = imgFaceCarteGriseUrl;
    if (imgDosCarteGriseUrl != null) existingVoiture.imgDosCarteGriseUrl = imgDosCarteGriseUrl;
    if (imgAssuranceUrl != null) existingVoiture.imgAssuranceUrl = imgAssuranceUrl;
    if (imgTaxUrl != null) existingVoiture.imgTaxUrl = imgTaxUrl;
    if (imgVisiteUrl != null) existingVoiture.imgVisiteUrl = imgVisiteUrl;
    if (voitureFillUps != null) existingVoiture.voitureFillUps = voitureFillUps;
  }*/
