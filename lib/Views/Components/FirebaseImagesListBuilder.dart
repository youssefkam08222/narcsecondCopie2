import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../../Globals/globals.dart';
import '../../Models/firebase_file.dart';
import 'FullScreenImage.dart';



 class FirebaseImagesListBuilder extends StatelessWidget {
   final Future<List<FirebaseFile>> futureFiles;

  const FirebaseImagesListBuilder({required this.futureFiles});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FirebaseFile>>(
      future: futureFiles,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          default:
            if (snapshot.hasError) {
              return Center(child: Text('Some error occurred!'));
            } else {
              final files = snapshot.data!;
              if (files.isEmpty) {
                return SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: HexColor("#4174B0"),
                        ),
                        width: MediaQuery.of(context).size.width - 150,
                        child: const Center(
                          child: Padding(
                            padding: EdgeInsets.all(minimumPadding * 2),
                            child: Text(
                              "Modifier votre voiture en ajoutant les images de vos documents !",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: files
                        .map(
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => FullScreenImage(imageUrl: file.url),
                                ),
                              );
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
                    )
                        .toList(),
                  ),
                );
              }
            }
        }
      },
    );
  }
}