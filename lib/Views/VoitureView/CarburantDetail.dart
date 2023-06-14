import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:narcsecond/Globals/globals.dart';
import 'package:narcsecond/Models/fillUpModel.dart';
import 'package:narcsecond/Views/VoitureView/UpdateFillUpVoiture.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../Models/voitureModel.dart';
import '../../Services/voitureService.dart';
import '../Components/YearMonthPicker.dart';
import '../VoitureView/DetailVoiture.dart';

class CarburantDetail extends StatefulWidget {
  VoitureModel voiture;
  CarburantDetail(this.voiture, {super.key});
  @override
  State<CarburantDetail> createState() => _CarburantDetailtState(voiture);
}

class _CarburantDetailtState extends State<CarburantDetail> {
  late VoitureModel voiture;

  _CarburantDetailtState( VoitureModel v) {
    voiture=v;

  }
   List<FillUpModel> fillups=<FillUpModel>[];
  Future<void> loadData() async {
    fillups = await getAllCarburantByVoitureId(voiture.voitureId);
    fillUpDataSource = FillUpDataSource(fillupData: fillups);
    fillUpDataSource.sortedColumns.add(const SortColumnDetails(name: 'dateFillUp', sortDirection: DataGridSortDirection.ascending));
    setState(() {
      fillups=fillups;
      fillUpDataSource=fillUpDataSource;
    });
  }

  FillUpDataSource fillUpDataSource=FillUpDataSource(fillupData: <FillUpModel>[]);
  TextEditingController dateController = TextEditingController();

  final DataGridController _dataGridController = DataGridController();
  late FillUpModel fillUpModel = FillUpModel.empty();
  late String dateValue;
  DateTime? newDate;


  @override
  void initState() {
    Intl.defaultLocale = 'fr';
    super.initState();
    loadData();
    newDate = DateTime.now().toLocal();
    //DateFormat.yMMMM().format(DateTime.now())
    dateController = TextEditingController(text:"ALL" );
  }

  getValuesAndpush(){
    DataGridRow? selectedRow = _dataGridController.selectedRow;
    if (selectedRow != null) {
      List<DataGridCell> cells = selectedRow.getCells();
      fillUpModel.fillUpId = cells.firstWhere((cell) => cell.columnName == 'fillUpId').value.toString();
      fillUpModel.imgFillUpUrl = cells.firstWhere((cell) => cell.columnName == 'imgFillUpUrl').value.toString();
      fillUpModel.imgFillUpName = cells.firstWhere((cell) => cell.columnName == 'imgFillUpName').value.toString();
      fillUpModel.costFillUp = cells.firstWhere((cell) => cell.columnName == 'costFillUp').value;
      fillUpModel.fillUpNotes = cells.firstWhere((cell) => cell.columnName == 'fillUpNotes').value.toString();
      fillUpModel.dateFillUp = cells.firstWhere((cell) => cell.columnName == 'dateFillUp').value.toString();
      Navigator.push(context, MaterialPageRoute(
          builder: (context) =>  UpdateFillUpVoiture(voiture,fillUpModel)));
    }
    print("date = ${fillUpModel.costFillUp}");
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DetailVoiture(voiture)),
          );
          return false; // Return false to prevent the default back button behavior
        },
        child:SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text("Detail carburant"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back), // Custom icon for the return button
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  DetailVoiture(voiture)));
                },
              ),
            ),

            body:ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: minimumPadding, bottom: minimumPadding),
                  child: GestureDetector(
                    onTap: () async {
                      DateTime? newDate = await showModalBottomSheet<DateTime>(
                        context: context,
                        builder: (BuildContext context) {
                          return YearMonthPicker(initialDate: DateTime.now());
                        },
                      );
                      if (newDate != null) {
                        String formattedDate="";
                        late List<FillUpModel> filteredFillups;
                        if(newDate.year == -1){
                          formattedDate = "ALL";
                          filteredFillups = fillups;
                        }else if (newDate.year == 0){
                          formattedDate = DateFormat.MMMM().format(newDate).toString();
                          filteredFillups = fillups.where((fillup) {
                            DateTime dateFillUp = DateTime.parse(fillup.dateFillUp);
                            return dateFillUp.month == newDate.month;
                          }).toList();
                        }else if(newDate.year> 0 && newDate.day != 15){
                          formattedDate = DateFormat.yMMMM().format(newDate).toString();
                          filteredFillups = fillups.where((fillup) {
                            DateTime dateFillUp = DateTime.parse(fillup.dateFillUp);
                            return  dateFillUp.year == newDate.year && dateFillUp.month == newDate.month;
                          }).toList();
                        }else{
                          formattedDate = (newDate.year+1).toString();
                          filteredFillups = fillups.where((fillup) {
                            DateTime dateFillUp = DateTime.parse(fillup.dateFillUp);
                            return  dateFillUp.year == newDate.year+1 ;
                          }).toList();
                        }
                        setState(() {
                          fillUpDataSource = FillUpDataSource(fillupData: filteredFillups);
                          dateController.text = formattedDate;
                        });
                      }
                    },
                    child: AbsorbPointer(
                      absorbing: true,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          controller: dateController,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 12.0),
                              labelText: 'Filtrer par année et moi',
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
                ),

                fillups.isNotEmpty
                    ? SizedBox(
                          height: MediaQuery.of(context).size.height-150,
                          child: SfDataGrid(
                            source: fillUpDataSource,
                            columnWidthMode: ColumnWidthMode.fill,
                            //rowHeight: 100,
                            allowSorting: true,
                            selectionMode: SelectionMode.single,
                            controller: _dataGridController,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            sortingGestureType: SortingGestureType.tap,
                            onSelectionChanged:(addedRows, removedRows) {
                              getValuesAndpush();
                              _dataGridController.selectedIndex = -1;
                            },

                            navigationMode: GridNavigationMode.row,
                            allowTriStateSorting: true,
                            columns: <GridColumn>[
                              GridColumn(

                                  visible: false,
                                  columnName: 'fillUpId',
                                  label: Container()),
                              GridColumn(
                                  visible: false,
                                  columnName: 'imgFillUpUrl',
                                  label: Container()),
                              GridColumn(
                                  visible: false,
                                  columnName: 'imgFillUpName',
                                  label: Container()
                              ),
                              GridColumn(
                                  visible: false,
                                  columnName: 'dateFillUp',
                                  label: Container()
                              ),
                              GridColumn(
                                allowSorting: false,
                                  columnName: 'da',
                                  //width: 110,
                                  label: Container(
                                    color: Colors.lightBlueAccent,
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child:  const Text('Date'))),
                              GridColumn(
                                allowSorting: true,
                                  columnName: 'costFillUp',
                                  label: Container(
                                      color: Colors.lightBlueAccent,
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,

                                      child: const Text(
                                        'Montant',
                                        style: TextStyle(fontSize: 13),
                                        //overflow: TextOverflow.ellipsis,

                                      ))),
                              GridColumn(
                                allowSorting: false,
                                  columnName: 'fillUpNotes',
                                  label: Container(
                                      color: Colors.lightBlueAccent,
                                      padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child:  const Text('Notes')
                                  )),
                              GridColumn(
                                allowSorting: false,
                                  columnName: 'imgFillUp',
                                  label: Container(
                                      color: Colors.lightBlueAccent,
                                      //padding: const EdgeInsets.all(8.0),
                                      alignment: Alignment.center,
                                      child: const Text('Image')
                                  )),

                            ],
                          ),
                    )
                    : fillups.isEmpty
                    ? Builder(
                      builder: (BuildContext context) {
                        Future.delayed(const Duration(seconds: 5), () {
                          return const Center(child: CircularProgressIndicator());
                        });
                        return const Center(child: Text("Empty data"));
                      },
                    )
                    : const Center(child: Text("Empty data")),
              ],
            ),
          ),
        )
    );

  }

}
class FillUpDataSource extends DataGridSource {

