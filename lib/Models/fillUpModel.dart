import 'dart:convert';

FillUpModel fillUpModelJson(String str) =>
    FillUpModel.fromJson(json.decode(str));

String fillUpModelToJson(FillUpModel data) => json.encode(data.toJson());

class FillUpModel {
  String fillUpId ;
  String dateFillUp ;
  int costFillUp ;
  String imgFillUpName;
  String imgFillUpUrl ;
  String fillUpNotes ;


  FillUpModel(
      {required this.fillUpId,
        required this.dateFillUp,
        required this.costFillUp,
        required this.imgFillUpName,
        required this.imgFillUpUrl,
        required this.fillUpNotes,
      });

  factory FillUpModel.fromJson(Map<String, dynamic> json) => FillUpModel(
    fillUpId: json["fillUpId"],
    dateFillUp: json["dateFillUp"],
    costFillUp: json["costFillUp"],
    imgFillUpName: json["imgFillUpName"],
    imgFillUpUrl: json["imgFillUpUrl"],
    fillUpNotes: json["fillUpNotes"],
  );

  Map<String, dynamic> toJson() => {
    "fillUpId": fillUpId,
    "dateFillUp": dateFillUp,
    "costFillUp": costFillUp,
    "imgFillUpName": imgFillUpName,
    "imgFillUpUrl": imgFillUpUrl,
    "fillUpNotes": fillUpNotes,

  };

  static FillUpModel empty() {
    return FillUpModel(
      fillUpId: '',
      dateFillUp: '',
      costFillUp: 0,
      imgFillUpName: '',
      imgFillUpUrl: '',
        fillUpNotes : ''
    );
  }


}
