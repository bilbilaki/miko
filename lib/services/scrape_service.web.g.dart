// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: WorkerGenerator 7.1.6 (Squadron 7.1.2+1)
// **************************************************************************

import 'package:squadron/squadron.dart';

import 'scrape_service.dart';

void main() {
  /// Web entry point for ScrapeService
  run($ScrapeServiceInitializer);
}

EntryPoint $getScrapeServiceActivator(SquadronPlatformType platform) {
  if (platform.isJs) {
    return Squadron.uri('~/workers/scrape_service.web.g.dart.js');
  } else if (platform.isWasm) {
    return Squadron.uri('~/workers/scrape_service.web.g.dart.wasm');
  } else {
    throw UnsupportedError('${platform.label} not supported.');
  }
}
