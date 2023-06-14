import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:narcsecond/Models/voitureModel.dart';
import 'package:narcsecond/Views/Components/CustomAnimatedButton.dart';
import 'package:narcsecond/Views/Components/Toast.dart';
import 'package:narcsecond/Views/VoitureView/CarburantDetail.dart';
import 'package:narcsecond/Views/VoitureView/UpdateVoiture.dart';
import 'package:narcsecond/Views/VoitureView/VoitureMain.dart';

import '../../Globals/globals.dart';
import '../../Models/fillUpModel.dart';
import '../../Models/firebase_file.dart';
import '../../Services/firebase_api.dart';
import '../../Services/voitureService.dart';
import '../AlertDialog/ConfirmAlertDialog.dart';
import '../Components/FirebaseImagesListBuilder.dart';
import '../Components/FullScreenImage.dart';
import '../Components/ViewDetailsCustomSpeedDial.dart';

class DetailVoiture extends StatefulWidget {
  VoitureModel v;

  @override
  State<StatefulWidget> createState() {
    return DetailVoitureState(v);
  }

  DetailVoiture(this.v, {super.key});
}



class DetailVoitureState extends State<DetailVoiture> {
  VoitureModel voiture = VoitureModel.empty();
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
  //List<String> documentsImgList=[];
  //bool documentsEmptyImgList=false;
  late Future<List<FirebaseFile>> futureFiles;
  bool _saving = false;
  late List<FillUpModel> l  ;



   int totalCarburantCost=0;
  List<FillUpModel> fillups=<FillUpModel>[];
  Future<void> loadData() async {
    fillups = await getAllCarburantByVoitureId(voiture.voitureId);
    for (var element in fillups) {
      totalCarburantCost+= element.costFillUp;
    }
    setState(() {
      totalCarburantCost=totalCarburantCost;
    });
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);

