// lib/core/session_manager.dart
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import 'ai_core_models.dart';
import 'ai_converters.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as gemini;
import 'package:openai_dart/openai_dart.dart' as openai;

class SessionManager extends ChangeNotifier {
  final LinkedHashMap<String, Session> _sessions = LinkedHashMap();
  String? _currentSessionId;

  // -------- Public getters --------

  List<Session> get sessions => UnmodifiableListView(_sessions.values);
  String? get currentSessionId => _currentSessionId;
  Session? get currentSession =>
      _currentSessionId != null ? _sessions[_currentSessionId] : null;

  // -------- Session CRUD --------

  String createSession({String title = 'New Chat', String? description}) {
    final id = const Uuid().v4();
    final now = DateTime.now();
    _sessions[id] = Session(
      id: id,
      title: title,
      description: description,
      createdAt: now,
      updatedAt: now,
      messages: const [],
    );
    _currentSessionId ??= id;
    notifyListeners();
    return id;
  }

  void setCurrentSession(String sessionId) {
    if (_sessions.containsKey(sessionId)) {
      _currentSessionId = sessionId;
      notifyListeners();
    }
  }

  void renameSession(String sessionId, String newTitle) {
    final s = _sessions[sessionId];
    if (s != null) {
      _sessions[sessionId] = s.copyWith(
        title: newTitle,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void updateDescription(String sessionId, String? description) {
    final s = _sessions[sessionId];
    if (s != null) {
      _sessions[sessionId] = s.copyWith(
        description: description,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  void deleteSession(String sessionId) {
    _sessions.remove(sessionId);
    if (_currentSessionId == sessionId) {
      _currentSessionId = _sessions.isEmpty ? null : _sessions.keys.first;
    }
    notifyListeners();
  }

  void clearAll() {
    _sessions.clear();
    _currentSessionId = null;
    notifyListeners();
  }

  // -------- Message operations --------

  UnifiedMessage addMessage({
    required String sessionId,
    required MessageRole role,
    String? text,
    List<Attachment> attachments = const [],
    Map<String, dynamic> metadata = const {},
  }) {
    final s = _sessions[sessionId];
    if (s == null) {
      throw StateError('Session not found');
    }
    final msg = UnifiedMessage(
      id: const Uuid().v4(),
      role: role,
      text: text,
      attachments: List.unmodifiable(attachments),
      metadata: Map.unmodifiable(metadata),
      createdAt: DateTime.now(),
    );

    final updated = s.copyWith(
      messages: List.of(s.messages)..add(msg),
      updatedAt: DateTime.now(),
    );
    _sessions[sessionId] = updated;
    notifyListeners();
    return msg;
  }

  void editMessage({
    required String sessionId,
    required String messageId,
    String? newText,
    List<Attachment>? newAttachments,
    Map<String, dynamic>? newMetadata,
  }) {
    final s = _sessions[sessionId];
    if (s == null) return;

    final idx = s.messages.indexWhere((m) => m.id == messageId);
    if (idx == -1) return;

    final old = s.messages[idx];
    final edited = old.copyWith(
      text: newText ?? old.text,
      attachments: newAttachments ?? old.attachments,
      metadata: newMetadata ?? old.metadata,
      updatedAt: DateTime.now(),
      isEdited: true,
    );

    final msgs = List<UnifiedMessage>.of(s.messages)..[idx] = edited;
    _sessions[sessionId] = s.copyWith(messages: msgs, updatedAt: DateTime.now());
    notifyListeners();
  }

  void deleteMessage({
    required String sessionId,
    required String messageId,
  }) {
    final s = _sessions[sessionId];
    if (s == null) return;
    final msgs = s.messages.where((m) => m.id != messageId).toList();
    _sessions[sessionId] = s.copyWith(messages: msgs, updatedAt: DateTime.now());
    notifyListeners();
  }

  void replaceAllMessages({
    required String sessionId,
    required List<UnifiedMessage> messages,
  }) {
    final s = _sessions[sessionId];
    if (s == null) return;
    _sessions[sessionId] =
        s.copyWith(messages: List.unmodifiable(messages), updatedAt: DateTime.now());
    notifyListeners();
  }

  // -------- Context limiting --------

  void limitContextByMessageCount({
    required String sessionId,
    required int maxMessages,
    bool alwaysKeepFirstSystem = true,
  }) {
    final s = _sessions[sessionId];
    if (s == null) return;
    if (maxMessages <= 0 || s.messages.length <= maxMessages) return;

    final List<UnifiedMessage> trimmed;
    if (alwaysKeepFirstSystem && s.messages.isNotEmpty && s.messages.first.role == MessageRole.system) {
      final head = s.messages.first;
      final tail = s.messages.sublist(1);
      final keptTail = tail.sublist(tail.length - (maxMessages - 1)).toList();
      trimmed = [head, ...keptTail];
    } else {
      trimmed = s.messages.sublist(s.messages.length - maxMessages).toList();
    }

    _sessions[sessionId] = s.copyWith(messages: trimmed, updatedAt: DateTime.now());
    notifyListeners();
  }

  void limitContextByCharBudget({
    required String sessionId,
    required int maxChars,
  }) {
    final s = _sessions[sessionId];
    if (s == null) return;
    var budget = 0;
    final kept = <UnifiedMessage>[];

    // Walk backward keeping newest until budget exceeded
    for (var i = s.messages.length - 1; i >= 0; i--) {
      final m = s.messages[i];
      final size = _messageApproxSize(m);
      if (kept.isEmpty || budget + size <= maxChars) {
        kept.insert(0, m);
        budget += size;
      } else {
        break;
      }
    }

    // Always keep first system if present
    if (s.messages.isNotEmpty && s.messages.first.role == MessageRole.system) {
      if (!kept.contains(s.messages.first)) {
        kept.insert(0, s.messages.first);
      }
    }

    _sessions[sessionId] = s.copyWith(messages: kept, updatedAt: DateTime.now());
    notifyListeners();
  }

  int _messageApproxSize(UnifiedMessage m) {
    var sum = (m.text ?? '').length;
    for (final a in m.attachments) {
      a.map(
        image: (img) => sum += (img.description?.length ?? 8) + 64,
        audio: (aud) => sum += 64 + aud.bytes.length ~/ 8,
        file: (f) => sum += (f.size ?? f.bytes.length) ~/ 8,
        chunk: (c) => sum += c.text.length,
      );
    }
    return sum;
  }

  // -------- Provider payload builders --------

  List<openai.ChatCompletionMessage> openAiMessagesFor(String sessionId) {
    final s = _sessions[sessionId];
    if (s == null) return const [];
    return AiMessageConverters.buildOpenAiMessages(s.messages);
    }

  List<gemini.Content> geminiHistoryFor(String sessionId) {
    final s = _sessions[sessionId];
    if (s == null) return const [];
    return AiMessageConverters.buildGeminiHistory(s.messages);
  }

  // -------- Serialization (sessions only) --------

  Map<String, dynamic> toJson() => {
        'currentSessionId': _currentSessionId,
        'sessions': _sessions.map((k, v) => MapEntry(k, v.toJson())),
      };

  static SessionManager fromJson(Map<String, dynamic> json) {
    final mgr = SessionManager();
    final sessionsJson = json['sessions'] as Map<String, dynamic>? ?? {};
    sessionsJson.forEach((key, val) {
      mgr._sessions[key] = Session.fromJson(val as Map<String, dynamic>);
    });
    mgr._currentSessionId = json['currentSessionId'] as String?;
    return mgr;
  }
}