import 'package:miko/configs/consts2.dart';
import 'package:miko/main.dart';
import 'package:miko/services/user_data_service.dart';
import 'package:openai_dart/openai_dart.dart' as openai;
import 'dart:convert';

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';


typedef OpenRoute =
    Future<void> Function(String route, Map<String, dynamic>? args);
typedef SearchApi = Future<List<Map<String, dynamic>>> Function(String query);
typedef RecommendApi =
    Future<List<Map<String, dynamic>>> Function(String userId);
typedef FactApi = Future<String> Function(String topic);

class Assistant {
  Assistant({
    required this.client,
    required this.searchApi,
    required this.openRoute,
    required this.recommendApi,
    required this.factApi,
    this.modelId = 'gpt-4.1-mini', // or your fast model
  });

  final openai.OpenAIClient client;
  final String modelId;
  final SearchApi searchApi;
  final OpenRoute openRoute;
  final RecommendApi recommendApi;
  final FactApi factApi;

  openai.ChatCompletionTool get _searchTool => openai.ChatCompletionTool(
    type: openai.ChatCompletionToolType.function,
    function: openai.FunctionObject(
      name: 'search_web',
      description: 'Search the web and return concise results',
      parameters: {
        'type': 'object',
        'properties': {
          'query': {'type': 'string'},
        },
        'required': ['query'],
      },
    ),
  );

  openai.ChatCompletionTool get _openRouteTool => openai.ChatCompletionTool(
    type: openai.ChatCompletionToolType.function,
    function: openai.FunctionObject(
      name: 'open_route',
      description: 'Open a page/route in the app',
      parameters: {
        'type': 'object',
        'properties': {
          'route': {'type': 'string'},
          'args': {'type': 'object'},
        },
        'required': ['route'],
      },
    ),
  );

  openai.ChatCompletionTool get _recommendTool => openai.ChatCompletionTool(
    type: openai.ChatCompletionToolType.function,
    function: openai.FunctionObject(
      name: 'recommend_items',
      description: 'Recommend items to a user',
      parameters: {
        'type': 'object',
        'properties': {
          'userId': {'type': 'string'},
        },
        'required': ['userId'],
      },
    ),
  );

  openai.ChatCompletionTool get _factTool => openai.ChatCompletionTool(
    type: openai.ChatCompletionToolType.function,
    function: openai.FunctionObject(
      name: 'get_fact',
      description: 'Return a short, verified fact about a topic',
      parameters: {
        'type': 'object',
        'properties': {
          'topic': {'type': 'string'},
        },
        'required': ['topic'],
      },
    ),
  );

