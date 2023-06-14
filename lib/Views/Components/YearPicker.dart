import 'package:flutter/material.dart';

class OnlyYearPicker extends StatefulWidget {
  final int initialYear;

  const OnlyYearPicker({required this.initialYear});

  @override
  _YearPickerState createState() => _YearPickerState();
}

class _YearPickerState extends State<OnlyYearPicker> {
  int? _selectedYear;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialYear;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _selectedYear);
                  },
                  child: const Text('Confirm'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _getYears().length,
              itemBuilder: (context, index) {
                final year = _getYears()[index];
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
              },
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
}
