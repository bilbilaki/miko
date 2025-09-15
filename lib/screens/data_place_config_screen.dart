import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:miko/models/data_safer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../network/proxy_manager.dart';
import '../../services/scrape_service.dart';

class DataPlaceConfigScreen extends StatefulWidget {
  const DataPlaceConfigScreen({super.key});
  @override
  State<DataPlaceConfigScreen> createState() => _DataPlaceConfigScreenState();
}

class _DataPlaceConfigScreenState extends State<DataPlaceConfigScreen> {
  late DataPlaceConfig cfg;
  final _form = GlobalKey<FormState>();
  final _baseUrlsCtrl = TextEditingController();
  final _extCtrl = TextEditingController();
  final _socksHostCtrl = TextEditingController();
  final _socksPortCtrl = TextEditingController(text: '1080');
  final _status = ValueNotifier<String>('');

  late final ScrapeServiceWorker _worker;

  @override
  void initState() {
    super.initState();
    cfg = _defaultConfig();
    _worker = ScrapeServiceWorker();
    _load();
  }

  @override
  void dispose() {
    _worker.stop();
    _baseUrlsCtrl.dispose();
    _extCtrl.dispose();
    _socksHostCtrl.dispose();
   // _socksPo.dispose();
    _status.dispose();
    super.dispose();
  }

  DataPlaceConfig _defaultConfig() {
    return DataPlaceConfig(
      false, // from json/csv
      false, // from txt
      false, // api calls
      true, // create session
      [], // base urls
      0.5, // delay
      ErrorAndFailedHandel.ignoreAndKeepGoing,
      const [], // examples
      ExcludeConfig(null, [], [], [], [], []),
      [], // file extensions
      IncludeConfig(null, [], [], [], [], []),
      true, // realtime save
      false, // multipage
      false, // record anything
      3, // retry
      '', // socks host
      0, // socks port
      ScenarioOfDataplacing.webPage,
      false, // unstop
      8, // workers
      false, // use proxy
      false, // collect meta
    );
  }

  Future<void> _load() async {
    final sp = await SharedPreferences.getInstance();
    final s = sp.getString('data_place_config');
    if (s != null && s.isNotEmpty) {
      final m = jsonDecode(s) as Map<String, dynamic>;
      setState(() {
        cfg = DataPlaceConfigJson.fromJson(m);
      });
    }
    _syncCtrls();
  }

  void _syncCtrls() {
    _baseUrlsCtrl.text = cfg.baseUrls.join('\n');
    _extCtrl.text = cfg.extOfFileYouNeed.join(', ');
    _socksHostCtrl.text = cfg.socksProxyAddress;
    _socksPortCtrl.text = (cfg.socksProxyPort == 0 ? 1080 : cfg.socksProxyPort)
        .toString();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();
    final sp = await SharedPreferences.getInstance();
    await sp.setString('data_place_config', jsonEncode(cfg.toJson()));
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Configuration saved')));
  }

  Future<void> _testSquadron() async {
    try {
      final msg = await _worker.ping();
      _status.value = 'Squadron worker OK ($msg)';
    } catch (e) {
      _status.value = 'Squadron ping failed: $e';
    }
  }

  Future<void> _testHttp() async {
    final url = (cfg.baseUrls.isNotEmpty ? cfg.baseUrls.first : '').trim();
    if (url.isEmpty) {
      _status.value = 'Add at least one Base URL to test.';
      return;
    }

    _status.value = 'Testing HTTP...';
    try {
      if (cfg.youNeedUsingProxy &&
          (cfg.socksProxyAddress.isNotEmpty ||
              _socksHostCtrl.text.isNotEmpty)) {
        // Test via dart:io + socks
        final io = ProxyManager.createIoClientWithSocks(
          ProxyConfig(
            socksHost: _socksHostCtrl.text.trim().isEmpty
                ? cfg.socksProxyAddress
                : _socksHostCtrl.text.trim(),
            socksPort:
                int.tryParse(_socksPortCtrl.text.trim()) ??
                (cfg.socksProxyPort == 0 ? 1080 : cfg.socksProxyPort),
          ),
        );
        final (status, len) = await ProxyManager.testHttpWithIo(io, url);
        _status.value = 'IO+SOCKS OK: HTTP $status, bytes: $len';
      } else {
        // Test via rhttp (system or http proxy URL if provided)
        final holder = await ProxyManager.createRhttpClient(
          ProxyConfig(
            url: null, // set to http://host:port if you prefer HTTP proxy here
          ),
        );
        final (status, len) = await ProxyManager.testHttpWithRhttp(holder, url);
        holder.dispose();
        _status.value = 'rhttp OK: HTTP $status, bytes: $len';
      }
    } catch (e) {
      _status.value = 'HTTP test failed: $e';
    }
  }

