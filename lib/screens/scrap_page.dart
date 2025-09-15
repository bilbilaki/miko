import 'dart:async';
import 'dart:convert';

import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';


import 'package:miko/functions/data_storage.dart';

import 'dataset_manager_screen.dart';

// Your existing TabularData/JsonTabularParser/CsvTabularParser can remain in a separate file.
// If they are in the same file originally, keep them there and only replace the widget below.

class DataExplorerScreen extends StatefulWidget {
  const DataExplorerScreen({
    super.key,
    this.initialData,
    this.initialDatasetName,
  });

  final TabularData? initialData;
  final String? initialDatasetName;

  @override
  State<DataExplorerScreen> createState() => _DataExplorerScreenState();
}

enum UiStage { pick, fieldSelect, viewRows }

class _DataExplorerScreenState extends State<DataExplorerScreen> {
  UiStage stage = UiStage.pick;

  TabularData? data;
  String? fileName;
  String? error;

  // Field selection
  final Set<String> selectedFields = {};
  String fieldFilter = '';

  // Row viewing
  int currentRowIndex = 0;

  // CSV parsing options
  bool csvHasHeader = true;
  String csvDelimiter = ',';

  // JSON parsing options
  bool jsonFlatten = true;

  bool isParsing = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      data = widget.initialData;
      stage = UiStage.fieldSelect;
      fileName = widget.initialDatasetName ?? 'Loaded dataset';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabular Data Explorer'),
        actions: [
          IconButton(
            tooltip: 'Manage saved datasets',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const DatasetManagerScreen()),
              );
            },
            icon: const Icon(Icons.folder_open),
          ),
          IconButton(
            tooltip: 'Save current data',
            onPressed: data == null ? null : _saveCurrentToStore,
            icon: const Icon(Icons.save),
          ),
                    IconButton(
            tooltip: 'Save selected item (row)',
            onPressed: (data == null || stage != UiStage.viewRows)
                ? null
                : _saveCurrentItemToStore,
            icon: const Icon(Icons.save_as),
          ),
        ],
      ),
      body: SafeArea(
        child: switch (stage) {
          UiStage.pick => _buildPickView(context),
          UiStage.fieldSelect => _buildFieldSelectView(context),
          UiStage.viewRows => _buildRowViewer(context),
        },
      ),
    );
  }

  Widget _buildPickView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          Text(
            'Pick a JSON or CSV file. For JSON, nested objects are flattened by default. For CSV, the first row is treated as header by default.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.upload_file),
            label: const Text('Pick file'),
            onPressed: isParsing ? null : _pickAndParseFile,
          ),
          const SizedBox(height: 16),
          if (isParsing) const LinearProgressIndicator(),
          if (fileName != null) ...[
            const SizedBox(height: 8),
            Text('Selected file: $fileName'),
          ],
        ],
      ),
    );
  }

  Widget _buildFieldSelectView(BuildContext context) {
    final allFields = data?.columns ?? const <String>[];
    final filteredFields = allFields
        .where(
          (f) =>
              fieldFilter.isEmpty ||
              f.toLowerCase().contains(fieldFilter.toLowerCase()),
        )
        .toList();

    final allSelected =
        selectedFields.length == allFields.length && allFields.isNotEmpty;

    return Column(
      children: [
        _TopBar(
          left: TextButton.icon(
            onPressed: () {
              setState(() {
                stage = UiStage.pick;
                selectedFields.clear();
                data = null;
                error = null;
                fileName = null;
              });
            },
            icon: const Icon(Icons.chevron_left),
            label: const Text('Pick another file'),
          ),
          right: FilledButton.icon(
            onPressed: selectedFields.isEmpty
                ? null
                : () {
                    setState(() {
                      currentRowIndex = 0;
                      stage = UiStage.viewRows;
                    });
                  },
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Next'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Filter fields...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (s) => setState(() => fieldFilter = s),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: allSelected
                    ? () => setState(() => selectedFields.clear())
                    : () => setState(() => selectedFields.addAll(allFields)),
                child: Text(allSelected ? 'Clear all' : 'Select all'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredFields.length,
            itemBuilder: (context, index) {
              final field = filteredFields[index];
              final checked = selectedFields.contains(field);
              return CheckboxListTile(
                title: Text(field),
                value: checked,
                onChanged: (v) {
                  setState(() {
                    if (v == true) {
                      selectedFields.add(field);
                    } else {
                      selectedFields.remove(field);
                    }
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRowViewer(BuildContext context) {
    final td = data!;
    final selected = selectedFields.toList()..sort();

    final isFirst = currentRowIndex <= 0;
    final isLast = currentRowIndex >= (td.rowCount - 1);

    return Column(
      children: [
        _TopBar(
          left: TextButton.icon(
            onPressed: () => setState(() => stage = UiStage.fieldSelect),
            icon: const Icon(Icons.chevron_left),
            label: const Text('Back to fields'),
          ),
          center: Text('Row ${currentRowIndex + 1} of ${td.rowCount}'),
          right: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Previous row',
                icon: const Icon(Icons.navigate_before),
                onPressed: isFirst
                    ? null
                    : () => setState(() => currentRowIndex--),
              ),
              IconButton(
                tooltip: 'Next row',
                icon: const Icon(Icons.navigate_next),
                onPressed: isLast
                    ? null
                    : () => setState(() => currentRowIndex++),
              ),
            ],
          ),
        ),
        if (td.rowCount == 0)
          const Expanded(
            child: Center(child: Text('No rows found in this file.')),
          )
        else if (selected.isEmpty)
          const Expanded(
            child: Center(
              child: Text('No fields selected. Go back and choose fields.'),
            ),
          )
        else
          Expanded(
            child: ListView.separated(
              itemCount: selected.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final field = selected[index];
                final value = _stringify(td.valueOf(currentRowIndex, field));
                return ListTile(
                  title: Text(field),
                  subtitle: Text(
                    value,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Future<void> _pickAndParseFile() async {
    setState(() {
      error = null;
      isParsing = true;
    });

    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.any,
        withData: true,
      );
      if (res == null || res.files.isEmpty) {
        setState(() {
          isParsing = false;
        });
        return;
      }

      final file = res.files.first;
      fileName = file.name;

      if (file.bytes == null) {
        throw Exception(
          'Could not read file bytes. Try another file or platform.',
        );
      }
      final raw = _decodeBytesToString(file.bytes!);

      final ext = (file.extension ?? '').toLowerCase();
      if (ext == 'json' || _looksLikeJson(raw)) {
        final td = JsonTabularParser.fromJsonString(
          raw,
          flatten: jsonFlatten,
          encodeComplexAsJson: true,
        );
        _onParsed(td);
      } else {
        csvDelimiter = _guessDelimiter(raw);
        final td = CsvTabularParser.fromCsvString(
          raw,
          delimiter: csvDelimiter,
          hasHeader: csvHasHeader,
          trimFields: true,
        );
        _onParsed(td);
      }
    } catch (e) {
      setState(() {
        error = 'Failed to parse: $e';
        isParsing = false;
      });
    }
  }

  Future<void> _saveCurrentItemToStore() async {
    final td = data;
    if (td == null || td.rowCount == 0) return;
    if (currentRowIndex < 0 || currentRowIndex >= td.rowCount) return;

    // Default: save only currently selected fields; if none selected, use all.
    final defaultSelected =
        selectedFields.isEmpty ? td.columns : (selectedFields.toList()..sort());

    BackendKind selectedBackend = BackendKind.sqflite;
    bool onlySelected = true;
    final nameCtrl = TextEditingController(
      text: (fileName ?? widget.initialDatasetName ?? 'Dataset')
          .toString()
          .trim()
          .isEmpty
          ? 'Item Row ${currentRowIndex + 1}'
          : '${(fileName ?? widget.initialDatasetName)!} - Row ${currentRowIndex + 1}',
    );

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          title: const Text('Save selected item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<BackendKind>(
                value: selectedBackend,
                decoration: const InputDecoration(labelText: 'Backend'),
                onChanged: (v) =>
                                    setStateDialog(() => selectedBackend = v ?? selectedBackend),
                items: const [
                  DropdownMenuItem(
                    value: BackendKind.sqflite,
                    child: Text('SQLite (sqflite)'),
                  ),
                  DropdownMenuItem(
                    value: BackendKind.jsonFile,
                    child: Text('JSON file'),
                  ),
                  DropdownMenuItem(
                    value: BackendKind.csvFile,
                    child: Text('CSV file'),
                  ),
                  DropdownMenuItem(
                    value: BackendKind.sharedPrefs,
                    child: Text('SharedPreferences'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,

                value: onlySelected,
                onChanged: (v) =>
                    setStateDialog(() => onlySelected = v ?? true),
                title: Text(
                  'Save only selected fields (${defaultSelected.length})',
                ),
                subtitle: Text(
                  'If unchecked, all ${td.columnCount} fields in this row will be saved.',
                ),

              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Save item'),
            ),
          ],
        ),
      ),
    );

    if (ok != true) return;

    final cols = onlySelected ? defaultSelected : td.columns;
    // Build one-row dataset with these columns
    final row = List<dynamic>.generate(

      cols.length,
      (i) => td.valueOf(currentRowIndex, cols[i]),
      growable: false,
    );
    final itemDataset = TabularData(cols, [row]);

    final store = TabularDataStoreFactory.create(selectedBackend);
    final name = nameCtrl.text.trim().isEmpty
        ? 'Item Row ${currentRowIndex + 1}'
        : nameCtrl.text.trim();
    final id = await store.save(itemDataset, name: name);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Item saved (backend ${store.backendId}) id=$id',
        ),
      ),
    );
  }
  void _onParsed(TabularData td) {
    setState(() {
      data = td;
      selectedFields.clear();
      currentRowIndex = 0;
      stage = UiStage.fieldSelect;
      isParsing = false;
    });
  }

  String _decodeBytesToString(List<int> bytes) {
    try {
      return utf8.decode(bytes);
    } catch (_) {
      return latin1.decode(bytes);
    }
  }

  String _stringify(dynamic v) {
    if (v == null) return 'null';
    if (v is String) return v;
    return v.toString();
  }

  bool _looksLikeJson(String s) {
    final t = s.trimLeft();
    return t.startsWith('{') || t.startsWith('[');
  }

  String _guessDelimiter(String s) {
    final lines = const LineSplitter().convert(s);
    final sample = lines.where((l) => l.trim().isNotEmpty).take(5).toList();
    int commas = 0, semis = 0, tabs = 0, pipes = 0;
    for (final l in sample) {
      commas += _countChar(l, ',');
      semis += _countChar(l, ';');
      tabs += _countChar(l, '\t');
      pipes += _countChar(l, '|');
    }
    final pairs = {',': commas, ';': semis, '\t': tabs, '|': pipes};
    final best = pairs.entries.reduce((a, b) => a.value >= b.value ? a : b);
    return best.key;
  }

  int _countChar(String s, String ch) {
    var count = 0;
    for (var i = 0; i < s.length; i++) {
      if (s[i] == ch) count++;
    }
    return count;
  }

  Future<void> _saveCurrentToStore() async {
    final td = data;
    if (td == null) return;

    BackendKind selected = BackendKind.sqflite;
    final nameCtrl = TextEditingController(
      text:
          widget.initialDatasetName ??
          'Dataset ${DateTime.now().toIso8601String()}',
    );

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Save dataset'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<BackendKind>(
              value: selected,
              decoration: const InputDecoration(labelText: 'Backend'),
              onChanged: (v) => selected = v ?? selected,
              items: const [
                DropdownMenuItem(
                  value: BackendKind.sqflite,
                  child: Text('SQLite (sqflite)'),
                ),
                DropdownMenuItem(
                  value: BackendKind.jsonFile,
                  child: Text('JSON file'),
                ),
                DropdownMenuItem(
                  value: BackendKind.csvFile,
                  child: Text('CSV file'),
                ),
                DropdownMenuItem(
                  value: BackendKind.sharedPrefs,
                  child: Text('SharedPreferences'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (ok != true) return;

    final store = TabularDataStoreFactory.create(selected);
    final id = await store.save(
      td,
      name: nameCtrl.text.trim().isEmpty
          ? 'Dataset ${DateTime.now().toIso8601String()}'
          : nameCtrl.text.trim(),
    );

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Saved (backend ${store.backendId}) id=$id')),
    );
  }
}

// NOTE: Keep your existing JsonTabularParser and CsvTabularParser classes as-is in your project.
class JsonTabularParser {
  static TabularData fromJsonString(
    String jsonSource, {
    bool flatten = false,
    String separator = '.',
    bool encodeComplexAsJson = true,
    bool preserveKeyDiscoveryOrder = true,
  }) {
    final decoded = jsonDecode(jsonSource);
    return fromJsonDynamic(
      decoded,
      flatten: flatten,
      separator: separator,
      encodeComplexAsJson: encodeComplexAsJson,
      preserveKeyDiscoveryOrder: preserveKeyDiscoveryOrder,
    );
  }

  static TabularData fromJsonDynamic(
    dynamic decoded, {
    bool flatten = false,
    String separator = '.',
    bool encodeComplexAsJson = true,
    bool preserveKeyDiscoveryOrder = true,
  }) {
    final uniqueKeys = preserveKeyDiscoveryOrder ? <String>{} : <String>{};
    final List<Map<String, dynamic>> normalizedRows = [];

    if (decoded is List) {
      for (final item in decoded) {
        final map = _normalizeToFlatMap(
          item,
          flatten: flatten,
          separator: separator,
          encodeComplexAsJson: encodeComplexAsJson,
        );
        normalizedRows.add(map);
        uniqueKeys.addAll(map.keys);
      }
    } else if (decoded is Map) {
      final map = _normalizeToFlatMap(
        decoded,
        flatten: flatten,
        separator: separator,
        encodeComplexAsJson: encodeComplexAsJson,
      );
      normalizedRows.add(map);
      uniqueKeys.addAll(map.keys);
    } else {
      throw ArgumentError('Expected a JSON array or object.');
    }

    final columns = preserveKeyDiscoveryOrder
        ? uniqueKeys.toList()
        : (uniqueKeys.toList()..sort());

    final rows = <List<dynamic>>[];
    for (final m in normalizedRows) {
      final row = List<dynamic>.generate(
        columns.length,
        (i) => m.containsKey(columns[i]) ? m[columns[i]] : null,
        growable: false,
      );
      rows.add(row);
    }

    return TabularData(columns, rows);
  }

  static Map<String, dynamic> _normalizeToFlatMap(
    dynamic value, {
    required bool flatten,
    required String separator,
    required bool encodeComplexAsJson,
  }) {
    if (value is Map) {
      if (!flatten) {
        return value.map(
          (k, v) => MapEntry(
            k.toString(),
            _maybeEncodeComplex(v, encodeComplexAsJson),
          ),
        );
      } else {
        final out = <String, dynamic>{};
        _flattenInto(out, value, '', separator, encodeComplexAsJson);
        return out;
      }
    } else if (value is List) {
      final out = <String, dynamic>{};
      for (var i = 0; i < value.length; i++) {
        final key = '[$i]';
        final v = value[i];
        if (flatten && v is Map) {
          _flattenInto(out, v, key, separator, encodeComplexAsJson);
        } else {
          out[key] = _maybeEncodeComplex(v, encodeComplexAsJson);
        }
      }
      return out;
    } else {
      return {'value': value};
    }
  }

  static void _flattenInto(
    Map<String, dynamic> out,
    Map input,
    String prefix,
    String separator,
    bool encodeComplexAsJson,
  ) {
    input.forEach((k, v) {
      final key = prefix.isEmpty ? k.toString() : '$prefix$separator$k';
      if (v is Map) {
        _flattenInto(out, v, key, separator, encodeComplexAsJson);
      } else if (v is List) {
        out[key] = jsonEncode(v);
      } else {
        out[key] = v;
      }
    });
  }

  static dynamic _maybeEncodeComplex(dynamic v, bool encode) {
    if (!encode) return v;
    if (v is Map || v is List) return jsonEncode(v);
    return v;
  }
}

class CsvTabularParser {
  static TabularData fromCsvString(
    String input, {
    String delimiter = ',',
    bool hasHeader = true,
    bool trimFields = false,
  }) {
    if (delimiter.length != 1) {
      throw ArgumentError('Only single-character delimiter is supported.');
    }
    final rows = _parseCsv(input, delimiter);
    if (rows.isEmpty) return TabularData(const [], const []);

    late final List<String> columns;
    final List<List<dynamic>> dataRows = [];

    if (hasHeader) {
      columns = rows.first.map((s) => trimFields ? s.trim() : s).toList();
      for (var i = 1; i < rows.length; i++) {
        final r = trimFields ? rows[i].map((s) => s.trim()).toList() : rows[i];
        dataRows.add(_fitToWidth(r, columns.length));
      }
    } else {
      final width = rows
          .map((r) => r.length)
          .fold<int>(0, (a, b) => a > b ? a : b);
      columns = List.generate(width, (i) => 'col_$i');
      for (final r in rows) {
        dataRows.add(
          _fitToWidth(trimFields ? r.map((s) => s.trim()).toList() : r, width),
        );
      }
    }

    return TabularData(columns, dataRows);
  }

  static List<List<String>> _parseCsv(String input, String delimiter) {
    final List<List<String>> rows = [];
    final List<String> currentRow = [];
    final StringBuffer field = StringBuffer();

    final d = delimiter.codeUnitAt(0);
    final q = 34; // "
    final cr = 13; // \r
    final lf = 10; // \n

    bool inQuotes = false;
    final codes = input.codeUnits;
    int i = 0;

    void endField() {
      currentRow.add(field.toString());
      field.clear();
    }

    void endRow() {
      endField();
      rows.add(List<String>.from(currentRow));
      currentRow.clear();
    }

    while (i < codes.length) {
      final c = codes[i];

      if (inQuotes) {
        if (c == q) {
          final isEscaped = (i + 1 < codes.length && codes[i + 1] == q);
          if (isEscaped) {
            field.writeCharCode(q);
            i += 2;
            continue;
          } else {
            inQuotes = false;
            i++;
            continue;
          }
        } else {
          field.writeCharCode(c);
          i++;
          continue;
        }
      } else {
        if (c == q) {
          inQuotes = true;
          i++;
          continue;
        } else if (c == d) {
          endField();
          i++;
          continue;
        } else if (c == cr) {
          if (i + 1 < codes.length && codes[i + 1] == lf) {
            i += 2;
          } else {
            i++;
          }
          endRow();
          continue;
        } else if (c == lf) {
          i++;
          endRow();
          continue;
        } else {
          field.writeCharCode(c);
          i++;
          continue;
        }
      }
    }

    if (inQuotes) {
      inQuotes = false;
    }
    if (field.isNotEmpty || currentRow.isNotEmpty) {
      endRow();
    }

    return rows;
  }

  static List<dynamic> _fitToWidth(List<String> row, int width) {
    if (row.length == width) return List<dynamic>.from(row);
    if (row.length > width) {
      return List<dynamic>.from(row.take(width));
    } else {
      final r = List<dynamic>.from(row);
      while (r.length < width) {
        r.add(null);
      }
      return r;
    }
  }
}

class _TopBar extends StatelessWidget {
  final Widget? left;
  final Widget? center;
  final Widget? right;

  const _TopBar({this.left, this.center, this.right});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            SizedBox(width: 160, child: left),
            Expanded(child: Center(child: center)),
            SizedBox(
              width: 160,
              child: Align(alignment: Alignment.centerRight, child: right),
            ),
          ],
        ),
      ),
    );
  }
}
class ScraperPage extends StatefulWidget {
  const ScraperPage({super.key});

  @override
  State<ScraperPage> createState() => _ScraperPageState();
}

class _ScraperPageState extends State<ScraperPage> {
  bool _loading = false;
  String? _status;
  List<Map<String, dynamic>> _results = [];
  List<Map<String, dynamic>> _rawInputs = [];
  String _outputFormat = 'json'; // 'json' or 'csv'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MPD Extractor (BeautifulSoup for Flutter)'),
        actions: [
          PopupMenuButton<String>(
            initialValue: _outputFormat,
            onSelected: (v) => setState(() => _outputFormat = v),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'json', child: Text('Output: JSON')),
              PopupMenuItem(value: 'csv', child: Text('Output: CSV')),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: Text(_outputFormat.toUpperCase())),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: 'Save results',
            onPressed: _results.isEmpty || _loading ? null : _saveResults,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _loading ? null : _pickJsonAndProcess,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Load JSON and Process'),
                ),
                const SizedBox(width: 12),
                if (_loading) const CircularProgressIndicator(),
                const SizedBox(width: 12),
                if (_status != null) Expanded(child: Text(_status!)),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _results.isEmpty
                ? const Center(child: Text('No results yet.'))
                : ListView.separated(
                    itemCount: _results.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final r = _results[i];
                      final urls = (r['urls'] as Map<String, dynamic>);
                      return ListTile(
                        title: Text(r['title'] ?? '(no title)'),
                        subtitle: Text(
                          [
                            'Source: ${r['sourceUrl'] ?? ''}',
                            'Poster: ${r['poster'] ?? ''}',
                            'MPDs: 360(${(urls['360'] as List).length}), '
                                '720(${(urls['720'] as List).length}), '
                                '1280(${(urls['1280'] as List).length}), '
                                '2160(${(urls['2160'] as List).length}), '
                                '4096(${(urls['4096'] as List).length}), '
                                'unknown(${(urls['unknown'] as List).length})',
                          ].join('\n'),
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.copy),
                          tooltip: 'Copy JSON to clipboard',
                          onPressed: () {
                            final pretty = const JsonEncoder.withIndent(
                              '  ',
                            ).convert(r);
                            _copyToClipboard(context, pretty);
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickJsonAndProcess() async {
    try {
      setState(() {
        _loading = true;
        _status = 'Pick a JSON file…';
        _results = [];
        _rawInputs = [];
      });

      final typeGroup = XTypeGroup(label: 'json', extensions: ['json']);
      final xfile = await openFile(acceptedTypeGroups: [typeGroup]);
      if (xfile == null) {
        setState(() {
          _loading = false;
          _status = 'Canceled.';
        });
        return;
      }

      _status = 'Reading ${xfile.name}…';
      setState(() {});

      final content = await xfile.readAsString();
      dynamic decoded;
      try {
        decoded = jsonDecode(content);
      } catch (e) {
        throw Exception('Invalid JSON: $e');
      }

      final List<Map<String, dynamic>> items = _normalizeInput(decoded);
      setState(() {
        _rawInputs = items;
        _status = 'Found ${items.length} item(s). Processing…';
      });

      final results = <Map<String, dynamic>>[];
      // Process sequentially to keep it simple and friendly to servers.
      for (var i = 0; i < items.length; i++) {
        final item = items[i];
        setState(() {
          _status = 'Processing ${i + 1}/${items.length}…';
        });
        final res = await _processOne(item);
        results.add(res);
      }

      setState(() {
        _results = results;
        _status = 'Done. ${results.length} result(s) ready.';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _status = 'Error: $e';
      });
    }
  }

  List<Map<String, dynamic>> _normalizeInput(dynamic decoded) {
    if (decoded is List) {
      return decoded
          .cast<Map>()
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    }
    if (decoded is Map) {
      return [Map<String, dynamic>.from(decoded)];
    }
    throw Exception('Top-level JSON must be an object or a list of objects.');
  }

  Future<Map<String, dynamic>> _processOne(Map<String, dynamic> item) async {
    // Extract meta fields
    final meta = (item['meta'] is Map<String, dynamic>)
        ? item['meta'] as Map<String, dynamic>
        : {};
    final metaTags = (meta['meta_tags'] is Map<String, dynamic>)
        ? meta['meta_tags'] as Map<String, dynamic>
        : {};

    final ogUrl = _firstNonEmpty([
      metaTags['og:url'],
      item['post_url'],
      item['main_url'],
    ]);

    if (ogUrl == null || ogUrl.isEmpty) {
      return _buildEmptyResult(
        title: _firstNonEmpty([metaTags['og:title'], item['post_title']]) ?? '',
        description:
            _firstNonEmpty([metaTags['og:description'], item['overview']]) ??
            '',
        poster: _firstNonEmpty([metaTags['og:image'], item['poster']]) ?? '',
        sourceUrl: null,
      );
    }

    final title =
        _firstNonEmpty([metaTags['og:title'], item['post_title']]) ?? '';
    final description =
        _firstNonEmpty([metaTags['og:description'], item['overview']]) ?? '';
    final poster = _absoluteUrl(
      _firstNonEmpty([metaTags['og:image'], item['poster']]) ?? '',
      ogUrl,
    );

    // Fetch page
    final html = await _fetchHtml(ogUrl);

    // Parse and extract mpd urls
    final mpdUrls = _extractMpdUrls(html, ogUrl);

    // Bucket by resolution
    final buckets = <String, List<String>>{
      '360': [],
      '720': [],
      '1280': [], // 1080 will be mapped here (per your request)
      '2160': [],
      '4096': [],
      'unknown': [],
    };
    for (final u in mpdUrls) {
      final bucket = _bucketResolution(u);
      buckets[bucket]!.add(u);
    }

    return {
      'title': title,
      'description': description,
      'poster': poster,
      'sourceUrl': ogUrl,
      'urls': buckets,
    };
  }

  Map<String, dynamic> _buildEmptyResult({
    required String title,
    required String description,
    required String poster,
    required String? sourceUrl,
  }) {
    return {
      'title': title,
      'description': description,
      'poster': poster,
      'sourceUrl': sourceUrl,
      'urls': {
        '360': [],
        '720': [],
        '1280': [],
        '2160': [],
        '4096': [],
        'unknown': [],
      },
    };
  }

  String? _firstNonEmpty(List<dynamic> candidates) {
    for (final c in candidates) {
      if (c == null) continue;
      final s = c.toString().trim();
      if (s.isNotEmpty) return s;
    }
    return null;
  }

  Future<String> _fetchHtml(String url) async {
    final uri = Uri.parse(url);
    final resp = await http.get(
      uri,
      headers: {
        // Basic headers to look more like a browser
        'User-Agent':
            'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 '
            '(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept':
            'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
      },
    );
    if (resp.statusCode != 200) {
      throw Exception('HTTP ${resp.statusCode} for $url');
    }
    return resp.body;
  }

  List<String> _extractMpdUrls(String html, String baseUrl) {
    final bs = BeautifulSoup(html);

    // Find the Plyr video wrapper
    // 1) find the div with class plyr__video-wrapper
    // 2) find a descendant <video>
    // 3) find all <source> where src contains .mpd OR mode="mpd"
    final wrapper = bs.find('div', class_: 'plyr__video-wrapper');
    if (wrapper == null) {
      // fallback: any <source> with mpd on the page
      return bs
          .findAll('source', attrs: {'src': true})
          .where((e) {
            final src = e['src']?.toString() ?? '';
            final mode = e['mode']?.toString() ?? '';
            return mode.toLowerCase() == 'mpd' ||
                src.toLowerCase().contains('.mpd');
          })
          .map((e) => _absoluteUrl(e['src']!.toString(), baseUrl))
          .toSet()
          .toList();
    }

    final video = wrapper.find('video');
    if (video == null) {
      return [];
    }

    final sources = video.findAll('source', attrs: {'src': true});
    final urls = <String>{};
    for (final s in sources) {
      final mode = (s['mode'] ?? '').toString().toLowerCase();
      final src = (s['src'] ?? '').toString();
      if (src.isEmpty) continue;
      if (mode == 'mpd' || src.toLowerCase().contains('.mpd')) {
        urls.add(_absoluteUrl(src, baseUrl));
      }
    }
    return urls.toList();
  }

  String _absoluteUrl(String maybeRelative, String base) {
    if (maybeRelative.isEmpty) return maybeRelative;
    try {
      final baseUri = Uri.parse(base);
      final uri = Uri.parse(maybeRelative);
      if (uri.hasScheme) return uri.toString();
      return baseUri.resolveUri(uri).toString();
    } catch (_) {
      return maybeRelative;
    }
  }

  // Map MPD URL to resolution bucket
  // Logic:
  // - Try to read "size=" from the query or path if present (common in HTML attribute, but we don’t see it here).
  // - Parse common resolution tokens from URL: 360, 480, 720, 1080, 1280, 1440, 2160, 4096
  // - Per request: map 1080 => 1280 bucket.
  String _bucketResolution(String url) {
    // Try extracting typical resolution hints from URL segments
    final lower = url.toLowerCase();

    // Common patterns, adjust as needed
    final reg = RegExp(r'(?<!\d)(360|480|720|1080|1280|1440|2160|4096)(?!\d)');
    final match = reg.firstMatch(lower);
    if (match != null) {
      final val = int.tryParse(match.group(1)!);
      if (val != null) {
        switch (val) {
          case 360:
            return '360';
          case 720:
            return '720';
          case 1080:
            // Map 1080 to 1280 bucket per your instruction
            return '1280';
          case 1280:
            return '1280';
          case 2160:
            return '2160';
          case 4096:
            return '4096';
          default:
            return 'unknown';
        }
      }
    }
    return 'unknown';
  }

  Future<void> _saveResults() async {
    try {
      final suggestedName = _outputFormat == 'json'
          ? 'results_${DateTime.now().toIso8601String().replaceAll(':', '-')}.json'
          : 'results_${DateTime.now().toIso8601String().replaceAll(':', '-')}.csv';
      final saveLocation = await getSaveLocation(suggestedName: suggestedName);
      if (saveLocation == null) return;

      final data = _outputFormat == 'json'
          ? const JsonEncoder.withIndent('  ').convert(_results)
          : _toCsv(_results);

      final xfile = XFile.fromData(
        utf8.encode(data),
        mimeType: _outputFormat == 'json' ? 'application/json' : 'text/csv',
        name: suggestedName,
      );
      await xfile.saveTo(saveLocation.path);

      setState(() {
        _status = 'Saved to ${saveLocation.path}';
      });
    } catch (e) {
      setState(() {
        _status = 'Save failed: $e';
      });
    }
  }

  String _toCsv(List<Map<String, dynamic>> results) {
    // Columns: title, description, poster, sourceUrl, 360, 720, 1280, 2160, 4096, unknown
    final headers = [
      'title',
      'description',
      'poster',
      'sourceUrl',
      '360',
      '720',
      '1280',
      '2160',
      '4096',
      'unknown',
    ];
    final rows = <List<String>>[];
    rows.add(headers);

    for (final r in results) {
      final urls = (r['urls'] as Map<String, dynamic>);
      String joinList(List<dynamic> l) =>
          l.map((e) => e.toString()).join(' | ');
      rows.add([
        _csvEscape(r['title'] ?? ''),
        _csvEscape(r['description'] ?? ''),
        _csvEscape(r['poster'] ?? ''),
        _csvEscape(r['sourceUrl'] ?? ''),
        _csvEscape(joinList(urls['360'] as List)),
        _csvEscape(joinList(urls['720'] as List)),
        _csvEscape(joinList(urls['1280'] as List)),
        _csvEscape(joinList(urls['2160'] as List)),
        _csvEscape(joinList(urls['4096'] as List)),
        _csvEscape(joinList(urls['unknown'] as List)),
      ]);
    }

    final sb = StringBuffer();
    for (final row in rows) {
      sb.writeln(row.join(','));
    }
    return sb.toString();
  }

  String _csvEscape(String value) {
    // Escape CSV fields by surrounding with quotes if needed
    final needsQuotes =
        value.contains(',') ||
        value.contains('"') ||
        value.contains('\n') ||
        value.contains('\r');
    var v = value.replaceAll('"', '""');
    if (needsQuotes) v = '"$v"';
    return v;
  }

  void _copyToClipboard(BuildContext context, String text) {
    // Clipboard.setData requires services; avoid importing here to keep file tight
    // ignore: deprecated_member_use
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied JSON to clipboard (simulate).')),
    );
  }
}


// lib/tabular_parsers.dart

// class TabularData {
//   final List<String> columns;
//   final List<List<dynamic>> rows;

//   late final Map<String, int> _columnIndex =
//       {for (var i = 0; i < columns.length; i++) columns[i]: i};

//   TabularData(this.columns, this.rows);

//   int get rowCount => rows.length;
//   int get columnCount => columns.length;

//   dynamic valueAt(int rowIndex, int colIndex) {
//     return rows[rowIndex][colIndex];
//   }

//   dynamic valueOf(int rowIndex, String fieldName) {
//     final idx = _columnIndex[fieldName];
//     if (idx == null) {
//       throw ArgumentError('Field not found: $fieldName');
//     }
//     return rows[rowIndex][idx];
//   }

//   Iterable<dynamic> columnValues(String fieldName) sync* {
//     final idx = _columnIndex[fieldName];
//     if (idx == null) {
//       throw ArgumentError('Field not found: $fieldName');
//     }
//     for (final r in rows) {
//       yield r[idx];
//     }
//   }

//   Map<String, dynamic> rowAsMap(int rowIndex) {
//     final r = rows[rowIndex];
//     return {for (var i = 0; i < columns.length; i++) columns[i]: r[i]};
//   }

//   List<Map<String, dynamic>> toMapRows() {
//     return List.generate(rowCount, rowAsMap);
//   }

//   // Generates a Dart class with static const String for each field.
//   // Example: final code = data.generateConstantsClass('JsonFields');
//   String generateConstantsClass(String className) {
//     final sb = StringBuffer();
//     sb.writeln('class $className {');
//     for (final c in columns) {
//       final constName = _toValidIdentifier(c);
//       sb.writeln("  static const String $constName = '$c';");
//     }
//     sb.writeln('}');
//     return sb.toString();
//   }

//   String _toValidIdentifier(String input) {
//     final cleaned = input.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '_');
//     final startsWithDigit = RegExp(r'^\d').hasMatch(cleaned);
//     final base = cleaned.isEmpty ? 'field' : cleaned;
//     return startsWithDigit ? '_$base' : base;
//   }
// }

// class JsonTabularParser {
//   // jsonSource can be:
//   // - A JSON array of objects: [{"a":1,"b":2}, {"a":3,"c":4}]
//   // - A single object: {"a":1,"b":2}
//   //
//   // flatten: if true, nested maps are flattened to dotted paths: user.name -> "John"
//   // encodeComplexAsJson: for lists/maps (when not flattened), encode to JSON string
//   static TabularData fromJsonString(
//     String jsonSource, {
//     bool flatten = false,
//     String separator = '.',
//     bool encodeComplexAsJson = true,
//     bool preserveKeyDiscoveryOrder = true,
//   }) {
//     final decoded = jsonDecode(jsonSource);
//     return fromJsonDynamic(
//       decoded,
//       flatten: flatten,
//       separator: separator,
//       encodeComplexAsJson: encodeComplexAsJson,
//       preserveKeyDiscoveryOrder: preserveKeyDiscoveryOrder,
//     );
//   }

//   static TabularData fromJsonDynamic(
//     dynamic decoded, {
//     bool flatten = false,
//     String separator = '.',
//     bool encodeComplexAsJson = true,
//     bool preserveKeyDiscoveryOrder = true,
//   }) {
//     final uniqueKeys = preserveKeyDiscoveryOrder
//         ? <String>{} // LinkedHashSet by default in Dart
//         : <String>{};

//     final List<Map<String, dynamic>> normalizedRows = [];

//     if (decoded is List) {
//       for (final item in decoded) {
//         final map = _normalizeToFlatMap(
//           item,
//           flatten: flatten,
//           separator: separator,
//           encodeComplexAsJson: encodeComplexAsJson,
//         );
//         normalizedRows.add(map);
//         uniqueKeys.addAll(map.keys);
//       }
//     } else if (decoded is Map) {
//       final map = _normalizeToFlatMap(
//         decoded,
//         flatten: flatten,
//         separator: separator,
//         encodeComplexAsJson: encodeComplexAsJson,
//       );
//       normalizedRows.add(map);
//       uniqueKeys.addAll(map.keys);
//     } else {
//       throw ArgumentError('Expected a JSON array or object.');
//     }

//     final columns = preserveKeyDiscoveryOrder
//         ? uniqueKeys.toList()
//         : (uniqueKeys.toList()..sort());

//     final rows = <List<dynamic>>[];
//     for (final m in normalizedRows) {
//       final row = List<dynamic>.generate(
//         columns.length,
//         (i) => m.containsKey(columns[i]) ? m[columns[i]] : null,
//         growable: false,
//       );
//       rows.add(row);
//     }

//     return TabularData(columns, rows);
//   }

//   static Map<String, dynamic> _normalizeToFlatMap(
//     dynamic value, {
//     required bool flatten,
//     required String separator,
//     required bool encodeComplexAsJson,
//   }) {
//     if (value is Map) {
//       if (!flatten) {
//         // Keep top-level keys; convert complex nested values if needed.
//         return value.map((k, v) => MapEntry(k.toString(),
//             _maybeEncodeComplex(v, encodeComplexAsJson)));
//       } else {
//         final out = <String, dynamic>{};
//         _flattenInto(out, value, '', separator, encodeComplexAsJson);
//         return out;
//       }
//     } else if (value is List) {
//       // Treat list-of-values as a single record:
//       // create indexed keys: [0], [1], ...
//       final out = <String, dynamic>{};
//       for (var i = 0; i < value.length; i++) {
//         final key = '[$i]';
//         final v = value[i];
//         if (flatten && v is Map) {
//           _flattenInto(out, v, key, separator, encodeComplexAsJson);
//         } else {
//           out[key] = _maybeEncodeComplex(v, encodeComplexAsJson);
//         }
//       }
//       return out;
//     } else {
//       // Single primitive as a record
//       return {'value': value};
//     }
//   }

//   static void _flattenInto(
//     Map<String, dynamic> out,
//     Map input,
//     String prefix,
//     String separator,
//     bool encodeComplexAsJson,
//   ) {
//     input.forEach((k, v) {
//       final key = prefix.isEmpty ? k.toString() : '$prefix$separator$k';
//       if (v is Map) {
//         _flattenInto(out, v, key, separator, encodeComplexAsJson);
//       } else if (v is List) {
//         // Lists are encoded as JSON string to avoid exploding columns.
//         out[key] = jsonEncode(v);
//       } else {
//         out[key] = v;
//       }
//     });
//   }

//   static dynamic _maybeEncodeComplex(dynamic v, bool encode) {
//     if (!encode) return v;
//     if (v is Map || v is List) return jsonEncode(v);
//     return v;
//     }
// }

// class CsvTabularParser {
//   // Parses CSV with:
//   // - Custom delimiter (default ,)
//   // - Proper quote handling (double quotes, "" escaped inside)
//   // - Optional header row
//   static TabularData fromCsvString(
//     String input, {
//     String delimiter = ',',
//     bool hasHeader = true,
//     bool trimFields = false,
//   }) {
//     if (delimiter.length != 1) {
//       throw ArgumentError('Only single-character delimiter is supported.');
//     }
//     final rows = _parseCsv(input, delimiter);
//     if (rows.isEmpty) return TabularData(const [], const []);

//     late final List<String> columns;
//     final List<List<dynamic>> dataRows = [];

//     if (hasHeader) {
//       columns = rows.first.map((s) => trimFields ? s.trim() : s).toList();
//       for (var i = 1; i < rows.length; i++) {
//         final r = trimFields ? rows[i].map((s) => s.trim()).toList() : rows[i];
//         // Pad or trim to match column count
//         dataRows.add(_fitToWidth(r, columns.length));
//       }
//     } else {
//       final width = rows.map((r) => r.length).fold<int>(0, (a, b) => a > b ? a : b);
//       columns = List.generate(width, (i) => 'col_$i');
//       for (final r in rows) {
//         dataRows.add(_fitToWidth(trimFields ? r.map((s) => s.trim()).toList() : r, width));
//       }
//     }

//     return TabularData(columns, dataRows);
//   }

//   static List<List<String>> _parseCsv(String input, String delimiter) {
//     final List<List<String>> rows = [];
//     final List<String> currentRow = [];
//     final StringBuffer field = StringBuffer();

//     final d = delimiter.codeUnitAt(0);
//     final q = 34; // "
//     final cr = 13; // \r
//     final lf = 10; // \n

//     bool inQuotes = false;
//     final codes = input.codeUnits;
//     int i = 0;

//     void endField() {
//       currentRow.add(field.toString());
//       field.clear();
//     }

//     void endRow() {
//       endField();
//       rows.add(List<String>.from(currentRow));
//       currentRow.clear();
//     }

//     while (i < codes.length) {
//       final c = codes[i];

//       if (inQuotes) {
//         if (c == q) {
//           // Peek for escaped quote
//           final isEscaped = (i + 1 < codes.length && codes[i + 1] == q);
//           if (isEscaped) {
//             field.writeCharCode(q);
//             i += 2;
//             continue;
//           } else {
//             inQuotes = false;
//             i++;
//             continue;
//           }
//         } else {
//           field.writeCharCode(c);
//           i++;
//           continue;
//         }
//       } else {
//         if (c == q) {
//           inQuotes = true;
//           i++;
//           continue;
//         } else if (c == d) {
//           endField();
//           i++;
//           continue;
//         } else if (c == cr) {
//           // Handle CR LF or standalone CR
//           if (i + 1 < codes.length && codes[i + 1] == lf) {
//             i += 2;
//           } else {
//             i++;
//           }
//           endRow();
//           continue;
//         } else if (c == lf) {
//           i++;
//           endRow();
//           continue;
//         } else {
//           field.writeCharCode(c);
//           i++;
//           continue;
//         }
//       }
//     }

//     // finalize last row if there is content or trailing delimiter
//     if (inQuotes) {
//       // Unclosed quote; treat as end of field/row.
//       inQuotes = false;
//     }
//     if (field.isNotEmpty || currentRow.isNotEmpty) {
//       endRow();
//     }

//     return rows;
//   }

//   static List<dynamic> _fitToWidth(List<String> row, int width) {
//     if (row.length == width) return List<dynamic>.from(row);
//     if (row.length > width) {
//       return List<dynamic>.from(row.take(width));
//     } else {
//       final r = List<dynamic>.from(row);
//       while (r.length < width) {
//         r.add(null);
//       }
//       return r;
//     }
//   }
// }

