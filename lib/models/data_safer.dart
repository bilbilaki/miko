enum ScenarioOfDataplacing { webPath, webPage, findAWay, useAI }

enum ErrorAndFailedHandel {
  ignoreAndKeepGoing,
  waitingSomeTimesAndKeepGoing,
  cancellationTask,
  askingInApp,
  askFromAI,
}

class DataPlace {
  final DataPlaceConfig config;
  final DataPlaceAdvancedConfig handyConfig;
  DataPlace(this.config, this.handyConfig);
}

class DataPlaceAdvancedConfig {
  Map<String, dynamic> toJson() => {};
  static DataPlaceAdvancedConfig fromJson(Map<String, dynamic> _) =>
      DataPlaceAdvancedConfig();
}

class DataPlaceConfig {
  List<String> baseUrls = [];
  bool multiPage = false;
  bool unStop = false;
  bool youNeedUsingProxy = false;
  double deley = 0.5;
  int worker = 8;
  List<String>? exampleOfOtherWebAdressOrPathYouWant;
  bool recordAnyThing = false;
  List<String> extOfFileYouNeed = [];
  bool youWantToCollectPostsMetadata = false;
  final ScenarioOfDataplacing strategy;

  final ExcludeConfig excludeConfig;
  final IncludeConfig includeConfig;
  String socksProxyAddress = '';
  int socksProxyPort = 0;
  bool areYouHaveListOfAddressInTxtFile = false;
  bool areYouHaveListOfAddressInJsonOrCsvFile = false;
  bool areYouNeedAPICalls = false;
  bool isNeedToSavingInRealTime = true;
  late final ErrorAndFailedHandel errorAndFailedHandel;
  int retryNumber = 3;
  bool areYouNeedCreateSessionForTask = false;

  DataPlaceConfig(
    this.areYouHaveListOfAddressInJsonOrCsvFile,
    this.areYouHaveListOfAddressInTxtFile,
    this.areYouNeedAPICalls,
    this.areYouNeedCreateSessionForTask,
    this.baseUrls,
    this.deley,
    this.errorAndFailedHandel,
    this.exampleOfOtherWebAdressOrPathYouWant,
    this.excludeConfig,
    this.extOfFileYouNeed,
    this.includeConfig,
    this.isNeedToSavingInRealTime,
    this.multiPage,
    this.recordAnyThing,
    this.retryNumber,
    this.socksProxyAddress,
    this.socksProxyPort,
    this.strategy,
    this.unStop,
    this.worker,
    this.youNeedUsingProxy,
    this.youWantToCollectPostsMetadata,
  );
}

class IncludeConfig {
  List<String> listIncludedPath = [];
  List<String> listIncludedRegex = [];
  List<String> listIncludedKeyWord = [];
  List<int> listIncludedPages = [];
  List<String> listExtOfFileYouNeed = [];
  HtmlConfig? htmlConfigYouNeedIncluded;
  IncludeConfig(
    this.htmlConfigYouNeedIncluded,
    this.listExtOfFileYouNeed,
    this.listIncludedKeyWord,
    this.listIncludedPages,
    this.listIncludedPath,
    this.listIncludedRegex,
  );
}

class ExcludeConfig {
  List<String> listExcludedPath = [];
  List<String> listExcludedRegex = [];
  List<String> listExcludedKeyWord = [];
  List<int> listExcludedPages = [];
  List<String> listExtOfFileYouNotNeed = [];
  HtmlConfig? htmlConfigYouNeedExcluded;
  ExcludeConfig(
    this.htmlConfigYouNeedExcluded,
    this.listExcludedKeyWord,
    this.listExcludedPages,
    this.listExcludedPath,
    this.listExcludedRegex,
    this.listExtOfFileYouNotNeed,
  );
}

