enum AiProvider {
  openai,
  genai,
}

class AppSettings {
  final AiProvider provider;
  final String baseUrl;
  final String apiKey;
  final int batchSize;
  final int maxRetries;
  final bool enableCache;
  final String modelId;

  const AppSettings({
    this.provider = AiProvider.openai,
    this.baseUrl = '',
    this.apiKey = '',
    this.batchSize = 100,
    this.maxRetries = 5,
    this.enableCache = false,
    this.modelId=''
  });

  String get defaultBaseUrl {
    switch (provider) {
      case AiProvider.openai:
        return 'https://api.openai.com/v1';
      case AiProvider.genai:
        return 'https://generativelanguage.googleapis.com/v1beta';
    }
  }

  AppSettings copyWith({
    AiProvider? provider,
    String? baseUrl,
    String? apiKey,
    int? batchSize,
    int? maxRetries,
    bool? enableCache,
    String? modelId
  }) {
    return AppSettings(
      provider: provider ?? this.provider,
      baseUrl: baseUrl ?? this.baseUrl,
      apiKey: apiKey ?? this.apiKey,
      batchSize: batchSize ?? this.batchSize,
      maxRetries: maxRetries ?? this.maxRetries,
      enableCache: enableCache ?? this.enableCache,
      modelId:modelId?? this.modelId
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider': provider.name,
      'baseUrl': baseUrl,
      'apiKey': apiKey,
      'batchSize': batchSize,
      'maxRetries': maxRetries,
      'enableCache': enableCache,
      'modelId': modelId
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      provider: AiProvider.values.firstWhere(
        (e) => e.name == json['provider'],
        orElse: () => AiProvider.openai,
      ),
      baseUrl: json['baseUrl'] as String? ?? '',
      apiKey: json['apiKey'] as String? ?? '',
      batchSize: json['batchSize'] as int? ?? 100,
      maxRetries: json['maxRetries'] as int? ?? 5,
      enableCache: json['enableCache'] as bool? ?? false,
      modelId: json['modelId'] as String? ?? ''
    );
  }
}
