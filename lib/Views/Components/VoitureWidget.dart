import 'dart:convert';
import 'package:flutter/material.dart';
import '../../Models/voitureModel.dart';
import '../../Services/voitureService.dart';
import '../VoitureView/DetailVoiture.dart';

class VoitureWidget extends StatefulWidget {
  const VoitureWidget({Key? key}) : super(key: key);

  @override
  State<VoitureWidget> createState() => _VoitureWidgetState();
}

class _VoitureWidgetState extends State<VoitureWidget> {
//safeArea
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
        future: getAllVoituresfromDB(),
        builder: (context, AsyncSnapshot<List<VoitureModel>> snapshot) {
          //print("snapshot= "+snapshot.data.toString());
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  const Center(
              child: CircularProgressIndicator(),
            );
          }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              // Empty state
              return const Center(
                child: Text('No data available.'),
              );
            }

            return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate:  const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 22.0,
                  mainAxisSpacing: 12,
                  mainAxisExtent: 275,
                ),
                itemCount: snapshot.data?.length ,
                itemBuilder: (BuildContext context, index) => OutlinedButton(
                      style: OutlinedButton.styleFrom(side: BorderSide.none),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            16.0,
                          ),
                          color: Colors.grey,
                        ),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(16.0)),
                              child: Image.network(
                                snapshot.data![index].imgVoitureUrl,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              child: Column(
                                //mainAxisSize: MainAxisSize.max,
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ListTile(

                                      title: Text(
                                        "${snapshot.data![index]
                                            .voitureMake} ${snapshot
                                            .data![index].voitureModele}"
                                            " ${snapshot
                                            .data![index].voitureMakeYear} ",
                                        maxLines: 2,
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .titleMedium!
                                            .merge(
                                          const TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 20.0,
                                          ),
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
                                              print("Notification qr code");
                                            },
                                          ),
                                          IconButton(
                                            icon: const ImageIcon(
                                              AssetImage(
                                                  'assets/images/verifDocuments.png'),
                                              color: Colors.green,
                                            ),
                                            onPressed: () {
                                              print("Notification Documents");
                                            },
                                          ),
                                          IconButton(
                                            icon: const ImageIcon(
                                              AssetImage(
                                                  'assets/images/notifMaintenance.png'),
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              print("Notification Maintenance");
                                            },
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              //mainAxisSize: MainAxisSize.max,
                              children: [
                                ListTile(
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const ImageIcon(
                                          AssetImage(
                                              'assets/images/barometer1.png'),
                                          color: Colors.black),
                                      Text(
                                        "  ${snapshot.data![index]
                                            .voitureKilometrage
                                            .replaceAllMapped(
                                            RegExp(r".{0}"), (match) => "${match
                                            .group(0)} ")} KLM",
                                        style: Theme
                                            .of(context)
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
                                  leading: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white70,
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(
                                            5.0)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (snapshot.data![index]
                                            .voitureTypeSerie ==
                                            "تونس")
                                          Row(
                                            children: [
                                              Text(
                                                "  ${snapshot.data![index]
                                                    .voitureSerie.substring(0,
                                                    snapshot.data![index]
                                                        .voitureSerie.indexOf(
                                                        'T'))} ",
                                                style: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .merge(
                                                  const TextStyle(
                                                      fontWeight: FontWeight
                                                          .w400,
                                                      fontSize: 15.0),
                                                ),
                                              ),
                                              Text(
                                                " ${snapshot.data![index]
                                                    .voitureTypeSerie} ",
                                                style: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .merge(
                                                  const TextStyle(
                                                      fontWeight: FontWeight
                                                          .w400,
                                                      fontSize: 15.0),
                                                ),
                                              ),
                                              Text(
                                                " ${snapshot.data![index]
                                                    .voitureSerie
                                                    .split("T")
                                                    .last}  ",
                                                style: Theme
                                                    .of(context)
                                                    .textTheme
                                                    .titleMedium!
                                                    .merge(
                                                  const TextStyle(
                                                      fontWeight: FontWeight
                                                          .w400,
                                                      fontSize: 15.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        if (snapshot.data![index]
                                            .voitureTypeSerie !=
                                            "تونس")
                                          Text(
                                            "  ${snapshot.data![index]
                                                .voitureSerie}  ${snapshot
                                                .data![index]
                                                .voitureTypeSerie}  ",
                                            style: Theme
                                                .of(context)
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
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DetailVoiture(snapshot.data![index])));
                      },
                    ),
              );

        },
      ),
    );
  }
}

/* Container(
                        child:Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const ImageIcon(AssetImage('assets/images/barometer1.png'),color: Colors.black),
                              Text(
                                "  ${snapshot.data![index].voitureKilometrage.replaceAllMapped(RegExp(r".{0}"), (match) => "${match.group(0)} ")} KLM",
                                style: Theme.of(context).textTheme.titleMedium!.merge(
                                  const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15.0
                                  ),
                                ),
                              ) ,
                            ],
                          ),
                        )
                      ),*/

/* ListTile(

                          leading: Image.memory(base64Decode(snapshot.data![index].loadFileID),
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,),
                            title: const Text(
                                'voitureId Marque Modele typeSerie Serie kilometrage'
                            ),
                            subtitle: Text(
                                '${snapshot.data![index].voitureId}${snapshot.data![index].voitureMarque}'
                                    '${snapshot.data![index].voitureModele}${snapshot.data![index].voitureSerie}'
                                    '${snapshot.data![index].voitureTypeSerie}${snapshot.data![index].voitureKilometrage}'
                            ),
                            onTap: (){
                              print("voiture marque = "+snapshot.data![index].voitureMarque);
                              //Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(snapshot.data![index])));
                            }
                        )*/
