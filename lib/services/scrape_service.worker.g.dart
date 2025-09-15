// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scrape_service.dart';

// **************************************************************************
// Generator: WorkerGenerator 7.1.6 (Squadron 7.1.2+1)
// **************************************************************************

/// Command ids used in operations map
const int _$bs4QueryId = 1;
const int _$extractLinksAndAssetsId = 2;
const int _$extractPostsId = 3;
const int _$fetchHtmlIoId = 4;
const int _$pingId = 5;
const int _$runWebScraperId = 6;

/// WorkerService operations for ScrapeService
extension on ScrapeService {
  OperationsMap _$getOperations() => OperationsMap({
    _$bs4QueryId: ($req) async {
      final List<String> $res;
      try {
        final $dsr = _$Deser(contextAware: false);
        $res = await bs4Query(
          $dsr.$0($req.args[0]),
          selector: $dsr.$0($req.args[1]),
          text: $dsr.$1($req.args[2]),
        );
      } finally {}
      return $res;
    },
    _$extractLinksAndAssetsId: ($req) async {
      final Map<String, List<String>> $res;
      try {
        final $dsr = _$Deser(contextAware: false);
        $res = await extractLinksAndAssets(
          $dsr.$0($req.args[0]),
          $dsr.$0($req.args[1]),
        );
      } finally {}
      return $res;
    },
    _$extractPostsId: ($req) async {
      final List<Map<String, Object?>> $res;
      try {
        final $dsr = _$Deser(contextAware: false);
        $res = await extractPosts(
          $dsr.$0($req.args[0]),
          $dsr.$0($req.args[1]),
          cssSelectors: $dsr.$2($req.args[2]),
        );
      } finally {}
      return $res;
    },
    _$fetchHtmlIoId: ($req) async {
      final String $res;
      try {
        final $dsr = _$Deser(contextAware: false);
        $res = await fetchHtmlIo(
          $dsr.$0($req.args[0]),
          socksHost: $dsr.$3($req.args[1]),
          socksPort: $dsr.$5($req.args[2]),
          userAgent: $dsr.$3($req.args[3]),
          headers: $dsr.$7($req.args[4]),
        );
      } finally {}
      return $res;
    },
    _$pingId: ($req) => ping(),
    _$runWebScraperId: ($req) async {
      final Map<String, Object> $res;
      try {
        final $dsr = _$Deser(contextAware: false);
        $res = await runWebScraper(
          url: $dsr.$0($req.args[0]),
          scraperConfigJson: $dsr.$9($req.args[1]),
          overrideHeaders: $dsr.$7($req.args[2]),
          userAgent: $dsr.$3($req.args[3]),
        );
      } finally {}
      return $res;
    },
  });
}

