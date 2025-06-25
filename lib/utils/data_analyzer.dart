import 'package:collection/collection.dart';
import 'csv_parser.dart';

class DataAnalyzer {
  static Map<String, dynamic> getStatistics(CsvData data, String column) {
    final colIndex = data.headers.indexOf(column);
    if (colIndex == -1) return {};
    
    final values = data.rows
        .map((row) => row[colIndex])
        .where((value) => value != null && value.toString().isNotEmpty)
        .map((val) => num.tryParse(val.toString()) ?? 0)
        .toList();
    
    if (values.isEmpty) return {};
    
    values.sort();
    final sum = values.sum;
    final mean = sum / values.length;
    final median = values.length % 2 == 0
        ? (values[values.length ~/ 2] + values[values.length ~/ 2 - 1]) / 2
        : values[values.length ~/ 2];
    final min = values.first;
    final max = values.last;
    
    return {
      'sum': sum,
      'mean': mean,
      'median': median,
      'min': min,
      'max': max,
      'count': values.length,
    };
  }
  
  static List<dynamic> getUniqueValues(CsvData data, String column) {
    final colIndex = data.headers.indexOf(column);
    if (colIndex == -1) return [];
    
    return data.rows
        .map((row) => row[colIndex])
        .toSet()
        .toList();
  }
  
  static PivotTableData createPivotTable(
    CsvData data, 
    List<String> leftHeaders, 
    List<String> topHeaders,
    String dataColumn,
    String aggregateFunction,
  ) {
    final leftIndices = leftHeaders.map((h) => data.headers.indexOf(h)).toList();
    final topIndices = topHeaders.map((h) => data.headers.indexOf(h)).toList();
    final dataIndex = data.headers.indexOf(dataColumn);
    
    if (leftIndices.contains(-1) || topIndices.contains(-1) || dataIndex == -1) {
      return PivotTableData(
        leftHeaders: leftHeaders,
        topHeaders: topHeaders,
        dataColumn: dataColumn,
        aggregateFunction: aggregateFunction,
        pivotData: {},
      );
    }
    
    // Group data for pivot table
    Map<String, Map<String, List<num>>> groupedData = {};
    
    for (var row in data.rows) {
      final leftKey = leftIndices.map((i) => row[i].toString()).join('|');
      final topKey = topIndices.map((i) => row[i].toString()).join('|');
      
      final value = num.tryParse(row[dataIndex].toString()) ?? 0;
      
      groupedData[leftKey] ??= {};
      groupedData[leftKey]![topKey] ??= [];
      groupedData[leftKey]![topKey]!.add(value);
    }
    
    // Calculate aggregates
    Map<String, Map<String, double>> pivotData = {};
    
    groupedData.forEach((leftKey, topMap) {
      pivotData[leftKey] = {};
      
      topMap.forEach((topKey, values) {
        double? result;
        switch (aggregateFunction) {
          case 'Sum':
            result = values.sum.toDouble();
            break;
          case 'Mean':
            result = values.average;
            break;
          case 'Median':
            values.sort();
            result = values.length % 2 == 0
                ? (values[values.length ~/ 2] + values[values.length ~/ 2 - 1]) / 2
                : values[values.length ~/ 2].toDouble();
            break;
          default:
            result = values.sum.toDouble();
        }
        
        pivotData[leftKey]![topKey] = result;
      });
    });
    
    return PivotTableData(
      leftHeaders: leftHeaders,
      topHeaders: topHeaders,
      dataColumn: dataColumn,
      aggregateFunction: aggregateFunction,
      pivotData: pivotData,
    );
  }
}