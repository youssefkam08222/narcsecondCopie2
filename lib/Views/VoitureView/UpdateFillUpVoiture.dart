import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:narcsecond/Models/fillUpModel.dart';
import 'package:narcsecond/Views/AlertDialog/showInfoAddFillUpAttachementDialog.dart';
import 'package:narcsecond/Views/VoitureView/CarburantDetail.dart';
import '../../Globals/globals.dart';
import '../../Models/voitureModel.dart';
import '../../Services/firebase_api.dart';
import '../../Services/voitureService.dart';
import '../AlertDialog/ConfirmAlertDialog.dart';
import '../Components/DatePicker2.dart';
import '../Components/FullScreenImage.dart';
import '../Components/SelectImage.dart';
import 'package:intl/intl.dart';

class UpdateFillUpVoiture extends StatefulWidget {
  VoitureModel v;
  FillUpModel f;

  @override
  State<StatefulWidget> createState() {
    return _UpdateFillUpVoiture(v, f);
  }

  UpdateFillUpVoiture(this.v, this.f, {super.key});
}

class _UpdateFillUpVoiture extends State<UpdateFillUpVoiture> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  FillUpModel fillUpModel = FillUpModel.empty();
  VoitureModel voiture = VoitureModel.empty();

  _UpdateFillUpVoiture(v, f) {
    voiture = v;
    fillUpModel = f;
  }

  TextEditingController dateController = TextEditingController();
  TextEditingController fillUpCostController = TextEditingController();

  //TextEditingController kilometrageController = TextEditingController();
  TextEditingController NotesController = TextEditingController();
  late File fileAttachement = File("");
  int toastDuration = 3;
  bool isButtonSaveSubmitted = false;
  bool _saving = false;
  bool _isUpdate = false;
  late String oldImgFillUpUrl;
  late String oldDate;

  DateTime? newDate;
  DateTime? dateTime;
  DateTime? dateToSave;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    //DateTime d= DateTime.parse('2023-12-31 10:27:36.878229');
    DateTime d = DateTime.parse(fillUpModel.dateFillUp);
    Intl.defaultLocale = 'fr';

    dateController = TextEditingController(text: DateFormat.yMMMd().format(d));
    fillUpCostController =
        TextEditingController(text: fillUpModel.costFillUp.toString());
    NotesController = TextEditingController(text: fillUpModel.fillUpNotes);
    newDate = DateTime.now().toLocal();
    oldImgFillUpUrl = fillUpModel.imgFillUpUrl;
    oldDate = fillUpModel.dateFillUp;
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
    TextStyle? textStyle = Theme.of(context).textTheme.titleSmall;

    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CarburantDetail(voiture)),
          );
          return false; // Return false to prevent the default back button behavior
        },
        child: Scaffold(
            appBar: AppBar(
              title: const Center(child: Text("Details")),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                // Custom icon for the return button
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CarburantDetail(voiture)));
                },
              ),
              actions: [
                PopupMenuButton(
                  onSelected: (value) async {
                    if (value == AppBarOptions.update.index) {
                      setState(() {
                        _isUpdate = true;
                      });
                    } else if (value == AppBarOptions.delete.index) {
                      bool? userChoice = await confirmAlertDialog(
                          "Supprimer operation",
                          "Est ce que vous etes sur de supprimer cette operation de carburant ?",
                          context);
                      if (userChoice != null && userChoice) {
                        Future.delayed(const Duration(seconds: 1), () async {
                          setState(() {
                            _saving = true;
                          });
                          await deleteVoitureFillUpByVoiture(voiture,fillUpModel, context);
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
                    _buildPopupMenuItem('Mettre a jour', Icons.update,
                        AppBarOptions.update.index),
                    _buildPopupMenuItem(
                        'Supprimer', Icons.delete, AppBarOptions.delete.index),
                  ],
                )
              ],
            ),
            body: ModalProgressHUD(
              progressIndicator: const CircularProgressIndicator(
                  color: Colors.blue, backgroundColor: Colors.transparent),
              inAsyncCall: _saving,
              child: Container(
                color: Colors.black12,
                child: Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: minimumPadding * 2,
                        left: minimumPadding * 2,
                        right: minimumPadding * 2),
                    child: ListView(
                      controller: _scrollController,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16.0)),
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              100,
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
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (voiture.voitureTypeSerie == "تونس")
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
                                                              FontWeight.w400,
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
                                                              FontWeight.w400,
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
                                                              FontWeight.w400,
                                                          fontSize: 15.0),
                                                    ),
                                              ),
                                            ],
                                          ),
                                        if (voiture.voitureTypeSerie != "تونس")
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
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                                "${voiture.voitureMake} ${voiture.voitureMakeYear} ${voiture.voitureModele} "),
                          ),
                        ),
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
                              if (_isUpdate) {
                                newDate = await showDatePicker2Dialog(
                                    DateTime.now(), context);
                                // newDate = await showDatePickerDialog(newDate!,context) ;
                                if (newDate != null) {
                                  final formattedDate =
                                      DateFormat.yMMMMd().format(newDate!);
                                  setState(() {
                                    dateController.text = formattedDate;
                                    oldDate = "";
                                    print("new date $newDate");
                                  });
                                }
                              }
                            },
                            child: AbsorbPointer(
                              absorbing: true,
                              child: TextFormField(
                                enabled: _isUpdate,
                                textAlign: TextAlign.center,
                                controller: dateController,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 12.0),
                                    labelText: _isUpdate
                                        ? 'Coisir une date'
                                        : "Date de l'operation",
                                    labelStyle: const TextStyle(fontSize: 14),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0)),
                                    suffixIcon: const Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.calendar_month,
                                          size: 35,
                                          color: Colors.blueAccent,
                                        ),
                                        onPressed: null,
                                      ),
                                    )),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: minimumPadding, bottom: minimumPadding),
                          child: TextFormField(
                            enabled: _isUpdate,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(7),
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              //MaskedInputFormatter('000 000 000 000 000 000 000'),
                            ],
                            style:
                                const TextStyle(fontWeight: FontWeight.normal),
                            controller: fillUpCostController,
                            onChanged: (value) {
                              if (isButtonSaveSubmitted) {
                                _formKey.currentState!.validate();
                              }
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Entrer le montant que vous avez payé dans cette operation";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 12.0),
                                labelText: "Montant de l'operation",
                                hintText: 'Entrer le montant convenable',
                                labelStyle: const TextStyle(fontSize: 14),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(25.0)),
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Image.asset(
                                    "assets/images/tnd.png",
                                    color: Colors.blueAccent,
                                  ),
                                )),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                                top: minimumPadding, bottom: minimumPadding),
                            child: TextFormField(
                              enabled: _isUpdate,
                              style: textStyle,
                              controller: NotesController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              expands: false,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 12.0),
                                  labelText: 'Notes',
                                  hintText: 'Entrer des notes',
                                  labelStyle:
                                      TextStyle(fontWeight: FontWeight.normal),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(25.0))),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: minimumPadding, bottom: minimumPadding),
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(width: 1),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black12, spreadRadius: 0),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    bottom: minimumPadding * 2,
                                    left: minimumPadding * 2,
                                    right: minimumPadding * 2),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: minimumPadding, top: 2),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              _isUpdate
                                                  ? "Ajouter un fichier joint "
                                                  : "Votre fichier join:",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue)),
                                          if (_isUpdate)
                                            Row(
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                        Icons.info_outline,
                                                        color: Colors.blue,
                                                        size: 40,
                                                      ),
                                                      onPressed: () {
                                                        showInfoAddFillUpAttachementDialog(
                                                            context);
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                      },
                                                    ),
                                                    const Text(
                                                      'Cliquer ici',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Material(
                                                color: Colors.transparent,
                                                elevation: 0.1,
                                                clipBehavior:
                                                    Clip.antiAliasWithSaveLayer,
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                child: InkWell(
                                                  splashColor: Colors.black26,
                                                  onTap: () async {
                                                    if (_isUpdate) {
                                                      File f =
                                                          (await getImageFile(
                                                              context));
                                                      setState(() {
                                                        if (f.path != "") {
                                                          fileAttachement = f;
                                                        }
                                                      });
                                                    }
                                                  },
                                                  child: Column(
                                                    children: [
                                                      fileAttachement.path ==
                                                                  '' &&
                                                              oldImgFillUpUrl
                                                                  .isEmpty
                                                          ? Stack(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              children: [
                                                                Ink.image(
                                                                  image: const AssetImage(
                                                                      "assets/images/facture.jpg"),
                                                                  height: 200,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                                Image.asset(
                                                                    'assets/images/cameragif.gif',
                                                                    colorBlendMode:
                                                                        BlendMode
                                                                            .dstIn,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    height: 200,
                                                                    color: Colors
                                                                        .red
                                                                        .withOpacity(
                                                                            0.8)),
                                                              ],
                                                            )
                                                          : oldImgFillUpUrl
                                                                  .isNotEmpty
                                                              ? GestureDetector(
                                                                  onTap: () {
                                                                    if (!_isUpdate &&
                                                                        oldImgFillUpUrl
                                                                            .isNotEmpty) {
                                                                      Navigator.of(
                                                                              context)
                                                                          .push(
                                                                              MaterialPageRoute(builder: (context) => FullScreenImage(imageUrl: oldImgFillUpUrl)));
                                                                    }
                                                                  },
                                                                  child: Stack(
                                                                    children: [
                                                                      Image
                                                                          .network(
                                                                        oldImgFillUpUrl,
                                                                        height:
                                                                            200,
                                                                        width: MediaQuery.of(context)
                                                                            .size
                                                                            .width,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      ),
                                                                      if (_isUpdate)
                                                                        Positioned(
                                                                          bottom:
                                                                              1,
                                                                          right:
                                                                              1,
                                                                          child:
                                                                              IconButton(
                                                                            icon:
                                                                                const Icon(
                                                                              Icons.delete,
                                                                              size: 40,
                                                                              color: Colors.red,
                                                                            ),
                                                                            onPressed:
                                                                                () {
                                                                              setState(() {
                                                                                oldImgFillUpUrl = "";
                                                                                fileAttachement = File("");
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : Stack(
                                                                  children: [
                                                                    Image.file(
                                                                      File(fileAttachement
                                                                          .path),
                                                                      height:
                                                                          200,
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                    if (_isUpdate)
                                                                    Positioned(
                                                                      bottom: 1,
                                                                      right: 1,
                                                                      child:
                                                                          IconButton(
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .delete,
                                                                          size:
                                                                              40,
                                                                          color:
                                                                              Colors.red,
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            fileAttachement =
                                                                                File("");
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
                                ),
                              )),
                        ),
                        // Form Submit
                        if (_isUpdate)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, bottom: 8),
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
                                  Icon(Icons.update_sharp, size: 30),
                                  // Add the desired icon here
                                  SizedBox(width: 10),
                                  Text(
                                    'Mettre a jour',
                                    style: TextStyle(fontSize: 30),
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                FocusManager.instance.primaryFocus?.unfocus();
                                setState(() {
                                  isButtonSaveSubmitted = true;
                                });
                                if (_formKey.currentState!.validate()) {
                                  Future.delayed(const Duration(seconds: 1), () async {
                                    setState(() {
                                      _saving = true;
                                    });
                                    if (oldDate.isEmpty) {
                                      dateToSave = DateFormat('d MMMM yyyy', 'fr_FR').parse(dateController.text);
                                      //DateTime d = DateTime.parse(fillUpModel.dateFillUp);
                                      dateToSave = DateTime(dateToSave!.year, dateToSave!.month, dateToSave!.day, DateTime.now().hour, DateTime.now().minute, DateTime.now().second, DateTime.now().millisecond);
                                    }

                                    int cout = int.parse(fillUpCostController.text);
                                    String notes = NotesController.text;
                                    String imgFillUpName = fillUpModel.imgFillUpName;
                                    String imgFillUpUrl = fillUpModel.imgFillUpUrl;
                                    if (fileAttachement.path.isNotEmpty) {
                                      imgFillUpName = fillUpModel.imgFillUpName.isNotEmpty ? fillUpModel.imgFillUpName : oldDate.isNotEmpty ? oldDate : dateToSave.toString() ;
                                      imgFillUpUrl = await FirebaseApi.firebaseUploadImage(fileAttachement, "$imgFillUpName.jpeg",
                                                  "${voiture.voitureSerie}${voiture.voitureTypeSerie}/fillup") ?? "";
                                    } else if (oldImgFillUpUrl.isEmpty && fillUpModel.imgFillUpUrl.isNotEmpty) {
                                      await FirebaseApi.firebaseDeleteImage("${fillUpModel.imgFillUpName}.jpeg", "${voiture.voitureSerie}${voiture.voitureTypeSerie}/fillup");
                                      imgFillUpName = "";
                                      imgFillUpUrl = "";
                                    }
                                    FillUpModel fillUpmodelToUpdate =
                                        FillUpModel(
                                            fillUpId: fillUpModel.fillUpId,
                                            dateFillUp: oldDate.isNotEmpty
                                                ? oldDate
                                                : dateToSave.toString(),
                                            costFillUp: cout,
                                            imgFillUpName: imgFillUpName,
                                            imgFillUpUrl: imgFillUpUrl,
                                            fillUpNotes: notes);

                                    //print("new date $newDate");
                                    //print("save = ${fillUpmodelToUpdate.toJson()}");
                                    await updateVoitureFillUpByVoiture(
                                        voiture, fillUpmodelToUpdate, context);

                                    setState(() {
                                      _isUpdate = false;
                                      _saving = false;
                                    });
                                  });
                                } else {
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
            ))
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