/// Invoker for ScrapeService, implements the public interface to invoke the
/// remote service.
base mixin _$ScrapeService$Invoker on Invoker implements ScrapeService {
  @override
  Future<List<String>> bs4Query(
    String html, {
    String selector = 'a',
    bool text = false,
  }) async {
    final dynamic $res = await send(_$bs4QueryId, args: [html, selector, text]);
    try {
      final $dsr = _$Deser(contextAware: false);
      return $dsr.$2($res);
    } finally {}
  }

  @override
  Future<Map<String, List<String>>> extractLinksAndAssets(
    String html,
    String baseUrl,
  ) async {
    final dynamic $res = await send(
      _$extractLinksAndAssetsId,
      args: [html, baseUrl],
    );
    try {
      final $dsr = _$Deser(contextAware: false);
      return $dsr.$10($res);
    } finally {}
  }

  @override
  Future<List<Map<String, Object?>>> extractPosts(
    String html,
    String baseUrl, {
    List<String> cssSelectors = const [
      'article.post2',
      'article.w-grid-item',
      'article',
      '.multiple-link-wrapper',
      '.home-rows-videos-div',
    ],
  }) async {
    final dynamic $res = await send(
      _$extractPostsId,
      args: [html, baseUrl, cssSelectors],
    );
    try {
      final $dsr = _$Deser(contextAware: false);
      return $dsr.$12($res);
    } finally {}
  }

  @override
  Future<String> fetchHtmlIo(
    String url, {
    String? socksHost,
    int? socksPort,
    String? userAgent,
    Map<String, String>? headers,
  }) async {
    final dynamic $res = await send(
      _$fetchHtmlIoId,
      args: [url, socksHost, socksPort, userAgent, headers],
    );
    try {
      final $dsr = _$Deser(contextAware: false);
      return $dsr.$0($res);
    } finally {}
  }

  @override
  Future<String> ping() async {
    final dynamic $res = await send(_$pingId);
    try {
      final $dsr = _$Deser(contextAware: false);
      return $dsr.$0($res);
    } finally {}
  }

  @override
  Future<Map<String, Object>> runWebScraper({
    required String url,
    required Map<String, Object> scraperConfigJson,
    Map<String, String>? overrideHeaders,
    String? userAgent,
  }) async {
    final dynamic $res = await send(
      _$runWebScraperId,
      args: [url, scraperConfigJson, overrideHeaders, userAgent],
    );
    try {
      final $dsr = _$Deser(contextAware: false);
      return $dsr.$9($res);
    } finally {}
  }
}

/// Facade for ScrapeService, implements other details of the service unrelated to
/// invoking the remote service.
base mixin _$ScrapeService$Facade implements ScrapeService {}

/// WorkerService class for ScrapeService
base class _$ScrapeService$WorkerService extends ScrapeService
    implements WorkerService {
  _$ScrapeService$WorkerService() : super();

  @override
  OperationsMap get operations => _$getOperations();
}

/// Service initializer for ScrapeService
WorkerService $ScrapeServiceInitializer(WorkerRequest $req) =>
    _$ScrapeService$WorkerService();

/// Worker for ScrapeService
base class ScrapeServiceWorker extends Worker
    with _$ScrapeService$Invoker, _$ScrapeService$Facade
    implements ScrapeService {
  ScrapeServiceWorker({
    PlatformThreadHook? threadHook,
    ExceptionManager? exceptionManager,
  }) : super(
         $ScrapeServiceActivator(Squadron.platformType),
         threadHook: threadHook,
         exceptionManager: exceptionManager,
       );

  ScrapeServiceWorker.vm({
    PlatformThreadHook? threadHook,
    ExceptionManager? exceptionManager,
  }) : super(
         $ScrapeServiceActivator(SquadronPlatformType.vm),
         threadHook: threadHook,
         exceptionManager: exceptionManager,
       );

  ScrapeServiceWorker.js({
    PlatformThreadHook? threadHook,
    ExceptionManager? exceptionManager,
  }) : super(
         $ScrapeServiceActivator(SquadronPlatformType.js),
         threadHook: threadHook,
         exceptionManager: exceptionManager,
       );

  ScrapeServiceWorker.wasm({
    PlatformThreadHook? threadHook,
    ExceptionManager? exceptionManager,
  }) : super(
         $ScrapeServiceActivator(SquadronPlatformType.wasm),
         threadHook: threadHook,
         exceptionManager: exceptionManager,
       );

  @override
  List? getStartArgs() => null;
}

