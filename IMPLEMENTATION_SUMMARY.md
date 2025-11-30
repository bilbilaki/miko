# AI Model Fetching Implementation Summary

## Overview
Implemented functionality to fetch available models from AI providers (OpenAI and Google Gemini) with retry logic and UI selection interface.

## Files Created

### 1. `lib/services/ai_models_service.dart`
A new service for fetching available models from AI providers with the following features:

- **Main Method**: `fetchAvailableModels()`
  - Takes base URL, API key, provider type, and max retries
  - Implements exponential backoff retry logic (1s, 2s, 4s, 8s, 16s)
  - 30-second timeout for each request
  - Handles different API formats for each provider

- **OpenAI Support**: `_fetchOpenAIModels()`
  - Calls `/models` endpoint
  - Uses Bearer token authentication
  - Parses `data[].id` from response
  - Handles 401 (invalid key) and 403 (access denied) errors

- **Google Gemini Support**: `_fetchGeminiModels()`
  - Calls `/models` endpoint with API key as query parameter
  - Parses `models[].name` from response
  - Strips "models/" prefix from model names
  - Handles authentication errors gracefully

## Files Modified

### `lib/screens/settings_page/subtitle_generation_settings.dart`

#### Added State Variables:
```dart
List<String> _availableModels = [];          // List of fetched models
bool _isFetchingModels = false;              // Loading state
String? _modelFetchError;                    // Error message display
```

#### New Method: `_fetchModels()`
- Validates base URL and API key before fetching
- Sets loading state and shows loading spinner
- Calls `AiModelsService.fetchAvailableModels()`
- Catches and displays errors to user
- Updates state with available models

#### Updated UI Section: "Model ID"
Replaced simple text field with enhanced interface:

**Components:**
1. **Model ID Input Field** (Expanded)
   - Allows manual entry of model IDs
   - Form validation required

2. **Fetch Models Button**
   - Shows loading spinner while fetching
   - Disabled state during fetch operation
   - Icon changes based on state

3. **Error Display**
   - Shows error message if fetch fails
   - Red text styling for visibility

4. **Models Selection List**
   - Displays all available models (max height 200dp)
   - Scrollable list view
   - Clickable items to auto-fill model ID
   - Selected model highlighted in cyan with checkmark
   - Sorted alphabetically

## User Experience Flow

1. User enters Base URL and API Key
2. User clicks "Fetch Models" button
3. System validates inputs and shows loading spinner
4. Service fetches models with retry logic:
   - If network fails, retries up to 5 times with exponential backoff
   - Shows error message if all retries fail
5. On success, displays list of available models
6. User can click any model to auto-fill the Model ID field
7. User can also manually enter a custom model ID
8. Form validates Model ID is not empty before saving

## Error Handling

- **Input Validation**: Base URL and API Key required before fetch
- **Network Errors**: Automatic retry with exponential backoff
- **Authentication Errors**: Clear error messages (invalid key, access denied)
- **Timeout**: 30-second timeout per request
- **UI State**: Loading spinner, error display, disabled buttons during fetch

## Provider Support

### OpenAI
- Endpoint: `{baseUrl}/models`
- Auth: Bearer token
- Model extraction: `data[].id`

### Google Gemini (GenAI)
- Endpoint: `{baseUrl}/models?key={apiKey}`
- Auth: Query parameter
- Model extraction: `models[].name` (with "models/" prefix removed)

## Future Enhancement Possibilities

1. Add support for more providers (DeepSeek, X.AI)
2. Cache fetched models locally with timestamp
3. Add model filtering/search functionality
4. Display model metadata (context window, pricing, etc.)
5. Auto-refresh models on provider change
