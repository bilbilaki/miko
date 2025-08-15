/// OpenAI chat request related funcs
part of 'home.dart';

bool _validChatCfg(BuildContext context) {
  final config = Cfg.current;
  final urlEmpty = config.url == 'https://api.openai.com' || config.url.isEmpty;
  if (urlEmpty && config.key.isEmpty) {
    final msg = l10n.emptyFields('${l10n.secretKey} | Api Url');
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return false;
  }
  return true;
}

/// Assumption that context len = 3:
/// - History len = 0 => [prompt]
/// - History len = 1 => [prompt, idx0]
/// - 2 => [prompt, idx0, idx1]
/// - n >= 3 => [prompt, idxn-2, idxn-1]
Future<Iterable<ChatCompletionMessage>> _historyCarried(
  ChatHistory workingChat,
) async {
  final config = Cfg.current;

  // #106
  final ignoreCtxCons = workingChat.settings?.ignoreContextConstraint == true;
  if (ignoreCtxCons) {
    return Future.wait(workingChat.items.map((e) => e.toOpenAI()));
  }

  final promptStr = config.prompt + Stores.mcp.memories.get().join('\n');
  final prompt = promptStr.isNotEmpty
      ? await ChatHistoryItem.single(
          role: ChatRole.system,
          raw: promptStr,
        ).toOpenAI()
      : null;

  // #101
  if (workingChat.settings?.headTailMode == true) {
    final first = await workingChat.items.firstOrNull?.toOpenAI();
    return [if (prompt != null) prompt, if (first != null) first];
  }

  var count = 0;
  final msgs = <ChatCompletionMessage>[];
  for (final item in workingChat.items.reversed) {
    if (count > config.historyLen) break;
    if (item.role.isSystem) continue;
    final msg = await item.toOpenAI();
    msgs.add(msg);
    count++;
  }
  if (prompt != null) msgs.add(prompt);
  return msgs.reversed;
}

/// Auto select model and send the request
void _onCreateRequest(BuildContext context, String chatId) async {
  if (!_validChatCfg(context)) return;

  // #18
  // Prohibit users from starting chat in the initial chat
  if (_curChat?.isInitHelp ?? false) {
    final newId = _newChat().id;
    _switchChat(newId);
    chatId = newId;
  }

  final chatType = Cfg.chatType.value;

  final input = inputCtrl.text;
  if (input.isEmpty) return;
  _imeFocus.unfocus();

  _loadingChatIds.value.add(chatId);
  _loadingChatIds.notify();
  _autoHideCtrl.autoHideEnabled = false;

  final func = switch ((chatType, _filesPicked.value)) {
    (ChatType.text, _) => _onCreateText,
    (ChatType.img, _) => _onCreateImg,
    (ChatType.audio, _) =>
      _onCreateSTT, // audio generation (TTS-like) streaming
    (ChatType.voice, _) => _onVoiceChat, // voice in + voice out
    (ChatType.voicejustin, _) =>
      _onVoiceJustInput, // voice in + text out (stream)
  };

  return await func(context, chatId, input, _filesPicked.value);
}

