import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:narcsecond/Views/AlertDialog/showInfoAddFillUpAttachementDialog.dart';
import '../../Globals/globals.dart';
import '../../Models/voitureModel.dart';
import '../../Services/firebase_api.dart';
import '../../Services/voitureService.dart';
import '../Components/DatePicker2.dart';
import '../Components/SelectImage.dart';
import 'package:intl/intl.dart';


class AddFillUpVoiture extends StatefulWidget {
  VoitureModel v;

  @override
  State<StatefulWidget> createState() {
    return _AddFillUpVoitureState(v);
  }
  AddFillUpVoiture(this.v, {super.key});
}
class _AddFillUpVoitureState extends State<AddFillUpVoiture> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController dateController = TextEditingController();
  TextEditingController fillUpCostController = TextEditingController();
  //TextEditingController kilometrageController = TextEditingController();
  TextEditingController NotesController = TextEditingController();
  late File fileAttachement = File("");
  int toastDuration=3;
  bool isButtonSaveSubmitted = false;
  bool _saving = false;
  VoitureModel voiture = VoitureModel.empty();
  _AddFillUpVoitureState(v) {voiture =v ;}
  DateTime? newDate;
  DateTime? dateTime;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    //DateTime d= DateTime.parse('2023-12-31 10:27:36.878229');
    Intl.defaultLocale = 'fr';

    dateController = TextEditingController(text: DateFormat.yMMMd().format(DateTime.now().toLocal()));
    newDate=DateTime.now().toLocal();
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }
  @override
  void dispose() {
    super.dispose();
  }


  void _focusOnPosition() {
    // Scroll to the desired position
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }



  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme.of(context).textTheme.titleSmall;


    return Scaffold(

        appBar: AppBar(
          title: Text("Remplissage du réservoir"),
        ),

        body: ModalProgressHUD(
          progressIndicator: const CircularProgressIndicator(color: Colors.blue,backgroundColor: Colors.transparent),
          inAsyncCall: _saving,
          child:  Container(
            color: Colors.black12,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(top:  minimumPadding * 2,left: minimumPadding * 2,right: minimumPadding * 2),
                child: ListView(
                  controller: _scrollController,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                      child: Stack(
                        children: [
                          Center(
                            child: Material(
                              color: Colors.transparent,
                              elevation: 0.1,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              borderRadius: BorderRadius.circular(25),
                              child: InkWell(
                                splashColor: Colors.black26,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.network(
                                      voiture.imgVoitureUrl,
                                      height: 150,
                                      width: MediaQuery.of(context).size.width-100,
                                      fit: BoxFit.fill,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: FractionalTranslation(
                              translation: const Offset(0, 4),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white70,
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(
                                        5.0)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (voiture.voitureTypeSerie =="تونس")
                                      Row(
                                        children: [
                                          Text(
                                            "  ${voiture.voitureSerie.substring(0,voiture.voitureSerie.indexOf('T'))} ",
                                            style: Theme.of(context).textTheme.titleMedium!.merge(
                                              const TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0),
                                            ),
                                          ),
                                          Text(
                                            " ${voiture.voitureTypeSerie} ",
                                            style: Theme.of(context).textTheme.titleMedium!.merge(
                                              const TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0),
                                            ),
                                          ),
                                          Text(
                                            " ${voiture.voitureSerie.split("T").last}  ",
                                            style: Theme.of(context).textTheme.titleMedium!.merge(
                                              const TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (voiture.voitureTypeSerie != "تونس")
                                      Text(
                                        "  ${voiture.voitureSerie}  ${voiture.voitureTypeSerie}  ",
                                        style: Theme.of(context).textTheme.titleMedium!.merge(
                                          const TextStyle(fontWeight: FontWeight.w400, fontSize: 15.0),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text("${voiture.voitureMake} ${voiture.voitureMakeYear} ${voiture.voitureModele} "),
                    ),),
                    const Divider(
                      color: Colors.black,
                      height: 25,
                      thickness: 2,
                      indent: 5,
                      endIndent: 5,
                    ),


                    Padding(
                      padding: const EdgeInsets.only(
                          top: minimumPadding, bottom: minimumPadding),
                      child: GestureDetector(
                        onTap: () async {
                          newDate = await showDatePicker2Dialog(DateTime.now(), context);
                          // newDate = await showDatePickerDialog(newDate!,context) ;
                          if (newDate != null) {
                            final formattedDate = DateFormat.yMMMMd().format(newDate!);
                            setState(() {
                              dateController.text = formattedDate;
                              print("new date $newDate");
                            });
                          }

                        },
                        child: AbsorbPointer(
                          absorbing: true,
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller: dateController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                              labelText: 'Coisir une date',
                              labelStyle: const TextStyle(fontSize: 14),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0)
                              ),
                              suffixIcon: const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: IconButton(
                                  icon: Icon(Icons.calendar_month,size: 35,color: Colors.blueAccent,),
                                  onPressed: null,
                                ),
                              )

                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: minimumPadding, bottom: minimumPadding),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(7),
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          //MaskedInputFormatter('000 000 000 000 000 000 000'),
                        ],
                        style: const TextStyle(fontWeight: FontWeight.normal),
                        controller: fillUpCostController,
                        onChanged: (value) {
                          if (isButtonSaveSubmitted) {
                            _formKey.currentState!.validate();
                          }
                        },
                        validator: ( value) {
                          if (value!.isEmpty) {
                            return "Entrer le montant que vous avez payé dans cette operation";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                          labelText: "Montant de l'operation",

                          hintText: 'Entrer le montant convenable',
                          labelStyle: const TextStyle(fontSize: 14),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25.0)),
                          suffixIcon:  Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Image.asset("assets/images/tnd.png",color: Colors.blueAccent,),
                          )
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: minimumPadding, bottom: minimumPadding),
                        child: TextFormField(
                          style: textStyle,
                          controller: NotesController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          expands: false,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                              labelText: 'Notes',
                              hintText:
                              'Entrer des notes',
                              labelStyle: TextStyle(fontWeight: FontWeight.normal),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0))),
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: minimumPadding,bottom: minimumPadding),
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(width: 1),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, spreadRadius: 0),
                            ],
                          ),
                          child:Padding(
                            padding: const EdgeInsets.only(bottom: minimumPadding*2,left: minimumPadding*2,right: minimumPadding*2),
                            child: Column(
                              children: [
                                Padding(padding: const EdgeInsets.only(bottom: minimumPadding),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children:  [
                                      const Text("Ajouter un fichier joint ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.blue)),
                                      Row(
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.info_outline,
                                                  color: Colors.blue,
                                                  size: 40,
                                                ),
                                                onPressed: () {
                                                  showInfoAddFillUpAttachementDialog(context);
                                                  FocusScope.of(context).unfocus();
                                                },
                                              ),
                                              const Text(
                                                'Cliquer ici',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Material(
                                            color: Colors.transparent,
                                            elevation: 0.1,
                                            clipBehavior: Clip.antiAliasWithSaveLayer,
                                            borderRadius: BorderRadius.circular(25),
                                            child: InkWell(
                                              splashColor: Colors.black26,
                                              onTap: () async {
                                                File f=(await getImageFile(context));
                                                setState(() {
                                                  if(f.path!="")
                                                  {
                                                    fileAttachement=f;
                                                  }
                                                });
                                              },
                                              child: Column(
                                                children: [
                                                  fileAttachement.path == ''
                                                      ? Stack(
                                                          alignment: Alignment.center,
                                                          children: [
                                                            Ink.image(
                                                              image: const AssetImage("assets/images/facture.jpg"),
                                                              height: 200,
                                                              width: MediaQuery.of(context).size.width,
                                                              fit: BoxFit.fill,
                                                            ),
                                                             Image.asset(
                                                                 'assets/images/cameragif.gif',
                                                                 colorBlendMode: BlendMode.dstIn,
                                                              width: MediaQuery.of(context).size.width,
                                                              height: 200,
                                                              color: Colors.red.withOpacity(0.8)
                                                            ),
                                                          ],
                                                        )
                                                      : Stack(
                                                    children: [
                                                      Image.file(
                                                        File(fileAttachement.path),
                                                        height: 200,
                                                        width: MediaQuery.of(context).size.width,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      Positioned(
                                                        bottom: 1,
                                                        right: 1,
                                                        child: IconButton(
                                                          icon: const Icon(Icons.delete,size: 40,color: Colors.red,),
                                                          onPressed: () {
                                                            setState(() {
                                                              fileAttachement=File("");
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ) ,
                          )
                      ),
                    ),
                    // Form Submit

                    Padding(
                      padding: const EdgeInsets.only(top: 8.0,bottom: 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(0, 60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(45),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.data_saver_on_outlined, size: 30), // Add the desired icon here
                            SizedBox(width: 10),
                            Text('Enregistrer',style: TextStyle(fontSize: 30),),
                          ],
                        ),
                        onPressed: () async {
                          FocusManager.instance.primaryFocus?.unfocus();
                          setState(() {
                            isButtonSaveSubmitted=true;
                          });
                          if(_formKey.currentState!.validate()  )
                          {
                              Future.delayed(const Duration(seconds: 1),() async {
                                setState(() {
                                  _saving = true;
                                });

                                DateTime dateToSave=DateFormat('d MMMM yyyy', 'fr_FR').parse(dateController.text);
                                dateToSave = DateTime(dateToSave.year, dateToSave.month, dateToSave.day, DateTime.now().hour+1, DateTime.now().minute, DateTime.now().second ,DateTime.now().millisecond,DateTime.now().microsecond);
                                int cout = int.parse(fillUpCostController.text);
                                String notes = NotesController.text;
                                String imgFillUpName= fileAttachement.path.isNotEmpty ? dateToSave.toString() : "";
                                String imgFillUpUrl = await FirebaseApi.firebaseUploadImage(fileAttachement, "$imgFillUpName.jpeg","${voiture.voitureSerie}${voiture.voitureTypeSerie}/fillup") ?? "";

                                addVoitureFillUp(voiture,dateToSave.toString(),cout,imgFillUpName,imgFillUpUrl,notes,context);

                                setState(() {
                                  _saving = false;
                                });

                              });
                            }
                          else{
                            _focusOnPosition();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
}

/*Padding(
                      padding: const EdgeInsets.only(
                          top: minimumPadding, bottom: minimumPadding),
                      child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(7),
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          //MaskedInputFormatter('000 000 000 000 000 000 000'),
                        ],
                        style: TextStyle(fontWeight: FontWeight.normal),
                        controller: kilometrageController,
                        onChanged: (value) {
                          if (isButtonSaveSubmitted) {
                            _formKey.currentState!.validate();
                          }
                        },
                        validator: ( value) {
                          if (value!.isEmpty) {
                            return "Entrer le kilometrage pour suivir votre voiture";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                            labelText: "Kilométrage",

                            hintText: 'Entrer le kilometrage lors de cette operation',
                            labelStyle: const TextStyle(fontSize: 14),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0)),
                            suffixIcon:  Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Image.asset("assets/images/barometer2.png",color: Colors.blueAccent,),
                            )
                        ),
                      ),
                    ),*/


/* Future<void> DatePicker(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      locale: const Locale("fr", "FR"),
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(DateTime.now().year ),
      lastDate: DateTime(DateTime.now().year ),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Colors.lightBlueAccent,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          dialogBackgroundColor: Colors.white,
        ),
        child: child ?? const Text(''),
      ),
    );
    if(newDate ==null ){
      return;
    }
    setState(() {
      dateController.text = newDate.toString();
    });


  }*/