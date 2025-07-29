// TODO Implement this library.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:miko/jackett/models/jackett_config.dart';

class ConfigService {
  static const String boxName = 'jackett_configs';

  final Box<JackettConfig> _box;

  ConfigService(this._box);

  Future<void> addConfig(JackettConfig config) async {
    await _box.add(config);
  }

  Future<void> updateConfig(dynamic key, JackettConfig config) async {
    await _box.put(key, config);
  }

  Future<void> deleteConfig(dynamic key) async {
    await _box.delete(key);
  }

  List<JackettConfig> getConfigs() {
    return _box.values.toList();
  }

  JackettConfig? getConfig(dynamic key) {
    return _box.get(key);
  }

  bool hasConfigs() {
    return _box.isNotEmpty;
  }
  
  Stream<BoxEvent> watch() {
    return _box.watch();
  }
}

final configServiceProvider = Provider<ConfigService>((ref) {
  final box = Hive.box<JackettConfig>(ConfigService.boxName);
  return ConfigService(box);
});