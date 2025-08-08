// TODO Implement this library.

import 'package:hive/hive.dart';

part 'jackett_config.g.dart';

@HiveType(typeId: 0)
class JackettConfig extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String url;

  @HiveField(2)
  late String apiKey;

  JackettConfig({
    required this.name,
    required this.url,
    required this.apiKey,
  });

  @override
  String toString() => 'JackettConfig(name: $name, url: $url)';
}