import 'dart:convert';
import 'dart:io';
import 'dart:convert' as convert;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../../Globals/globals.dart';
import '../../Models/voitureModel.dart';
import '../../Services/firebase_api.dart';
import '../../Services/voitureService.dart';
import '../AlertDialog/AfterActionAlertDialog.dart';
import '../AlertDialog/InfoAlertDialog.dart';
import '../Components/SelectImage.dart';
import '../Components/Toast.dart';

class updateVoiture extends StatefulWidget {
  VoitureModel voiture;
  @override
  State<StatefulWidget> createState() {
    //print("update.dartcreatestate " +voiture.toJson().toString());
    return updateVoitureState(voiture);
  }
  updateVoiture(this.voiture);
}

class updateVoitureState extends State<updateVoiture> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  TextEditingController searchEditingController = TextEditingController();
  TextEditingController voitureLeftImmatController = TextEditingController();
  TextEditingController voitureRightImmatController = TextEditingController();
  TextEditingController voiturefullImmatController = TextEditingController();
  TextEditingController voitureKilometrageController = TextEditingController();
  TextEditingController NotesController = TextEditingController();
  late File fileImgVoiture = File("");
  late File fileImgAssurance = File("");
  late File fileImgVisite = File("");
  late File fileImgTax = File("");
  late File fileImgFaceCarteGrise = File("");
  late File fileImgDosCarteGrise = File("");
  String? selectedMakeValue;
  String? selectedMakeYearValue;
  String? selectedCarModelValue;
  List<String> makesList = [];
  List<String> makeYearsListbyMake = [];
  List<String> carModelListbyMakeYears = [];
  List<String> voituresSeriesList = [];
  String? selectedTypeImmatriculationValue;
  String? selectedTypeCarburantValue;
  bool isMarqueSelected = false;
  bool isMakeYearsSelected = false;
  bool isModelSelected = false;
  bool _isTypeImmatSelected=false;
  String? ImgVoitureUrl="";
  String? ImgFaceCarteGriseUrl="";
  String? ImgDosCarteGriseUrl="";
  String? ImgAssuranceUrl="";
  String? ImgTaxUrl="";
  String? ImgVisiteUrl="";
  int toastDuration=3;
  String leftImmatValue = '';
  //String rightImmatValue = '';
  //String fullImmatValue = '';
  late String ImmatValueToSave ;
  bool isButtonSaveSubmitted = false;
  bool ImmatExists=false;
  bool _saving = false;
  late File file = File("");
  String? voitureID="";
  String oldImmatNumber="";

  late File image = File("");
  String? OldSelectedTypeImmatriculationValue;


  updateVoitureState(voiture)  {
    voitureID = voiture.voitureId;
    ImgVoitureUrl = voiture.imgVoitureUrl;
    selectedMakeValue = voiture.voitureMake;
    selectedMakeYearValue = voiture.voitureMakeYear;
    selectedCarModelValue = voiture.voitureModele;
    selectedTypeImmatriculationValue = voiture.voitureTypeSerie;
    OldSelectedTypeImmatriculationValue = voiture.voitureTypeSerie;
    if (selectedTypeImmatriculationValue == "تونس") {
      voitureLeftImmatController = TextEditingController(
          text: voiture.voitureSerie.substring(
              0, voiture.voitureSerie.indexOf('T')));
      voitureRightImmatController =
          TextEditingController(text: voiture.voitureSerie
              .split("T")
              .last);
    } else {
      voiturefullImmatController =
          TextEditingController(text: voiture.voitureSerie);
    }
    oldImmatNumber=voiture.voitureSerie;
    selectedTypeCarburantValue=voiture.voitureCarburant;
    voitureKilometrageController =
        TextEditingController(text: voiture.voitureKilometrage);
    NotesController = TextEditingController(text: voiture.voitureNotes);
     ImgVoitureUrl=voiture.imgVoitureUrl;
    ImgFaceCarteGriseUrl=voiture.imgFaceCarteGriseUrl;
    ImgDosCarteGriseUrl=voiture.imgDosCarteGriseUrl;
    ImgAssuranceUrl=voiture.imgAssuranceUrl;
    ImgTaxUrl=voiture.imgTaxUrl;
    ImgVisiteUrl=voiture.imgVisiteUrl;


  }
  void getMakesList() async{
    List<String> l= await getAllMakes ();
    setState(() {
      makesList=l;
    });
  }
  void getYearsList(value) async{
    List<String> l= await getAllMakeyears (selectedMakeValue);
    setState(() {
      makeYearsListbyMake=l;
    });
  }
  void getAllModelsList(value1,value2) async{
    List<String> l= await getAllModels (value1,value2);
    setState(() {
      carModelListbyMakeYears=l;
    });
  }
  final ScrollController _scrollController = ScrollController();

  void _focusOnPosition() {
    // Scroll to the desired position
    _scrollController.animateTo(
      _scrollController.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    getMakesList ();
    getYearsList(selectedMakeValue);
    getAllModelsList(selectedMakeValue,selectedMakeYearValue);
    _isTypeImmatSelected=true;
    fToast = FToast();
    fToast.init(context);
    super.initState();
  }
  @override
  void dispose() {
    searchEditingController.dispose();
    super.dispose();
  }

  /*showImage(String image) {
    return Image.memory(base64Decode(image));
  }*/

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = Theme
        .of(context)
        .textTheme
        .titleSmall;
    return Scaffold(
      appBar: AppBar(
        title: Text("Modifier voiture"),
      ),
      body: ModalProgressHUD(
          progressIndicator: const CircularProgressIndicator(color: Colors.blue,backgroundColor: Colors.red),
          inAsyncCall: _saving,
          child:Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(minimumPadding * 2),
              child: ListView(
                controller: _scrollController,
                children: <Widget>[
                ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      "Scanner un code QR pour copier une voiture",
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Icon(
                      Icons.qr_code,
                      size: 24.0,
                      color: Colors.blue,
                    )
                  ],
                ),
                onPressed: () async {


                },
              ),
                const Divider(
                color: Colors.black,

                height: 25,
                thickness: 2,
                indent: 5,
                endIndent: 5,
              ),
                // Image picker
                Center(
                  child: Material(
                    color: Colors.blue,
                    elevation: 8,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      splashColor: Colors.black26,
                      onTap: () async {
                        File f=(await getImageFile(context));
                        setState(() {
                        if(f.path!="")
                          {
                            fileImgVoiture=f;
                            ImgVoitureUrl='';
                          }
                        });
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          fileImgVoiture.path == '' && ImgVoitureUrl==""
                              ? Ink.image(
                            image: const AssetImage(
                                'assets/images/image_placeholder.png'),
                            height: 150,
                            width: MediaQuery.of(context).size.width-100,
                            fit: BoxFit.cover,
                          )
                          : fileImgVoiture.path == '' && ImgVoitureUrl!=""
                              ? Stack(
                            children: [
                              Image.network(
                                ImgVoitureUrl!,
                                height: 150,
                                width: MediaQuery.of(context).size.width-100,
                                fit: BoxFit.fill,
                              ),
                              Positioned(
                                bottom: 1,
                                right: 1,
                                child: IconButton(
                                  icon: const Icon(Icons.delete,size: 40,color: Colors.red,),
                                  onPressed: () {
                                    setState(() {
                                      ImgVoitureUrl='';
                                      fileImgVoiture=File("");
                                    });
                                  },
                                ),
                              ),
                            ],
                          )
                          :Stack(
                            children: [
                              Image.file(
                                File(fileImgVoiture.path),
                                height: 150,
                                width: MediaQuery.of(context).size.width-100,
                                fit: BoxFit.fill,
                              ),
                              Positioned(
                                bottom: 1,
                                right: 1,
                                child: IconButton(
                                  icon: const Icon(Icons.delete,size: 40,color: Colors.red,),
                                  onPressed: () {
                                    setState(() {
                                      fileImgVoiture=File("");
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(top: 5),
                    child: isButtonSaveSubmitted && fileImgVoiture.path == '' && ImgVoitureUrl==''
                        ? const Text("Ajouter la photo de votre voiture",
                        style: TextStyle(color: Colors.red,fontSize: 12.0,))
                        :const SizedBox.shrink(),
                  ),
                const SizedBox(height: 15),
                // Car make DropdownButtonFormField
                Padding(
                  padding: const EdgeInsets.only(
                    top: minimumPadding, bottom: minimumPadding),
                  child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField2(
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                    isExpanded: true,
                    hint: const Text(
                      'Selectionner la marque de votre véhicule',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    items: makesList
                        .map((item) =>
                        DropdownMenuItem<String>(
                            value: item, child: Text(item)))
                        .toList(),
                    value: selectedMakeValue,
                    validator: (value) {
                      if (value == null) {
                        return "Selectionner la Marque de votre voiture";
                      }return null;
                    },
                    onChanged: (value) async {
                      if (isButtonSaveSubmitted) {
                        _formKey.currentState!.validate();
                      }
                      makeYearsListbyMake= await getAllMakeyears (selectedMakeValue);
                      setState(()  {
                        selectedMakeYearValue=null;
                        selectedMakeValue = value as String;
                        print("selectedMakeValue " + selectedMakeValue!);
                        isMarqueSelected = true;
                        selectedCarModelValue=null;
                        carModelListbyMakeYears = [];
                        isMakeYearsSelected = false;
                        isModelSelected=false;
                      });
                    },
                    buttonStyleData: const ButtonStyleData(
                      height: 50,
                    ),
                    dropdownStyleData: const DropdownStyleData(
                      maxHeight: 200,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                    ),
                    dropdownSearchData: DropdownSearchData(
                      searchController: searchEditingController,
                      searchInnerWidgetHeight: 50,
                      searchInnerWidget: Container(
                        height: 50,
                        padding: const EdgeInsets.only(
                          top: 8,
                          bottom: 4,
                          right: 8,
                          left: 8,
                        ),
                        child: TextFormField(
                          expands: true,
                          maxLines: null,
                          controller: searchEditingController,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            hintText: 'Cherecher...',
                            hintStyle: const TextStyle(fontSize: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      searchMatchFn: (item, searchValue) {
                        return (item.value.toString().contains(searchValue));
                      },
                    ),
                    //This to clear the search value when you close the menu
                    onMenuStateChange: (isOpen) {
                      if (!isOpen) {
                        searchEditingController.clear();
                      }
                    },
                  ),
                ),
              ),
                // Car makeYear DropdownButtonFormField
                Padding(
                    padding: const EdgeInsets.only(
                        top: minimumPadding, bottom: minimumPadding),
                    child: DropdownButtonHideUnderline(
                        child: GestureDetector(
                          onTap: (){
                            if(selectedMakeValue == null){
                              fToast.showToast(
                                child: toastM(
                                    "Il faut selectionner la marque du véhicule",Colors.red),
                                gravity:
                                ToastGravity
                                    .BOTTOM,
                                toastDuration:
                                Duration(
                                    seconds:
                                    toastDuration),
                              );
                            }
                          },
                          child: DropdownButtonFormField2<String>(
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            isExpanded: true,
                            hint: const Text(
                              "Selectionner l'annee de creation de votre véhicule",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            items: makeYearsListbyMake
                                .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            ))
                                .toList(),
                            value: selectedMakeYearValue,
                            validator: (value) {
                              if (value==null) {
                                return "Selectionner l'annee de creation de votre voiture";
                              }return null;
                            },
                            onChanged: (value) {
                              if (isButtonSaveSubmitted) {
                                _formKey.currentState!.validate();
                              }
                              setState(() {
                                selectedCarModelValue=null;
                                carModelListbyMakeYears = [];
                                selectedMakeYearValue = value as String;
                                print("selectedMakeYearValue " + selectedMakeYearValue!);
                                isMakeYearsSelected = true;
                                isModelSelected=false;
                                getAllModelsList (selectedMakeValue, selectedMakeYearValue);
                              });
                            },
                            buttonStyleData: const ButtonStyleData(
                              height: 50,
                            ),
                            dropdownStyleData: const DropdownStyleData(
                              maxHeight: 200,
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                            ),
                            dropdownSearchData: DropdownSearchData(
                              searchController: searchEditingController,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: Container(
                                height: 50,
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                  right: 8,
                                  left: 8,
                                ),
                                child: TextFormField(
                                  expands: true,
                                  maxLines: null,
                                  controller: searchEditingController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    hintText: 'Cherecher...',
                                    hintStyle: const TextStyle(fontSize: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              searchMatchFn: (item, searchValue) {
                                return (item.value.toString().toLowerCase().contains(searchValue));
                              },
                            ),
                            //This to clear the search value when you close the menu
                            onMenuStateChange: (isOpen) {
                              if (!isOpen) {
                                searchEditingController.clear();
                              }
                            },
                          ),
                        )
                    ),
                  ),
                // Car model DropdownButtonFormField
                Padding(
                    padding:  EdgeInsets.only(
                        top: minimumPadding, bottom: minimumPadding),
                    child: DropdownButtonHideUnderline(
                        child: GestureDetector(
                          onTap: (){
                            if(selectedMakeYearValue == null){
                              fToast.showToast(
                                child: toastM(
                                    "Il faut selectionner l'année de création du véhicule",Colors.red),
                                gravity:
                                ToastGravity
                                    .BOTTOM,
                                toastDuration:
                                Duration(
                                    seconds:
                                    toastDuration),
                              );
                            }
                          },
                          child: DropdownButtonFormField2<String>(
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                )),
                            isExpanded: true,
                            hint: const Text(
                              'Selectionner le modele de votre véhicule',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            items: carModelListbyMakeYears
                                .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            ))
                                .toList(),
                            value: selectedCarModelValue,
                            validator: (value) {
                              if (value == null) {
                                return "Selectionner le Modele de votre voiture";
                              }return null;
                            },
                            onChanged: (value) {
                              if (isButtonSaveSubmitted) {
                                _formKey.currentState!.validate();
                              }
                              setState(() {
                                selectedCarModelValue = value as String;
                                isModelSelected=true;
                              });
                            },
                            buttonStyleData: const ButtonStyleData(
                              height: 50,
                            ),
                            dropdownStyleData: const DropdownStyleData(
                              maxHeight: 200,
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                            ),
                            dropdownSearchData: DropdownSearchData(
                              searchController: searchEditingController,
                              searchInnerWidgetHeight: 50,
                              searchInnerWidget: Container(
                                height: 50,
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 4,
                                  right: 8,
                                  left: 8,
                                ),
                                child: TextFormField(
                                  expands: true,
                                  maxLines: null,
                                  controller: searchEditingController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 8,
                                    ),
                                    hintText: 'Cherecher...',
                                    hintStyle: const TextStyle(fontSize: 12),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ),
                              searchMatchFn: (item, searchValue) {
                                return (item.value.toString().toLowerCase().contains(searchValue));
                              },
                            ),
                            //This to clear the search value when you close the menu
                            onMenuStateChange: (isOpen) {
                              if (!isOpen) {
                                searchEditingController.clear();
                              }
                            },
                          ),
                        )
                    ),
                  ),
                // Immatriculation type DropdownButtonFormField
                Padding(
                padding: const EdgeInsets.only(
                    top: minimumPadding, bottom: minimumPadding),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField2<String>(
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        )),
                    isExpanded: true,
                    hint: const Text(
                      "Choisir le type d'immatriculation de votre voiture",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    items: voituresTypesImmatriculationList
                        .map((item) =>
                        DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ))
                        .toList(),
                    value: selectedTypeImmatriculationValue,
                    validator: (value) {
                      if (value == null) {
                        return "Selectionner le type d'immatriculation de votre voiture";
                      }
                    },
                    onChanged: (value)  {

                      leftImmatValue="";
                      //rightImmatValue="";
                      //fullImmatValue="";
                      if (isButtonSaveSubmitted) {
                        _formKey.currentState!.validate();
                      }
                      setState(() {
                        selectedTypeImmatriculationValue = value as String;
                        _isTypeImmatSelected=true;
                        voitureLeftImmatController=TextEditingController();
                        voitureRightImmatController=TextEditingController();
                        voiturefullImmatController=TextEditingController();
                      });
                      print("Selected= $selectedTypeImmatriculationValue");
                      print("object= $voituresSeriesList");

                    },
                    buttonStyleData: const ButtonStyleData(
                      height: 50,
                    ),
                    dropdownStyleData: const DropdownStyleData(
                      maxHeight: 200,
                    ),
                    menuItemStyleData: const MenuItemStyleData(
                      height: 40,
                    ),
                  ),
                ),
              ),
              if(selectedTypeImmatriculationValue.toString() == "تونس")
                Padding(
                  padding:  const EdgeInsets.only(
                      top: minimumPadding),
                  child:Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius:BorderRadius.circular(5.0)
                              ),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(3),
                                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                                        ],
                                        onChanged: (value){
                                          setState(() {
                                            //leftImmatValue=value;
                                            ImmatExists=false;
                                          });
                                        },
                                        //maxLength: 3,
                                        //maxLengthEnforcement: MaxLengthEnforcement.enforced,
                                        style: textStyle,
                                        controller: voitureLeftImmatController,
                                        decoration: const InputDecoration(
                                            hintText: "000",
                                            border: InputBorder.none,
                                            errorStyle: TextStyle(height: 0)
                                        ),
                                      ),
                                    ),
                                    const Expanded(
                                      child: Center(
                                        child: Text("تونس"),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        textAlign: TextAlign.center,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(4),
                                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                                        ],
                                        style: textStyle,
                                        controller: voitureRightImmatController,
                                        onChanged: (value) {
                                          setState(() {
                                            ImmatExists=false;
                                            //rightImmatValue = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          hintText: '0000',
                                          labelStyle: textStyle,
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),

                                  ])
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child:  voitureLeftImmatController.text.isNotEmpty && voitureRightImmatController.text.isNotEmpty && isButtonSaveSubmitted
                                ? const SizedBox.shrink()
                                :isButtonSaveSubmitted
                                ? Text(validateRow(voitureLeftImmatController.text, voitureRightImmatController.text) ?? '',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12.0,),)

                                : const SizedBox.shrink(),
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(vertical: 0.5),
                              child:  ImmatExists== false
                                  ? const SizedBox.shrink()
                                  :const Text("Changer le numero car il existe deja !",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12.0,),)
                          ),
                        ],
                      )
                  ),
                ),
              if(selectedTypeImmatriculationValue.toString() != "تونس" && _isTypeImmatSelected)
                Padding(
                  padding: const EdgeInsets.only(
                      top: minimumPadding),
                  child: Center(
                    //heightFactor: 1.1,
                      child:  Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius:BorderRadius.circular(5.0)
                            ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      inputFormatters: [new LengthLimitingTextInputFormatter(6),
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                                      style: textStyle,
                                      controller: voiturefullImmatController,
                                      onChanged: (value){
                                        setState(() {
                                          //fullImmatValue=value;
                                          ImmatExists=false;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        hintText: '000000',
                                        labelStyle: textStyle,
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child:  Center(
                                      child: Text(selectedTypeImmatriculationValue.toString()),
                                    ),
                                  ),
                                ]),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: voiturefullImmatController.text.isNotEmpty && isButtonSaveSubmitted
                                ? const SizedBox.shrink()
                                :isButtonSaveSubmitted
                                ? Text(
                              validateRow(voiturefullImmatController.text,"doesntmatter") ?? '',
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12.0,),)
                                :const SizedBox.shrink(),
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(vertical: 0.5),
                              child:  ImmatExists== false
                                  ? const SizedBox.shrink()
                                  :const Text("Changer le numero car il existe deja !",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 12.0,),)
                          ),
                        ],
                      )
                  ),
                ),
                // Type Carburant DropdownButtonFormField
                Padding(
                      padding: const EdgeInsets.only(
                          top: minimumPadding, bottom: minimumPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButtonFormField2<String>(
                              decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  )),
                              isExpanded: true,
                              hint: const Text(
                                "Choisir le type du carburant de votre voiture",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              items: voituresTypesCarburantList
                                  .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              ))
                                  .toList(),
                              value: selectedTypeCarburantValue,
                              validator: (value) {
                                if (value == null) {
                                  return "Selectionner le type du carburant de votre voiture";
                                }return null;
                              },
                              onChanged: (value) {
                                if (isButtonSaveSubmitted) {
                                  _formKey.currentState!.validate();
                                }
                                setState(() {
                                  selectedTypeCarburantValue = value as String;
                                });
                                print("Selected= "+selectedTypeCarburantValue.toString());
                              },
                              buttonStyleData: const ButtonStyleData(
                                height: 50,
                              ),
                              dropdownStyleData: const DropdownStyleData(
                                maxHeight: 200,
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 40,
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                // Number of kilometers TextFormField
                Padding(
                    padding: const EdgeInsets.only(
                        top: minimumPadding, bottom: minimumPadding),
                    child: TextFormField(
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(7),
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        //MaskedInputFormatter('000 000 000 000 000 000 000'),
                      ],
                      style: TextStyle(fontWeight: FontWeight.normal),
                      controller: voitureKilometrageController,
                      onChanged: (value) {
                        if (isButtonSaveSubmitted) {
                          _formKey.currentState!.validate();
                        }
                      },
                      validator: ( value) {
                        if (value!.isEmpty) {
                          return "Entrer le numero du kilométrage de votre voiture";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Nombre du kilométrage',
                        hintText: 'Entrer le numero du kilométrage de votre voiture',
                        labelStyle: TextStyle(fontWeight: FontWeight.normal),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)),),
                    ),
                  ),
                // Notes TextFormField
                Padding(
                      padding: EdgeInsets.only(
                          top: minimumPadding, bottom: minimumPadding),
                      child: TextFormField(
                        style: textStyle,
                        controller: NotesController,
                        /*validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Entrer des notes';
                      }
                    },*/
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        expands: false,
                        decoration: InputDecoration(
                            labelText: 'Notes',
                            hintText:
                            'Entrer des notes',
                            labelStyle: TextStyle(fontWeight: FontWeight.normal),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      )
                  ),
                // Documents Images
                Padding(
                    padding: EdgeInsets.only(top: minimumPadding,bottom: minimumPadding),
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(width: 1),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, spreadRadius: 0),
                          ],
                        ),
                        child:Padding(
                          padding: EdgeInsets.all(minimumPadding),
                          child: Column(
                            children: [
                              Padding(padding: EdgeInsets.all(minimumPadding),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:  [
                                    Text("Documents",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.indigo)),
                                    IconButton(
                                      icon:  const Icon(Icons.info_outline,color: Colors.blue,size: 40,),
                                      onPressed: () {
                                        showInfoDialog(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.grey,
                                          border: Border.all(width: 1),
                                          boxShadow: const [
                                            BoxShadow(color: Colors.transparent, spreadRadius: 1),
                                          ],
                                        ),
                                        padding: EdgeInsets.all(minimumPadding),
                                        child:Column(
                                          children: [
                                            const FittedBox(
                                              fit: BoxFit.cover,
                                              child: Text(
                                                  "Face du carte grise",
                                                  style:
                                                  TextStyle(
                                                      color: Colors
                                                          .indigo,
                                                      fontSize: 12
                                                  )),
                                            ),
                                            const SizedBox(height: 5,),
                                            Material(
                                              color: Colors.transparent,
                                              elevation: 0,
                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                              borderRadius: BorderRadius.circular(20),
                                              child: InkWell(
                                                splashColor: Colors.black26,
                                                onTap: () async {
                                                  File f=(await getImageFile(context));
                                                  setState(() {
                                                    if(f.path!="")
                                                    {
                                                      fileImgFaceCarteGrise=f;
                                                      ImgFaceCarteGriseUrl="";
                                                    }
                                                  });
                                                },
                                                child: Column(
                                                  children: [
                                                    fileImgFaceCarteGrise.path.isEmpty && ImgFaceCarteGriseUrl!.isEmpty
                                                        ? Ink.image(
                                                      image: const AssetImage(
                                                          'assets/images/image_placeholder.png'),
                                                      height: 100,
                                                      width: double.infinity,
                                                      fit: BoxFit.fill,
                                                    )
                                                        :  fileImgFaceCarteGrise.path.isEmpty  && ImgFaceCarteGriseUrl!.isNotEmpty
                                                        ? Stack(
                                                      children: [
                                                        Image.network(
                                                          ImgFaceCarteGriseUrl!,
                                                          height: 100,
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
                                                                ImgFaceCarteGriseUrl='';
                                                                fileImgFaceCarteGrise=File("");
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                        :Stack(
                                                      children: [
                                                        Image.file(
                                                          File(fileImgFaceCarteGrise.path),
                                                          height: 100,
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
                                                                ImgFaceCarteGriseUrl='';
                                                                fileImgFaceCarteGrise=File("");

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
                                        )
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  Expanded(
                                    child:Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.grey,
                                          border: Border.all(width: 1),
                                          boxShadow: const [
                                            BoxShadow(color: Colors.transparent, spreadRadius: 3),
                                          ],
                                        ),
                                        padding: EdgeInsets.all(minimumPadding),
                                        child:Column(
                                          children: [
                                            const FittedBox(
                                              fit: BoxFit.cover,
                                              child: Text(
                                                  "Dos du carte grise",
                                                  style:
                                                  TextStyle(
                                                      color: Colors
                                                          .indigo,
                                                      fontSize: 12
                                                  )),
                                            ),
                                            const SizedBox(height: 5,),
                                            Material(
                                              color: Colors.transparent,
                                              elevation: 0,
                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                              borderRadius: BorderRadius.circular(20),
                                              child: InkWell(
                                                splashColor: Colors.black26,
                                                onTap: () async {
                                                  File f=(await getImageFile(context));
                                                  setState(() {
                                                    if(f.path!="")
                                                    {
                                                      fileImgDosCarteGrise=f;
                                                      ImgDosCarteGriseUrl="";
                                                    }
                                                  });
                                                },
                                                child: Column(
                                                  children: [
                                                    fileImgDosCarteGrise.path.isEmpty && ImgDosCarteGriseUrl!.isEmpty
                                                        ? Ink.image(
                                                      image: const AssetImage(
                                                          'assets/images/image_placeholder.png'),
                                                      height: 100,
                                                      width: double.infinity,
                                                      fit: BoxFit.fill,
                                                    )
                                                        :  fileImgDosCarteGrise.path.isEmpty  && ImgDosCarteGriseUrl!.isNotEmpty
                                                        ? Stack(
                                                      children: [
                                                        Image.network(
                                                          ImgDosCarteGriseUrl!,
                                                          height: 100,
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
                                                                ImgDosCarteGriseUrl='';
                                                                fileImgDosCarteGrise=File("");
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                        :Stack(
                                                      children: [
                                                        Image.file(
                                                          File(fileImgDosCarteGrise.path),
                                                          height: 100,
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
                                                                ImgDosCarteGriseUrl='';
                                                                fileImgDosCarteGrise=File("");

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
                                        )
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.grey,
                                          border: Border.all(width: 1),
                                          boxShadow: const [
                                            BoxShadow(color: Colors.transparent, spreadRadius: 1),
                                          ],
                                        ),
                                        padding: EdgeInsets.all(minimumPadding),
                                        child:Column(
                                          children: [
                                            const FittedBox(
                                              fit: BoxFit.cover,
                                              child: Text(
                                                  "Assurance",
                                                  style:
                                                  TextStyle(
                                                      color: Colors
                                                          .indigo,
                                                      fontSize: 12
                                                  )),
                                            ),
                                            const SizedBox(height: 5,),
                                            Material(
                                              color: Colors.transparent,
                                              elevation: 0,
                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                              borderRadius: BorderRadius.circular(20),
                                              child: InkWell(
                                                splashColor: Colors.black26,
                                                onTap: () async {
                                                  File f=(await getImageFile(context));
                                                  setState(() {
                                                    if(f.path!="")
                                                    {
                                                      fileImgAssurance=f;
                                                      ImgAssuranceUrl="";
                                                    }
                                                  });
                                                },
                                                child: Column(
                                                  children: [
                                                    fileImgAssurance.path.isEmpty && ImgAssuranceUrl!.isEmpty
                                                        ? Ink.image(
                                                      image: const AssetImage(
                                                          'assets/images/image_placeholder.png'),
                                                      height: 100,
                                                      width: double.infinity,
                                                      fit: BoxFit.fill,
                                                    )
                                                        :  fileImgAssurance.path.isEmpty  && ImgAssuranceUrl!.isNotEmpty
                                                        ? Stack(
                                                      children: [
                                                        Image.network(
                                                          ImgAssuranceUrl!,
                                                          height: 100,
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
                                                                ImgAssuranceUrl='';
                                                                fileImgAssurance=File("");
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                        :Stack(
                                                      children: [
                                                        Image.file(
                                                          File(fileImgAssurance.path),
                                                          height: 100,
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
                                                                ImgAssuranceUrl='';
                                                                fileImgAssurance=File("");

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
                                        )
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  Expanded(
                                    child:Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.grey,
                                          border: Border.all(width: 1),
                                          boxShadow: const [
                                            BoxShadow(color: Colors.transparent, spreadRadius: 3),
                                          ],
                                        ),
                                        padding: EdgeInsets.all(minimumPadding),
                                        child:Column(
                                          children: [
                                            const FittedBox(
                                              fit: BoxFit.cover,
                                              child: Text(
                                                  "Tax/Vignette",
                                                  style:
                                                  TextStyle(
                                                      color: Colors
                                                          .indigo,
                                                      fontSize: 12
                                                  )),
                                            ),
                                            const SizedBox(height: 5,),
                                            Material(
                                              color: Colors.transparent,
                                              elevation: 0,
                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                              borderRadius: BorderRadius.circular(20),
                                              child: InkWell(
                                                splashColor: Colors.black26,
                                                onTap: () async {
                                                  File f=(await getImageFile(context));
                                                  setState(() {
                                                    if(f.path!="")
                                                    {
                                                      fileImgTax=f;
                                                      ImgTaxUrl="";
                                                    }
                                                  });
                                                },
                                                child: Column(
                                                  children: [
                                                    fileImgTax.path.isEmpty && ImgTaxUrl!.isEmpty
                                                        ? Ink.image(
                                                      image: const AssetImage(
                                                          'assets/images/image_placeholder.png'),
                                                      height: 100,
                                                      width: double.infinity,
                                                      fit: BoxFit.fill,
                                                    )
                                                        :  fileImgTax.path.isEmpty  && ImgTaxUrl!.isNotEmpty
                                                        ? Stack(
                                                      children: [
                                                        Image.network(
                                                          ImgTaxUrl!,
                                                          height: 100,
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
                                                                ImgTaxUrl='';
                                                                fileImgTax=File("");
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                        :Stack(
                                                      children: [
                                                        Image.file(
                                                          File(fileImgTax.path),
                                                          height: 100,
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
                                                                ImgTaxUrl='';
                                                                fileImgTax=File("");
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
                                        )
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  Expanded(
                                    child:Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.grey,
                                          border: Border.all(width: 1),
                                          boxShadow: const [
                                            BoxShadow(color: Colors.transparent, spreadRadius: 3),
                                          ],
                                        ),
                                        padding: EdgeInsets.all(minimumPadding),
                                        child:Column(
                                          children: [
                                            const FittedBox(
                                              fit: BoxFit.cover,
                                              child: Text(
                                                  "Visite",
                                                  style:
                                                  TextStyle(
                                                      color: Colors
                                                          .indigo,
                                                      fontSize: 12
                                                  )),
                                            ),
                                            const SizedBox(height: 5,),
                                            Material(
                                              color: Colors.transparent,
                                              elevation: 0,
                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                              borderRadius: BorderRadius.circular(20),
                                              child: InkWell(
                                                splashColor: Colors.black26,
                                                onTap: () async {
                                                  File f=(await getImageFile(context));
                                                  setState(() {
                                                    if(f.path!="")
                                                    {
                                                      fileImgVisite=f;
                                                      ImgVisiteUrl="";
                                                    }
                                                  });
                                                },
                                                child: Column(
                                                  children: [
                                                    fileImgVisite.path.isEmpty && ImgVisiteUrl!.isEmpty
                                                        ? Ink.image(
                                                      image: const AssetImage(
                                                          'assets/images/image_placeholder.png'),
                                                      height: 100,
                                                      width: double.infinity,
                                                      fit: BoxFit.fill,
                                                    )
                                                        :  fileImgVisite.path.isEmpty  && ImgVisiteUrl!.isNotEmpty
                                                        ? Stack(
                                                      children: [
                                                        Image.network(
                                                          ImgVisiteUrl!,
                                                          height: 100,
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
                                                                ImgVisiteUrl='';
                                                                fileImgVisite=File("");
                                                              });
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                        :Stack(
                                                      children: [
                                                        Image.file(
                                                          File(fileImgVisite.path),
                                                          height: 100,
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
                                                                ImgVisiteUrl='';
                                                                fileImgVisite=File("");
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
                                        )
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
                Padding(padding: const EdgeInsets.only(top: minimumPadding),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(fixedSize: const Size(150, 70)),
                  child: const Text('Mettre a jour',style: TextStyle(fontSize: 30),),
                  onPressed: () async {
                    FocusManager.instance.primaryFocus?.unfocus();
                    setState(() {
                      isButtonSaveSubmitted=true;
                    });
                    if(_formKey.currentState!.validate() && (fileImgVoiture.path!=""||ImgVoitureUrl!="") &&
                        (voiturefullImmatController.text.isNotEmpty|| (voitureLeftImmatController.text.isNotEmpty && voitureRightImmatController.text.isNotEmpty) ))
                    {
                      if (selectedTypeImmatriculationValue.toString() == "تونس") {
                        ImmatValueToSave = "${voitureLeftImmatController.text}T${voitureRightImmatController.text}";
                      }else{
                        ImmatValueToSave=voiturefullImmatController.text;
                      }


                      if(OldSelectedTypeImmatriculationValue==selectedTypeImmatriculationValue.toString()&& oldImmatNumber==ImmatValueToSave){
                        setState(() {
                          _saving = true;
                        });
                        await update();
                      }
                      else if (OldSelectedTypeImmatriculationValue!=selectedTypeImmatriculationValue.toString() ||
                          (OldSelectedTypeImmatriculationValue==selectedTypeImmatriculationValue.toString()&& oldImmatNumber!=ImmatValueToSave)){
                        ImmatExists= await checkVoitureSerie (selectedTypeImmatriculationValue.toString(),ImmatValueToSave);
                        if(ImmatExists){

                          fToast.showToast(
                            child: toastM("Changer le numero d'immatricule car il deja existe !",Colors.red),
                            gravity: ToastGravity.BOTTOM,
                            toastDuration: Duration(seconds: toastDuration),);
                          _focusOnPosition();
                        }else {
                          setState(() {
                            _saving = true;
                          });
                          await FirebaseApi.moveFolderContent("$oldImmatNumber$OldSelectedTypeImmatriculationValue","$ImmatValueToSave$selectedTypeImmatriculationValue");
                          await FirebaseApi.moveFolderContent("$oldImmatNumber$OldSelectedTypeImmatriculationValue/documents","$ImmatValueToSave$selectedTypeImmatriculationValue/documents");
                           ImgVoitureUrl =   await FirebaseStorage.instance.ref().child("$ImmatValueToSave$selectedTypeImmatriculationValue/ImageVoiture.jpeg").getDownloadURL();
                           ImgFaceCarteGriseUrl = ImgFaceCarteGriseUrl!.isNotEmpty ? await FirebaseStorage.instance.ref().child("$ImmatValueToSave$selectedTypeImmatriculationValue/documents/ImageFaceCarteGrise.jpeg").getDownloadURL() : "";
                           ImgDosCarteGriseUrl = ImgDosCarteGriseUrl!.isNotEmpty ? await FirebaseStorage.instance.ref().child("$ImmatValueToSave$selectedTypeImmatriculationValue/documents/ImageDosCarteGrise.jpeg").getDownloadURL() : "";
                           ImgAssuranceUrl = ImgAssuranceUrl!.isNotEmpty ? await FirebaseStorage.instance.ref().child("$ImmatValueToSave$selectedTypeImmatriculationValue/documents/ImageAssurance.jpeg").getDownloadURL() : "";
                           ImgTaxUrl = ImgTaxUrl!.isNotEmpty ? await FirebaseStorage.instance.ref().child("$ImmatValueToSave$selectedTypeImmatriculationValue/documents/ImageTax.jpeg").getDownloadURL() : "";
                           ImgVisiteUrl = ImgVisiteUrl!.isNotEmpty ? await FirebaseStorage.instance.ref().child("$ImmatValueToSave$selectedTypeImmatriculationValue/documents/ImageVisite.jpeg").getDownloadURL() :"";
                          await update();
                        }
                      }
                    }else {
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

    );
  }

  Future<void> update() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8080/voitures/check'));
    if(response.statusCode==200){
      Future.delayed(const Duration(seconds: 1),() async {




        ImgVoitureUrl =  fileImgVoiture.path.isNotEmpty ? await FirebaseApi.firebaseUploadImage(fileImgVoiture, "ImageVoiture.jpeg","$ImmatValueToSave$selectedTypeImmatriculationValue") : ImgVoitureUrl;
        //ImgVoitureUrlToSave !="" ?    ImgVoitureUrl =ImgVoitureUrlToSave  : ImgVoitureUrl = ImgVoitureUrl;
        //ImgVoitureUrl = ImgVoitureUrlToSave!.isNotEmpty ? ImgVoitureUrlToSave : ImgVoitureUrl;

        ImgFaceCarteGriseUrl= fileImgFaceCarteGrise.path.isNotEmpty
            ? await FirebaseApi.firebaseUploadImage(fileImgFaceCarteGrise, "ImageFaceCarteGrise.jpeg","$ImmatValueToSave$selectedTypeImmatriculationValue/documents")
            :  ImgFaceCarteGriseUrl!.isNotEmpty
            ? ImgFaceCarteGriseUrl
            : await FirebaseApi.firebaseDeleteImage("ImageFaceCarteGrise.jpeg", "$ImmatValueToSave$selectedTypeImmatriculationValue/documents");

        ImgDosCarteGriseUrl= fileImgDosCarteGrise.path.isNotEmpty
            ? await FirebaseApi.firebaseUploadImage(fileImgDosCarteGrise, "ImageDosCarteGrise.jpeg","$ImmatValueToSave$selectedTypeImmatriculationValue/documents")
            :  ImgDosCarteGriseUrl!.isNotEmpty
            ? ImgDosCarteGriseUrl
            : await FirebaseApi.firebaseDeleteImage("ImageDosCarteGrise.jpeg", "$ImmatValueToSave$selectedTypeImmatriculationValue/documents");

        ImgAssuranceUrl= fileImgAssurance.path.isNotEmpty
            ? await FirebaseApi.firebaseUploadImage(fileImgAssurance, "ImageAssurance.jpeg","$ImmatValueToSave$selectedTypeImmatriculationValue/documents")
            :  ImgAssuranceUrl!.isNotEmpty
            ? ImgAssuranceUrl
            : await FirebaseApi.firebaseDeleteImage("ImageAssurance.jpeg", "$ImmatValueToSave$selectedTypeImmatriculationValue/documents");

        ImgTaxUrl= fileImgTax.path.isNotEmpty
            ? await FirebaseApi.firebaseUploadImage(fileImgTax, "ImageTax.jpeg","$ImmatValueToSave$selectedTypeImmatriculationValue/documents")
            :  ImgTaxUrl!.isNotEmpty
            ? ImgTaxUrl
            : await FirebaseApi.firebaseDeleteImage("ImageTax.jpeg", "$ImmatValueToSave$selectedTypeImmatriculationValue/documents");

        ImgVisiteUrl= fileImgVisite.path.isNotEmpty
            ? await FirebaseApi.firebaseUploadImage(fileImgVisite, "ImageVisite.jpeg","$ImmatValueToSave$selectedTypeImmatriculationValue/documents")
            :  ImgVisiteUrl!.isNotEmpty
            ? ImgVisiteUrl
            : await FirebaseApi.firebaseDeleteImage("ImageVisite.jpeg", "$ImmatValueToSave$selectedTypeImmatriculationValue/documents");

        //ImgAssuranceUrl = await firebaseUploadImage(fileImgAssurance, "ImageAssurance$ImmatValueToSave.jpeg","$ImmatValueToSave/documents");
        //ImgTaxUrl = await firebaseUploadImage(fileImgTax, "ImageTax$ImmatValueToSave.jpeg","$ImmatValueToSave/documents");
        //ImgVisiteUrl = await firebaseUploadImage(fileImgVisite, "ImageVisite$ImmatValueToSave.jpeg","$ImmatValueToSave/documents");

        VoitureModel v =VoitureModel(voitureId: voitureID.toString(), imgVoitureUrl: ImgVoitureUrl.toString(),
            voitureMake: selectedMakeValue.toString(), voitureMakeYear: selectedMakeYearValue.toString(),
            voitureModele: selectedCarModelValue.toString(), voitureTypeSerie: selectedTypeImmatriculationValue.toString(),
            voitureSerie: ImmatValueToSave, voitureCarburant: selectedTypeCarburantValue.toString(),
            voitureKilometrage: voitureKilometrageController.text,voitureNotes: NotesController.text,
            imgFaceCarteGriseUrl: ImgFaceCarteGriseUrl.toString(), imgDosCarteGriseUrl: ImgDosCarteGriseUrl.toString(),
            imgAssuranceUrl: ImgAssuranceUrl.toString(), imgTaxUrl: ImgTaxUrl.toString(), imgVisiteUrl: ImgVisiteUrl.toString());
        updateVoitureById(v,context);
        setState(() {
          _saving = false;
        });
      });
    }else{
      Navigator.pop(context);
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return  AfterActionAlertDialog(
            title: "Probleme du mise a jour",
            content: "Réessayer plus tard !",
            status:response.statusCode,
          );
        },
      );
    }
  }


  String? validateRow(String value1, String value2) {
    if (value1.isEmpty || value2.isEmpty) {
      _formKey.currentState!.validate();
      return "Entrer le numero d'immatriculation complet de votre voiture";
    }
    return null;
  }


}