    //documentsImgList.addAll([voiture.imgFaceCarteGriseUrl,voiture.imgDosCarteGriseUrl,voiture.imgAssuranceUrl,voiture.imgVisiteUrl,voiture.imgTaxUrl]);
    //documentsImgList=documentsImgList.where((element) => element.isNotEmpty).toList();
    //documentsEmptyImgList = documentsImgList.every((element) => element.isEmpty);
    loadData();
    futureFiles = FirebaseApi.GetAllFireBaseStorageFiles("${voiture.voitureSerie}${voiture.voitureTypeSerie}/documents");



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
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VoitureMain()),
          );
          return false; // Return false to prevent the default back button behavior
        },
        child:Scaffold(
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
                      if (userChoice != null && userChoice) {
                        Future.delayed(const Duration(seconds: 1),() async {
                          setState(() {
                            _saving = true;
                          });
                          await deleteVoiture(voiture,context);
                          setState(() {
                            _saving = false;
                          });
                        });
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
            body: ModalProgressHUD(
              progressIndicator:  const CircularProgressIndicator(color: Colors.blue,backgroundColor: Colors.transparent),
              inAsyncCall: _saving,
              child: Container(
                color: Colors.black12,
                child: Form(
                  child: ListView(
                    children: <Widget>[
                      Column(
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
                                child: Stack(
                                    children :[

                                      Image.network(
                                        voiture.imgVoitureUrl,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                      ),
                                      Container(
                                        height: 200,
                                        width: double.infinity,

                                        child:
                                        CustomAnimatedButton(voiture),

                                      )

                                    ]
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
                                                      onPressed: () async {
                                                        //await FirebaseApi.deleteFolder("${voiture.voitureSerie}${voiture.voitureTypeSerie}/documents");
                                                        //await FirebaseApi.deleteFolder("${voiture.voitureSerie}${voiture.voitureTypeSerie}");

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
                                        EdgeInsets.only(left: minimumPadding,top: minimumPadding),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:  EdgeInsets.only(left: 6.0,bottom: minimumPadding*2),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    //mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      const ImageIcon(

                                                        AssetImage(
                                                            'assets/images/barometer2.png'),
                                                        color: Colors.yellow,size: 18,),
                                                      Text(
                                                        " ${voiture.voitureKilometrage.toString().replaceAllMapped(RegExp(r".{0}"), (match) => "${match.group(0)} ")} KLM",
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
                                                  padding:  EdgeInsets.only(left: 8.0,bottom: minimumPadding*2),
                                                  child: Row(
                                                    children: [
                                                      const ImageIcon(
                                                        AssetImage(
                                                            'assets/images/Carburant.png'),
                                                        color: Colors.orangeAccent,size: 18,),
                                                      RichText(
                                                        text: TextSpan(
                                                          text: ' ${voiture.voitureCarburant} ce mois: ',
                                                          style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 15.0,
                                                              color: Colors.black
                                                          ),
                                                          children: const [
                                                            TextSpan(
                                                              text: '450,600 DT',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.normal,
                                                                fontSize: 15.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:  EdgeInsets.only(left: 8.0,bottom: minimumPadding),
                                                  child: Row(
                                                    children: const [
                                                      ImageIcon(
                                                        AssetImage(
                                                            'assets/images/main.png'),
                                                        color: Colors.deepPurple,size: 18,),
                                                      Text.rich(
                                                        TextSpan(
                                                          text: ' Maintenance ce mois: ',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 15.0,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: '450,600 DT',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.normal,
                                                                fontSize: 15.0,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                ViewDetailsCustomSpeedDial(
                                                  onCarburantTap: () {},
                                                  onMaintenanceTap: () {},
                                                )
                                              ],
                                            ),
                                          ],
                                        ),

                                      ),
                                      if (voiture.voitureNotes.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 10.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                child: RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      const WidgetSpan(
                                                        child: Padding(
                                                          padding: EdgeInsets.only(top: 3.0), // Adjust the top padding as needed
                                                          child: Icon(Icons.notes_outlined, color: Colors.indigo,size: 18,),
                                                        ),
                                                      ),
                                                      const TextSpan(
                                                        text: "  Notes: ",
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 15.0,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: "${voiture.voitureNotes}",
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.normal,
                                                          fontSize: 15.0,
                                                          color: Colors.black,
                                                          height: 0.9, // Add spacing between lines (adjust the value as needed)
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
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
                                            GestureDetector(
                                              onTap: (){
                                                if(totalCarburantCost!=0){
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => CarburantDetail(voiture)));
                                                }else{
                                                  fToast.showToast(
                                                    child: toastM("Ajouter des operations d'ajout carburant", Colors.yellow),
                                                    gravity: ToastGravity.BOTTOM,
                                                    toastDuration: const Duration(seconds: 2),
                                                  );

                                                }

                                              },
                                              child: Container(
                                                //height: 100,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(15)),
                                                      color: Colors.transparent,
                                                      border: Border.all(
                                                          color: Colors.indigo,
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
                                                      children:  [
                                                        Image.asset(
                                                          'assets/images/commodity.gif',
                                                          colorBlendMode: BlendMode.dstIn,
                                                          width: 60,
                                                          height: 60,
                                                        ),
                                                        Text(
                                                          "$totalCarburantCost DT",
                                                          style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 20),
                                                        ),
                                                        const Text("Cliquer ici pour voir detail !",
                                                          style:TextStyle(
                                                              color: Colors.indigo,
                                                              fontSize: 10
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                print("object= ${voiture.voitureId}");
                                              },
                                              child: Container(
                                                //height: 100,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(15)),
                                                      color: Colors.transparent,
                                                      border: Border.all(
                                                          color: Colors.indigo,
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
                                                      children:  [
                                                        Image.asset(
                                                          'assets/images/maintenancegif.gif',
                                                          colorBlendMode: BlendMode.dstIn,
                                                          width: 60,
                                                          height: 60,

                                                        ),
                                                        const Text(
                                                          "3655,500 DT",
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 20),
                                                        ),
                                                        const Text("Cliquer ici pour voir detail !",
                                                          style:TextStyle(
                                                              color: Colors.indigo,
                                                              fontSize: 10
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )),
                                            ),
                                          ]),
                                    ),
                                  ],
                                )),
                          ),

                          Container(
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
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: FirebaseImagesListBuilder(futureFiles: futureFiles),
                                      ),
                                    ],
                                  ))),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
        )
    );


  }

}
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
/*
// couts par mois
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

 */