Future<void> _onCreateText(
  BuildContext context,
  String chatId,
  String input,
  List<String> files,
) async {
  final workingChat = _allHistories[chatId];
  if (workingChat == null) {
    final msg = 'Chat($chatId) not found';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }
  final config = Cfg.current;

  final questionContents = <ChatContent>[ChatContent.text(input)];
  for (final file in files) {
    // Ensure images are sent as base64 data URL
    final content = await _contentFromPath(file);
    questionContents.add(content);
  }
  final question = ChatHistoryItem.gen(
    content: questionContents,
    role: ChatRole.user,
  );
  final msgs = (await _historyCarried(workingChat)).toList();
  msgs.add(await question.toOpenAI());

  workingChat.items.add(question);
  inputCtrl.clear();
  _chatRN.notify();
  _autoScroll(chatId);
  final titleCompleter = await _genChatTitle(context, chatId, config);

  final mcpCompatible = Cfg.isMcpCompatible();

  // #104
  final chatScopeUseMcp = workingChat.settings?.useTools != false;

  // #111
  final availableMcp = await OpenAIFuncCalls.tools;
  final isMcpEmpty = availableMcp.isEmpty;
  final customtemp = ss.temperature.get();
  final maxtoken = ss.maxTokens.get();
  if (mcpCompatible && chatScopeUseMcp && !isMcpEmpty && customtemp == 1.0) {
    // Used for logging mcp call resp
    final mcpReply = ChatHistoryItem.single(role: ChatRole.tool, raw: '');
    workingChat.items.add(mcpReply);
    _chatRN.notify();
    _autoScroll(chatId);

    CreateChatCompletionResponse? resp;
    try {
      resp = await Cfg.client.createChatCompletion(
        request: CreateChatCompletionRequest(
          messages: msgs,
          model: ChatCompletionModel.modelId(config.model),
          tools: availableMcp.toList(),
        ),
      );
    } catch (e, s) {
      _onErr(e, s, chatId, 'MCP');
      return;
    }

    final firstMcpReply = resp.choices.firstOrNull;
    final mcpCalls = firstMcpReply?.message.toolCalls;
    if (mcpCalls != null && mcpCalls.isNotEmpty) {
      final assistReply = ChatHistoryItem.gen(
        role: ChatRole.assist,
        content: [],
        toolCalls: mcpCalls,
      );
      workingChat.items.add(assistReply);
      msgs.add(await assistReply.toOpenAI());
      void onMcpLog(String log) {
        final content = ChatContent.text(log);
        if (mcpReply.content.isEmpty) {
          mcpReply.content.add(content);
        } else {
          mcpReply.content[0] = content;
        }
        _chatItemRNMap[mcpReply.id]?.notify();
      }

      for (final mcpCall in mcpCalls) {
        final contents = <ChatContent>[];
        try {
          final msg = await OpenAIFuncCalls.handle(
            mcpCall,
            (e, s) => _askMcpConfirm(context, e, s),
            onMcpLog,
          );
          if (msg != null) contents.addAll(msg);
        } catch (e, s) {
          _onErr(e, s, chatId, 'MCP call');
        }
        if (contents.isNotEmpty && contents.every((e) => e.raw.isNotEmpty)) {
          final historyItem = ChatHistoryItem.gen(
            role: ChatRole.tool,
            content: contents,
            toolCallId: mcpCall.id,
          );
          workingChat.items.add(historyItem);
          msgs.add(await historyItem.toOpenAI());
        }
      }
    }

    _chatItemRNMap[mcpReply.id]?.notify();
    workingChat.items.remove(mcpReply);
    _chatRN.notify();
    _chatItemRNMap.remove(mcpReply.id)?.dispose();
  } else if (mcpCompatible && chatScopeUseMcp && !isMcpEmpty) {
    // Used for logging mcp call resp
    final mcpReply = ChatHistoryItem.single(role: ChatRole.tool, raw: '');
    workingChat.items.add(mcpReply);
    _chatRN.notify();
    _autoScroll(chatId);

    CreateChatCompletionResponse? resp;
    try {
      resp = await Cfg.client.createChatCompletion(
        request: CreateChatCompletionRequest(
          messages: msgs,
          model: ChatCompletionModel.modelId(config.model),
          tools: availableMcp.toList(),
        ),
      );
    } catch (e, s) {
      _onErr(e, s, chatId, 'MCP');
      return;
    }

    final firstMcpReply = resp.choices.firstOrNull;
    final mcpCalls = firstMcpReply?.message.toolCalls;
    if (mcpCalls != null && mcpCalls.isNotEmpty) {
      final assistReply = ChatHistoryItem.gen(
        role: ChatRole.assist,
        content: [],
        toolCalls: mcpCalls,
      );
      workingChat.items.add(assistReply);
      msgs.add(await assistReply.toOpenAI());
      void onMcpLog(String log) {
        final content = ChatContent.text(log);
        if (mcpReply.content.isEmpty) {
          mcpReply.content.add(content);
        } else {
          mcpReply.content[0] = content;
        }
        _chatItemRNMap[mcpReply.id]?.notify();
      }

      for (final mcpCall in mcpCalls) {
        final contents = <ChatContent>[];
        try {
          final msg = await OpenAIFuncCalls.handle(
            mcpCall,
            (e, s) => _askMcpConfirm(context, e, s),
            onMcpLog,
          );
          if (msg != null) contents.addAll(msg);
        } catch (e, s) {
          _onErr(e, s, chatId, 'MCP call');
        }
        if (contents.isNotEmpty && contents.every((e) => e.raw.isNotEmpty)) {
          final historyItem = ChatHistoryItem.gen(
            role: ChatRole.tool,
            content: contents,
            toolCallId: mcpCall.id,
          );
          workingChat.items.add(historyItem);
          msgs.add(await historyItem.toOpenAI());
        }
      }
    }

    _chatItemRNMap[mcpReply.id]?.notify();
    workingChat.items.remove(mcpReply);
    _chatRN.notify();
    _chatItemRNMap.remove(mcpReply.id)?.dispose();
  }
   double tmp =1.0;
  int maxt= 0;
  if (customtemp != 1.0) {
    tmp = customtemp;
  }
  if (maxtoken != 0) {
    maxt = maxtoken;
  }

  final chatStream = Cfg.client.createChatCompletionStream(
    request: CreateChatCompletionRequest(
      messages: msgs,
      model: ChatCompletionModel.modelId(config.model),
      temperature: tmp,
      maxTokens: maxt==0? null:maxt,
    ),
  );
  final assistReply = ChatHistoryItem.single(role: ChatRole.assist);
  workingChat.items.add(assistReply);
  _chatRN.notify();
  _filesPicked.value = [];

  try {
    final sub = chatStream.listen(
      (eve) async {
        final delta = eve.choices.firstOrNull?.delta;
        if (delta == null) return;

        final content = delta.content;
        if (content != null) {
          final newContent = ChatContent.text(
            (assistReply.content.isEmpty ? '' : assistReply.content.first.raw) +
                content,
          );
          if (assistReply.content.isEmpty) {
            assistReply.content.add(newContent);
          } else {
            assistReply.content[0] = newContent;
          }
          _chatItemRNMap[assistReply.id]?.notify();
        }

        final deltaResoningContent = delta.reasoningContent;
        if (deltaResoningContent != null) {
          final originReasoning = assistReply.reasoning ?? '';
          final newReasoning = '$originReasoning$deltaResoningContent';
          assistReply.reasoning = newReasoning;
          _chatItemRNMap[assistReply.id]?.notify();
        }

        _autoScroll(chatId);
      },
      onDone: () async {
        _onStopStreamSub(chatId);
        _loadingChatIds.value.remove(chatId);
        _loadingChatIds.notify();
        _autoHideCtrl.autoHideEnabled = true;

        _storeChat(chatId);

        // Wait for db to store the chat
        await titleCompleter?.future;
        await Future.delayed(const Duration(milliseconds: 300));
        BakSync.instance.sync();
      },
      onError: (e, s) {
        _onErr(e, s, chatId, 'Listen text stream');
      },
    );
    _chatStreamSubs[chatId] = sub;
  } catch (e, s) {
    _loadingChatIds.value.remove(chatId);
    _loadingChatIds.notify();
    _onErr(e, s, chatId, 'Catch text stream');
  }
}

