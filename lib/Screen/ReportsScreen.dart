import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  Map<String, List<int>> weeklyData = {};
  List<String> selectedHabits = [];
  final List<String> daysOfWeek = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun'
  ];

  @override
  void initState() {
    super.initState();
    _loadWeeklyData();
  }

  Future<void> _loadWeeklyData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Load selected habits from SharedPreferences
    String? selectedHabitsMapString = prefs.getString('selectedHabitsMap');
    if (selectedHabitsMapString != null) {
      Map<String, dynamic> selectedHabitsMap =
      jsonDecode(selectedHabitsMapString);
      selectedHabits = selectedHabitsMap.keys.toList();
    } else {
      setState(() {
        selectedHabits = [];
      });
    }

    // If no habits are selected, reset weeklyData
    if (selectedHabits.isEmpty) {
      setState(() {
        weeklyData = {};
      });
      return;
    }

    // Load weekly data from SharedPreferences or generate random mixed data if none exists
    String? storedData = prefs.getString('weeklyData');
    if (storedData == null) {
      Map<String, List<int>> mixedData = {
        for (var habit in selectedHabits)
          habit: List.generate(
              7, (_) => Random().nextBool() ? 1 : 0), // Random completion (1 or 0)
      };
      await prefs.setString('weeklyData', jsonEncode(mixedData));
      storedData = jsonEncode(mixedData);
    }

    // Decode the stored data and update the state
    setState(() {
      Map<String, dynamic> decodedData = jsonDecode(storedData!);
      weeklyData = decodedData.map((key, value) =>
          MapEntry(key, List<int>.from(value as List<dynamic>)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          'Weekly Report',
          style: TextStyle(
              fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: weeklyData.isEmpty
          ? const Center(
        child: Text(
          'No data available. Please configure habits first.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            columns: _buildColumns(),
            rows: _buildRows(),
          ),
        ),
      ),
    );
  }

  // Build columns for the table: Habit and Days of the Week
  List<DataColumn> _buildColumns() {
    return [
      const DataColumn(
        label: Text('Habit', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      ...daysOfWeek.map((day) => DataColumn(
        label: Text(
          day,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      )),
    ];
  }

  // Build rows for each habit: Displays whether it's completed each day of the week
  List<DataRow> _buildRows() {
    return selectedHabits.map((habit) {
      return DataRow(
        cells: [
          DataCell(Text(habit)),
          ...List.generate(7, (index) {
            bool isCompleted = weeklyData[habit]?[index] == 1;
            return DataCell(
              Icon(
                isCompleted ? Icons.check_circle : Icons.cancel,
                color: isCompleted ? Colors.green : Colors.red,
              ),
            );
          }),
        ],
      );
    }).toList();
  }
}
