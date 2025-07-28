// lib/providers/ai_chat_provider.dart
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/services/ai_chat_service.dart';
import 'package:miko/utils/utils.dart'; // Ensure these service files exist

// Enum for AI chat modes, updated for Gemini
enum GeminiChatMode {
  textChat,
  multiModal,
//  toolCalling, // Retained for mode-switching UI, though implementation is simplified
 // structuredOutput,
}

// 1. Define the State for AI Chat, updated for Gemini
class AIChatState {
  final bool isLoading;
  final String response;
  final Uint8List? imageBytes; // Use Uint8List for image data
  final GeminiChatMode currentMode;
  final String promptInput;

  AIChatState({
    this.isLoading = false,
    this.response = '',
    this.imageBytes,
    this.currentMode = GeminiChatMode.textChat,
    this.promptInput = '',
  });

  AIChatState copyWith({
    bool? isLoading,
    String? response,
    Uint8List? imageBytes,
    bool? clearImage, // Flag to explicitly clear image
    GeminiChatMode? currentMode,
    String? promptInput,
  }) {
    return AIChatState(
      isLoading: isLoading ?? this.isLoading,
      response: response ?? this.response,
      imageBytes: clearImage == true ? null : imageBytes ?? this.imageBytes,
      currentMode: currentMode ?? this.currentMode,
      promptInput: promptInput ?? this.promptInput,
    );
  }
}

// Providers for external services (can be kept as is)
final fileUtilsProvider = Provider.autoDispose((ref) => FileUtils());

// 2. Create the StateNotifier to manage AI Chat logic and state
final aiChatProvider = StateNotifierProvider.autoDispose<AIChatNotifier, AIChatState>((ref) {
  final fileUtils = ref.watch(fileUtilsProvider);
  return AIChatNotifier(fileUtils, ref);
});

class AIChatNotifier extends StateNotifier<AIChatState> {
  final FileUtils _fileUtils;
  final Ref _ref;

  late GeminiServiceBase _currentService;

  AIChatNotifier(this._fileUtils, this._ref) : super(AIChatState()) {
    _setCurrentGeminiService(state.currentMode); // Initialize with default service
  }

  void _setCurrentGeminiService(GeminiChatMode mode) {
    state = state.copyWith(
      currentMode: mode,
      imageBytes: null, // Use clearImage flag
      clearImage: true,
      isLoading: false,
      response: '',
    );
    // Instantiate the correct service based on the mode
    switch (mode) {
      case GeminiChatMode.textChat:
        _currentService = GeminiTextChatService();
        break;
      case GeminiChatMode.multiModal:
        _currentService = GeminiMultiModalService();
        break;
      // case GeminiChatMode.toolCalling:
      //   _currentService = GeminiToolCallingService();
      //   break;
      // case GeminiChatMode.structuredOutput:
      //   _currentService = GeminiStructuredOutputService();
      //   break;
    }
  }

  void setChatMode(GeminiChatMode mode) {
    _setCurrentGeminiService(mode);
  }

  void updatePromptInput(String text) {
    state = state.copyWith(promptInput: text);
  }

  void clearMedia() {
    state = state.copyWith(clearImage: true);
  }

  Future<void> pickImage() async {
    state = state.copyWith(isLoading: true, response: 'Picking image...');
    // Assumes a utility function that returns Uint8List directly
    final imageBytes = await FileUtils.pickImageAndConvertToBase64();

    state = state.copyWith(
      imageBytes: imageBytes,
      isLoading: false,
      response: imageBytes != null ? 'Image selected.' : 'No image selected.',
    );
  }

  // Audio picking is removed as it's not supported by Gemini service

  Future<void> sendMessage({bool stream = false}) async {
    state = state.copyWith(isLoading: true, response: '');
    final prompt = state.promptInput;

    if (prompt.isEmpty && state.imageBytes == null) {
      state = state.copyWith(
        response: 'Please enter a prompt or select an image.',
        isLoading: false,
      );
      return;
    }

    try {
      if (stream) {
        state = state.copyWith(response: 'Streaming response...\n');
        _currentService.getStreamResponse(
          prompt,
          imageBytes: state.imageBytes,
        ).listen(
          (chunk) {
            state = state.copyWith(response: state.response + chunk);
          },
          onDone: () {
            state = state.copyWith(isLoading: false);
          },
          onError: (e) {
            state = state.copyWith(response: 'Stream Error: $e', isLoading: false);
          },
        );
      } else {
        state = state.copyWith(response: 'Fetching response...');
        final String textResponse = await _currentService.getResponse(
          prompt,
          imageBytes: state.imageBytes,
        );
        state = state.copyWith(response: textResponse, isLoading: false);
        // Audio generation logic is removed
      }
    } catch (e) {
      state = state.copyWith(response: 'General Request Error: $e', isLoading: false);
    }
  }
}