Future<void> _onCreateImg(
  BuildContext context,
  String chatId,
  String input,
  List<String> files,
) async {
  final prompt = inputCtrl.text;
  if (prompt.isEmpty) return;
  _imeFocus.unfocus();
  inputCtrl.clear();

  final workingChat = _allHistories[chatId];
  if (workingChat == null) {
    final msg = 'Chat($chatId) not found';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }

  final userQuestion = ChatHistoryItem.single(role: ChatRole.user, raw: prompt);
  workingChat.items.add(userQuestion);
  final assistReply = ChatHistoryItem.gen(role: ChatRole.assist, content: []);
  workingChat.items.add(assistReply);
  _chatRN.notify();
  _autoScroll(chatId);

  final cfg = Cfg.current;
  final imgModel = cfg.imgModel;
  if (imgModel == null) {
    final msg = l10n.emptyFields('Image Model');
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }

  _loadingChatIds.value.add(chatId);
  _loadingChatIds.notify();
  _autoHideCtrl.autoHideEnabled = false;

  try {
    final resp = await Cfg.client.createImage(
      request: CreateImageRequest(
        prompt: prompt,
        model: CreateImageRequestModel.modelId(imgModel),
      ),
    );
    final imgs = <String>[];
    for (final item in resp.data) {
      final url = item.url;
      if (url != null) {
        imgs.add(url);
      }
    }
    if (imgs.isEmpty) {
      const msg = 'Create image: empty resp';
      Loggers.app.warning(msg);
      context.showSnackBar(msg);
      return;
    }

    final imgContents = imgs.map((e) => ChatContent.image(e)).toList();
    assistReply.content.addAll(imgContents);

    _storeChat(chatId);
    _chatRN.notify();
    _autoScroll(chatId);

    // Only sync if success
    BakSync.instance.sync();
  } catch (e, s) {
    // _onErr handles removing loading state and enabling auto-hide
    _onErr(e, s, chatId, 'Create image');
  } finally {
    _loadingChatIds.value.remove(chatId);
    _loadingChatIds.notify();
    _autoHideCtrl.autoHideEnabled = true;
  }
}

