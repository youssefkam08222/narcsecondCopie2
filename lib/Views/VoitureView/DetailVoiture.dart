import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:narcsecond/Models/voitureModel.dart';
import 'package:narcsecond/Views/VoitureView/VoitureMain.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:narcsecond/Views/VoitureView/UpdateVoiture.dart';
import '../../Models/firebase_file.dart';
import '../../Services/firebase_api.dart';
import '../../Services/voitureService.dart';
import '../AlertDialog/ConfirmAlertDialog.dart';
import '../Components/FullScreenImage.dart';
import '../Components/Toast.dart';

class DetailVoiture extends StatefulWidget {
  VoitureModel v;

  @override
  State<StatefulWidget> createState() {
    return DetailVoitureState(v);
  }

  DetailVoiture(this.v);
}

enum AppBarOptions { update, delete }

class DetailVoitureState extends State<DetailVoiture> {
  VoitureModel voiture = VoitureModel(
      voitureId: "",
      imgVoitureUrl: "",
      voitureMake: "",
      voitureMakeYear: "",
      voitureModele: "",
      voitureTypeSerie: "",
      voitureSerie: "",
      voitureCarburant: "",
      voitureNotes: "",
      voitureKilometrage: 0,
      imgFaceCarteGriseUrl: "",
      imgDosCarteGriseUrl: "",
      imgAssuranceUrl: "",
      imgVisiteUrl: "",
      imgTaxUrl: "",
  );
  DetailVoitureState(VoitureModel v) {
    voiture = v;
  }
  final minimumPadding = 5.0;
  List<String> Date = [
    "Jan 2023",
    "Feb 2023",
    "Mars 2023",
    "Avril 2023",
    "Mai 2023",
    "Juin 2023"
  ];
  FToast fToast = FToast();
  List<String> documentsImgList=[];
  bool documentsEmptyImgList=false;

