import 'package:flutter/material.dart';

class YearMonthPicker extends StatefulWidget {
  final DateTime initialDate;

  const YearMonthPicker({super.key, required this.initialDate});

  @override
  _YearMonthPickerState createState() => _YearMonthPickerState();
}

class _YearMonthPickerState extends State<YearMonthPicker> {
  int? _selectedYear=0;
  int _selectedMonth = 0;

  @override
  void initState() {
    super.initState();
    _selectedYear = 0;
    _selectedMonth = 0;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final selectedYear = _selectedYear == 0 ? 0 : _selectedYear!;
                    final day = _selectedMonth == 0 ? 15 : 1;
                    final selectedDate = DateTime(selectedYear, _selectedMonth,day);
                    Navigator.pop(context, selectedDate);
                  },
                  child: const Text('Confirmer'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _getYears().length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return ListTile(
                          title: const Text('ALL'),
                          onTap: () {
                            setState(() {
                              _selectedYear = 0;
                            });
                          },
                          tileColor:
                          _selectedYear == 0 ? Colors.lightBlueAccent : null,
                        );
                      } else {
                        final year = _getYears()[index - 1];
                        return ListTile(
                          title: Text(year.toString()),
                          onTap: () {
                            setState(() {
                              _selectedYear = year;
                            });
                          },
                          tileColor: _selectedYear == year
                              ? Colors.lightBlueAccent
                              : null,
                        );
                      }
                    },
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 13,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return ListTile(
                          title: const Text('ALL'),
                          onTap: () {
                            setState(() {
                              _selectedMonth = 0;
                            });
                          },
                          tileColor:
                          _selectedMonth == 0 ? Colors.lightBlueAccent : null,
                        );
                      } else {
                        final month = index;
                        return ListTile(
                          title: Text(_getMonthAbbreviation(month)),
                          onTap: () {
                            setState(() {
                              _selectedMonth = month;
                            });
                          },
                          tileColor: _selectedMonth == month
                              ? Colors.lightBlueAccent
                              : null,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<int> _getYears() {
    final currentYear = DateTime.now().year;
    return List.generate(
      currentYear - 2020 + 1,
          (index) => currentYear - index,
    );
  }

  String _getMonthAbbreviation(int month) {
    switch (month) {
      case 1:
        return 'Janv';
      case 2:
        return 'Févr';
      case 3:
        return 'Mars';
      case 4:
        return 'Avr';
      case 5:
        return 'Mai';
      case 6:
        return 'Juin';
      case 7:
        return 'Juil';
      case 8:
        return 'Août';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Déc';
      default:
        return 'ALL';
    }
  }
}