Future<Completer<void>?> _genChatTitle(
  BuildContext context,
  String chatId,
  ChatConfig cfg,
) async {
  if (!Stores.setting.genTitle.get()) return null;

  final entity = _allHistories[chatId];
  if (entity == null) {
    final msg = 'Gen Chat($chatId) not found';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return null;
  }
  if (entity.items.where((e) => e.role.isUser).length > 1) return null;

  final completer = Completer<void>();
  void onErr(Object e, StackTrace s) {
    Loggers.app.warning('Gen title: $e');
    _historyRN.notify();
    completer.complete();
  }

  try {
    final msgs = [
      await ChatHistoryItem.single(
        raw: Cfg.current.genTitlePrompt ?? ChatTitleUtil.titlePrompt,
        role: ChatRole.system,
      ).toOpenAI(),
      await ChatHistoryItem.single(
        role: ChatRole.user,
        raw: entity.items.first.content
            .firstWhere((p0) => p0.type == ChatContentType.text)
            .raw,
      ).toOpenAI(),
    ];
    final model = ChatTitleUtil.pickSuitableModel ?? cfg.model;
    final req = CreateChatCompletionRequest(
      model: ChatCompletionModel.modelId(model),
      messages: msgs,
    );
    Cfg.client.createChatCompletion(request: req).then((resp) {
      var title = resp.choices.firstOrNull?.message.content;
      title = ChatTitleUtil.prettify(title ?? '');

      if (title.isNotEmpty) {
        final ne = entity.copyWith(name: title)..save();
        _allHistories[chatId] = ne;
        _historyRN.notify();
        if (chatId == _curChatId.value) {
          _appbarTitleVN.value = title;
        }
      }

      completer.complete();
    }, onError: onErr);

    return completer;
  } catch (e, s) {
    onErr(e, s);
    return null;
  }
}

/// Remove the [ChatHistoryItem] behind this [item], and resend the [item] like
/// [_onCreateText], but append the result after this [item] instead of at the end.
void _onReplay({
  required BuildContext context,
  required String chatId,
  required ChatHistoryItem item,
}) async {
  if (!_validChatCfg(context)) return;

  // If is receiving the reply, ignore this action
  if (_loadingChatIds.value.contains(chatId)) {
    return;
  }

  final chatHistory = _allHistories[chatId];
  if (chatHistory == null) {
    final msg = 'Replay Chat($chatId) not found';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }

  // Find the item, then delete all items behind it and itself
  final replayMsgIdx = chatHistory.items.indexOf(item);
  if (replayMsgIdx == -1) {
    final msg = 'Replay Chat($chatId) item($item) not found';
    Loggers.app.warning(msg);
    context.showSnackBar('${libL10n.fail}: $msg');
    return;
  }
  chatHistory.items.removeRange(replayMsgIdx, chatHistory.items.length);

  // Each item has only one text content inputed by user
  final text = item.content.firstWhereOrNull((e) => e.type.isText)?.raw;
  if (text != null) {
    inputCtrl.text = text;
  }

  final files = item.content
      .where((e) => !e.type.isText)
      .map((e) => e.raw)
      .toList();
  _filesPicked.value = files;

  _onCreateRequest(context, chatId);
}