class HtmlConfig {
  List<String> listCssPaths = [];
  List<String> listTags = [];
  List<String> listIds = [];
  List<String> listClass = [];
  List<String> listXPath = [];
  List<String> listOfElementWeCanUseAsPatternForTask = [];
  bool getHelpFromAIToFillValue = false;
  String explainForAI = '';
  HtmlConfig(
    this.explainForAI,
    this.getHelpFromAIToFillValue,
    this.listClass,
    this.listCssPaths,
    this.listIds,
    this.listOfElementWeCanUseAsPatternForTask,
    this.listTags,
    this.listXPath,
  );
}

// JSON helpers (non-invasive)
extension DataPlaceConfigJson on DataPlaceConfig {
  Map<String, dynamic> toJson() => {
    'baseUrls': baseUrls,
    'multiPage': multiPage,
    'unStop': unStop,
    'youNeedUsingProxy': youNeedUsingProxy,
    'deley': deley,
    'worker': worker,
    'exampleOfOtherWebAdressOrPathYouWant':
        exampleOfOtherWebAdressOrPathYouWant,
    'recordAnyThing': recordAnyThing,
    'extOfFileYouNeed': extOfFileYouNeed,
    'youWantToCollectPostsMetadata': youWantToCollectPostsMetadata,
    'strategy': strategy.name,
    'excludeConfig': excludeConfig.toJson(),
    'includeConfig': includeConfig.toJson(),
    'socksProxyAddress': socksProxyAddress,
    'socksProxyPort': socksProxyPort,
    'areYouHaveListOfAddressInTxtFile': areYouHaveListOfAddressInTxtFile,
    'areYouHaveListOfAddressInJsonOrCsvFile':
        areYouHaveListOfAddressInJsonOrCsvFile,
    'areYouNeedAPICalls': areYouNeedAPICalls,
    'isNeedToSavingInRealTime': isNeedToSavingInRealTime,
    'errorAndFailedHandel': errorAndFailedHandel.name,
    'retryNumber': retryNumber,
    'areYouNeedCreateSessionForTask': areYouNeedCreateSessionForTask,
  };

