import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:miko/data/models/session_models.dart'; // For SessionEvent
import 'package:google_generative_ai/google_generative_ai.dart'; // For Content

part 'session_manager.freezed.dart';

// Cubit State Definition
@freezed
class SessionStateData with _$SessionStateData {
  const factory SessionStateData({
    required SessionState session,
  }) = _SessionStateData;
}

class SessionManager extends Cubit<SessionStateData> {
  SessionManager() : super(SessionStateData(session: createInitialSession()));

  static SessionState createInitialSession() {
    return SessionState(
      sessionId: Uuid().v4(),
      associatedProjectId: 'default_project', // Temporary
      displayHistory: [],
      apiHistory: [],
      attachedFilePaths: {},
      customKnowledge: '',
    );
  }

  /// Starts a brand new session for a new project
  void startNewSession({required String projectId}) {
    final newSession = SessionState(
      sessionId: Uuid().v4(),
      associatedProjectId: projectId,
      displayHistory: [],
      apiHistory: [],
      attachedFilePaths: {},
      customKnowledge: '',
    );
    emit(SessionStateData(session: newSession));
  }

  /// Loads an existing session (e.g., from a file)
  void loadSession(SessionState session) {
    emit(SessionStateData(session: session));
  }

  /// Adds an event to the current session and updates the API history if needed
  void addEvent(SessionEvent event) {
    final currentSession = state.session;
    
    // Update display history
    final newDisplayHistory = List<SessionEvent>.from(currentSession.displayHistory)..add(event);

    // Update API history if it's an AI-related event
    List<Content> newApiHistory = List<Content>.from(currentSession.apiHistory);
    event.whenOrNull(
      userMessage: (text) => newApiHistory.add(Content.text(text)),
      aiResponse: (markdownText, isError) {
        if (!isError) {
          newApiHistory.add(Content.model([TextPart(markdownText)]));
        }
      },
      // File attachments don't usually go into API history directly unless used as input
      // Tool calls/results might need specific Content format, depending on Gemini's API for that.
    );

    // Update session state
    emit(SessionStateData(
      session: currentSession.copyWith(
        displayHistory: newDisplayHistory,
        apiHistory: newApiHistory,
      ),
    ));
  }

  /// Updates specific parts of the session
  void updateSessionDetails({
    String? customKnowledge,
    Map<String, String>? attachedFilePaths,
  }) {
    final currentSession = state.session;
    emit(SessionStateData(
      session: currentSession.copyWith(
        customKnowledge: customKnowledge ?? currentSession.customKnowledge,
        attachedFilePaths: attachedFilePaths ?? currentSession.attachedFilePaths,
      ),
    ));
  }

  void clearSession() {
    // Decide if clearing should go back to a default state or null
    emit(SessionStateData(session: createInitialSession()));
  }
}