  Future<String> handle(List<openai.ChatCompletionMessage> history) async {
    final res1 = await client.createChatCompletion(
      request: openai.CreateChatCompletionRequest(
        model: openai.ChatCompletionModel.modelId(modelId),
        messages: history,
        tools: [_searchTool, _openRouteTool, _recommendTool, _factTool],
       // toolChoice: openai.ChatCompletionToolChoiceOption(openai.ChatCompletionToolChoiceOption.auto),
      ),
    );

    final msg = res1.choices.first.message;
    final calls = msg.toolCalls ?? [];
    if (calls.isEmpty) return msg.content ?? '';

    final toolMsgs = <openai.ChatCompletionMessage>[];

    for (final c in calls) {
      final name = c.function.name;
      final args = json.decode(c.function.arguments) as Map<String, dynamic>;
      dynamic result;

      switch (name) {
        case 'search_web':
          result = await searchApi(args['query'] as String);
          break;
        case 'open_route':
          await openRoute(
            args['route'] as String,
            (args['args'] as Map?)?.cast<String, dynamic>(),
          );
          result = {'status': 'opened'};
          break;
        case 'recommend_items':
          result = await recommendApi(args['userId'] as String);
          break;
        case 'get_fact':
          result = {'fact': await factApi(args['topic'] as String)};
          break;
      }

      toolMsgs.add(
        openai.ChatCompletionMessage.tool(
          toolCallId: c.id,
          content: json.encode(result),
        ),
      );
    }

    final res2 = await client.createChatCompletion(
      request: openai.CreateChatCompletionRequest(
        model: openai.ChatCompletionModel.modelId(modelId),
        messages: [...history, msg, ...toolMsgs],
      ),
    );

    return res2.choices.first.message.content ?? '';
  }
}
class TranslatableText extends StatefulWidget {
  const TranslatableText(
    this.text, {
    super.key,
    required this.targetLang,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final String targetLang;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  State<TranslatableText> createState() => _TranslatableTextState();
}

class _TranslatableTextState extends State<TranslatableText> {
  String _display = '';

  @override
  void initState() {
    super.initState();
    final svc = TranslationService(
      apiKey: webVieApiKey,
      baseUrl: webViewBaseUrl,
      modelId: 'gemini-2.5-flash-lite',
    );
    _display = svc.translateSyncFirst(
      text: widget.text,
      targetLang: widget.targetLang,
      onUpdate: (fresh) {
        if (mounted) setState(() => _display = fresh);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _display.isEmpty ? widget.text : _display,
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow ?? TextOverflow.clip,
    );
  }
}
class _Lru<K, V> {
  final int capacity;
  final _map = <K, V>{};
  _Lru(this.capacity);
  V? get(K k) {
    final v = _map.remove(k);
    if (v != null) _map[k] = v;
    return v;
  }

  void set(K k, V v) {
    if (_map.containsKey(k)) _map.remove(k);
    _map[k] = v;
    if (_map.length > capacity) _map.remove(_map.keys.first);
  }
}

class TranslationService {
  TranslationService({
    required this.apiKey,
    required this.baseUrl,
    this.modelId = 'gemini-2.5-flash-lite',
    this.cacheTtl = const Duration(days: 14),
    this.memoryCapacity = 2000,
  });

  final String apiKey;
  final String baseUrl;
  final String modelId;
  final Duration cacheTtl;
  final int memoryCapacity;

  late final openai.OpenAIClient _client = openai.OpenAIClient(
    apiKey: apiKey,
    baseUrl: baseUrl,
  );

  final _mem = _Lru<String, Map<String, dynamic>>(2000);
  SharedPreferences? _prefs;
  final _inFlight = <String, Future<String>>{};

  Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  String _key(String text, String lang) {
    final norm = text.trim().replaceAll(RegExp(r'\s+'), ' ');
    return 'tr_v2|$modelId|$lang|${norm.hashCode}';
    // keep key short to avoid SharedPreferences size bloat
  }

  String? _getCached(String text, String lang) {
    final k = _key(text, lang);
    final now = DateTime.now();
    final mem = _mem.get(k);
    if (mem != null) {
      final ts = DateTime.parse(mem['ts'] as String);
      if (now.difference(ts) < cacheTtl) return mem['t'] as String;
    }
    final s = _prefs?.getString(k);
    if (s != null) {
      final obj = json.decode(s) as Map<String, dynamic>;
      final ts = DateTime.tryParse(obj['ts'] as String? ?? '');
      if (ts != null && DateTime.now().difference(ts) < cacheTtl) {
        _mem.set(k, obj);
        return obj['t'] as String?;
      }
    }
    return null;
  }

  Future<void> _setCached(String text, String lang, String t) async {
    final k = _key(text, lang);
    final obj = {'t': t, 'ts': DateTime.now().toIso8601String()};
    _mem.set(k, obj);
    final prefs = _prefs ??= await SharedPreferences.getInstance();
    await prefs.setString(k, json.encode(obj));
  }

  // Sync-first: returns cached value (or original) immediately. Fetches fresh in background.
  String translateSyncFirst({
    required String text,
    required String targetLang,
    void Function(String fresh)? onUpdate,
    bool fallbackToOriginal = true,
  }) {
    final cached = _getCached(text, targetLang);
    if (cached != null) return cached;
    if (onUpdate != null) {
      unawaited(
        translate(
          text: text,
          targetLang: targetLang,
        ).then(onUpdate).catchError((_) {}),
      );
    }
    return fallbackToOriginal ? text : '';
  }

  Future<String> translate({
    required String text,
    required String targetLang,
  }) async {
    await _init();
    final cached = _getCached(text, targetLang);
    if (cached != null) return cached;

    final k = _key(text, targetLang);
    if (_inFlight.containsKey(k)) return _inFlight[k]!;

    final f = _translateNetwork(text: text, targetLang: targetLang)
        .then((t) async {
          await _setCached(text, targetLang, t);
          return t;
        })
        .whenComplete(() => _inFlight.remove(k));

    _inFlight[k] = f;
    return f;
  }

  Future<String> _translateNetwork({
    required String text,
    required String targetLang,
  }) async {
    final res = await _client.createChatCompletion(
      request: openai.CreateChatCompletionRequest(
        model: openai.ChatCompletionModel.modelId(modelId),
        messages: [
          openai.ChatCompletionMessage.system(
            content: 'Translate the input to $targetLang. Return JSON only.',
          ),
          openai.ChatCompletionMessage.user(
            content: openai.ChatCompletionUserMessageContent.string(
              'text="$text"\nlang="$targetLang"',
            ),
          ),
        ],
        temperature: 0.1,
        responseFormat: openai.ResponseFormat.jsonSchema(
          jsonSchema: openai.JsonSchemaObject(
            name: 'TranslateResult',
            description: 'Deterministic translation result',
            strict: true,
            schema: {
              'type': 'object',
              'properties': {
                't': {'type': 'string', 'description': 'translated text'},
              },
              'required': ['t'],
              'additionalProperties': false,
            },
          ),
        ),
      ),
    );

    // Guaranteed JSON matching schema
    final content = res.choices.first.message.content ?? '{}';
    final obj = json.decode(content) as Map<String, dynamic>;
    return (obj['t'] as String).trim();
  }

  // Batch translate: returns one line per input; uses Structured Outputs
  Future<List<String>> translateBatch({
    required List<String> texts,
    required String targetLang,
  }) async {
    await _init();

    final out = List<String?>.filled(texts.length, null);
    var allCached = true;
    for (var i = 0; i < texts.length; i++) {
      final c = _getCached(texts[i], targetLang);
      out[i] = c;
      if (c == null) allCached = false;
    }
    if (allCached) return out.cast<String>();

    // Prepare only missing items
    final pending = <int, String>{};
    for (var i = 0; i < texts.length; i++) {
      if (out[i] == null) pending[i] = texts[i];
    }

    final res = await _client.createChatCompletion(
      request: openai.CreateChatCompletionRequest(
        model: openai.ChatCompletionModel.modelId(modelId),
        messages: [
          openai.ChatCompletionMessage.system(
            content: 'Translate each item to $targetLang. Return JSON only.',
          ),
          openai.ChatCompletionMessage.user(
            content: openai.ChatCompletionUserMessageContent.string(
              json.encode({
                'lang': targetLang,
                'items': pending.entries
                    .map((e) => {'i': e.key, 'text': e.value})
                    .toList(),
              }),
            ),
          ),
        ],
        temperature: 0.1,
        responseFormat: openai.ResponseFormat.jsonSchema(
          jsonSchema: openai.JsonSchemaObject(
            name: 'BatchTranslate',
            description: 'Batch translation results',
            strict: true,
            schema: {
              'type': 'object',
              'properties': {
                'results': {
                  'type': 'array',
                  'items': {
                    'type': 'object',
                    'properties': {
                      'i': {'type': 'integer'},
                      't': {'type': 'string'},
                    },
                    'required': ['i', 't'],
                    'additionalProperties': false,
                  },
                },
              },
              'required': ['results'],
              'additionalProperties': false,
            },
          ),
        ),
      ),
    );

    final content = res.choices.first.message.content ?? '{}';
    final obj = json.decode(content) as Map<String, dynamic>;
    final results = (obj['results'] as List).cast<Map<String, dynamic>>();
    for (final r in results) {
      final i = r['i'] as int;
      final t = (r['t'] as String).trim();
      out[i] = t;
      unawaited(_setCached(texts[i], targetLang, t));
    }
    // Fill any remaining holes with original text
    return List<String>.generate(texts.length, (i) => out[i] ?? texts[i]);
  }
}

/// Singleton translator for movie and TV show content
class MovieTvTranslator {
  static final MovieTvTranslator _instance = MovieTvTranslator._internal();
  
  factory MovieTvTranslator() => _instance;
  
  MovieTvTranslator._internal();

  Future<String> translateTextForMoviesAndTV(String text) async {
    final userDataService = UserDataService();
    final targetLanguage = userDataService.translationTargetLanguage.isNotEmpty 
        ? userDataService.translationTargetLanguage 
        : userDataService.custoombaseurl;
    final client = openai.OpenAIClient(
      apiKey: userDataService.aiTranslationApiKey,
      baseUrl: userDataService.aiTranslationBaseUrl,
    );
    return persistentCache.runOrGet(text, targetLanguage, () async {
      final res = await client.createChatCompletion(
        request: openai.CreateChatCompletionRequest(
          model: openai.ChatCompletionModel.modelId(userDataService.aiTranslationModelId),
          messages: [
            openai.ChatCompletionMessage.system(
              content: 'You are a professional translator specializing in movie and TV show content. Translate the given text accurately and naturally.',
            ),
            openai.ChatCompletionMessage.user(
              content: openai.ChatCompletionUserMessageContent.string(
                'Translate the following text into $targetLanguage. Maintain the original tone and style. Only provide the translated text, nothing else:\n\n$text',
              ),
            ),
          ],
          temperature: 0.7,
        ),
      );
      return (res.choices.first.message.content ?? '').trim();
    });
  }
}
