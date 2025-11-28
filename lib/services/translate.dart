import 'package:llm_dart/llm_dart.dart';

import '../models/subtitletranslator/app_settings.dart';
import 'settings_service.dart';

class TranslationService {

final AppSettings appSettings=AppSettings();


  static Future<XAIProvider> _createProvider() async {
        final settings = await SettingsService.loadSettings();

    final provider = await createProvider(
      baseUrl: settings.baseUrl,
      providerId: settings.provider ==AiProvider.openai?"xai":"genai",
      apiKey: settings.apiKey,
      model: settings.modelId,
    );
    return provider as XAIProvider ;
  }

  static Future<String> translate(String content, String systemMessage) async {
    final provider = await _createProvider();
    final responses = await provider.chat([
      ChatMessage.system(systemMessage),
      ChatMessage.user(content),
    ]);

    return responses.text??"failed";
  }
}
