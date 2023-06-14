import 'package:fluttertoast/fluttertoast.dart';
//var url = "http://10.0.2.2:8080";
var url = "http://192.168.1.50:8080";
const minimumPadding = 5.0;
FToast fToast = FToast();

List<String> voituresTypesImmatriculationList = [
  "تونس",
  "ع.م",
  "د.ن",
  "ن.ت",
  "جرار",
  "م.خ",
  "ت.م",
  "أ.ف"
];List<String> voituresTypesCarburantList = [
  "Essence",
  "Diesel",
  "GPL",
  "Electrique",
  "Hybride",
];

enum AppBarOptions { update, delete }


