import 'package:miko/functions/data_storage.dart';


class TabularDataAppend {
  static TabularData merge(TabularData base, TabularData add) {
    final allCols = {...base.columns, ...add.columns}.toList();
    List<List<dynamic>> remap(TabularData td) {
      final idx = {
        for (var i = 0; i < td.columns.length; i++) td.columns[i]: i,
      };
      return List<List<dynamic>>.generate(td.rowCount, (r) {
        final row = td.rows[r];
        return List<dynamic>.generate(allCols.length, (c) {
          final ci = idx[allCols[c]];
          return ci == null ? null : row[ci];
        });
      });
    }

    final rows = <List<dynamic>>[];
    rows.addAll(remap(base));
    rows.addAll(remap(add));
    return TabularData(allCols, rows);
  }

  static Future<String> appendToDataset({
    required TabularDataStore store,
    required String datasetId,
    required String nameIfNew,
    required TabularData newData,
  }) async {
    final existing = await store.load(datasetId);
    if (existing == null) {
      // create new with given id
      return await store.save(newData, name: nameIfNew, id: datasetId);
    }
    final merged = merge(existing, newData);
    return await store.save(merged, name: nameIfNew, id: datasetId);
  }
}
