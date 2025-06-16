import 'package:flutter/material.dart';
import '../utils/csv_parser.dart';
import '../utils/data_analyzer.dart';

class StatisticsView extends StatefulWidget {
  final CsvData csvData;

  const StatisticsView({super.key, required this.csvData});

  @override
  _StatisticsViewState createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  String? selectedColumn;
  Map<String, dynamic> statistics = {};

  @override
  void initState() {
    super.initState();
    if (widget.csvData.hasData && widget.csvData.headers.isNotEmpty) {
      selectedColumn = widget.csvData.headers.first;
      _updateStatistics();
    }
  }

  void _updateStatistics() {
    if (selectedColumn != null) {
      setState(() {
        statistics = DataAnalyzer.getStatistics(widget.csvData, selectedColumn!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton<String>(
            value: selectedColumn,
            hint: Text('Select Column'),
            items: widget.csvData.headers.map((header) {
              return DropdownMenuItem<String>(
                value: header,
                child: Text(header),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedColumn = value;
                _updateStatistics();
              });
            },
          ),
          SizedBox(height: 20),
          if (statistics.isNotEmpty) ...[
            Card(
              color: Color(0xFF323C4F),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Statistics for $selectedColumn',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    _buildStatRow('Count', statistics['count']?.toString() ?? 'N/A'),
                    _buildStatRow('Sum', statistics['sum']?.toStringAsFixed(2) ?? 'N/A'),
                    _buildStatRow('Mean', statistics['mean']?.toStringAsFixed(2) ?? 'N/A'),
                    _buildStatRow('Median', statistics['median']?.toStringAsFixed(2) ?? 'N/A'),
                    _buildStatRow('Min', statistics['min']?.toString() ?? 'N/A'),
                    _buildStatRow('Max', statistics['max']?.toString() ?? 'N/A'),
                  ],
                ),
              ),
            ),
          ] else ...[
            Text('Select a numeric column to view statistics'),
          ],
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: TextStyle(fontWeight: FontWeight.bold))),
          Text(value),
        ],
      ),
    );
  }
}