/// Worker pool for ScrapeService
base class ScrapeServiceWorkerPool extends WorkerPool<ScrapeServiceWorker>
    with _$ScrapeService$Facade
    implements ScrapeService {
  ScrapeServiceWorkerPool({
    PlatformThreadHook? threadHook,
    ExceptionManager? exceptionManager,
    ConcurrencySettings? concurrencySettings,
  }) : super(
         (ExceptionManager exceptionManager) => ScrapeServiceWorker(
           threadHook: threadHook,
           exceptionManager: exceptionManager,
         ),
         concurrencySettings: concurrencySettings,
         exceptionManager: exceptionManager,
       );

  ScrapeServiceWorkerPool.vm({
    PlatformThreadHook? threadHook,
    ExceptionManager? exceptionManager,
    ConcurrencySettings? concurrencySettings,
  }) : super(
         (ExceptionManager exceptionManager) => ScrapeServiceWorker.vm(
           threadHook: threadHook,
           exceptionManager: exceptionManager,
         ),
         concurrencySettings: concurrencySettings,
         exceptionManager: exceptionManager,
       );

  ScrapeServiceWorkerPool.js({
    PlatformThreadHook? threadHook,
    ExceptionManager? exceptionManager,
    ConcurrencySettings? concurrencySettings,
  }) : super(
         (ExceptionManager exceptionManager) => ScrapeServiceWorker.js(
           threadHook: threadHook,
           exceptionManager: exceptionManager,
         ),
         concurrencySettings: concurrencySettings,
         exceptionManager: exceptionManager,
       );

  ScrapeServiceWorkerPool.wasm({
    PlatformThreadHook? threadHook,
    ExceptionManager? exceptionManager,
    ConcurrencySettings? concurrencySettings,
  }) : super(
         (ExceptionManager exceptionManager) => ScrapeServiceWorker.wasm(
           threadHook: threadHook,
           exceptionManager: exceptionManager,
         ),
         concurrencySettings: concurrencySettings,
         exceptionManager: exceptionManager,
       );

  @override
  Future<List<String>> bs4Query(
    String html, {
    String selector = 'a',
    bool text = false,
  }) => execute((w) => w.bs4Query(html, selector: selector, text: text));

  @override
  Future<Map<String, List<String>>> extractLinksAndAssets(
    String html,
    String baseUrl,
  ) => execute((w) => w.extractLinksAndAssets(html, baseUrl));

  @override
  Future<List<Map<String, Object?>>> extractPosts(
    String html,
    String baseUrl, {
    List<String> cssSelectors = const [
      'article.post2',
      'article.w-grid-item',
      'article',
      '.multiple-link-wrapper',
      '.home-rows-videos-div',
    ],
  }) =>
      execute((w) => w.extractPosts(html, baseUrl, cssSelectors: cssSelectors));

  @override
  Future<String> fetchHtmlIo(
    String url, {
    String? socksHost,
    int? socksPort,
    String? userAgent,
    Map<String, String>? headers,
  }) => execute(
    (w) => w.fetchHtmlIo(
      url,
      socksHost: socksHost,
      socksPort: socksPort,
      userAgent: userAgent,
      headers: headers,
    ),
  );

  @override
  Future<String> ping() => execute((w) => w.ping());

  @override
  Future<Map<String, Object>> runWebScraper({
    required String url,
    required Map<String, Object> scraperConfigJson,
    Map<String, String>? overrideHeaders,
    String? userAgent,
  }) => execute(
    (w) => w.runWebScraper(
      url: url,
      scraperConfigJson: scraperConfigJson,
      overrideHeaders: overrideHeaders,
      userAgent: userAgent,
    ),
  );
}

final class _$Deser extends MarshalingContext {
  _$Deser({super.contextAware});
  late final $0 = value<String>();
  late final $1 = value<bool>();
  late final $2 = list<String>($0);
  late final $3 = Converter.allowNull($0);
  late final $4 = value<int>();
  late final $5 = Converter.allowNull($4);
  late final $6 = map<String, String>(kcast: $0, vcast: $0);
  late final $7 = Converter.allowNull($6);
  late final $8 = value<Object>();
  late final $9 = map<String, Object>(kcast: $0, vcast: $8);
  late final $10 = map<String, List<String>>(kcast: $0, vcast: $2);
  late final $11 = nmap<String, Object>(kcast: $0, vcast: $8);
  late final $12 = list<Map<String, Object?>>($11);
}