  late Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    documentsImgList.addAll([voiture.imgFaceCarteGriseUrl,voiture.imgDosCarteGriseUrl,voiture.imgAssuranceUrl,voiture.imgVisiteUrl,voiture.imgTaxUrl]);
    documentsImgList=documentsImgList.where((element) => element.isNotEmpty).toList();
    documentsEmptyImgList = documentsImgList.every((element) => element.isEmpty);
    futureFiles = FirebaseApi.listAll("${voiture.voitureSerie}${voiture.voitureTypeSerie}/documents");
  }

  //var appBarHeight = AppBar().preferredSize.height;

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position) {
    return PopupMenuItem(
      value: position,
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.black,
          ),
          Text(title),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Custom icon for the return button
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const VoitureMain()));
          },
        ),
        title: Text("Détail de votre voiture"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (value) async {
              if (value == AppBarOptions.update.index) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => updateVoiture(voiture)));
              } else if (value == AppBarOptions.delete.index) {
                bool? userChoice= await confirmAlertDialog("Supprimer voiture", "Est ce que vous etes sur de supprimer cette voiture ?", context);
                if (userChoice == true) {
                  deleteVoiture(voiture,context);
                }
              }
            },
            offset: Offset(0.0, AppBar().preferredSize.height),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            itemBuilder: (ctx) => [
              _buildPopupMenuItem(
                  'Mettre a jour', Icons.update, AppBarOptions.update.index),
              _buildPopupMenuItem(
                  'Supprimer', Icons.delete, AppBarOptions.delete.index),
            ],
          )
        ],
      ),
      body: Form(
        child: ListView(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(bottom: minimumPadding * 2),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: minimumPadding),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FullScreenImage(imageUrl: voiture.imgVoitureUrl)
                          )
                          );

                        },
                        child: Image.network(
                          voiture.imgVoitureUrl,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: minimumPadding),
                      child: Container(
                        color: Colors.grey,
                        child: Padding(
                            padding: EdgeInsets.only(bottom: minimumPadding),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.zero,
                                  child: Column(
                                    children: [
                                      ListTile(
                                          title: Text(
                                            "${voiture.voitureMake} ${voiture.voitureMakeYear}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.merge(
                                                  TextStyle(
                                                      color:
                                                          HexColor("#4174B0"),
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 25.0),
                                                ),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const ImageIcon(
                                                    AssetImage(
                                                        'assets/images/qr-code.png'),
                                                    color: Colors.black),
                                                onPressed: () {
                                                  //print("Notification qr code = "+documentsImgList.toString());
                                                },
                                              ),
                                              IconButton(
                                                icon: const ImageIcon(
                                                  AssetImage(
                                                      'assets/images/verifDocuments.png'),
                                                  color: Colors.green,
                                                ),
                                                onPressed: () {
                                                  print(
                                                      "Notification Documents");
                                                },
                                              ),
                                              IconButton(
                                                icon: const ImageIcon(
                                                  AssetImage(
                                                      'assets/images/notifMaintenance.png'),
                                                  color: Colors.red,
                                                ),
                                                onPressed: () {
                                                  print(
                                                      "Notification Maintenance");
                                                },
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.zero,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white70,
                                              border: Border.all(),
                                              borderRadius:
                                                  BorderRadius.circular(5.0)),
                                          child: Row(
                                            children: [
                                              if (voiture.voitureTypeSerie ==
                                                  "تونس")
                                                Row(
                                                  children: [
                                                    Text(
                                                      "  ${voiture.voitureSerie.substring(0, voiture.voitureSerie.indexOf('T'))} ",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .merge(
                                                            const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 15.0),
                                                          ),
                                                    ),
                                                    Text(
                                                      " ${voiture.voitureTypeSerie} ",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .merge(
                                                            const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 15.0),
                                                          ),
                                                    ),
                                                    Text(
                                                      " ${voiture.voitureSerie.split("T").last}  ",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium!
                                                          .merge(
                                                            const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 15.0),
                                                          ),
                                                    ),
                                                  ],
                                                ),
                                              if (voiture.voitureTypeSerie !=
                                                  "تونس")
                                                Text(
                                                  "  ${voiture.voitureSerie}  ${voiture.voitureTypeSerie}  ",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .merge(
                                                        const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 15.0),
                                                      ),
                                                ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: minimumPadding),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    //mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const ImageIcon(
                                          AssetImage(
                                              'assets/images/barometer1.png'),
                                          color: Colors.black),
                                      Text(
                                        "  ${voiture.voitureKilometrage.toString().replaceAllMapped(RegExp(r".{0}"), (match) => "${match.group(0)} ")} KLM",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .merge(
                                              const TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15.0),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: minimumPadding,
                                      right: minimumPadding * 3,
                                      bottom: minimumPadding * 3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    //mainAxisSize: MainAxisSize.min,
                                    //mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              const ImageIcon(
                                                  AssetImage(
                                                      'assets/images/activity.png'),
                                                  color: Colors.black),
                                              Text(
                                                "  Couts totales: 450,600 DT",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .merge(
                                                      const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontSize: 15.0),
                                                    ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 80,
                                                height: 80,
                                                child: SpeedDial(
                                                  backgroundColor: Colors.blue,
                                                  animatedIcon:
                                                      AnimatedIcons.add_event,
                                                  overlayColor: Colors.black,
                                                  overlayOpacity: 0.4,
                                                  children: [
                                                    SpeedDialChild(
                                                        child: Icon(
                                                            Icons.gas_meter),
                                                        backgroundColor:
                                                            Colors.green,
                                                        label:
                                                            "Ajouter Carburant",
                                                        onTap: () => {
                                                              fToast.showToast(
                                                                child: toastM(
                                                                    "Ajouter Carburant",Colors.blue),
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                toastDuration:
                                                                    const Duration(
                                                                        seconds:
                                                                            2),
                                                              )
                                                            }),
                                                    SpeedDialChild(
                                                        backgroundColor:
                                                            Colors.amberAccent,
                                                        child: Icon(Icons
                                                            .auto_fix_high),
                                                        label:
                                                            "Ajouter maintenance",
                                                        onTap: () => {
                                                              fToast.showToast(
                                                                child: toastM(
                                                                    "Ajouter Maintenance",Colors.green),
                                                                gravity:
                                                                    ToastGravity
                                                                        .BOTTOM,
                                                                toastDuration:
                                                                    const Duration(
                                                                        seconds:
                                                                            2),
                                                              )
                                                            }),
                                                  ],
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: minimumPadding),
                      child: Container(
                          color: HexColor("#C9C3C3"),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.zero,
                                child: ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Couts par mois",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.merge(
                                            TextStyle(
                                                color: HexColor("#4174B0"),
                                                fontWeight: FontWeight.w900,
                                                fontSize: 25.0),
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                      bottom: minimumPadding * 2),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: Date.map(
                                            (date) => Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(
                                                        15)),
                                                color: HexColor("#4174B0")),
                                            margin: EdgeInsets.only(
                                                right: minimumPadding * 2),
                                            width: 160.0,
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  minimumPadding),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    date,
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                  const Divider(
                                                    color: Colors.black,
                                                    height: 1,
                                                    thickness: 1,
                                                    indent: 5,
                                                    endIndent: 5,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(
                                                        minimumPadding),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                      children: const [
                                                        ImageIcon(
                                                            AssetImage(
                                                                'assets/images/Carburant.png'),
                                                            color: Colors
                                                                .blue),
                                                        FittedBox(
                                                          fit: BoxFit.cover,
                                                          child: Text(
                                                              "22222",
                                                              style:
                                                              TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                        ),
                                                        ImageIcon(
                                                            AssetImage(
                                                                'assets/images/tnd.png'),
                                                            color: Colors
                                                                .pinkAccent),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(
                                                        minimumPadding),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                      children: const [
                                                        ImageIcon(
                                                          AssetImage(
                                                              'assets/images/main.png'),
                                                          color:
                                                          Colors.blue,
                                                        ),
                                                        FittedBox(
                                                          fit: BoxFit.cover,
                                                          child: Text(
                                                              "985265",
                                                              style:
                                                              TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                        ),
                                                        ImageIcon(
                                                            AssetImage(
                                                                'assets/images/tnd.png'),
                                                            color: Colors
                                                                .pinkAccent),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ).toList(),
                                    ),
                                  )),
                            ],
                          )
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: minimumPadding),
                      child: Container(
                        color: Colors.grey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.zero,
                              child: ListTile(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Couts totales",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.merge(
                                          TextStyle(
                                              color: HexColor("#4174B0"),
                                              fontWeight: FontWeight.w900,
                                              fontSize: 25.0),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  bottom: minimumPadding ),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            const BorderRadius.all(
                                                Radius.circular(15)),
                                            color: Colors.transparent,
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 2)),
                                        margin:
                                        EdgeInsets.all(minimumPadding),
                                        width: 160.0,
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              minimumPadding),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceEvenly,
                                            children: const [
                                              ImageIcon(
                                                  AssetImage(
                                                      'assets/images/Carburant.png'),
                                                  size: 60,
                                                  color: Colors.blue),
                                              Text(
                                                "2855,500 DT",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        )),
                                    Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            const BorderRadius.all(
                                                Radius.circular(15)),
                                            color: Colors.transparent,
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 2)),
                                        margin:
                                        EdgeInsets.all(minimumPadding),
                                        width: 160.0,
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              minimumPadding),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceEvenly,
                                            children: const [
                                              ImageIcon(
                                                  AssetImage(
                                                      'assets/images/main.png'),
                                                  size: 60,
                                                  color: Colors.blue),
                                              Text(
                                                "3655,500 DT",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ],
                                          ),
                                        )),
                                  ]),
                            ),
                          ],
                        )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: minimumPadding),
                      child: Container(
                          color: HexColor("#C9C3C3"),
                          child: Padding(
                              padding: EdgeInsets.only(bottom: minimumPadding),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.zero,
                                    child: ListTile(
                                        title: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Text("Documents", style: Theme.of(context).textTheme.titleLarge?.merge(
                                                TextStyle(color: HexColor("#4174B0"), fontWeight: FontWeight.w900, fontSize: 25.0),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                  FutureBuilder<List<FirebaseFile>>(
                                    future: futureFiles,
                                    builder: (context,snapshot){
                                      switch(snapshot.connectionState){
                                        case ConnectionState.waiting:
                                          return Center(child: CircularProgressIndicator());
                                        default: if(snapshot.hasError){
                                          return Center(child: Text('Some error occured!'),);
                                        }else {
                                          final files = snapshot.data!;
                                          return buildFile(context, files);
                                        }
                                      }
                                    },
                                  ),

                                ],
                              ))),
                    ),

                  ],
                )),
          ],
        ),
      ),
      /*floatingActionButton: Container(
          width: 80,
          height: 80,
          child: FloatingActionButton(
            onPressed: () {
              //deleteVoiture(voiture);

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const VoitureMain()));
            },
            backgroundColor: Colors.pink,
            child: const Icon(Icons.delete),
          ),
        )*/
    );

  }
  SingleChildScrollView buildFile(BuildContext context, List<FirebaseFile> files) {
    if (files.isEmpty) {
      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: HexColor("#4174B0"),
              ),

              width: MediaQuery.of(context).size.width-150,
              child: Center(

                child: Padding(
                  padding: EdgeInsets.all(minimumPadding * 2),
                  child:  const Text(
                    "Modifier votre voiture en ajoutant les images de vos documents !",
                    style: TextStyle(color: Colors.white),
                      textAlign:TextAlign.center,
                  ),
                ),
              )
            ),
          ],
        ),
      );
    } else {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: files.map(
                (file) => Container(
              height: 130,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: HexColor("#4174B0"),
              ),
              margin: EdgeInsets.only(right: minimumPadding * 2),
              width: 160,
              child: Padding(
                padding: EdgeInsets.all(minimumPadding),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FullScreenImage(imageUrl: file.url),
                    ));
                  },
                  child: Material(
                    color: Colors.transparent,
                    elevation: 0,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      child: Column(
                        children: [
                          Image.network(
                            file.url,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ).toList(),
        ),
      );
    }
  }



}

