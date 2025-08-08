import 'dart:typed_data';
import 'package:miko/data/services/gemini_api_service.dart';
import 'package:miko/core/session/session_manager.dart'; // SessionManager is now a Cubit
import 'package:miko/data/models/session_models.dart'; // For SessionEvent
import 'package:google_generative_ai/google_generative_ai.dart'; // For Content

class AITaskOrchestrator {
  final GeminiModelService _geminiService;
  final SessionManager _sessionManager; // It's a Cubit now

  AITaskOrchestrator(this._geminiService, this._sessionManager);

  /// orchestrateTask will be called by UI Cubits (e.g., GeminiPanelCubit)
  Future<void> processUserRequest({
    required String userPrompt,
    List<Uint8List>? imageBytes,
    // Add other context like code snippets, selected files etc. later
  }) async {
    // Ensure we have an active session
    // if (_sessionManager.state.session.associatedProjectId == 'default_project') {
    //   This indicates no project is loaded yet. Prompt the user to load one.
    //   _sessionManager.addEvent(const SessionEvent.aiResponse(
    //       markdownText: "Please load a project first.", isError: true));
    //   return;
    // }

    // 1. Add user's message to the display history
    _sessionManager.addEvent(UserMessageEvent(text: userPrompt));

    // 2. Decide which AI mode to use based on input and session context
    // This is where the "intent parsing" happens.
    // For now, we'll default to single-turn, but will add chat/tool logic.

    try {
      String aiResponseText = '';

      // --- Basic Logic for Mode Switching ---
      if (_sessionManager.state.session.apiHistory.isNotEmpty && // If there's chat history
          !userPrompt.startsWith('/') && // And it's not a command
          (imageBytes == null || imageBytes.isEmpty)) // And no image
      {
        // --- Chatting Mode ---
        // Need to manage the ChatSession instance. A simple way is to store it
        // within SessionState or manage it here, making sure it's the right one.
        // For simplicity, let's assume we re-start the chat with history for now.
        // A better approach is to manage a 'currentChatSession' variable here.
        
        // Reconstruct API history for the chat session
        final chatHistory = _sessionManager.state.session.apiHistory.map((apiContent) {
          // We need to distinguish between user and model content.
          // This requires a richer SessionEvent or a way to map apiHistory back.
          // For now, a simplified assumption: even-indexed are user, odd are model.
          // This is problematic, better to store role in SessionEvent or use Content.fromMap.
          return apiContent; // This needs more careful handling if history is complex.
        }).toList();
        
        final chatSession = _geminiService.startChatSession(history: chatHistory);
        final chatResult = await chatSession.sendMessage(
          Content.text(userPrompt),
        );
        aiResponseText = chatResult.text ?? '';
        // NOTE: You would need to update sessionManager.state.session.apiHistory
        // with the actual user message and the model's response here to maintain chat context.
        // This is complex because you're adding to a list that might be immutable.
        // The SessionManager's `addEvent` needs to handle this correctly for apiHistory.
        _sessionManager.addEvent(SessionEvent.toolResult(toolName: 'user_message', result: userPrompt)); // Add user's turn to API history
        _sessionManager.addEvent(SessionEvent.aiResponse(markdownText: aiResponseText)); // Add AI's response

      } else if (imageBytes != null && imageBytes.isNotEmpty) {
        // --- Multimodal Mode ---
        aiResponseText = await _geminiService.generateSingleTurnResponse(userPrompt, imageBytes: imageBytes);
        // This is a one-shot, so doesn't directly affect apiHistory unless you decide to log it.
      } else {
        // --- Single Turn Mode (default) ---
        // You might want to include customKnowledge and other context here.
        final effectivePrompt = "${_sessionManager.state.session.customKnowledge}\n\nUser: $userPrompt";
        aiResponseText = await _geminiService.generateSingleTurnResponse(effectivePrompt);
        // This is a one-shot, doesn't affect apiHistory directly.
      }

      // 3. Add AI's response to the display history
      _sessionManager.addEvent(AiResponseMessageEvent(markdownText: aiResponseText));

    } catch (e) {
      // 4. Handle errors
      print('Orchestrator Error: $e');
      _sessionManager.addEvent(AiResponseMessageEvent(markdownText: 'Error: ${e.toString()}', isError: true));
    }
  }

  List<String> getAvailableModels() {
    return _geminiService.availableModels;
  }

  void setModel(String modelName) {
    _geminiService.setModel(modelName);
  }

  void setTemperature(double temperature) {
    _geminiService.setTemperature(temperature);
  }

  void setThinkingMode(bool enabled) {
    _geminiService.setThinkingMode(enabled);
  }

  Future<void> attachFile(String filePath) async {
    final fileName = filePath.split('/').last;
    _sessionManager.addEvent(
        FileAttachmentEvent(fileName: fileName, filePath: filePath));
  }

  // You'll need methods to:
  // - Handle file uploads (get bytes, update session.attachedFiles)
  // - Handle tool calls (parse Gemini's response, call local functions, add ToolResultEvent)
}