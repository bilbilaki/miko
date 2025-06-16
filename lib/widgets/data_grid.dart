import 'package:flutter/material.dart';
import '../utils/csv_parser.dart';

class DataGrid extends StatelessWidget {
  final CsvData csvData;

  const DataGrid({super.key, required this.csvData});

  @override
  Widget build(BuildContext context) {
    if (!csvData.hasData) {
      return Center(child: Text('No data available'));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(Color(0xFF2C3A4F)),
          dataRowColor: WidgetStateProperty.all(Color(0xFF323C4F)),
          border: TableBorder.all(color: Colors.blueGrey.shade700),
          columns: csvData.headers.map((header) {
            return DataColumn(label: Text(header));
          }).toList(),
          rows: csvData.rows.map((row) {
            return DataRow(
              cells: row.map((cell) {
                return DataCell(
                  Text(cell.toString()),
                  showEditIcon: true,
                  onTap: () {
                    // Enable in-place editing
                  },
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }
}