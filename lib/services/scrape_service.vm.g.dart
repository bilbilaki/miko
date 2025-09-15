// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// Generator: WorkerGenerator 7.1.6 (Squadron 7.1.2+1)
// **************************************************************************

import 'package:squadron/squadron.dart';

import 'scrape_service.dart';

void _start$ScrapeService(WorkerRequest command) {
  /// VM entry point for ScrapeService
  run($ScrapeServiceInitializer, command);
}

EntryPoint $getScrapeServiceActivator(SquadronPlatformType platform) {
  if (platform.isVm) {
    return _start$ScrapeService;
  } else {
    throw UnsupportedError('${platform.label} not supported.');
  }
}
