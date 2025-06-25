import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/csv_parser.dart';
import '../utils/data_analyzer.dart';
import '../widgets/statistics_view.dart';

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

  // List<List<String>> _parseCompoundKeys(List<String> keys) {
  //   return keys.map((key) => key.split('|')).toList();
  // }

  @override
  Widget build(BuildContext context) {
    final leftKeys = _getUniqueLeftKeys();
    final topKeys = _getUniqueTopKeys();

  //  final leftParsedKeys = _parseCompoundKeys(leftKeys);
   // final topParsedKeys = _parseCompoundKeys(topKeys);

    // Create a unique list of values for each left header dimension
    // final leftDimensions = List<List<String>>.generate(
    //   pivotData.leftHeaders.length,
    //   (i) => leftParsedKeys.map((parts) => parts[i]).toSet().toList(),
    // );

    // Create a unique list of values for each top header dimension
    // final topDimensions = List<List<String>>.generate(
    //   pivotData.topHeaders.length,
    //   (i) => topParsedKeys.map((parts) => parts[i]).toSet().toList(),
    // );

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
                          final value =
                              pivotData.pivotData[leftKey]?[topKey] ?? 0.0;
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

class HeaderSelector extends StatelessWidget {
  final String title;
  final List<String> headers;
  final List<String> selectedHeaders;
  final Function(List<String>) onHeadersChanged;
  final bool singleSelect;

  const HeaderSelector({
    super.key,
    required this.title,
    required this.headers,
    required this.selectedHeaders,
    required this.onHeadersChanged,
    this.singleSelect = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Color(0xFF262F3D),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Wrap(
            spacing: 4.0,
            runSpacing: 4.0,
            children: [
              ...selectedHeaders.map((header) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(header),
                      SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          final newHeaders = List<String>.from(selectedHeaders);
                          newHeaders.remove(header);
                          onHeadersChanged(newHeaders);
                        },
                        child: Icon(Icons.close, size: 16),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
          SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: headers.length,
              itemBuilder: (context, index) {
                final header = headers[index];
                final isSelected = selectedHeaders.contains(header);

                return CheckboxListTile(
                  title: Text(header),
                  value: isSelected,
                  onChanged: (_) {
                    List<String> newHeaders;
                    if (isSelected) {
                      newHeaders =
                          selectedHeaders.where((h) => h != header).toList();
                    } else {
                      if (singleSelect) {
                        newHeaders = [header];
                      } else {
                        newHeaders = List<String>.from(selectedHeaders)
                          ..add(header);
                      }
                    }
                    onHeadersChanged(newHeaders);
                  },
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Toolbar extends StatelessWidget {
  final VoidCallback onRefresh;
  final VoidCallback onClear;
  final VoidCallback onSwap;

  const Toolbar(
      {super.key,
      required this.onRefresh,
      required this.onClear,
      required this.onSwap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        spacing: 8.0,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF373E4E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: onRefresh,
            child: Text('Refresh Data'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF373E4E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: onClear,
            child: Text('Clear Data'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF373E4E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: onSwap,
            child: Text('Swap Left and Top'),
          ),
        ],
      ),
    );
  }
}

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
