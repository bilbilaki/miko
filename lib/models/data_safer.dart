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

  DataPlace(this.config, this.handyConfig) {}
}

class DataPlaceAdvancedConfig {}

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
  final ErrorAndFailedHandel errorAndFailedHandel;
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
