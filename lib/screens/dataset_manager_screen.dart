import 'package:flutter/material.dart';
import 'package:miko/services/data_storage.dart';
import 'package:miko/screens/scrap_page.dart';

class DatasetManagerScreen extends StatefulWidget {
  const DatasetManagerScreen({super.key});

  @override
  State<DatasetManagerScreen> createState() => _DatasetManagerScreenState();
}

class _DatasetManagerScreenState extends State<DatasetManagerScreen> {
  BackendKind _kind = BackendKind.sqflite;
  late TabularDataStore _store;
  late Future<List<DatasetMeta>> _future;

  @override
  void initState() {
    super.initState();
    _store = TabularDataStoreFactory.create(_kind);
    _future = _store.list();
  }

  void _reload() {
    setState(() {
      _store = TabularDataStoreFactory.create(_kind);
      _future = _store.list();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Datasets'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _reload,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Text('Backend:'),
                const SizedBox(width: 8),
                DropdownButton<BackendKind>(
                  value: _kind,
                  onChanged: (k) {
                    if (k == null) return;
                    setState(() {
                      _kind = k;
                      _store = TabularDataStoreFactory.create(_kind);
                      _future = _store.list();
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: BackendKind.sqflite,
                      child: Text('SQLite (sqflite)'),
                    ),
                    DropdownMenuItem(
                      value: BackendKind.jsonFile,
                      child: Text('JSON files'),
                    ),
                    DropdownMenuItem(
                      value: BackendKind.csvFile,
                      child: Text('CSV files'),
                    ),
                    DropdownMenuItem(
                      value: BackendKind.sharedPrefs,
                      child: Text('SharedPreferences'),
                    ),
                  ],
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _reload,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reload'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: FutureBuilder<List<DatasetMeta>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(child: Text('Error: ${snap.error}'));
                }
                final items = snap.data ?? const [];
                if (items.isEmpty) {
                  return const Center(child: Text('No datasets saved.'));
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final m = items[i];
                    return ListTile(
                      title: Text(m.name),
                      subtitle: Text(
                        'id: ${m.id}\nbackend: ${m.backend} • rows: ${m.rowCount} • cols: ${m.columnCount}\ncreated: ${m.createdAt.toLocal()}',
                        maxLines: 3,
                      ),
                      isThreeLine: true,
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          OutlinedButton(
                            onPressed: () async {
                              final data = await _store.load(m.id);
                              if (data == null || !context.mounted) return;
                              // Open in explorer with loaded data
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => DataExplorerScreen(
                                    initialData: data,
                                    initialDatasetName: m.name,
                                  ),
                                ),
                              );
                            },
                            child: const Text('Open'),
                          ),
                          IconButton(
                            tooltip: 'Delete',
                            onPressed: () async {
                              final ok = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete dataset'),
                                  content: Text(
                                    'Delete "${m.name}" from ${m.backend}?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(ctx, false),
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                              if (ok != true) return;
                              await _store.delete(m.id);
                              if (mounted) _reload();
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
