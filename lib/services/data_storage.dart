import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as ffi;

import 'package:uuid/uuid.dart';

// Uses your existing TabularData. If it's in another file, import it instead.
class TabularData {
  final List<String> columns;
  final List<List<dynamic>> rows;

  late final Map<String, int> _columnIndex = {
    for (var i = 0; i < columns.length; i++) columns[i]: i,
  };

  TabularData(this.columns, this.rows);

  int get rowCount => rows.length;
  int get columnCount => columns.length;

  dynamic valueAt(int rowIndex, int colIndex) {
    return rows[rowIndex][colIndex];
  }

  dynamic valueOf(int rowIndex, String fieldName) {
    final idx = _columnIndex[fieldName];
    if (idx == null) {
      throw ArgumentError('Field not found: $fieldName');
    }
    return rows[rowIndex][idx];
  }

  Iterable<dynamic> columnValues(String fieldName) sync* {
    final idx = _columnIndex[fieldName];
    if (idx == null) {
      throw ArgumentError('Field not found: $fieldName');
    }
    for (final r in rows) {
      yield r[idx];
    }
  }

  Map<String, dynamic> rowAsMap(int rowIndex) {
    final r = rows[rowIndex];
    return {for (var i = 0; i < columns.length; i++) columns[i]: r[i]};
  }

  List<Map<String, dynamic>> toMapRows() {
    return List.generate(rowCount, rowAsMap);
  }

  String generateConstantsClass(String className) {
    final sb = StringBuffer();
    sb.writeln('class $className {');
    for (final c in columns) {
      final constName = _toValidIdentifier(c);
      sb.writeln("  static const String $constName = '$c';");
    }
    sb.writeln('}');
    return sb.toString();
  }

  String _toValidIdentifier(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '_');
    final startsWithDigit = RegExp(r'^\d').hasMatch(cleaned);
    final base = cleaned.isEmpty ? 'field' : cleaned;
    return startsWithDigit ? '_$base' : base;
  }
}

// ---- Serialization helpers ----
class TabularDataCodec {
  static Map<String, dynamic> toMap(TabularData d) => {
    'columns': d.columns,
    'rows': d.rows,
  };

  static TabularData fromMap(Map<String, dynamic> m) {
    final cols = List<String>.from(m['columns'] as List);
    final rows = (m['rows'] as List)
        .map((r) => List<dynamic>.from(r as List))
        .toList(growable: false);
    return TabularData(cols, rows);
  }

  static String toJsonString(TabularData d) => jsonEncode(toMap(d));

  static TabularData fromJsonString(String s) =>
      fromMap(jsonDecode(s) as Map<String, dynamic>);
}

// ---- Metadata ----
class DatasetMeta {
  final String id;
  final String name;
  final DateTime createdAt;
  final String backend; // 'sqflite' | 'json_file' | 'csv_file' | 'shared_prefs'
  final int rowCount;
  final int columnCount;

  DatasetMeta({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.backend,
    required this.rowCount,
    required this.columnCount,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'createdAt': createdAt.millisecondsSinceEpoch,
    'backend': backend,
    'rowCount': rowCount,
    'columnCount': columnCount,
  };

  static DatasetMeta fromMap(Map<String, dynamic> m) => DatasetMeta(
    id: m['id'] as String,
    name: m['name'] as String,
    createdAt: DateTime.fromMillisecondsSinceEpoch(m['createdAt'] as int? ?? 0),
    backend: m['backend'] as String,
    rowCount: (m['rowCount'] as num?)?.toInt() ?? 0,
    columnCount: (m['columnCount'] as num?)?.toInt() ?? 0,
  );
}

// ---- Store interface ----
abstract class TabularDataStore {
  String get backendId;

  Future<String> save(TabularData data, {required String name, String? id});
  Future<TabularData?> load(String id);
  Future<void> delete(String id);
  Future<List<DatasetMeta>> list();
}

final _uuid = Uuid();

// ---- Sqflite store (SQLite) ----
class SqfliteTabularDataStore implements TabularDataStore {
  final String dbFileName;
  Database? _db;

  SqfliteTabularDataStore({this.dbFileName = 'sqflite_store.db'});