void _onErr(Object e, StackTrace s, String chatId, String action) {
  Loggers.app.warning('$action: $e');
  _onStopStreamSub(chatId);
  // Ensure loading state is removed and auto-hide is enabled on error
  _loadingChatIds.value.remove(chatId);
  _loadingChatIds.notify();
  _autoHideCtrl.autoHideEnabled = true;

  final msg = '$e\n\n```$s```';
  final workingChat = _allHistories[chatId];
  if (workingChat == null) return;

  // If previous msg is assistant reply and it's empty, remove it
  if (workingChat.items.isNotEmpty) {
    final last = workingChat.items.last;
    final role = last.role;
    if ((role.isAssist || role.isTool) &&
        last.content.every((e) => e.raw.isEmpty)) {
      workingChat.items.removeLast();
    }
  }

  // Add error msg to the chat
  workingChat.items.add(
    ChatHistoryItem.single(
      type: ChatContentType.text,
      raw: msg,
      role: ChatRole.system,
    ),
  );

  _chatRN.notify();

  if (Stores.setting.saveErrChat.get()) _storeChat(chatId);
}

/// =========================
/// Audio helpers/utilities
/// =========================

final AudioRecorder _audioRecorder = AudioRecorder();

Future<bool> _ensureRecordPermission() async {
  try {
    return await _audioRecorder.hasPermission();
  } catch (_) {
    return false;
  }
}

Future<String?> _quickRecordWav({
  Duration duration = const Duration(seconds: 6),
}) async {
  if (!await _ensureRecordPermission()) return null;
  final dir = Directory.systemTemp.createTempSync('rec_');
  final path = p.join(
    dir.path,
    'input_${DateTime.now().millisecondsSinceEpoch}.wav',
  );
  await _audioRecorder.start(
    const RecordConfig(
      encoder: AudioEncoder.wav,
      sampleRate: 16000,
      bitRate: 128000,
    ),
    path: path,
  );
  try {
    await Future.delayed(duration);
  } finally {
    try {
      await _audioRecorder.stop();
    } catch (_) {}
  }
  return File(path).existsSync() ? path : null;
}

bool _isImagePath(String path) {
  final ext = p.extension(path).toLowerCase();
  return [
    '.png',
    '.jpg',
    '.jpeg',
    '.webp',
    '.gif',
    '.bmp',
    '.heic',
    '.heif',
  ].contains(ext);
}

bool _isAudioPath(String path) {
  final ext = p.extension(path).toLowerCase();
  return [
    '.wav',
    '.mp3',
    '.m4a',
    '.aac',
    '.flac',
    '.ogg',
    '.oga',
    '.webm',
  ].contains(ext);
}

String _mimeFromExt(String path) {
  final ext = p.extension(path).toLowerCase();
  switch (ext) {
    case '.png':
      return 'image/png';
    case '.jpg':
    case '.jpeg':
      return 'image/jpeg';
    case '.webp':
      return 'image/webp';
    case '.gif':
      return 'image/gif';
    case '.bmp':
      return 'image/bmp';
    case '.heic':
      return 'image/heic';
    case '.heif':
      return 'image/heif';
    default:
      return 'application/octet-stream';
  }
}

Future<String> _fileToBase64(String path) async {
  final bytes = await File(path).readAsBytes();
  return base64Encode(bytes);
}

Future<String> _imagePathToDataUrl(String path) async {
  final mime = _mimeFromExt(path);
  final b64 = await _fileToBase64(path);
  return 'data:$mime;base64,$b64';
}

Future<ChatContent> _contentFromPath(String path) async {
  if (_isImagePath(path)) {
    final dataUrl = await _imagePathToDataUrl(path);
    return ChatContent.image(dataUrl);
  }
  return ChatContent.file(path);
}

Future<String> _saveBase64ToFile(
  String base64Data, {
  String ext = '.wav',
}) async {
  final bytes = base64Decode(base64Data);
  final dir = await Directory.systemTemp.createTemp('oai_audio_');
  final path = p.join(
    dir.path,
    'out_${DateTime.now().millisecondsSinceEpoch}$ext',
  );
  final f = File(path);
  await f.writeAsBytes(bytes, flush: true);
  return f.path;
}