  static DataPlaceConfig fromJson(Map<String, dynamic> json) {
    final include = IncludeConfigJson.fromJson(
      Map<String, dynamic>.from(json['includeConfig'] as Map),
    );
    final exclude = ExcludeConfigJson.fromJson(
      Map<String, dynamic>.from(json['excludeConfig'] as Map),
    );
    return DataPlaceConfig(
      json['areYouHaveListOfAddressInJsonOrCsvFile'] as bool? ?? false,
      json['areYouHaveListOfAddressInTxtFile'] as bool? ?? false,
      json['areYouNeedAPICalls'] as bool? ?? false,
      json['areYouNeedCreateSessionForTask'] as bool? ?? false,
      (json['baseUrls'] as List?)?.map((e) => e.toString()).toList() ?? [],
      (json['deley'] as num?)?.toDouble() ?? 0.5,
      ErrorAndFailedHandel.values.firstWhere(
        (e) => e.name == (json['errorAndFailedHandel'] as String? ?? ''),
        orElse: () => ErrorAndFailedHandel.ignoreAndKeepGoing,
      ),
      (json['exampleOfOtherWebAdressOrPathYouWant'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      exclude,
      (json['extOfFileYouNeed'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      include,
      json['isNeedToSavingInRealTime'] as bool? ?? true,
      json['multiPage'] as bool? ?? false,
      json['recordAnyThing'] as bool? ?? false,
      (json['retryNumber'] as num?)?.toInt() ?? 3,
      json['socksProxyAddress'] as String? ?? '',
      (json['socksProxyPort'] as num?)?.toInt() ?? 0,
      ScenarioOfDataplacing.values.firstWhere(
        (e) => e.name == (json['strategy'] as String? ?? 'webPage'),
        orElse: () => ScenarioOfDataplacing.webPage,
      ),
      json['unStop'] as bool? ?? false,
      (json['worker'] as num?)?.toInt() ?? 8,
      json['youNeedUsingProxy'] as bool? ?? false,
      json['youWantToCollectPostsMetadata'] as bool? ?? false,
    );
  }
}

extension IncludeConfigJson on IncludeConfig {
  Map<String, dynamic> toJson() => {
    'listIncludedPath': listIncludedPath,
    'listIncludedRegex': listIncludedRegex,
    'listIncludedKeyWord': listIncludedKeyWord,
    'listIncludedPages': listIncludedPages,
    'listExtOfFileYouNeed': listExtOfFileYouNeed,
    'htmlConfigYouNeedIncluded': htmlConfigYouNeedIncluded?.toJson(),
  };

  static IncludeConfig fromJson(Map<String, dynamic> json) => IncludeConfig(
    json['htmlConfigYouNeedIncluded'] == null
        ? null
        : HtmlConfigJson.fromJson(
            Map<String, dynamic>.from(json['htmlConfigYouNeedIncluded']),
          ),
    (json['listExtOfFileYouNeed'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        [],
    (json['listIncludedKeyWord'] as List?)?.map((e) => e.toString()).toList() ??
        [],
    (json['listIncludedPages'] as List?)
            ?.map((e) => (e as num).toInt())
            .toList() ??
        [],
    (json['listIncludedPath'] as List?)?.map((e) => e.toString()).toList() ??
        [],
    (json['listIncludedRegex'] as List?)?.map((e) => e.toString()).toList() ??
        [],
  );
}

extension ExcludeConfigJson on ExcludeConfig {
  Map<String, dynamic> toJson() => {
    'listExcludedPath': listExcludedPath,
    'listExcludedRegex': listExcludedRegex,
    'listExcludedKeyWord': listExcludedKeyWord,
    'listExcludedPages': listExcludedPages,
    'listExtOfFileYouNotNeed': listExtOfFileYouNotNeed,
    'htmlConfigYouNeedExcluded': htmlConfigYouNeedExcluded?.toJson(),
  };

  static ExcludeConfig fromJson(Map<String, dynamic> json) => ExcludeConfig(
    json['htmlConfigYouNeedExcluded'] == null
        ? null
        : HtmlConfigJson.fromJson(
            Map<String, dynamic>.from(json['htmlConfigYouNeedExcluded']),
          ),
    (json['listExcludedKeyWord'] as List?)?.map((e) => e.toString()).toList() ??
        [],
    (json['listExcludedPages'] as List?)
            ?.map((e) => (e as num).toInt())
            .toList() ??
        [],
    (json['listExcludedPath'] as List?)?.map((e) => e.toString()).toList() ??
        [],
    (json['listExcludedRegex'] as List?)?.map((e) => e.toString()).toList() ??
        [],
    (json['listExtOfFileYouNotNeed'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        [],
  );
}

extension HtmlConfigJson on HtmlConfig {
  Map<String, dynamic> toJson() => {
    'listCssPaths': listCssPaths,
    'listTags': listTags,
    'listIds': listIds,
    'listClass': listClass,
    'listXPath': listXPath,
    'listOfElementWeCanUseAsPatternForTask':
        listOfElementWeCanUseAsPatternForTask,
    'getHelpFromAIToFillValue': getHelpFromAIToFillValue,
    'explainForAI': explainForAI,
  };

  static HtmlConfig fromJson(Map<String, dynamic> json) => HtmlConfig(
    json['explainForAI'] as String? ?? '',
    json['getHelpFromAIToFillValue'] as bool? ?? false,
    (json['listClass'] as List?)?.map((e) => e.toString()).toList() ?? [],
    (json['listCssPaths'] as List?)?.map((e) => e.toString()).toList() ?? [],
    (json['listIds'] as List?)?.map((e) => e.toString()).toList() ?? [],
    (json['listOfElementWeCanUseAsPatternForTask'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        [],
    (json['listTags'] as List?)?.map((e) => e.toString()).toList() ?? [],
    (json['listXPath'] as List?)?.map((e) => e.toString()).toList() ?? [],
  );
}
