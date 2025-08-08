import 'dart:convert'; // For jsonEncode/jsonDecode
import 'package:miko/data/models/session_models.dart'; // Make sure SessionState is accessible
import 'package:miko/services/local_file_service.dart';
import 'package:uuid/uuid.dart'; // For Uuid

class ProjectWorkspaceManager {
  final LocalFileService _localFileService;
  // Using a Map to hold sessions that are currently "loaded" and managed
  final Map<String, SessionState> _loadedSessions = {};

  ProjectWorkspaceManager(this._localFileService);

  /// Returns the session state for a given project ID, loading it if necessary.
  Future<SessionState?> getSessionForProject(String projectId) async {
    if (_loadedSessions.containsKey(projectId)) {
      return _loadedSessions[projectId];
    }

    final session = await loadProjectSession(projectId);
    if (session != null) {
      _loadedSessions[projectId] = session;
      return session;
    }
    return null; // Project session not found
  }

  /// Loads a project's session from disk.
  Future<SessionState?> loadProjectSession(String projectId) async {
    final sessionFilePath = 'sessions/$projectId/session.json'; // Relative path
    try {
      if (await _localFileService.fileExists(sessionFilePath)) {
        final jsonString = await _localFileService.readFromFile(sessionFilePath);
        final jsonMap = jsonDecode(jsonString);
        return SessionState.fromJson(jsonMap); // Use Freezed's fromJson
      }
    } catch (e) {
      print('Error loading session for project $projectId: $e');
      // Handle error, maybe return null or a default state
    }
    return null;
  }

  /// Saves the current SessionState to disk.
  Future<void> saveProjectSession(SessionState session) async {
    final sessionFilePath = 'sessions/${session.associatedProjectId}/session.json';
    try {
      final jsonContent = jsonEncode(session.toJson()); // Use Freezed's toJson
      await _localFileService.writeToFile(sessionFilePath, jsonContent);
    } catch (e) {
      print('Error saving session for project ${session.associatedProjectId}: $e');
    }
  }

  /// Creates a new, empty session for a project and saves it.
  Future<SessionState> createNewSession(String projectId) async {
    final newSession = SessionState(
      sessionId: Uuid().v4(),
      associatedProjectId: projectId,
      displayHistory: [],
      apiHistory: [],
      attachedFilePaths: {},
      customKnowledge: '',
    );
    _loadedSessions[projectId] = newSession; // Keep it loaded
    await saveProjectSession(newSession); // Save it to disk immediately
    return newSession;
  }

  /// Unloads a session from memory. It can still be loaded later.
  void unloadSession(String projectId) {
    _loadedSessions.remove(projectId);
  }

  /// Cleans up all loaded sessions (e.g., on app exit)
  Future<void> saveAllLoadedSessions() async {
    for (final session in _loadedSessions.values) {
      await saveProjectSession(session);
    }
  }
}