Future<String?> _ensureAudioInputPath(List<String> files) async {
  final audio = files.firstWhereOrNull(_isAudioPath);
  if (audio != null) return audio;
  // fallback quick record if nothing provided
  return await _quickRecordWav();
}

/// =======================================
/// 1) Audio generation stream (CreateSTT)
/// Model: gpt-4o-mini-audio, modalities: [audio], stream audio
/// =======================================
Future<void> _onCreateSTT(
  BuildContext context,
  String chatId,
  String input,
  List<String> files,
) async {
  final workingChat = _allHistories[chatId];
  if (workingChat == null) {
    final msg = 'Chat($chatId) not found';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }
  final config = Cfg.current;

  // Prepare user question (text + optionally images/files already attached)
  final questionContents = <ChatContent>[ChatContent.text(input)];
  for (final f in files) {
    questionContents.add(await _contentFromPath(f));
  }
  final question = ChatHistoryItem.gen(
    content: questionContents,
    role: ChatRole.user,
  );
  final msgs = (await _historyCarried(workingChat)).toList();
  msgs.add(await question.toOpenAI());

  workingChat.items.add(question);
  inputCtrl.clear();
  _chatRN.notify();
  _autoScroll(chatId);

  final titleCompleter = await _genChatTitle(context, chatId, config);

  _loadingChatIds.value.add(chatId);
  _loadingChatIds.notify();
  _autoHideCtrl.autoHideEnabled = false;

  // Assistant reply placeholder (will attach audio file when done)
  final assistReply = ChatHistoryItem.gen(role: ChatRole.assist, content: []);
  workingChat.items.add(assistReply);
  _chatRN.notify();

  final audioDataBuffer = StringBuffer();
  final transcriptBuffer = StringBuffer();

  try {
    final stream = Cfg.client.createChatCompletionStream(
      request: CreateChatCompletionRequest(
        model: ChatCompletionModel.modelId('gpt-4o-mini-audio-preview'),
        messages: msgs,
        modalities: [ChatCompletionModality.audio, ChatCompletionModality.text],
        audio: ChatCompletionAudioOptions(
          voice: ChatCompletionAudioVoice.alloy,
          format: ChatCompletionAudioFormat.pcm16,
        ),
      ),
    );

    final sub = stream.listen(
      (eve) async {
        final delta = eve.choices.firstOrNull?.delta;
        if (delta == null) return;

        // Accumulate streaming audio base64
        final a = delta.audio;
        if (a?.data != null && a!.data!.isNotEmpty) {
          audioDataBuffer.write(a.data);
        }
        if (a?.transcript != null && a!.transcript!.isNotEmpty) {
          transcriptBuffer.write(a.transcript);
        }

        // Live transcript update (optional)
        if (transcriptBuffer.isNotEmpty) {
          final t = transcriptBuffer.toString();
          if (assistReply.content.isEmpty) {
            assistReply.content.add(ChatContent.text(t));
            //             final modelSoFar = assistReply.content.firstOrNull?.raw ?? '';
            // TokenCounter.updateFrom(userText: input, modelText: modelSoFar);
          } else {
            // Keep first content as transcript text until audio saved
            assistReply.content[0] = ChatContent.text(t);
            final modelSoFar = assistReply.content.firstOrNull?.raw ?? '';
            aiSettings.onTextChangedForTokens(modelText: modelSoFar);
          }
          _chatItemRNMap[assistReply.id]?.notify();
        }

        _autoScroll(chatId);
      },
      onDone: () async {
        try {
          // Persist audio
          if (audioDataBuffer.isNotEmpty) {
            final path = await _saveBase64ToFile(
              audioDataBuffer.toString(),
              ext: '.wav',
            );
            ss.voicePlayedUntilNow.set(false);
            if (assistReply.content.isEmpty) {
              assistReply.content.add(ChatContent.file(path));
              //               final modelSoFar = assistReply.content.firstOrNull?.raw ?? '';
              // TokenCounter.updateFrom(userText: input, modelText: modelSoFar);
            } else {
              // Keep transcript if present, also add audio as second content
              final hasText =
                  assistReply.content.firstOrNull?.type.isText == true;
              if (hasText) {
                assistReply.content.add(ChatContent.file(path));
              } else {
                assistReply.content[0] = ChatContent.file(path);
                final modelSoFar = assistReply.content.firstOrNull?.raw ?? '';
                aiSettings.onTextChangedForTokens(modelText: modelSoFar);
              }
            }
            _chatItemRNMap[assistReply.id]?.notify();
          }
        } finally {
          _onStopStreamSub(chatId);
          _loadingChatIds.value.remove(chatId);
          _loadingChatIds.notify();
          _autoHideCtrl.autoHideEnabled = true;

          _storeChat(chatId);
          await titleCompleter?.future;
          await Future.delayed(const Duration(milliseconds: 300));
          BakSync.instance.sync();
        }
      },
      onError: (e, s) {
        _onErr(e, s, chatId, 'Listen audio stream');
      },
    );
    _chatStreamSubs[chatId] = sub;
  } catch (e, s) {
    _loadingChatIds.value.remove(chatId);
    _loadingChatIds.notify();
    _onErr(e, s, chatId, 'Catch audio stream');
  }
}

