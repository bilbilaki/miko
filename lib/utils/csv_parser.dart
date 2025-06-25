import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:csv/csv.dart';


class CsvData with ChangeNotifier {
  List<List<dynamic>> _data = [];
  String _fileName = '';
  Set<int> _selectedRows = {};
  
  List<String> get headers => _data.isNotEmpty ? 
    _data.first.map((e) => e.toString()).toList() : [];
  
  List<List<dynamic>> get rows => _data.length > 1 ? 
    _data.sublist(1) : [];
  
  String get fileName => _fileName;
  
  bool get hasData => _data.isNotEmpty;
  
  Set<int> get selectedRows => _selectedRows;
  
  Future<void> loadFromFile(File file) async {
    try {
      final contents = await file.readAsString();
      _loadFromString(contents);
      _fileName = file.path.split('/').last;
    } catch (e) {
      // Try with Latin-1 encoding if UTF-8 fails
      try {
        final contents = await file.readAsString(encoding: const Latin1Codec());
        _loadFromString(contents);
        _fileName = file.path.split('/').last;
      } catch (e) {
        rethrow;
      }
    }
  }
  
  void _loadFromString(String contents) {
    _data = const CsvToListConverter().convert(contents);
    _selectedRows = {};
    notifyListeners();
  }
  
  Future<void> saveToFile(File file) async {
    final csv = const ListToCsvConverter().convert(_data);
    await file.writeAsString(csv);
  }
  
  void updateCell(int row, int col, dynamic value) {
    // For header row
    if (row == -1 && col < _data[0].length) {
      _data[0][col] = value;
      notifyListeners();
      return;
    }
    
    // For data rows (adding +1 because row 0 is header)
    final actualRow = row + 1;
    if (actualRow < _data.length && col < _data[actualRow].length) {
      _data[actualRow][col] = value;
      notifyListeners();
    }
  }
  
  void clearData() {
    _data = [];
    _fileName = '';
    _selectedRows = {};
    notifyListeners();
  }
  
  // Add a new column
  void addColumn(String name) {
    if (_data.isEmpty) {
      _data.add([name]);
    } else {
      // Add the column name to headers
      _data[0].add(name);
      
      // Add empty values for all existing rows
      for (int i = 1; i < _data.length; i++) {
        _data[i].add('');
      }
    }
    
    notifyListeners();
  }
  
  // Delete a column
  void deleteColumn(String header) {
    if (_data.isEmpty) return;
    
    final index = _data[0].indexOf(header);
    if (index == -1) return;
    
    // Remove the column from all rows
    for (var row in _data) {
      if (index < row.length) {
        row.removeAt(index);
      }
    }
    
    notifyListeners();
  }
  
  // Rename a column
  void renameColumn(String oldName, String newName) {
    if (_data.isEmpty) return;
    
    final index = _data[0].indexOf(oldName);
    if (index == -1) return;
    
    _data[0][index] = newName;
    notifyListeners();
  }
  
  // Add a new row
  void addRow(List<dynamic> rowData) {
    if (_data.isEmpty) {
      // Create headers first if data is empty
      _data.add(List.generate(rowData.length, (i) => 'Column ${i+1}'));
    }
    
    // Ensure the new row has the same number of columns as headers
    final List<dynamic> newRow = List.filled(_data[0].length, '');
    for (int i = 0; i < rowData.length && i < newRow.length; i++) {
      newRow[i] = rowData[i];
    }
    
    _data.add(newRow);
    notifyListeners();
  }
  
  // Delete a row
  void deleteRow(int rowIndex) {
    // Add 1 because rowIndex refers to the index in rows (which doesn't include header)
    final actualIndex = rowIndex + 1;
    if (actualIndex >= 1 && actualIndex < _data.length) {
      _data.removeAt(actualIndex);
      notifyListeners();
    }
  }
  
  // Delete multiple rows
  void deleteRows(Set<int> rowIndices) {
    // Convert to list and sort in descending order to avoid index shifting problems
    final indices = rowIndices.map((i) => i + 1).toList()..sort((a, b) => b.compareTo(a));
    
    for (final index in indices) {
      if (index >= 1 && index < _data.length) {
        _data.removeAt(index);
      }
    }
    
    _selectedRows = {};
    notifyListeners();
  }
  
  // Toggle row selection
  void toggleRowSelection(int rowIndex) {
    if (_selectedRows.contains(rowIndex)) {
      _selectedRows.remove(rowIndex);
    } else {
      _selectedRows.add(rowIndex);
    }
    notifyListeners();
  }
  
  // Select/deselect all rows
  void setAllRowsSelected(bool selected) {
    if (selected) {
      _selectedRows = Set<int>.from(List<int>.generate(rows.length, (i) => i));
    } else {
      _selectedRows = {};
    }
    notifyListeners();
  }
  
  // Check if a specific row is selected
  bool isRowSelected(int rowIndex) {
    return _selectedRows.contains(rowIndex);
  }
}

// Rest of the PivotTableData class remains the same

class PivotTableData {
  final List<String> leftHeaders;
  final List<String> topHeaders;
  final String dataColumn;
  final String aggregateFunction; // 'Sum', 'Mean', 'Median'
  final Map<String, Map<String, double>> pivotData;
  
  PivotTableData({
    required this.leftHeaders, 
    required this.topHeaders, 
    required this.dataColumn,
    required this.aggregateFunction,
    required this.pivotData
  });
}