/*  ListTile(
                                    trailing: Row(
                                      children: [
                                        const ImageIcon(
                                            AssetImage(
                                                'assets/images/barometer1.png'),
                                            color: Colors.black),
                                        Text(
                                          "  ${voiture.voitureKilometrage.replaceAllMapped(RegExp(r".{0}"), (match) => "${match.group(0)} ")} KLM",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .merge(
                                                const TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15.0),
                                              ),
                                        ),
                                      ],
                                    ),

                                )*/
/*
Container(

decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15)),
color: Colors.grey
),
margin: EdgeInsets.only(right: minimumPadding*2),
width: 160.0,
),

FloatingActionButton(
                                                    onPressed: () {
                                                      //deleteVoiture(voiture);
                                                      _showSimpleDialog();
                                                      //Navigator.push(context, MaterialPageRoute(builder: (context) => const VoitureMain()));
                                                    },
                                                    backgroundColor:
                                                        Colors.blue,
                                                    child: const Icon(Icons.add,
                                                        size: 60),
                                                  ),
*/
/*
Padding(
                      padding: EdgeInsets.only(top: minimumPadding,bottom: minimumPadding),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(width: 1),
                            boxShadow: const [
                              BoxShadow(color: Colors.transparent, spreadRadius: 3),
                            ],
                          ),
                          child:Padding(
                            padding: EdgeInsets.all(minimumPadding),
                            child: Column(

                              children: [
                                Row(
                                  children: const [
                                    Text("Documents",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.indigo)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.network(
                                      voiture.imgVoitureUrl,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    Image.network(
                                      voiture.imgVoitureUrl,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                    Image.network(
                                      voiture.imgVoitureUrl,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    )
                                  ],
                                ),


                              ],
                            ) ,
                          )
                      ),

                    ),
 */