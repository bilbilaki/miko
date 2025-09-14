import 'package:miko/configs/consts2.dart';
import 'package:miko/services/user_data_service.dart';
import 'package:openai_dart/openai_dart.dart' as openai;

class MovieTvTranslator {


  MovieTvTranslator() {
  }

  /// Translates the given [text] optimizing for movie and TV show contexts.
  /// Returns the translated string or an error message if translation fails.

  final client = openai.OpenAIClient(
    apiKey: webVieApiKey,
    baseUrl: webViewBaseUrl,
  );
  Future<String> translateTextForMoviesAndTV(String text) async {
    final UserDataService userDataService = UserDataService();
    final targetLanguage = userDataService.custoombaseurl;
    final res = await client.createChatCompletion(
      request: openai.CreateChatCompletionRequest(
        model: openai.ChatCompletionModel.modelId("gemini-2.5-flash-lite"),
        messages: [
          openai.ChatCompletionMessage.system(
            content:
                'just translate and return translated content',
          ),
          openai.ChatCompletionMessage.user(
            content: openai.ChatCompletionUserMessageContent.string('''I am a highly skilled movie and TV show translator. I will translate the given text into $targetLanguage, ensuring the translation is natural, idiomatic, and suitable for subtitles or dubbing in a film or series. I will maintain the original tone, character voice, and colloquialisms. Provide only the translated text, nothing else.\n\n"
          "Translate this: $text'''),
          ),
        ],
        temperature: 0.9,
      ),
    );
    return (res.choices.first.message.content ?? '').trim();
  }
}
// Example Usage (for demonstration purposes, not part of the core library code)
// void main() async {
//   // IMPORTANT: Replace with your actual Gemini API Key.
//   // DO NOT HARDCODE YOUR API KEY IN PRODUCTION APPS. Use environment variables or secure methods.
//   const String geminiApiKey = 'YOUR_API_KEY'; // <<< REPLACE THIS

//   if (geminiApiKey == 'YOUR_API_KEY' || geminiApiKey.isEmpty) {
//     print("Please replace 'YOUR_API_KEY' with your actual Gemini API key.");
//     return;
//   }

//   final translator = MovieTvTranslator();

//   const inputText = "Hey, what's up? Just caught a glimpse of that new series. It's totally mind-blowing!";
//   const targetLang = "French";

//   print("Original Text: \"$inputText\"");
//   print("Translating for movies/TV shows into $targetLang...");

//   final translatedText = await translator.translateTextForMoviesAndTV(inputText, targetLanguage: targetLang);
//   print("Translated Text ($targetLang): \"$translatedText\"");

//   const anotherInput = "C'est une histoire de vengeance et de trahison, avec des rebondissements inattendus. Le héros doit choisir entre l'amour et le devoir.";
//   const anotherTargetLang = "English";

//   print("\nOriginal Text: \"$anotherInput\"");
//   print("Translating for movies/TV shows into $anotherTargetLang...");

//   final anotherTranslatedText = await translator.translateTextForMoviesAndTV(anotherInput, targetLanguage: anotherTargetLang);
//   print("Translated Text ($anotherTargetLang): \"$anotherTranslatedText\"");
// }