  @override
  String get backendId => 'sqflite';
void init()async{
  databaseFactory= ffi.databaseFactoryFfi;
}
  Future<Database> _database() async {
    init();
    if (_db != null) return _db!;
    final docs = await getApplicationDocumentsDirectory();
    final dir = p.join(docs.path, 'tabular_data', 'sqflite');
    await Directory(dir).create(recursive: true);
    final path = p.join(dir, dbFileName);
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, v) async {
        await db.execute('''
          CREATE TABLE datasets (
            id TEXT PRIMARY KEY,
            name TEXT NOT NULL,
            created_at INTEGER NOT NULL,
            row_count INTEGER NOT NULL,
            column_count INTEGER NOT NULL,
            data_json TEXT NOT NULL
          );
        ''');
      },
    );
    return _db!;
  }

  @override
  Future<String> save(
    TabularData data, {
    required String name,
    String? id,
  }) async {
    final db = await _database();
    final datasetId = id ?? _uuid.v4();
    final now = DateTime.now().millisecondsSinceEpoch;
    final jsonStr = TabularDataCodec.toJsonString(data);
    await db.insert('datasets', {
      'id': datasetId,
      'name': name,
      'created_at': now,
      'row_count': data.rowCount,
      'column_count': data.columnCount,
      'data_json': jsonStr,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    return datasetId;
  }

  @override
  Future<TabularData?> load(String id) async {
    final db = await _database();
    final rows = await db.query(
      'datasets',
      columns: ['data_json'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return TabularDataCodec.fromJsonString(rows.first['data_json'] as String);
  }

  @override
  Future<void> delete(String id) async {
    final db = await _database();
    await db.delete('datasets', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<DatasetMeta>> list() async {
    final db = await _database();
    final rows = await db.query('datasets', orderBy: 'created_at DESC');
    return rows
        .map(
          (m) => DatasetMeta(
            id: m['id'] as String,
            name: m['name'] as String,
            createdAt: DateTime.fromMillisecondsSinceEpoch(
              m['created_at'] as int,
            ),
            backend: backendId,
            rowCount: (m['row_count'] as num).toInt(),
            columnCount: (m['column_count'] as num).toInt(),
          ),
        )
        .toList();
  }
}

// ---- JSON file store ----
class JsonFileTabularDataStore implements TabularDataStore {
  @override
  String get backendId => 'json_file';

  Future<Directory> _baseDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'tabular_data', 'json_store'));
    await dir.create(recursive: true);
    return dir;
  }

  Future<File> _indexFile() async {
    final dir = await _baseDir();
    return File(p.join(dir.path, 'index.json'));
  }

  Future<Map<String, dynamic>> _readIndex() async {
    final f = await _indexFile();
    if (!await f.exists()) return {'items': []};
    final content = await f.readAsString();
    if (content.trim().isEmpty) return {'items': []};
    return jsonDecode(content) as Map<String, dynamic>;
  }

  Future<void> _writeIndex(Map<String, dynamic> index) async {
    final f = await _indexFile();
    await f.writeAsString(jsonEncode(index));
  }

  Future<File> _dataFile(String id) async {
    final dir = await _baseDir();
    return File(p.join(dir.path, '$id.json'));
  }

  @override
  Future<String> save(
    TabularData data, {
    required String name,
    String? id,
  }) async {
    final datasetId = id ?? _uuid.v4();
    final f = await _dataFile(datasetId);
    await f.writeAsString(jsonEncode(TabularDataCodec.toMap(data)));

    final index = await _readIndex();
    final items = (index['items'] as List).cast<Map>().map((e) {
      return Map<String, dynamic>.from(e);
    }).toList();

    items.removeWhere((e) => e['id'] == datasetId);
    items.add(
      DatasetMeta(
        id: datasetId,
        name: name,
        createdAt: DateTime.now(),
        backend: backendId,
        rowCount: data.rowCount,
        columnCount: data.columnCount,
      ).toMap(),
    );

    await _writeIndex({'items': items});
    return datasetId;
  }

  @override
  Future<TabularData?> load(String id) async {
    final f = await _dataFile(id);
    if (!await f.exists()) return null;
    final content = await f.readAsString();
    return TabularDataCodec.fromMap(
      jsonDecode(content) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> delete(String id) async {
    final f = await _dataFile(id);
    if (await f.exists()) {
      await f.delete();
    }
    final index = await _readIndex();
    final items = (index['items'] as List).cast<Map>().map((e) {
      return Map<String, dynamic>.from(e);
    }).toList();
    items.removeWhere((e) => e['id'] == id);
    await _writeIndex({'items': items});
  }

  @override
  Future<List<DatasetMeta>> list() async {
    final index = await _readIndex();
    final items = (index['items'] as List?) ?? [];
    return items
        .map((e) => DatasetMeta.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }
}

// ---- CSV file store ----
class CsvFileTabularDataStore implements TabularDataStore {
  @override
  String get backendId => 'csv_file';

  Future<Directory> _baseDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'tabular_data', 'csv_store'));
    await dir.create(recursive: true);
    return dir;
  }

  Future<File> _indexFile() async {
    final dir = await _baseDir();
    return File(p.join(dir.path, 'index.json'));
  }

  Future<Map<String, dynamic>> _readIndex() async {
    final f = await _indexFile();
    if (!await f.exists()) return {'items': []};
    final content = await f.readAsString();
    if (content.trim().isEmpty) return {'items': []};
    return jsonDecode(content) as Map<String, dynamic>;
  }

  Future<void> _writeIndex(Map<String, dynamic> index) async {
    final f = await _indexFile();
    await f.writeAsString(jsonEncode(index));
  }

  Future<File> _csvFile(String id) async {
    final dir = await _baseDir();
    return File(p.join(dir.path, '$id.csv'));
  }

  @override
  Future<String> save(
    TabularData data, {
    required String name,
    String? id,
  }) async {
    final datasetId = id ?? _uuid.v4();
    final f = await _csvFile(datasetId);

    final rows = <List<dynamic>>[];
    rows.add(data.columns);
    rows.addAll(data.rows.map((r) => r.map((v) => v ?? '').toList()));

    final csv = const ListToCsvConverter().convert(rows);
    await f.writeAsString(csv);

    final index = await _readIndex();
    final items = (index['items'] as List).cast<Map>().map((e) {
      return Map<String, dynamic>.from(e);
    }).toList();
    items.removeWhere((e) => e['id'] == datasetId);
    items.add(
      DatasetMeta(
        id: datasetId,
        name: name,
        createdAt: DateTime.now(),
        backend: backendId,
        rowCount: data.rowCount,
        columnCount: data.columnCount,
      ).toMap(),
    );
    await _writeIndex({'items': items});

    return datasetId;
  }

  @override
  Future<TabularData?> load(String id) async {
    final f = await _csvFile(id);
    if (!await f.exists()) return null;
    final content = await f.readAsString();
    final list = const CsvToListConverter(eol: '\n').convert(content);
    if (list.isEmpty) return TabularData([], []);
    final header = List<String>.from(list.first.map((e) => e.toString()));
    final dataRows = list.skip(1).map((r) => r.map((e) => e).toList()).toList();
    return TabularData(header, dataRows);
  }

  @override
  Future<void> delete(String id) async {
    final f = await _csvFile(id);
    if (await f.exists()) {
      await f.delete();
    }
    final index = await _readIndex();
    final items = (index['items'] as List).cast<Map>().map((e) {
      return Map<String, dynamic>.from(e);
    }).toList();
    items.removeWhere((e) => e['id'] == id);
    await _writeIndex({'items': items});
  }

  @override
  Future<List<DatasetMeta>> list() async {
    final index = await _readIndex();
    final items = (index['items'] as List?) ?? [];
    return items
        .map((e) => DatasetMeta.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }
}

// ---- SharedPreferences store ----
class SharedPrefsTabularDataStore implements TabularDataStore {
  @override
  String get backendId => 'shared_prefs';

  static const _indexKey = 'td:index';

  Future<SharedPreferences> _prefs() => SharedPreferences.getInstance();

  String _dataKey(String id) => 'td:data:$id';

  Future<List<Map<String, dynamic>>> _readIndexItems() async {
    final prefs = await _prefs();
    final s = prefs.getString(_indexKey);
    if (s == null || s.isEmpty) return [];
    final decoded = jsonDecode(s);
    final items = (decoded['items'] as List?) ?? [];
    return items.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  Future<void> _writeIndexItems(List<Map<String, dynamic>> items) async {
    final prefs = await _prefs();
    await prefs.setString(_indexKey, jsonEncode({'items': items}));
  }

  @override
  Future<String> save(
    TabularData data, {
    required String name,
    String? id,
  }) async {
    final prefs = await _prefs();
    final datasetId = id ?? _uuid.v4();
    await prefs.setString(
      _dataKey(datasetId),
      TabularDataCodec.toJsonString(data),
    );

    final items = await _readIndexItems();
    items.removeWhere((e) => e['id'] == datasetId);
    items.add(
      DatasetMeta(
        id: datasetId,
        name: name,
        createdAt: DateTime.now(),
        backend: backendId,
        rowCount: data.rowCount,
        columnCount: data.columnCount,
      ).toMap(),
    );
    await _writeIndexItems(items);

    return datasetId;
  }

  @override
  Future<TabularData?> load(String id) async {
    final prefs = await _prefs();
    final s = prefs.getString(_dataKey(id));
    if (s == null) return null;
    return TabularDataCodec.fromJsonString(s);
  }

  @override
  Future<void> delete(String id) async {
    final prefs = await _prefs();
    await prefs.remove(_dataKey(id));
    final items = await _readIndexItems();
    items.removeWhere((e) => e['id'] == id);
    await _writeIndexItems(items);
  }

  @override
  Future<List<DatasetMeta>> list() async {
    final items = await _readIndexItems();
    return items.map(DatasetMeta.fromMap).toList();
  }
}

// ---- Factory ----
enum BackendKind { sqflite, jsonFile, csvFile, sharedPrefs }

class TabularDataStoreFactory {
  static TabularDataStore create(BackendKind kind) {
    switch (kind) {
      case BackendKind.sqflite:
        return SqfliteTabularDataStore();
      case BackendKind.jsonFile:
        return JsonFileTabularDataStore();
      case BackendKind.csvFile:
        return CsvFileTabularDataStore();
      case BackendKind.sharedPrefs:
        return SharedPrefsTabularDataStore();
    }
  }
}
