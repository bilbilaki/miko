// lib/ui/chat_controller.dart
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miko/ai/services/ai_browser_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

import 'ai_core_models.dart';
import 'ai_core_service.dart';
import 'gemini_core.dart';
import 'openai_core.dart';
import 'session_manager.dart';

enum AiProviderType { openai, gemini }

class AiSettings extends ChangeNotifier {
 AiProviderType provider = AiProviderType.openai;
 String openAiApiKey = '';
 String? openAiBaseUrl; // optional if your client supports custom base
 String geminiApiKey = '';
 String modelId = 'gpt-4o-mini';
 double temperature = 0.7;
 int maxTokens = 4096;
 bool streaming = true;
 bool voiceResponse = false;
 bool persistSystemMessage = true;
 String systemPrompt = 'You are a helpful and creative assistant.';

 void update(void Function(AiSettings s) change) {
 change(this);
 notifyListeners();
 }
}

class ChatController extends ChangeNotifier {
 final SessionManager sessionManager;
 final AiSettings settings;

 ChatController({required this.sessionManager, required this.settings});

 // Input state
 final textController = TextEditingController();
 final inputFocus = FocusNode();
 final List<Attachment> _pendingAttachments = [];
 bool get hasPendingAttachments => _pendingAttachments.isNotEmpty;
 List<Attachment> get pendingAttachments => List.unmodifiable(_pendingAttachments);

 // Recording
 final _recorder = AudioRecorder();
 bool isRecording = false;
 Duration recordingDuration = Duration.zero;
 Timer? _recordingTimer;
 String? _recordTempPath;

 // Streaming / typing
 bool isSending = false;
 bool isStreaming = false;
 String streamingMessageId = '';
 StreamSubscription<AiStreamEvent>? _streamSub;

 // Provider factory
 AiCoreService _makeService() {
 switch (settings.provider) {
 case AiProviderType.openai:
 return OpenAiCoreService(
 client: client, // you should create the client with apiKey/baseUrl in your app layer
 defaultChatModelId: settings.modelId,
 defaultTemperature: settings.temperature,
 );
 case AiProviderType.gemini:
 return GeminiCoreService(
 apiKey: settings.geminiApiKey,
 chatModelId: settings.modelId,
 defaultTemperature: settings.temperature,
 );
 }
 }

 // Placeholder for OpenAI dart client injection
 // Replace this with your actual client builder with API key/base URL
 dynamic _ensureOpenAIClient() {
 throw UnimplementedError('Provide an OpenAIClient instance wired with API key/baseUrl');
 }

 // Attachments handling
 void addImageBase64(String base64, {String mimeType = 'image/jpeg'}) {
 _pendingAttachments.add(Attachment.image(base64Data: base64, mimeType: mimeType));
 notifyListeners();
 }

 void addAudioBytes(Uint8List bytes,
 {Duration duration = Duration.zero, AudioFormat format = AudioFormat.wav, AudioSourceType source = AudioSourceType.recorded}) {
 _pendingAttachments.add(Attachment.audio(bytes: bytes, duration: duration, sourceType: source, format: format));
 notifyListeners();
 }

 void addFileBytes({
 required String fileName,
 required Uint8List bytes,
 String mimeType = 'application/octet-stream',
 int? size,
 }) {
 _pendingAttachments.add(Attachment.file(fileName: fileName, bytes: bytes, mimeType: mimeType, size: size));
 notifyListeners();
 }

 void addChunkText(String text, {String? sourceName}) {
 _pendingAttachments.add(Attachment.chunk(text: text, sourceName: sourceName));
 notifyListeners();
 }

 void removePendingAttachmentAt(int index) {
 if (index >= 0 && index < _pendingAttachments.length) {
 _pendingAttachments.removeAt(index);
 notifyListeners();
 }
 }

 void clearPending() {
 _pendingAttachments.clear();
 notifyListeners();
 }