  Future<void> _testBs4() async {
    final url = (cfg.baseUrls.isNotEmpty ? cfg.baseUrls.first : '').trim();
    if (url.isEmpty) {
      _status.value = 'Add at least one Base URL to test.';
      return;
    }
    _status.value = 'Fetching + parsing with BS4...';
    try {
      final html = await _worker.fetchHtmlIo(
        url,
        socksHost: cfg.youNeedUsingProxy ? _socksHostCtrl.text.trim() : null,
        socksPort: cfg.youNeedUsingProxy
            ? int.tryParse(_socksPortCtrl.text.trim()) ??
                  (cfg.socksProxyPort == 0 ? 1080 : cfg.socksProxyPort)
            : null,
        userAgent:
            'Mozilla/5.0 (Flutter; Scraper Config UI) AppleWebKit/537.36 (KHTML, like Gecko)',
      );
      final nodes = await _worker.bs4Query(html, selector: 'body', text: true);
      _status.value = 'BS4 OK: extracted ${nodes.length} nodes/chunks';
    } catch (e) {
      _status.value = 'BS4 test failed: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    final labelSmall = Theme.of(context).textTheme.labelSmall;
    return Scaffold(
      appBar: AppBar(
        title: const Text('DataPlace Configuration'),
        actions: [
          IconButton(
            onPressed: _testSquadron,
            icon: const Icon(Icons.bug_report),
          ),
          IconButton(onPressed: _save, icon: const Icon(Icons.save)),
        ],
      ),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Basics', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextFormField(
              controller: _baseUrlsCtrl,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Base URLs (one per line)',
                border: OutlineInputBorder(),
              ),
              onSaved: (_) {
                cfg.baseUrls = _baseUrlsCtrl.text
                    .split('\n')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty)
                    .toList();
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<ScenarioOfDataplacing>(
                    value: cfg.strategy,
                    decoration: const InputDecoration(labelText: 'Strategy'),
                    items: ScenarioOfDataplacing.values
                        .map(
                          (e) =>
                              DropdownMenuItem(value: e, child: Text(e.name)),
                        )
                        .toList(),
                    onChanged: (v) => setState(
                      () => cfg = DataPlaceConfig(
                        cfg.areYouHaveListOfAddressInJsonOrCsvFile,
                        cfg.areYouHaveListOfAddressInTxtFile,
                        cfg.areYouNeedAPICalls,
                        cfg.areYouNeedCreateSessionForTask,
                        cfg.baseUrls,
                        cfg.deley,
                        cfg.errorAndFailedHandel,
                        cfg.exampleOfOtherWebAdressOrPathYouWant,
                        cfg.excludeConfig,
                        cfg.extOfFileYouNeed,
                        cfg.includeConfig,
                        cfg.isNeedToSavingInRealTime,
                        cfg.multiPage,
                        cfg.recordAnyThing,
                        cfg.retryNumber,
                        cfg.socksProxyAddress,
                        cfg.socksProxyPort,
                        v ?? cfg.strategy,
                        cfg.unStop,
                        cfg.worker,
                        cfg.youNeedUsingProxy,
                        cfg.youWantToCollectPostsMetadata,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<ErrorAndFailedHandel>(
                    value: cfg.errorAndFailedHandel,
                    decoration: const InputDecoration(
                      labelText: 'Error handling',
                    ),
                    items: ErrorAndFailedHandel.values
                        .map(
                          (e) =>
                              DropdownMenuItem(value: e, child: Text(e.name)),
                        )
                        .toList(),
                    onChanged: (v) => setState(
                      () => cfg.errorAndFailedHandel =
                          v ?? cfg.errorAndFailedHandel,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: cfg.deley.toString(),
                    decoration: const InputDecoration(
                      labelText: 'Delay (seconds)',
                    ),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => cfg.deley = double.tryParse(v ?? '') ?? 0.5,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    initialValue: cfg.worker.toString(),
                    decoration: const InputDecoration(labelText: 'Workers'),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => cfg.worker = int.tryParse(v ?? '') ?? 8,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              value: cfg.multiPage,
              onChanged: (v) => setState(() => cfg.multiPage = v),
              title: const Text('Multi-page'),
            ),
            SwitchListTile(
              value: cfg.unStop,
              onChanged: (v) => setState(() => cfg.unStop = v),
              title: const Text('Unstoppable (keep crawling)'),
            ),
            SwitchListTile(
              value: cfg.youWantToCollectPostsMetadata,
              onChanged: (v) =>
                  setState(() => cfg.youWantToCollectPostsMetadata = v),
              title: const Text('Collect post metadata'),
            ),
            TextFormField(
              controller: _extCtrl,
              decoration: const InputDecoration(
                labelText: 'Wanted File Extensions (comma separated)',
                helperText: 'Example: .mp4, .mkv, .srt',
              ),
              onSaved: (_) => cfg.extOfFileYouNeed = _extCtrl.text
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
            ),
            const Divider(height: 24),
            Text('Proxy', style: Theme.of(context).textTheme.titleMedium),
            SwitchListTile(
              value: cfg.youNeedUsingProxy,
              onChanged: (v) => setState(() => cfg.youNeedUsingProxy = v),
              title: const Text('Use SOCKS5 proxy'),
            ),
            if (cfg.youNeedUsingProxy) ...[
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: _socksHostCtrl,
                      decoration: const InputDecoration(
                        labelText: 'SOCKS Host',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _socksPortCtrl,
                      decoration: const InputDecoration(labelText: 'Port'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Note: rhttp supports HTTP/HTTPS proxies via URL. SOCKS is provided via dart:io + socks_proxy.',
                style: labelSmall,
              ),
            ],
            const Divider(height: 24),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _testHttp,
                  icon: const Icon(Icons.wifi_tethering),
                  label: const Text('Test HTTP'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _testBs4,
                  icon: const Icon(Icons.science),
                  label: const Text('Test BS4'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ValueListenableBuilder<String>(
              valueListenable: _status,
              builder: (_, v, __) => Text(v, style: labelSmall),
            ),
          ],
        ),
      ),
    );
  }
}