  FillUpDataSource({required List<FillUpModel> fillupData}) {
    Intl.defaultLocale = 'fr';

    _fillupData = fillupData
        .map<DataGridRow>((e) => DataGridRow(cells: [


      DataGridCell<String>(columnName: 'fillUpId', value: e.fillUpId),
      DataGridCell<String>(columnName: 'imgFillUpUrl', value: e.imgFillUpUrl),
      DataGridCell<String>(columnName: 'imgFillUpName', value: e.imgFillUpName),
      DataGridCell<String>(columnName: 'dateFillUp', value: e.dateFillUp),
      DataGridCell<String>(columnName: 'da', value: DateFormat.yMMMd().format(DateTime.parse(e.dateFillUp)).toString()),
      DataGridCell<int>(columnName: 'costFillUp', value: e.costFillUp),
      DataGridCell<String>(columnName: 'fillUpNotes', value: e.fillUpNotes),
      DataGridCell<Widget>(columnName: 'imgFillUp', value: e.imgFillUpUrl.isNotEmpty ?  Image.network(e.imgFillUpUrl,fit: BoxFit.cover,) : const Center(child: Text("Vide"))
      ),
    ]))
        .toList();
  }

  List<DataGridRow> _fillupData = [];

  @override
  List<DataGridRow> get rows => _fillupData;

  @override
  int compare(DataGridRow? a, DataGridRow? b, SortColumnDetails sortColumn) {
    if(sortColumn.name == 'costFillUp'){
      final String? value1 = a?.getCells()
          .firstWhere((element) => element.columnName == sortColumn.name).value.toString();
      final String? value2 = b?.getCells()
          .firstWhere((element) => element.columnName == sortColumn.name).value.toString();
      if(value1 == null || value2==null){
        return 0;
      }
      if(sortColumn.sortDirection == DataGridSortDirection.ascending){
        return value1.toLowerCase().compareTo(value2.toLowerCase());
      }else{
        return value2.toLowerCase().compareTo(value1.toLowerCase());
      }

    }
    return super.compare(a, b, sortColumn);
  }

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {

    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          return Container(
            color: Colors.lightBlueAccent.shade100,
            child: e.columnName == 'imgFillUp'
                ? ( e.value as Widget)
                : e.columnName == 'da'
                ? Container(
              color: Colors.lightBlueAccent.shade400,
              padding: const EdgeInsets.only(left: minimumPadding),
              alignment: Alignment.centerLeft,
              child: Text(e.value.toString() ,  style: const TextStyle(
                fontFamily: 'Raleway',
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Colors.indigo,
              ),
              ),
            )
                : Center(
              child: Text(e.value.toString() ,  style: const TextStyle(
                fontFamily: 'Raleway',
                fontWeight: FontWeight.w300,
                color: Colors.indigo,
              ),
                textAlign: TextAlign.center,
              ),
            )
          );
        }).toList());
  }
}