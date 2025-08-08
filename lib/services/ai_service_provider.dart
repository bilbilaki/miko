import 'package:miko/core/ai/ai_task_orchestrator.dart';
import 'package:miko/core/session/session_manager.dart';
import 'package:miko/core/workspace/project_workspace_manager.dart';
import 'package:miko/data/services/gemini_api_service.dart';
import 'package:miko/services/local_file_service.dart';

/// A service locator for AI-related services.
/// This class provides a central point of access for AI services,
/// allowing for easy management and access throughout the application.
class AiServiceProvider {
  // The single instance of the service provider, initialized lazily.
  static final AiServiceProvider _instance = AiServiceProvider._internal();

  /// Provides access to the singleton instance of the service provider.
  factory AiServiceProvider() {
    return _instance;
  }

  AiServiceProvider._internal();

  /// Lazily initializes and provides the [LocalFileService].
  /// The service is only created when it is first accessed.
  late final LocalFileService localFileService = LocalFileServiceImpl();

  /// Lazily initializes and provides the [ProjectWorkspaceManager].
  /// The service is only created when it is first accessed.
  late final ProjectWorkspaceManager projectWorkspaceManager =
      ProjectWorkspaceManager(localFileService);

  /// Lazily initializes and provides the [GeminiModelService].
  /// The service is only created when it is first accessed.
  late final GeminiModelService geminiModelService = GeminiModelService();

  /// Lazily initializes and provides the [SessionManager].
  /// The service is only created when it is first accessed.
  late final SessionManager sessionManager = SessionManager();

  /// Lazily initializes and provides the [AITaskOrchestrator].
  /// The service is only created when it is first accessed.
  late final AITaskOrchestrator aiTaskOrchestrator =
      AITaskOrchestrator(geminiModelService, sessionManager);
}