/// =======================================
/// 2) Voice chat (voice in + voice out)
/// modalities: [text, audio]; includes input audio part
/// =======================================
Future<void> _onVoiceChat(
  BuildContext context,
  String chatId,
  String input,
  List<String> files,
) async {
  final workingChat = _allHistories[chatId];
  if (workingChat == null) {
    final msg = 'Chat($chatId) not found';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }

  final audioPath = await _ensureAudioInputPath(files);
  if (audioPath == null || !File(audioPath).existsSync()) {
    final msg = l10n.emptyFields('Voice input (record or pick an audio file)');
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    _loadingChatIds.value.remove(chatId);
    _loadingChatIds.notify();
    _autoHideCtrl.autoHideEnabled = true;
    return;
  }

  final userItem = ChatHistoryItem.gen(
    role: ChatRole.user,
    content: [
      if (input.isNotEmpty) ChatContent.text(input),
      ChatContent.file(audioPath),
    ],
  );
  workingChat.items.add(userItem);
  _chatRN.notify();
  _autoScroll(chatId);

  _loadingChatIds.value.add(chatId);
  _loadingChatIds.notify();
  _autoHideCtrl.autoHideEnabled = false;

  try {
    final prev = (await _historyCarried(workingChat)).toList();

    final inputB64 = await _fileToBase64(audioPath);

    final res = await Cfg.client.createChatCompletion(
      request: CreateChatCompletionRequest(
        model: ChatCompletionModel.model(
          ChatCompletionModels.gpt4oAudioPreview,
        ),
        modalities: const [
          ChatCompletionModality.text,
          ChatCompletionModality.audio,
        ],
        audio: const ChatCompletionAudioOptions(
          voice: ChatCompletionAudioVoice.alloy,
          format: ChatCompletionAudioFormat.pcm16,
        ),
        messages: [
          ...prev,
          ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.parts([
              if (input.isNotEmpty)
                ChatCompletionMessageContentPart.text(text: input),
              if (inputB64.isNotEmpty)
                ChatCompletionMessageContentPart.audio(
                  inputAudio: ChatCompletionMessageInputAudio(
                    data: inputB64,
                    format: ChatCompletionMessageInputAudioFormat.wav,
                  ),
                ),
            ]),
          ),
        ],
      ),
    );

    final choice = res.choices.first;
    final audio = choice.message.audio;
    final transcript = audio?.transcript ?? '';

    final reply = ChatHistoryItem.gen(role: ChatRole.assist, content: []);
    workingChat.items.add(reply);

    if (audio?.data != null && audio!.data.isNotEmpty) {
      final path = await _saveBase64ToFile(audio.data, ext: '.wav');
      ss.voicePlayedUntilNow.set(false);

      reply.content.add(ChatContent.file(path));
    }
    if (transcript.isNotEmpty) {
      reply.content.add(ChatContent.text(transcript));
    }

    _chatRN.notify();
    _autoScroll(chatId);

    _storeChat(chatId);
    BakSync.instance.sync();
  } catch (e, s) {
    _onErr(e, s, chatId, 'Voice chat');
  } finally {
    _loadingChatIds.value.remove(chatId);
    _loadingChatIds.notify();
    _autoHideCtrl.autoHideEnabled = true;
  }
}

