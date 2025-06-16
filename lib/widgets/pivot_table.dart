import 'package:flutter/material.dart';
import '../utils/csv_parser.dart';

class PivotTableWidget extends StatelessWidget {
  final PivotTableData pivotData;

  const PivotTableWidget({super.key, required this.pivotData});

  List<String> _getUniqueLeftKeys() {
    return pivotData.pivotData.keys.toList();
  }

  List<String> _getUniqueTopKeys() {
    final Set<String> keys = {};
    for (final topMap in pivotData.pivotData.values) {
      keys.addAll(topMap.keys);
    }
    return keys.toList();
  }

  List<List<String>> _parseCompoundKeys(List<String> keys) {
    return keys.map((key) => key.split('|')).toList();
  }

  @override
  Widget build(BuildContext context) {
    final leftKeys = _getUniqueLeftKeys();
    final topKeys = _getUniqueTopKeys();
    
    final leftParsedKeys = _parseCompoundKeys(leftKeys);
    final topParsedKeys = _parseCompoundKeys(topKeys);
    
    // Create a unique list of values for each left header dimension
    final leftDimensions = List<List<String>>.generate(
      pivotData.leftHeaders.length,
      (i) => leftParsedKeys.map((parts) => parts[i]).toSet().toList(),
    );
    
    // Create a unique list of values for each top header dimension
    final topDimensions = List<List<String>>.generate(
      pivotData.topHeaders.length,
      (i) => topParsedKeys.map((parts) => parts[i]).toSet().toList(),
    );

    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${pivotData.dataColumn} - ${pivotData.aggregateFunction}',
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(Color(0xFF2C3A4F)),
                  dataRowColor: WidgetStateProperty.all(Color(0xFF323C4F)),
                  border: TableBorder.all(color: Colors.blueGrey.shade700),
                  columnSpacing: 0,
                  columns: [
                    DataColumn(label: SizedBox(width: 80, child: Text(''))),
                    ...topKeys.expand((topKey) {
                      final parts = topKey.split('|');
                      return [
                        DataColumn(
                          label: Container(
                            width: 80,
                            alignment: Alignment.center,
                            child: Text(parts.join(' ')),
                          ),
                        ),
                      ];
                    }),
                  ],
                  rows: leftKeys.map((leftKey) {
                    final leftParts = leftKey.split('|');
                    
                    return DataRow(
                      cells: [
                        DataCell(
                          SizedBox(
                            width: 80,
                            child: Text(leftParts.join(' ')),
                          ),
                        ),
                        ...topKeys.map((topKey) {
                          final value = pivotData.pivotData[leftKey]?[topKey] ?? 0.0;
                          return DataCell(
                            Container(
                              width: 80,
                              alignment: Alignment.center,
                              child: Text(value.toStringAsFixed(1)),
                            ),
                          );
                        }),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}