 // Recording
 Future<void> startRecording() async {
 if (await _recorder.hasPermission() != true) return;
 isRecording = true;
 recordingDuration = Duration.zero;
 _recordingTimer?.cancel();
 _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
 recordingDuration += const Duration(seconds: 1);
 notifyListeners();
 });

 final dir = await getTemporaryDirectory();
 _recordTempPath = '${dir.path}/${const Uuid().v4()}.wav';
 await _recorder.start(const RecordConfig(encoder: AudioEncoder.wav), path: _recordTempPath!);
 notifyListeners();
 }

 Future<void> stopRecording({bool cancelled = false}) async {
 _recordingTimer?.cancel();
 final path = await _recorder.stop();
 isRecording = false;
 notifyListeners();

 if (cancelled || path == null) {
 if (path != null) {
 try { File(path).delete(); } catch (_) {}
 }
 return;
 }

 final bytes = await File(path).readAsBytes();
 addAudioBytes(bytes, duration: recordingDuration, format: AudioFormat.wav, source: AudioSourceType.recorded);
 recordingDuration = Duration.zero;
 notifyListeners();
 }

 // Send flow
 Future<void> sendCurrentInput() async {
 if (isSending) return;
 final session = sessionManager.currentSession;
 if (session == null) return;

 final text = textController.text.trim();
 final hasContent = text.isNotEmpty || _pendingAttachments.isNotEmpty;
 if (!hasContent) return;

 isSending = true;
 notifyListeners();

 final userMsg = sessionManager.addMessage(
 sessionId: session.id,
 role: MessageRole.user,
 text: text.isEmpty ? null : text,
 attachments: List.of(_pendingAttachments),
 );

 textController.clear();
 clearPending();

 // Auto title
 if (session.title == 'New Chat' && text.isNotEmpty) {
 _autoTitle(text);
 }

 try {
 final service = _makeService();
 final history = sessionManager.currentSession!.messages;
 if (settings.voiceResponse) {
 // voice answer
 final vr = await service.voiceResponse(
 history: history,
 options: AiCallOptions(modelIdOverride: settings.modelId, temperature: settings.temperature),
 tts: const AiTtsOptions(responseMimeType: 'audio/wav'),
 );
 final assistant = UnifiedMessage(
 id: const Uuid().v4(),
 role: MessageRole.assistant,
 text: vr.transcript ?? '',
 attachments: [
 if (vr.audioBytes.isNotEmpty)
 Attachment.audio(bytes: vr.audioBytes, duration: Duration.zero, sourceType: AudioSourceType.picked, format: AudioFormat.wav),
 ],
 createdAt: DateTime.now(),
 );
 sessionManager.addMessage(sessionId: session.id, role: assistant.role, text: assistant.text, attachments: assistant.attachments);
 } else if (settings.streaming) {
 await _handleStreaming(service, session.id, history);
 } else {
 final res = await service.messageMulti(
 history: history,
 options: AiCallOptions(modelIdOverride: settings.modelId, temperature: settings.temperature),
 );
 sessionManager.addMessage(
 sessionId: session.id,
 role: res.message.role,
 text: res.message.text,
 attachments: res.message.attachments,
 );
 }
 } finally {
 isSending = false;
 notifyListeners();
 }
 }

 Future<void> _handleStreaming(AiCoreService service, String sessionId, List<UnifiedMessage> history) async {
 isStreaming = true;
 final placeholder = sessionManager.addMessage(
 sessionId: sessionId,
 role: MessageRole.assistant,
 text: '',
 );

 streamingMessageId = placeholder.id;
 notifyListeners();

 _streamSub?.cancel();
 _streamSub = service
 .streamMessage(
 history: history,
 options: AiCallOptions(modelIdOverride: settings.modelId, temperature: settings.temperature),
 )
 .listen((event) {
 if (event is AiStreamDeltaText) {
 sessionManager.editMessage(
 sessionId: sessionId,
 messageId: streamingMessageId,
 newText: event.fullText,
 );
 } else if (event is AiStreamThinking) {
 // can be used to show thinking UI
 } else if (event is AiStreamToolCall) {
 // could append tool call info in metadata
 } else if (event is AiStreamCompleted) {
 isStreaming = false;
 notifyListeners();
 }
 }, onError: (e, st) {
 isStreaming = false;
 notifyListeners();
 });
 }

 // Resend: drop messages after target, then resend from that history
 Future<void> resendFromMessage(String messageId) async {
 final s = sessionManager.currentSession;
 if (s == null) return;
 final idx = s.messages.indexWhere((m) => m.id == messageId);
 if (idx < 0) return;

 final trimmed = s.messages.sublist(0, idx + 1);
 sessionManager.replaceAllMessages(sessionId: s.id, messages: trimmed);
 await sendCurrentInput(); // assumes current input has content; if not, re-run last user message only
 }

 // Edit a message
 void updateMessage(String messageId, String newText) {
 final s = sessionManager.currentSession;
 if (s == null) return;
 sessionManager.editMessage(sessionId: s.id, messageId: messageId, newText: newText);
 }

 // Title generation helper
 Future<void> _autoTitle(String seed) async {
 try {
 final service = _makeService();
 final title = await service.generateTitle(seedText: seed);
 final s = sessionManager.currentSession;
 if (s != null && title.isNotEmpty) {
 sessionManager.renameSession(s.id, title);
 }
 } catch (_) {}
 }

 // Generate a system prompt from user description
 Future<void> generateSystemPrompt(String description) async {
 final service = _makeService();
 final prompt = await service.summarize(text: 'Generate a concise system prompt for this app need: $description');
 settings.update((s) => s.systemPrompt = prompt.isNotEmpty ? prompt : s.systemPrompt);
 }

 // Cleanup
 @override
 void dispose() {
 _streamSub?.cancel();
 _recordingTimer?.cancel();
 textController.dispose();
 inputFocus.dispose();
 super.dispose();
 }
}