/// =======================================
/// 3) Voice input only (like text stream, but attach user audio input)
/// modalities: [text]; stream textual answer; user message contains text + audio
/// =======================================
Future<void> _onVoiceJustInput(
  BuildContext context,
  String chatId,
  String input,
  List<String> files,
) async {
  final workingChat = _allHistories[chatId];
  if (workingChat == null) {
    final msg = 'Chat($chatId) not found';
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }
  final config = Cfg.current;

  final audioPath = await _ensureAudioInputPath(files);
  if (audioPath == null || !File(audioPath).existsSync()) {
    final msg = l10n.emptyFields('Voice input (record or pick an audio file)');
    Loggers.app.warning(msg);
    context.showSnackBar(msg);
    return;
  }

  // Build prev messages
  final prev = (await _historyCarried(workingChat)).toList();

  // Build user message for OpenAI directly to attach audio part
  final inputB64 = await _fileToBase64(audioPath);
  final userMsg = ChatCompletionMessage.user(
    content: ChatCompletionUserMessageContent.parts([
      if (input.isNotEmpty) ChatCompletionMessageContentPart.text(text: input),
      ChatCompletionMessageContentPart.audio(
        inputAudio: ChatCompletionMessageInputAudio(
          data: inputB64,
          format: ChatCompletionMessageInputAudioFormat.wav,
        ),
      ),
    ]),
  );

  // Mirror into our history
  final userItem = ChatHistoryItem.gen(
    role: ChatRole.user,
    content: [
      if (input.isNotEmpty) ChatContent.text(input),
      ChatContent.file(audioPath),
    ],
  );
  workingChat.items.add(userItem);
  inputCtrl.clear();
  _chatRN.notify();
  _autoScroll(chatId);

  final titleCompleter = await _genChatTitle(context, chatId, config);

  _loadingChatIds.value.add(chatId);
  _loadingChatIds.notify();
  _autoHideCtrl.autoHideEnabled = false;

  final request = CreateChatCompletionRequest(
    model: ChatCompletionModel.modelId(config.model),
    modalities: const [ChatCompletionModality.text],
    messages: [...prev, userMsg],
  );

  final assistReply = ChatHistoryItem.single(role: ChatRole.assist);
  workingChat.items.add(assistReply);
  _chatRN.notify();

  try {
    final stream = Cfg.client.createChatCompletionStream(request: request);

    final sub = stream.listen(
      (eve) async {
        final delta = eve.choices.firstOrNull?.delta;
        if (delta == null) return;

        final content = delta.content;
        if (content != null) {
          final newContent = ChatContent.text(
            (assistReply.content.isEmpty ? '' : assistReply.content.first.raw) +
                content,
          );
          if (assistReply.content.isEmpty) {
            assistReply.content.add(newContent);
          } else {
            assistReply.content[0] = newContent;
            final modelSoFar = assistReply.content.firstOrNull?.raw ?? '';
            aiSettings.onTextChangedForTokens(modelText: modelSoFar);
          }
          _chatItemRNMap[assistReply.id]?.notify();
        }

        final deltaResoningContent = delta.reasoningContent;
        if (deltaResoningContent != null) {
          final originReasoning = assistReply.reasoning ?? '';
          final newReasoning = '$originReasoning$deltaResoningContent';
          assistReply.reasoning = newReasoning;
          _chatItemRNMap[assistReply.id]?.notify();
        }

        _autoScroll(chatId);
      },
      onDone: () async {
        _onStopStreamSub(chatId);
        _loadingChatIds.value.remove(chatId);
        _loadingChatIds.notify();
        _autoHideCtrl.autoHideEnabled = true;

        _storeChat(chatId);

        await titleCompleter?.future;
        await Future.delayed(const Duration(milliseconds: 300));
        BakSync.instance.sync();
      },
      onError: (e, s) {
        _onErr(e, s, chatId, 'Listen voice-input text stream');
      },
    );

    _chatStreamSubs[chatId] = sub;
  } catch (e, s) {
    _loadingChatIds.value.remove(chatId);
    _loadingChatIds.notify();
    _onErr(e, s, chatId, 'Catch voice-input text stream');
  }
}
