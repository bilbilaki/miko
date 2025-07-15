// lib/providers/ai_chat_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miko/services/ai_chat_service.dart'; // Ensure these service files exist
import 'package:miko/services/audio_player_service.dart';
import 'package:miko/services/files_service.dart';

// Enum for AI chat modes (already existed)
enum OpenAIChatMode {
  textChat,
  multiModal,
  toolCalling,
  structuredOutput,
}

// 1. Define the State for AI Chat
class AIChatState {
  final bool isLoading;
  final String response;
  final String? imageBase64;
  final String? audioBase64;
  final String? audioFormat; // e.g., 'wav', 'mp3'
  final OpenAIChatMode currentMode; // Track current mode
  final String promptInput; // For TextField content

  AIChatState({
    this.isLoading = false,
    this.response = '',
    this.imageBase64,
    this.audioBase64,
    this.audioFormat,
    this.currentMode = OpenAIChatMode.textChat,
    this.promptInput = '',
  });

  AIChatState copyWith({
    bool? isLoading,
    String? response,
    String? imageBase64,
    String? audioBase64,
    String? audioFormat,
    OpenAIChatMode? currentMode,
    String? promptInput,
  }) {
    return AIChatState(
      isLoading: isLoading ?? this.isLoading,
      response: response ?? this.response,
      // Use null for clearing, otherwise default to current value
      imageBase64: imageBase64 ?? this.imageBase64,
      audioBase64: audioBase64 ?? this.audioBase64,
      audioFormat: audioFormat ?? this.audioFormat,
      currentMode: currentMode ?? this.currentMode,
      promptInput: promptInput ?? this.promptInput,
    );
  }
}

// Providers for external services (now injected via Riverpod)
final audioPlayerServiceProvider = Provider.autoDispose((ref) => AudioPlayerService());
final fileUtilsProvider = Provider.autoDispose((ref) => FileUtils());

// 2. Create the StateNotifier to manage AI Chat logic and state
final aiChatProvider = StateNotifierProvider.autoDispose<AIChatNotifier, AIChatState>((ref) {
  // Read services for dependency injection
  final audioPlayerService = ref.watch(audioPlayerServiceProvider);
  final fileUtils = ref.watch(fileUtilsProvider);
  return AIChatNotifier(audioPlayerService, fileUtils, ref);
});

class AIChatNotifier extends StateNotifier<AIChatState> {
  final AudioPlayerService _audioPlayerService;
  final FileUtils _fileUtils;
  final Ref _ref; // Useful if you need to read other providers later

  late OpenAIServiceBase _currentService;

  AIChatNotifier(this._audioPlayerService, this._fileUtils, this._ref) : super(AIChatState()) {
    _setCurrentOpenAIService(state.currentMode); // Initialize with default service
  }

  // Helper to set the active AI service and clean up state
  void _setCurrentOpenAIService(OpenAIChatMode mode) {
    state = state.copyWith(
      currentMode: mode,
      // Clear media and reset response when switching modes
      imageBase64: null,
      audioBase64: null,
      audioFormat: null,
      isLoading: false,
      response: '',
    );
    // Instantiate the correct service based on the mode
    switch (mode) {
      
      case OpenAIChatMode.textChat:
        _currentService = OpenAITextChatService();
        break;
      case OpenAIChatMode.multiModal:
        _currentService = OpenAIMultiModalService();
        break;
      case OpenAIChatMode.toolCalling:
        _currentService = OpenAIToolCallingService();
        break;
      case OpenAIChatMode.structuredOutput:
        _currentService = OpenAIStructuredOutputService();
        break;
    }
  }

  // Public method for UI to change chat mode
  void setChatMode(OpenAIChatMode mode) {
    _setCurrentOpenAIService(mode);
  }

  // Update prompt input from TextField
  void updatePromptInput(String text) {
    state = state.copyWith(promptInput: text);
  }

  // Clear selected media files
  void clearMedia() {
    state = state.copyWith(
      imageBase64: null,
      audioBase64: null,
      audioFormat: null,
    );
  }

  // Pick an image and convert to base64
  Future<void> pickImage() async {
    state = state.copyWith(isLoading: true, response: 'Picking image...');
    final base64Image = await FileUtils.pickImageAndConvertToBase64();
    state = state.copyWith(
      // Pass null explicitly if base64Image is null, to clear previous selection
      imageBase64: base64Image,
      isLoading: false,
      response: base64Image != null ? 'Image selected.' : 'No image selected.',
    );
  }

  // Pick an audio file and convert to base64
  Future<void> pickAudio() async {
    state = state.copyWith(isLoading: true, response: 'Picking audio...');
    final audioData = await FileUtils.pickAudioAndConvertToBase64();
    if (audioData != null) {
      state = state.copyWith(
        audioBase64: audioData['data'],
        audioFormat: audioData['format'],
        isLoading: false,
        response: 'Audio selected: .${audioData['format']}',
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        response: 'No audio selected.',
      );
    }
  }

  // Send message to the AI model
  Future<void> sendMessage({bool stream = false}) async {
    state = state.copyWith(isLoading: true); // Set loading state
    final prompt = state.promptInput;

    if (prompt.isEmpty && state.imageBase64 == null && state.audioBase64 == null) {
      state = state.copyWith(
        response: 'Please enter a prompt or select media.',
        isLoading: false,
      );
      return;
    }

    try {
      if (stream) {
        state = state.copyWith(response: 'Streaming response...\n'); // Initial text for stream
        // Handle streaming text response
        _currentService.getStreamResponse(
          prompt,
          base64Image: state.imageBase64,
          base64Audio: state.audioBase64,
          audioFormat: state.audioFormat,
        ).listen(
              (chunk) {
            state = state.copyWith(response: state.response + chunk); // Append streamed chunks
          },
          onDone: () {
            state = state.copyWith(isLoading: false);
          },
          onError: (e) {
            state = state.copyWith(response: 'Stream Error: $e', isLoading: false);
          },
        );
      } else {
        state = state.copyWith(response: 'Fetching response...'); // Initial text for non-stream
        // Handle non-streaming text response
        final String textResponse = await _currentService.getResponse(
          prompt,
          base64Image: state.imageBase64,
          base64Audio: state.audioBase64,
          audioFormat: state.audioFormat,
        );
        state = state.copyWith(response: textResponse, isLoading: false);

        // Handle audio output for MultiModal mode
        if (_currentService is OpenAIMultiModalService) {
          final OpenAIMultiModalService multiModalService = _currentService as OpenAIMultiModalService;
          final String? audioBase64 = await multiModalService.generateAudioResponse(prompt);
          if (audioBase64 != null) {
            state = state.copyWith(response: state.response + '\n\n-- Audio Response Generated --');
            _audioPlayerService.playBase64Audio(audioBase64, 'wav'); // Assuming WAV, adjust if different
            state = state.copyWith(response: state.response + '\n(Playing audio...)');
          }
        }
      }
    } catch (e) {
      state = state.copyWith(response: 'General Request Error: $e', isLoading: false);
    }
  }

  @override
  void dispose() {
    // The AudioPlayerService will be disposed by its autoDispose provider
    // when the aiChatProvider is disposed.
    // OpenAIServiceBase instances typically don't hold resources requiring explicit dispose here.
    super.dispose();
  }
}