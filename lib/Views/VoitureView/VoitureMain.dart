import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Models/voitureModel.dart';
import '../Components/VoitureWidget.dart';
import 'RegisterVoiture.dart';

class VoitureMain extends StatefulWidget {
  const VoitureMain({super.key});

  @override
  State<StatefulWidget> createState() {
    return _VoitureMainState();
  }
}

class _VoitureMainState extends State<VoitureMain> {
  final minimumPadding = 5.0;
  List<VoitureModel> voitures = [];
  String loadedfile = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //getAllVoitures();
    //print("voitures= "+jsonEncode(voitures));
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop(); // Close the app
          return false; // Return false to prevent the default back button behavior
        },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tous votres voitures'),
        ),

        body: const SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: VoitureWidget(),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.lightBlueAccent,
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterVoiture()));
            }),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.only(top: minimumPadding, bottom: minimumPadding),
            children: <Widget>[
              const DrawerHeader(
                child: Text('Voiture management'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Ajouter Voiture'),
                onTap: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>registerVoiture()));
                },
              ),
              ListTile(
                title: Text('Recuperer Voitures'),
                onTap: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>getvoitures()));
                },
              )
            ],
          ),
        ),
      ),
    );

  }
}
