import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/csv_parser.dart';
import '../utils/data_analyzer.dart';
import '../widgets/data_grid.dart';
import '../widgets/header_selector.dart';
import '../widgets/pivot_table.dart';
import '../widgets/statistics_view.dart';
import '../widgets/toolbar.dart';

class CsvEditorScreen extends StatefulWidget {
  const CsvEditorScreen({super.key});

  @override
  _CsvEditorScreenState createState() => _CsvEditorScreenState();
}

class _CsvEditorScreenState extends State<CsvEditorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  PivotTableData? pivotData;
  List<String> leftHeaders = [];
  List<String> topHeaders = [];
  String selectedDataColumn = '';
  String aggregateFunction = 'Median';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      await context.read<CsvData>().loadFromFile(file);
    }
  }

  void _updatePivotTable() {
    final csvData = context.read<CsvData>();
    if (csvData.hasData &&
        leftHeaders.isNotEmpty &&
        topHeaders.isNotEmpty &&
        selectedDataColumn.isNotEmpty) {
      setState(() {
        pivotData = DataAnalyzer.createPivotTable(csvData, leftHeaders,
            topHeaders, selectedDataColumn, aggregateFunction);
      });
    }
  }

  void _swapHeaderLists() {
    setState(() {
      final temp = leftHeaders;
      leftHeaders = topHeaders;
      topHeaders = temp;
      _updatePivotTable();
    });
  }

  @override
  Widget build(BuildContext context) {
    final csvData = context.watch<CsvData>();

    return Scaffold(
      appBar: AppBar(
        title: Text(csvData.hasData
            ? 'File Analysis - ${csvData.fileName}'
            : 'CSV Editor'),
        actions: [
          IconButton(
            icon: Icon(Icons.folder_open),
            onPressed: _openFile,
            tooltip: 'Open CSV File',
          ),
        ],
        bottom: csvData.hasData
            ? TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: 'Statistics'),
                  Tab(text: 'Column Analysis'),
                  Tab(text: 'Unique Values'),
                  Tab(text: 'Pivot Table'),
                ],
              )
            : null,
      ),
      body: csvData.hasData
          ? TabBarView(
              controller: _tabController,
              children: [
                StatisticsView(csvData: csvData),
                DataGrid(csvData: csvData),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButton<String>(
                          value: csvData.headers.isNotEmpty
                              ? csvData.headers.first
                              : null,
                          hint: Text('Select Column'),
                          items: csvData.headers.map((header) {
                            return DropdownMenuItem<String>(
                              value: header,
                              child: Text(header),
                            );
                          }).toList(),
                          onChanged: (value) {
                            // Show unique values
                          },
                        ),
                        SizedBox(height: 20),
                        // Display unique values in a grid
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 220,
                              height: 400,
                              child: HeaderSelector(
                                title: 'Left Headers',
                                headers: csvData.headers,
                                selectedHeaders: leftHeaders,
                                onHeadersChanged: (headers) {
                                  setState(() {
                                    leftHeaders = headers;
                                    _updatePivotTable();
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            SizedBox(
                              width: 220,
                              height: 400,
                              child: HeaderSelector(
                                title: 'Top Headers',
                                headers: csvData.headers,
                                selectedHeaders: topHeaders,
                                onHeadersChanged: (headers) {
                                  setState(() {
                                    topHeaders = headers;
                                    _updatePivotTable();
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: 8),
                            SizedBox(
                              width: 220,
                              height: 400,
                              child: HeaderSelector(
                                title: 'Data',
                                headers: csvData.headers,
                                selectedHeaders: selectedDataColumn.isEmpty
                                    ? []
                                    : [selectedDataColumn],
                                onHeadersChanged: (headers) {
                                  setState(() {
                                    selectedDataColumn =
                                        headers.isNotEmpty ? headers.first : '';
                                    _updatePivotTable();
                                  });
                                },
                                singleSelect: true,
                              ),
                            ),
                            SizedBox(width: 8),
                            SizedBox(
                              width: 220,
                              height: 400,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Measure',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 8),
                                    CheckboxListTile(
                                      title: Text('Sum'),
                                      value: aggregateFunction == 'Sum',
                                      onChanged: (_) {
                                        setState(() {
                                          aggregateFunction = 'Sum';
                                          _updatePivotTable();
                                        });
                                      },
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    CheckboxListTile(
                                      title: Text('Mean'),
                                      value: aggregateFunction == 'Mean',
                                      onChanged: (_) {
                                        setState(() {
                                          aggregateFunction = 'Mean';
                                          _updatePivotTable();
                                        });
                                      },
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    CheckboxListTile(
                                      title: Text('Median'),
                                      value: aggregateFunction == 'Median',
                                      onChanged: (_) {
                                        setState(() {
                                          aggregateFunction = 'Median';
                                          _updatePivotTable();
                                        });
                                      },
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Toolbar(
                          onRefresh: _updatePivotTable,
                          onClear: () {
                            setState(() {
                              leftHeaders = [];
                              topHeaders = [];
                              selectedDataColumn = '';
                              pivotData = null;
                            });
                          },
                          onSwap: _swapHeaderLists,
                        ),
                        if (pivotData != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: PivotTableWidget(pivotData: pivotData!),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                'Open a CSV file to begin',
                style: TextStyle(fontSize: 18),
              ),
            ),
    );
  }
}
