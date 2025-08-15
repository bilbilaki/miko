import 'dart:convert';

/// Represents basic pricing information for a model.
class PriceInfo {
  final double input;
  final double output;
  final double inputCache;

  const PriceInfo({
    required this.input,
    required this.output,
    required this.inputCache,
  });
}

// Exact model pricing. Update these as needed.
final Map<String, PriceInfo> _exact = {
  // Previously: 0.00006 (now applied to all three for backward parity)
  'gpt-4-32k': PriceInfo(input: 0.00006, output: 0.00006, inputCache: 0.00006),
  // Previously: 0.00003
  'gpt-4': PriceInfo(input: 0.00003, output: 0.00003, inputCache: 0.00003),
};

/// Pattern-based fallbacks (by convention):
/// - gpt-4-* -> 0.00001
/// - gpt-3.5* -> 0.000001
PriceInfo? _patternPricing(String model) {
  if (model.startsWith('gpt-4-')) {
    return PriceInfo(input: 0.00001, output: 0.00001, inputCache: 0.00001);
  }
  if (model.startsWith('gpt-3.5')) {
    return PriceInfo(input: 0.000001, output: 0.000001, inputCache: 0.000001);
  }
  return null;
}

/// Returns the complete pricing info for a model, or null if unknown.
PriceInfo? getPrices(String model) {
  final exact = _exact[model];
  if (exact != null) return exact;
  return _patternPricing(model);
}

/// Convenience: input (prompt) price-per-1K-tokens for [model].
double? getInputPrice(String model) => getPrices(model)?.input;

/// Convenience: output (completion) price-per-1K-tokens for [model].
double? getOutputPrice(String model) => getPrices(model)?.output;

/// Convenience: cached input price-per-1K-tokens for [model].
double? getInputCachePrice(String model) => getPrices(model)?.inputCache;

/// Data structure to hold model pricing information parsed from JSON.
class ModelPricingInfo {
  final String id;
  final String object;
  final String? objectType; // e.g., 'model'
  final String ownedBy;
  final double? inputPrice;
  final double? cachedInputPrice;
  final double? outputPrice;
  final double? inputCostPerSecond; // For audio models
  final double? outputCostPerSecond; // For audio models
  final double? inputCostPerQuery; // For rerank models (single double value)
  final Map<String, dynamic>? searchContextCostPerQuery; // For models with detailed search costs (map)
  final double? outputCostPerImage; // For image generation models
  final double? imageInput; // For vision models
  final double? imageOutput; // For vision models

  ModelPricingInfo({
    required this.id,
    required this.object,
    this.objectType,
    required this.ownedBy,
    this.inputPrice,
    this.cachedInputPrice,
    this.outputPrice,
    this.inputCostPerSecond,
    this.outputCostPerSecond,
    this.inputCostPerQuery,
    this.searchContextCostPerQuery,
    this.outputCostPerImage,
    this.imageInput,
    this.imageOutput,
  });

  factory ModelPricingInfo.fromJson(Map<String, dynamic> json) {
    final pricing = json['pricing'] as Map<String, dynamic>?;
    final searchContextPricing = pricing?['search_context_cost_per_query'];
    
    Map<String, dynamic>? parsedSearchContextPricing;
    double? parsedInputCostPerQuery;

    // Handle 'search_context_cost_per_query' which can be either a map or a number
    if (searchContextPricing is Map<String, dynamic>) {
      parsedSearchContextPricing = searchContextPricing;
    } else if (searchContextPricing is num) {
      parsedInputCostPerQuery = searchContextPricing.toDouble();
    }


    return ModelPricingInfo(
      id: json['id'] as String,
      object: json['object'] as String,
      objectType: json['objectType'] as String?,
      ownedBy: json['owned_by'] as String,
      inputPrice: (pricing?['input'] as num?)?.toDouble(),
      cachedInputPrice: (pricing?['cached_input'] as num?)?.toDouble() ??
          (pricing?['cached_input_above_32K'] as num?)?.toDouble() ??
          (pricing?['cached_input_above_128K'] as num?)?.toDouble() ??
          (pricing?['cached_input_above_256K'] as num?)?.toDouble(),
      outputPrice: (pricing?['output'] as num?)?.toDouble() ??
          (pricing?['output_above_32K'] as num?)?.toDouble() ??
          (pricing?['output_above_128K'] as num?)?.toDouble() ??
          (pricing?['output_above_256K'] as num?)?.toDouble(),
      inputCostPerSecond: (pricing?['input_cost_per_second'] as num?)?.toDouble() ??
          (pricing?['audio_input'] as num?)?.toDouble(),
      outputCostPerSecond: (pricing?['output_cost_per_second'] as num?)?.toDouble() ??
          (pricing?['audio_output'] as num?)?.toDouble(),
      inputCostPerQuery: (pricing?['input_cost_per_query'] as num?)?.toDouble() ?? parsedInputCostPerQuery,
      searchContextCostPerQuery: parsedSearchContextPricing,
      outputCostPerImage: (pricing?['output_cost_per_image'] as num?)?.toDouble(),
      imageInput: (pricing?['image_input'] as num?)?.toDouble(),
      imageOutput: (pricing?['image_output'] as num?)?.toDouble(),
    );
  }
}

List<ModelPricingInfo> parseModelPricing(String jsonData) {
  final data = Map<String, dynamic>.from(
    json.decode(jsonData) as Map<String, dynamic>,
  );
  final List<dynamic> models = data['data'] as List<dynamic>;
  return models.map((json) => ModelPricingInfo.fromJson(json as Map<String, dynamic>)).toList();
}

/// The raw JSON data provided.
const String _modelPricingJsonData = r'''
{
 "object": "list",
 "data": [
 {
 "id": "gpt-oss-120b",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.3,
 "cached_input": 0.15,
 "output": 2.5
 },
 "max_tokens": 128000,
 "max_input_tokens": 128000,
 "max_output_tokens": 128000,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_vision": true,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "openai.gpt-oss-20b-1:0",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.07,
 "cached_input": 0.0035,
 "output": 0.3
 },
 "max_tokens": 128000,
 "max_input_tokens": 128000,
 "max_output_tokens": 128000,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_vision": true,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "openai.gpt-oss-120b-1:0",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.15,
 "cached_input": 0.075,
 "output": 0.6
 },
 "max_tokens": 128000,
 "max_input_tokens": 128000,
 "max_output_tokens": 128000,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_vision": true,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "gpt-5",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 1.25,
 "cached_input": 0.125,
 "output": 10.0
 },
 "max_tokens": 128000,
 "max_input_tokens": 400000,
 "max_output_tokens": 128000,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_native_streaming": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/chat/completions",
 "/v1/batch",
 "/v1/responses"
 ]
 },
 {
 "id": "gpt-5-2025-08-07",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 1.25,
 "cached_input": 0.125,
 "output": 10.0
 },
 "max_tokens": 128000,
 "max_input_tokens": 400000,
 "max_output_tokens": 128000,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_native_streaming": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/chat/completions",
 "/v1/batch",
 "/v1/responses"
 ]
 },
 {
 "id": "gpt-5-mini",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.25,
 "cached_input": 0.025,
 "output": 2.0
 },
 "max_tokens": 128000,
 "max_input_tokens": 400000,
 "max_output_tokens": 128000,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_native_streaming": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/chat/completions",
 "/v1/batch",
 "/v1/responses"
 ]
 },
 {
 "id": "gpt-5-mini-2025-08-07",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.25,
 "cached_input": 0.025,
 "output": 2.0
 },
 "max_tokens": 128000,
 "max_input_tokens": 400000,
 "max_output_tokens": 128000,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_native_streaming": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/chat/completions",
 "/v1/batch",
 "/v1/responses"
 ]
 },
 {
 "id": "gpt-5-nano",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.05,
 "cached_input": 0.005,
 "output": 0.4
 },
 "max_tokens": 128000,
 "max_input_tokens": 400000,
 "max_output_tokens": 128000,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_native_streaming": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/chat/completions",
 "/v1/batch",
 "/v1/responses"
 ]
 },
 {
 "id": "gpt-5-nano-2025-08-07",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.05,
 "cached_input": 0.005,
 "output": 0.4
 },
 "max_tokens": 128000,
 "max_input_tokens": 400000,
 "max_output_tokens": 128000,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_native_streaming": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/chat/completions",
 "/v1/batch",
 "/v1/responses"
 ]
 },
 {
 "id": "gpt-5-chat",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 1.25,
 "cached_input": 0.125,
 "output": 10.0
 },
 "max_tokens": 128000,
 "max_input_tokens": 400000,
 "max_output_tokens": 128000,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_native_streaming": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/chat/completions",
 "/v1/batch",
 "/v1/responses"
 ]
 },
 {
 "id": "gpt-5-chat-latest",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 1.25,
 "cached_input": 0.125,
 "output": 10.0
 },
 "max_tokens": 128000,
 "max_input_tokens": 400000,
 "max_output_tokens": 128000,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_native_streaming": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/chat/completions",
 "/v1/batch",
 "/v1/responses"
 ]
 },
 {
 "id": "anthropic.claude-opus-4-1-20250805-v1:0",
 "object": "model",
 "owned_by": "anthropic",
 "min_tier": 1,
 "pricing": {
 "input": 15.0,
 "cached_input": 7.5,
 "output": 75.0
 }
 },
 {
 "id": "wan2.2-t2i-flash",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 1,
 "pricing": {}
 },
 {
 "id": "wan2.2-t2i-plus",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 1,
 "pricing": {}
 },
 {
 "id": "gemini-2.5-flash-lite",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.1,
 "cached_input": 0.05,
 "output": 0.4,
 "audio_input": 0.1,
 "audio_cached_input": 0.05,
 "audio_output": 0.4
 }
 },
 {
 "id": "grok-4-0709",
 "object": "model",
 "owned_by": "xai",
 "min_tier": 1,
 "pricing": {
 "input": 3.0,
 "cached_input": 0.75,
 "output": 15.0
 },
 "max_tokens": 256000,
 "max_input_tokens": 256000,
 "max_output_tokens": 256000,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_tool_choice": true,
 "supports_web_search": true
 },
 {
 "id": "grok-4",
 "object": "model",
 "owned_by": "xai",
 "min_tier": 1,
 "pricing": {
 "input": 3.0,
 "cached_input": 0.75,
 "output": 15.0
 },
 "max_tokens": 256000,
 "max_input_tokens": 256000,
 "max_output_tokens": 256000,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_tool_choice": true,
 "supports_web_search": true
 },
 {
 "id": "grok-4-latest",
 "object": "model",
 "owned_by": "xai",
 "min_tier": 1,
 "pricing": {
 "input": 3.0,
 "cached_input": 0.75,
 "output": 15.0
 },
 "max_tokens": 256000,
 "max_input_tokens": 256000,
 "max_output_tokens": 256000,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_tool_choice": true,
 "supports_web_search": true
 },
 {
 "id": "o3-pro",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 20.0,
 "cached_input": 10.0,
 "output": 80.0
 },
 "max_tokens": 100000,
 "max_input_tokens": 200000,
 "max_output_tokens": 100000,
 "mode": "responses",
 "supports_function_calling": true,
 "supports_parallel_function_calling": false,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/responses",
 "/v1/batch"
 ]
 },
 {
 "id": "o3-pro-2025-06-10",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 20.0,
 "cached_input": 10.0,
 "output": 80.0
 },
 "max_tokens": 100000,
 "max_input_tokens": 200000,
 "max_output_tokens": 100000,
 "mode": "responses",
 "supports_function_calling": true,
 "supports_parallel_function_calling": false,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/responses",
 "/v1/batch"
 ]
 },
 {
 "id": "o3-deep-research",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 10.0,
 "cached_input": 2.5,
 "output": 40.0
 },
 "max_tokens": 100000,
 "max_input_tokens": 200000,
 "max_output_tokens": 100000,
 "mode": "responses",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_native_streaming": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/chat/completions",
 "/v1/batch",
 "/v1/responses"
 ]
 },
 {
 "id": "o3-deep-research-2025-06-26",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 10.0,
 "cached_input": 2.5,
 "output": 40.0
 },
 "max_tokens": 100000,
 "max_input_tokens": 200000,
 "max_output_tokens": 100000,
 "mode": "responses",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_native_streaming": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/chat/completions",
 "/v1/batch",
 "/v1/responses"
 ]
 },
 {
 "id": "o4-mini-deep-research",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 2.0,
 "cached_input": 0.5,
 "output": 8.0
 },
 "max_tokens": 100000,
 "max_input_tokens": 200000,
 "max_output_tokens": 100000,
 "mode": "responses",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_native_streaming": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/chat/completions",
 "/v1/batch",
 "/v1/responses"
 ]
 },
 {
 "id": "o4-mini-deep-research-2025-06-26",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 2.0,
 "cached_input": 0.5,
 "output": 8.0
 },
 "max_tokens": 100000,
 "max_input_tokens": 200000,
 "max_output_tokens": 100000,
 "mode": "responses",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_native_streaming": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/chat/completions",
 "/v1/batch",
 "/v1/responses"
 ]
 },
 {
 "id": "computer-use-preview",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 3,
 "pricing": {
 "input": 3.0,
 "cached_input": 1.5,
 "output": 12.0
 },
 "max_tokens": 1024,
 "max_input_tokens": 8192,
 "max_output_tokens": 1024,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_prompt_caching": false,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/responses"
 ]
 },
 {
 "id": "computer-use-preview-2025-03-11",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 3,
 "pricing": {
 "input": 3.0,
 "cached_input": 1.5,
 "output": 12.0
 }
 },
 {
 "id": "imagen-4.0-ultra-generate-preview-06-06",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 0.0,
 "cached_input": 0.0,
 "output": 60.0,
 "output_cost_per_image": 0.06
 }
 },
 {
 "id": "imagen-4.0-generate-preview-06-06",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 0.0,
 "cached_input": 0.0,
 "output": 40.0,
 "output_cost_per_image": 0.04
 }
 },
 {
 "id": "imagen-4.0-fast-generate-preview-06-06",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 0.0,
 "cached_input": 0.0,
 "output": 20.0,
 "output_cost_per_image": 0.02
 }
 },
 {
 "id": "gemini-2.5-pro",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 1.25,
 "cached_input": 0.625,
 "output": 10.0,
 "input_above_200k": 2.5,
 "output_above_200k": 15.0,
 "audio_input": 7.0,
 "audio_cached_input": 1.5,
 "audio_output": 7.0
 }
 },
 {
 "id": "gemini-2.5-flash",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.3,
 "cached_input": 0.15,
 "output": 2.5,
 "audio_input": 1.0,
 "audio_cached_input": 0.25,
 "audio_output": 1.0
 }
 },
 {
 "id": "gemini-2.5-flash-lite-preview-06-17",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.1,
 "cached_input": 0.05,
 "output": 0.4,
 "audio_input": 0.1,
 "audio_cached_input": 0.05,
 "audio_output": 0.4
 }
 },
 {
 "id": "gemma-3n-e2b-it",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.001,
 "cached_input": 0.0001,
 "output": 0.005
 },
 "max_tokens": 8192,
 "max_input_tokens": 131072,
 "max_output_tokens": 8192,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_vision": true,
 "supports_audio_output": false,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "codex-mini-latest",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 1.5,
 "cached_input": 0.375,
 "output": 6.0,
 "search_context_cost_per_query": {
 "low": 0.03,
 "medium": 0.035,
 "high": 0.05
 }
 },
 "max_tokens": 100000,
 "max_input_tokens": 200000,
 "max_output_tokens": 100000,
 "mode": "responses",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/responses"
 ]
 },
 {
 "id": "gemini-2.5-pro-preview-06-05",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 1.5,
 "cached_input": 0.625,
 "output": 10.0,
 "input_above_200k": 2.5,
 "output_above_200k": 15.0,
 "audio_input": 7.0,
 "audio_cached_input": 1.5,
 "audio_output": 7.0
 }
 },
 {
 "id": "gemini-2.5-pro-preview-tts",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 1.0,
 "cached_input": 0.5,
 "output": 20.0
 }
 },
 {
 "id": "gemini-2.5-flash-preview-tts",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.5,
 "cached_input": 0.25,
 "output": 10.0
 }
 },
 {
 "id": "mistral-small-2503",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.1,
 "cached_input": 0.05,
 "output": 0.3,
 "input_cost_per_page": 0.001
 },
 "max_tokens": 128000,
 "max_input_tokens": 128000,
 "max_output_tokens": 128000,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_vision": true,
 "supports_tool_choice": true
 },
 {
 "id": "codestral-2501",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.3,
 "cached_input": 0.15,
 "output": 0.9
 },
 "max_tokens": 128000,
 "max_input_tokens": 128000,
 "max_output_tokens": 128000,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_tool_choice": true
 },
 {
 "id": "imagen-4.0-generate-preview-05-20",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 0.0,
 "cached_input": 0.0,
 "output": 40.0,
 "output_cost_per_image": 0.04
 }
 },
 {
 "id": "imagen-4.0-ultra-generate-exp-05-20",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 0.0,
 "cached_input": 0.0,
 "output": 60.0,
 "output_cost_per_image": 0.06
 }
 },
 {
 "id": "imagen-3.0-generate-002",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.0,
 "cached_input": 0.0,
 "output": 40.0,
 "output_cost_per_image": 0.04
 }
 },
 {
 "id": "imagen-3.0-generate-001",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.0,
 "cached_input": 0.0,
 "output": 40.0,
 "output_cost_per_image": 0.04
 }
 },
 {
 "id": "imagen-3.0-fast-generate-001",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.0,
 "cached_input": 0.0,
 "output": 20.0,
 "output_cost_per_image": 0.02
 }
 },
 {
 "id": "gemini-embedding-exp-03-07",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.025,
 "cached_input": 0.0125,
 "output": 0.1
 },
 "max_tokens": 8192,
 "max_input_tokens": 8192,
 "mode": "embedding"
 },
 {
 "id": "anthropic.claude-opus-4-20250514-v1:0",
 "object": "model",
 "owned_by": "anthropic",
 "min_tier": 1,
 "pricing": {
 "input": 15.0,
 "cached_input": 7.5,
 "output": 75.0
 }
 },
 {
 "id": "anthropic.claude-sonnet-4-20250514-v1:0",
 "object": "model",
 "owned_by": "anthropic",
 "min_tier": 1,
 "pricing": {
 "input": 3.0,
 "cached_input": 1.5,
 "output": 15.0
 }
 },
 {
 "id": "grok-3",
 "object": "model",
 "owned_by": "xai",
 "min_tier": 0,
 "pricing": {
 "input": 3.0,
 "cached_input": 1.5,
 "output": 15.0
 },
 "max_tokens": 131072,
 "max_input_tokens": 131072,
 "max_output_tokens": 131072,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_tool_choice": true,
 "supports_response_schema": false,
 "supports_web_search": true
 },
 {
 "id": "grok-3-latest",
 "object": "model",
 "owned_by": "xai",
 "min_tier": 0,
 "pricing": {
 "input": 3.0,
 "cached_input": 1.5,
 "output": 15.0
 },
 "max_tokens": 131072,
 "max_input_tokens": 131072,
 "max_output_tokens": 131072,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_tool_choice": true,
 "supports_response_schema": false,
 "supports_web_search": true
 },
 {
 "id": "grok-3-fast",
 "object": "model",
 "owned_by": "xai",
 "min_tier": 1,
 "pricing": {
 "input": 5.0,
 "cached_input": 2.5,
 "output": 25.0
 },
 "max_tokens": 131072,
 "max_input_tokens": 131072,
 "max_output_tokens": 131072,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_tool_choice": true,
 "supports_response_schema": false
 },
 {
 "id": "grok-3-fast-latest",
 "object": "model",
 "owned_by": "xai",
 "min_tier": 0,
 "pricing": {
 "input": 5.0,
 "cached_input": 2.5,
 "output": 25.0
 },
 "max_tokens": 131072,
 "max_input_tokens": 131072,
 "max_output_tokens": 131072,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_tool_choice": true,
 "supports_response_schema": false,
 "supports_web_search": true
 },
 {
 "id": "grok-3-mini",
 "object": "model",
 "owned_by": "xai",
 "min_tier": 0,
 "pricing": {
 "input": 0.3,
 "cached_input": 0.15,
 "output": 0.5
 },
 "max_tokens": 131072,
 "max_input_tokens": 131072,
 "max_output_tokens": 131072,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_tool_choice": true,
 "supports_response_schema": false,
 "supports_web_search": true
 },
 {
 "id": "grok-3-mini-latest",
 "object": "model",
 "owned_by": "xai",
 "min_tier": 0,
 "pricing": {
 "input": 0.3,
 "cached_input": 0.15,
 "output": 0.5
 },
 "max_tokens": 131072,
 "max_input_tokens": 131072,
 "max_output_tokens": 131072,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_tool_choice": true,
 "supports_response_schema": false,
 "supports_web_search": true
 },
 {
 "id": "grok-3-mini-fast",
 "object": "model",
 "owned_by": "xai",
 "min_tier": 0,
 "pricing": {
 "input": 0.6,
 "cached_input": 0.3,
 "output": 4.0
 },
 "max_tokens": 131072,
 "max_input_tokens": 131072,
 "max_output_tokens": 131072,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_tool_choice": true,
 "supports_response_schema": false,
 "supports_web_search": true
 },
 {
 "id": "grok-3-mini-fast-latest",
 "object": "model",
 "owned_by": "xai",
 "min_tier": 0,
 "pricing": {
 "input": 0.6,
 "cached_input": 0.3,
 "output": 4.0
 },
 "max_tokens": 131072,
 "max_input_tokens": 131072,
 "max_output_tokens": 131072,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_tool_choice": true,
 "supports_response_schema": false,
 "supports_web_search": true
 },
 {
 "id": "gemini-2.5-flash-preview-05-20",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.15,
 "cached_input": 0.075,
 "output": 3.5,
 "audio_input": 1.0,
 "audio_cached_input": 0.25,
 "audio_output": 1.0
 }
 },
 {
 "id": "mistral-ocr-latest",
 "object": "model",
 "owned_by": "mistral ai",
 "min_tier": 0,
 "pricing": {
 "input_cost_per_page": 0.001
 }
 },
 {
 "id": "o1-pro",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 4,
 "pricing": {
 "input": 150.0,
 "cached_input": 75.0,
 "output": 600.0
 },
 "max_tokens": 100000,
 "max_input_tokens": 200000,
 "max_output_tokens": 100000,
 "mode": "responses",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_native_streaming": false,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/responses",
 "/v1/batch"
 ]
 },
 {
 "id": "o1-pro-2025-03-19",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 4,
 "pricing": {
 "input": 150.0,
 "cached_input": 75.0,
 "output": 600.0
 },
 "max_tokens": 100000,
 "max_input_tokens": 200000,
 "max_output_tokens": 100000,
 "mode": "responses",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_native_streaming": false,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/responses",
 "/v1/batch"
 ]
 },
 {
 "id": "o3",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 2,
 "pricing": {
 "input": 2.0,
 "cached_input": 0.5,
 "output": 8.0
 },
 "max_tokens": 100000,
 "max_input_tokens": 200000,
 "max_output_tokens": 100000,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_parallel_function_calling": false,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/responses",
 "/v1/chat/completions",
 "/v1/completions",
 "/v1/batch"
 ]
 },
 {
 "id": "o3-2025-04-16",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 2,
 "pricing": {
 "input": 2.0,
 "cached_input": 0.5,
 "output": 8.0
 },
 "max_tokens": 100000,
 "max_input_tokens": 200000,
 "max_output_tokens": 100000,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_parallel_function_calling": false,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/responses",
 "/v1/chat/completions",
 "/v1/completions",
 "/v1/batch"
 ]
 },
 {
 "id": "qwen3-235b-a22b-fp8-tput",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 1,
 "pricing": {
 "input": 0.2,
 "cached_input": 0.1,
 "output": 0.6
 }
 },
 {
 "id": "gemini-2.5-pro-preview-05-06",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 1.5,
 "cached_input": 0.625,
 "output": 10.0,
 "input_above_200k": 2.5,
 "output_above_200k": 15.0,
 "audio_input": 7.0,
 "audio_cached_input": 1.5,
 "audio_output": 7.0
 }
 },
 {
 "id": "gpt-4o-mini-tts",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 0.6,
 "cached_input": 0.3,
 "output": 0.015,
 "output_cost_per_second": 0.00025
 },
 "mode": "audio_speech",
 "supported_endpoints": [
 "/v1/audio/speech"
 ]
 },
 {
 "id": "gpt-image-1",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 3,
 "pricing": {
 "input": 5.0,
 "image_input": 10.0,
 "cached_input": 5.0,
 "output": 40.0,
 "image_output": 40.0
 },
 "mode": "image_generation",
 "supported_endpoints": [
 "/v1/images/generations"
 ]
 },
 {
 "id": "o4-mini",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 1.1,
 "cached_input": 0.55,
 "output": 4.4
 },
 "max_tokens": 100000,
 "max_input_tokens": 200000,
 "max_output_tokens": 100000,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_parallel_function_calling": false,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "o4-mini-2025-04-16",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 1.1,
 "cached_input": 0.55,
 "output": 4.4
 },
 "max_tokens": 100000,
 "max_input_tokens": 200000,
 "max_output_tokens": 100000,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_parallel_function_calling": false,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "gemini-2.5-flash-preview-04-17",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.15,
 "cached_input": 0.075,
 "output": 3.5,
 "audio_input": 1.0,
 "audio_cached_input": 0.25,
 "audio_output": 1.0
 }
 },
 {
 "id": "gemma-3-1b-it",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.001,
 "cached_input": 0.0001,
 "output": 0.005
 },
 "max_tokens": 8192,
 "max_input_tokens": 131072,
 "max_output_tokens": 8192,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_vision": true,
 "supports_audio_output": false,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "gemma-3-4b-it",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.001,
 "cached_input": 0.0001,
 "output": 0.005
 },
 "max_tokens": 8192,
 "max_input_tokens": 131072,
 "max_output_tokens": 8192,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_vision": true,
 "supports_audio_output": false,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "gemma-3-12b-it",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.001,
 "cached_input": 0.0001,
 "output": 0.005
 },
 "max_tokens": 8192,
 "max_input_tokens": 131072,
 "max_output_tokens": 8192,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_vision": true,
 "supports_audio_output": false,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "gemma-3-27b-it",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.001,
 "cached_input": 0.0001,
 "output": 0.005
 },
 "max_tokens": 8192,
 "max_input_tokens": 131072,
 "max_output_tokens": 8192,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_vision": true,
 "supports_audio_output": false,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "gemma-3n-e4b-it",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.001,
 "cached_input": 0.0001,
 "output": 0.005
 },
 "max_tokens": 8192,
 "max_input_tokens": 131072,
 "max_output_tokens": 8192,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_vision": true,
 "supports_audio_output": false,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "gpt-4.1",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 2.0,
 "cached_input": 0.5,
 "output": 8.0,
 "search_context_cost_per_query": {
 "low": 0.03,
 "medium": 0.035,
 "high": 0.05
 }
 },
 "max_tokens": 32768,
 "max_input_tokens": 1047576,
 "max_output_tokens": 32768,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_native_streaming": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/chat/completions",
 "/v1/batch",
 "/v1/responses"
 ]
 },
 {
 "id": "gpt-4.1-2025-04-14",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 2.0,
 "cached_input": 0.5,
 "output": 8.0,
 "search_context_cost_per_query": {
 "low": 0.03,
 "medium": 0.035,
 "high": 0.05
 }
 },
 "max_tokens": 32768,
 "max_input_tokens": 1047576,
 "max_output_tokens": 32768,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_native_streaming": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/chat/completions",
 "/v1/batch",
 "/v1/responses"
 ]
 },
 {
 "id": "gpt-4.1-mini",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.4,
 "cached_input": 0.1,
 "output": 1.6,
 "search_context_cost_per_query": {
 "low": 0.03,
 "medium": 0.035,
 "high": 0.05
 }
 },
 "max_tokens": 32768,
 "max_input_tokens": 1047576,
 "max_output_tokens": 32768,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_native_streaming": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/chat/completions",
 "/v1/batch",
 "/v1/responses"
 ]
 },
 {
 "id": "gpt-4.1-mini-2025-04-14",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.4,
 "cached_input": 0.1,
 "output": 1.6,
 "search_context_cost_per_query": {
 "low": 0.03,
 "medium": 0.035,
 "high": 0.05
 }
 },
 "max_tokens": 32768,
 "max_input_tokens": 1047576,
 "max_output_tokens": 32768,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_native_streaming": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/chat/completions",
 "/v1/batch",
 "/v1/responses"
 ]
 },
 {
 "id": "gpt-4.1-nano",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.1,
 "cached_input": 0.025,
 "output": 0.4
 },
 "max_tokens": 32768,
 "max_input_tokens": 1047576,
 "max_output_tokens": 32768,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_native_streaming": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/chat/completions",
 "/v1/batch",
 "/v1/responses"
 ]
 },
 {
 "id": "gpt-4.1-nano-2025-04-14",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.1,
 "cached_input": 0.025,
 "output": 0.4
 },
 "max_tokens": 32768,
 "max_input_tokens": 1047576,
 "max_output_tokens": 32768,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_native_streaming": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supported_endpoints": [
 "/v1/chat/completions",
 "/v1/batch",
 "/v1/responses"
 ]
 },
 {
 "id": "grok-3-beta",
 "object": "model",
 "owned_by": "xai",
 "min_tier": 0,
 "pricing": {
 "input": 3.0,
 "cached_input": 1.5,
 "output": 15.0
 },
 "max_tokens": 131072,
 "max_input_tokens": 131072,
 "max_output_tokens": 131072,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_tool_choice": true,
 "supports_response_schema": false,
 "supports_web_search": true
 },
 {
 "id": "grok-3-fast-beta",
 "object": "model",
 "owned_by": "xai",
 "min_tier": 1,
 "pricing": {
 "input": 5.0,
 "cached_input": 2.5,
 "output": 25.0
 },
 "max_tokens": 131072,
 "max_input_tokens": 131072,
 "max_output_tokens": 131072,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_tool_choice": true,
 "supports_response_schema": false,
 "supports_web_search": true
 },
 {
 "id": "grok-3-mini-beta",
 "object": "model",
 "owned_by": "xai",
 "min_tier": 0,
 "pricing": {
 "input": 0.3,
 "cached_input": 0.15,
 "output": 0.5
 },
 "max_tokens": 131072,
 "max_input_tokens": 131072,
 "max_output_tokens": 131072,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_tool_choice": true,
 "supports_response_schema": false,
 "supports_web_search": true
 },
 {
 "id": "grok-3-mini-fast-beta",
 "object": "model",
 "owned_by": "xai",
 "min_tier": 1,
 "pricing": {
 "input": 0.6,
 "cached_input": 0.3,
 "output": 4.0
 },
 "max_tokens": 131072,
 "max_input_tokens": 131072,
 "max_output_tokens": 131072,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_tool_choice": true,
 "supports_response_schema": false,
 "supports_web_search": true
 },
 {
 "id": "gpt-4o-transcribe",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 2.5,
 "cached_input": 1.5,
 "output": 10.0,
 "input_cost_per_second": 0.0001
 },
 "max_input_tokens": 16000,
 "max_output_tokens": 2000,
 "mode": "audio_transcription",
 "supported_endpoints": [
 "/v1/audio/transcriptions"
 ]
 },
 {
 "id": "gpt-4o-mini-transcribe",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 1.25,
 "cached_input": 0.75,
 "output": 5.0,
 "input_cost_per_second": 0.00005
 },
 "max_input_tokens": 16000,
 "max_output_tokens": 2000,
 "mode": "audio_transcription",
 "supported_endpoints": [
 "/v1/audio/transcriptions"
 ]
 },
 {
 "id": "gpt-4o-search-preview",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 2.5,
 "cached_input": 1.25,
 "output": 10.0,
 "search_context_cost_per_query": {
 "low": 0.03,
 "medium": 0.035,
 "high": 0.05
 }
 },
 "max_tokens": 16384,
 "max_input_tokens": 128000,
 "max_output_tokens": 16384,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supports_web_search": true,
 "search_context_cost_per_query": {
 "search_context_size_low": 0.03,
 "search_context_size_medium": 0.0275,
 "search_context_size_high": 0.03
 }
 },
 {
 "id": "gpt-4o-search-preview-2025-03-11",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 2.5,
 "cached_input": 1.25,
 "output": 10.0,
 "search_context_cost_per_query": {
 "low": 0.03,
 "medium": 0.035,
 "high": 0.05
 }
 },
 "max_tokens": 16384,
 "max_input_tokens": 128000,
 "max_output_tokens": 16384,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "gpt-4o-mini-search-preview",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 0.15,
 "cached_input": 0.075,
 "output": 0.6,
 "search_context_cost_per_query": {
 "low": 0.025,
 "medium": 0.0275,
 "high": 0.03
 }
 },
 "max_tokens": 16384,
 "max_input_tokens": 128000,
 "max_output_tokens": 16384,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "supports_web_search": true,
 "search_context_cost_per_query": {
 "search_context_size_low": 0.025,
 "search_context_size_medium": 0.0275,
 "search_context_size_high": 0.03
 }
 },
 {
 "id": "gpt-4o-mini-search-preview-2025-03-11",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 0.15,
 "cached_input": 0.075,
 "output": 0.6,
 "search_context_cost_per_query": {
 "low": 0.025,
 "medium": 0.0275,
 "high": 0.03
 }
 },
 "max_tokens": 16384,
 "max_input_tokens": 128000,
 "max_output_tokens": 16384,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "cohere.rerank-v3-5:0",
 "object": "model",
 "owned_by": "cohere",
 "min_tier": 0,
 "pricing": {
 "input": 0.0,
 "input_cost_per_query": 0.002,
 "output": 0.0
 }
 },
 {
 "id": "llama-4-maverick-17b-128e-instruct-fp8",
 "object": "model",
 "owned_by": "meta",
 "min_tier": 1,
 "pricing": {
 "input": 0.27,
 "cached_input": 0.14,
 "output": 0.85
 }
 },
 {
 "id": "llama-4-scout-17b-16e-instruct",
 "object": "model",
 "owned_by": "meta",
 "min_tier": 0,
 "pricing": {
 "input": 0.18,
 "cached_input": 0.09,
 "output": 0.59
 }
 },
 {
 "id": "qwen3-coder-plus",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 1.0,
 "input_above_32K": 1.8,
 "input_above_128K": 3.0,
 "input_above_256K": 6.0,
 "cached_input": 0.1,
 "cached_input_above_32K": 0.18,
 "cached_input_above_128K": 0.3,
 "cached_input_above_256K": 0.6,
 "output": 5.0,
 "output_above_32K": 9.0,
 "output_above_128K": 15.0,
 "output_above_256K": 60.0
 }
 },
 {
 "id": "qwen3-coder-plus-2025-07-22",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 1.0,
 "input_above_32K": 1.8,
 "input_above_128K": 3.0,
 "input_above_256K": 6.0,
 "cached_input": 0.1,
 "cached_input_above_32K": 0.18,
 "cached_input_above_128K": 0.3,
 "cached_input_above_256K": 0.6,
 "output": 5.0,
 "output_above_32K": 9.0,
 "output_above_128K": 15.0,
 "output_above_256K": 60.0
 }
 },
 {
 "id": "qwen3-coder-480b-a35b-instruct",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 1.5,
 "input_above_32K": 2.7,
 "input_above_128K": 4.5,
 "cached_input": 0.15,
 "cached_input_above_32K": 0.27,
 "cached_input_above_128K": 0.45,
 "output": 7.5,
 "output_above_32K": 13.5,
 "output_above_128K": 22.5
 }
 },
 {
 "id": "qwen3-235b-a22b-instruct-2507",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.7,
 "cached_input": 0.35,
 "output": 2.8
 }
 },
 {
 "id": "qwen3-235b-a22b-thinking-2507",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.7,
 "cached_input": 0.35,
 "output": 8.4
 }
 },
 {
 "id": "qwq-32b",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 1.2,
 "cached_input": 0.6,
 "output": 1.2
 }
 },
 {
 "id": "qwq-plus",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.8,
 "cached_input": 0.4,
 "output": 2.4
 }
 },
 {
 "id": "qwq-plus-2025-03-05",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.8,
 "cached_input": 0.4,
 "output": 2.4
 }
 },
 {
 "id": "qwen3-235b-a22b",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.7,
 "cached_input": 0.35,
 "output": 8.4
 }
 },
 {
 "id": "qwen3-32b",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.7,
 "cached_input": 0.35,
 "output": 8.4
 }
 },
 {
 "id": "qwen3-30b-a3b",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.2,
 "cached_input": 0.1,
 "output": 2.4
 },
 "max_tokens": 131072,
 "max_input_tokens": 129024,
 "max_output_tokens": 16384,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_tool_choice": true
 },
 {
 "id": "qwen3-30b-a3b-instruct-2507",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.2,
 "cached_input": 0.1,
 "output": 0.8
 }
 },
 {
 "id": "qwen3-30b-a3b-thinking-2507",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.2,
 "cached_input": 0.1,
 "output": 2.4
 }
 },
 {
 "id": "qwen3-14b",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.35,
 "cached_input": 0.16,
 "output": 4.2
 }
 },
 {
 "id": "qwen3-8b",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.18,
 "cached_input": 0.9,
 "output": 2.1
 }
 },
 {
 "id": "qwen3-4b",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.11,
 "cached_input": 0.5,
 "output": 1.26
 }
 },
 {
 "id": "qwen3-1.7b",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.11,
 "cached_input": 0.5,
 "output": 1.26
 }
 },
 {
 "id": "qwen3-0.6b",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.11,
 "cached_input": 0.5,
 "output": 1.26
 }
 },
 {
 "id": "qwen2.5-14b-instruct-1m",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.805,
 "cached_input": 0.4,
 "output": 3.22
 }
 },
 {
 "id": "qwen2.5-7b-instruct-1m",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.368,
 "cached_input": 0.18,
 "output": 1.47
 }
 },
 {
 "id": "qwen2.5-72b-instruct",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 1.4,
 "cached_input": 0.7,
 "output": 5.6
 }
 },
 {
 "id": "qwen2.5-32b-instruct",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.7,
 "cached_input": 0.35,
 "output": 2.8
 }
 },
 {
 "id": "qwen2.5-14b-instruct",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.35,
 "cached_input": 0.16,
 "output": 1.4
 }
 },
 {
 "id": "qwen2.5-7b-instruct",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.175,
 "cached_input": 0.08,
 "output": 0.7
 }
 },
 {
 "id": "qwen-mt-plus",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 2.46,
 "cached_input": 1.2,
 "output": 7.37
 }
 },
 {
 "id": "qwen-mt-turbo",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.16,
 "cached_input": 0.08,
 "output": 0.49
 }
 },
 {
 "id": "qwen-max",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 1.6,
 "cached_input": 0.8,
 "output": 6.4
 },
 "max_tokens": 32768,
 "max_input_tokens": 30720,
 "max_output_tokens": 8192,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_tool_choice": true
 },
 {
 "id": "qwen-max-latest",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 1.6,
 "cached_input": 0.8,
 "output": 6.4
 }
 },
 {
 "id": "qwen-max-2025-01-25",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 1.6,
 "cached_input": 0.8,
 "output": 6.4
 }
 },
 {
 "id": "qwen-plus",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.4,
 "cached_input": 0.2,
 "output": 4.0
 }
 },
 {
 "id": "qwen-plus-latest",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.4,
 "cached_input": 0.2,
 "output": 4.0
 },
 "max_tokens": 131072,
 "max_input_tokens": 129024,
 "max_output_tokens": 16384,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_tool_choice": true
 },
 {
 "id": "qwen-plus-2025-07-14",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.4,
 "cached_input": 0.2,
 "output": 4.0
 }
 },
 {
 "id": "qwen-plus-2025-04-28",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.4,
 "cached_input": 0.2,
 "output": 4.0
 }
 },
 {
 "id": "qwen-vl-max",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.8,
 "cached_input": 0.4,
 "output": 3.2
 }
 },
 {
 "id": "qwen-vl-plus",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.21,
 "cached_input": 0.1,
 "output": 0.63
 }
 },
 {
 "id": "qwen-vl-ocr",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.72,
 "output": 0.72
 }
 },
 {
 "id": "qwen-vl-plus-latest",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.21,
 "cached_input": 0.1,
 "output": 0.63
 }
 },
 {
 "id": "qwen-vl-max-latest",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.8,
 "cached_input": 0.4,
 "output": 3.2
 }
 },
 {
 "id": "qwen-vl-max-2025-04-08",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.8,
 "cached_input": 0.4,
 "output": 3.2
 }
 },
 {
 "id": "qwen-vl-plus-2025-05-07",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.21,
 "cached_input": 0.1,
 "output": 0.63
 }
 },
 {
 "id": "qwen2.5-vl-72b-instruct",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 2.8,
 "cached_input": 1.4,
 "output": 8.4
 }
 },
 {
 "id": "qwen2.5-vl-32b-instruct",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 1.4,
 "cached_input": 0.7,
 "output": 4.2
 }
 },
 {
 "id": "qwen2.5-vl-7b-instruct",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.35,
 "cached_input": 0.16,
 "output": 1.05
 }
 },
 {
 "id": "qwen2.5-vl-3b-instruct",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.21,
 "cached_input": 0.1,
 "output": 0.63
 }
 },
 {
 "id": "qvq-max",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 1.2,
 "cached_input": 0.6,
 "output": 4.8
 }
 },
 {
 "id": "qvq-max-latest",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 1.2,
 "cached_input": 0.6,
 "output": 4.8
 }
 },
 {
 "id": "qvq-max-2025-03-25",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 1.2,
 "cached_input": 0.6,
 "output": 4.8
 }
 },
 {
 "id": "qwen-turbo",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.05,
 "cached_input": 0.02,
 "output": 0.5
 }
 },
 {
 "id": "qwen-turbo-latest",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.05,
 "cached_input": 0.02,
 "output": 0.5
 },
 "max_tokens": 131072,
 "max_input_tokens": 129024,
 "max_output_tokens": 16384,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_tool_choice": true
 },
 {
 "id": "qwen-turbo-2025-04-28",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.05,
 "cached_input": 0.02,
 "output": 0.5
 }
 },
 {
 "id": "text-embedding-v3",
 "object": "model",
 "owned_by": "alibaba",
 "min_tier": 0,
 "pricing": {
 "input": 0.07
 }
 },
 {
 "id": "gemini-2.5-pro-preview-03-25",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 1.5,
 "cached_input": 0.625,
 "output": 10.0,
 "input_above_200k": 2.5,
 "output_above_200k": 15.0,
 "audio_input": 7.0,
 "audio_cached_input": 1.5,
 "audio_output": 7.0
 }
 },
 {
 "id": "anthropic.claude-3-7-sonnet-20250219-v1:0",
 "object": "model",
 "owned_by": "anthropic",
 "min_tier": 1,
 "pricing": {
 "input": 3.0,
 "cached_input": 1.5,
 "output": 15.0
 }
 },
 {
 "id": "anthropic.claude-3-5-sonnet-20241022-v2:0",
 "object": "model",
 "owned_by": "anthropic",
 "min_tier": 1,
 "pricing": {
 "input": 3.0,
 "cached_input": 1.5,
 "output": 15.0
 }
 },
 {
 "id": "gemini-2.0-pro-exp-02-05",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 3.5,
 "cached_input": 1.5,
 "output": 7.0,
 "audio_input": 7.0,
 "audio_cached_input": 1.5,
 "audio_output": 7.0
 }
 },
 {
 "id": "gemini-2.0-flash",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.1,
 "cached_input": 0.025,
 "output": 0.4,
 "audio_input": 0.7,
 "audio_cached_input": 0.175,
 "audio_output": 0.4
 }
 },
 {
 "id": "gemini-2.0-flash-lite",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.075,
 "cached_input": 0.01875,
 "output": 0.3,
 "audio_input": 0.075,
 "audio_cached_input": 0.01875,
 "audio_output": 0.3
 }
 },
 {
 "id": "o3-mini",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 2,
 "pricing": {
 "input": 1.1,
 "cached_input": 0.55,
 "output": 4.4
 },
 "max_tokens": 100000,
 "max_input_tokens": 200000,
 "max_output_tokens": 100000,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_parallel_function_calling": false,
 "supports_vision": false,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "o3-mini-2025-01-31",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 2,
 "pricing": {
 "input": 1.1,
 "cached_input": 0.55,
 "output": 4.4
 },
 "max_tokens": 100000,
 "max_input_tokens": 200000,
 "max_output_tokens": 100000,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_parallel_function_calling": false,
 "supports_vision": false,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "gemini-2.0-flash-exp",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.1,
 "cached_input": 0.025,
 "output": 0.4,
 "audio_input": 0.7,
 "audio_cached_input": 0.175,
 "audio_output": 0.4
 }
 },
 {
 "id": "gemini-1.5-flash-002",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 0.075,
 "cached_input": 0.0375,
 "output": 0.3,
 "input_above_128k": 0.15,
 "output_above_128k": 0.6
 }
 },
 {
 "id": "gemini-1.5-flash-001",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 0.075,
 "cached_input": 0.0375,
 "output": 0.3,
 "input_above_128k": 0.15,
 "output_above_128k": 0.6
 }
 },
 {
 "id": "gemini-1.5-flash",
 "object": "model",
 "owned_by": "google",
 "min_tier": 0,
 "pricing": {
 "input": 0.075,
 "cached_input": 0.0375,
 "output": 0.3,
 "input_above_128k": 0.15,
 "output_above_128k": 0.6
 }
 },
 {
 "id": "gemini-1.5-flash-latest",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 0.075,
 "cached_input": 0.0375,
 "output": 0.3,
 "input_above_128k": 0.15,
 "output_above_128k": 0.6
 }
 },
 {
 "id": "gemini-1.5-flash-8b",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 0.0375,
 "cached_input": 0.02,
 "output": 0.15,
 "input_above_128k": 0.075,
 "output_above_128k": 0.3
 }
 },
 {
 "id": "gemini-1.5-flash-8b-exp-0924",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 0.075,
 "cached_input": 0.02,
 "output": 0.3,
 "input_above_128k": 0.075,
 "output_above_128k": 0.3
 }
 },
 {
 "id": "gemini-exp-1114",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 2.5,
 "cached_input": 0.625,
 "output": 10.0
 },
 "max_tokens": 8192,
 "max_input_tokens": 1048576,
 "max_output_tokens": 8192,
 "max_images_per_prompt": 3000,
 "max_videos_per_prompt": 10,
 "max_video_length": 1,
 "max_audio_length_hours": 8.4,
 "max_audio_per_prompt": 1,
 "max_pdf_size_mb": 30,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_vision": true,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "gemini-exp-1206",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 2.5,
 "cached_input": 0.625,
 "output": 10.0
 },
 "max_tokens": 8192,
 "max_input_tokens": 2097152,
 "max_output_tokens": 8192,
 "max_images_per_prompt": 3000,
 "max_videos_per_prompt": 10,
 "max_video_length": 1,
 "max_audio_length_hours": 8.4,
 "max_audio_per_prompt": 1,
 "max_pdf_size_mb": 30,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_vision": true,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "gemini-1.5-flash-exp-0827",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 0.15,
 "cached_input": 0.0375,
 "output": 0.6
 }
 },
 {
 "id": "gemini-1.5-flash-8b-exp-0827",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 0.15,
 "cached_input": 0.0375,
 "output": 0.6
 }
 },
 {
 "id": "gemini-pro",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 0.5,
 "cached_input": 0.25,
 "output": 1.5
 },
 "max_tokens": 8192,
 "max_input_tokens": 32760,
 "max_output_tokens": 8192,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_tool_choice": true
 },
 {
 "id": "gemini-1.5-pro",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 1.25,
 "cached_input": 0.625,
 "output": 5.0,
 "input_above_128k": 2.5,
 "output_above_128k": 10.0
 }
 },
 {
 "id": "gemini-1.5-pro-002",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 2.5,
 "cached_input": 0.625,
 "output": 10.0
 }
 },
 {
 "id": "gemini-1.5-pro-001",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 2.5,
 "cached_input": 0.625,
 "output": 10.0
 }
 },
 {
 "id": "gemini-1.5-pro-exp-0801",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 2.5,
 "cached_input": 0.625,
 "output": 10.0
 }
 },
 {
 "id": "gemini-1.5-pro-exp-0827",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 2.5,
 "cached_input": 0.625,
 "output": 10.0
 }
 },
 {
 "id": "gemini-1.5-pro-latest",
 "object": "model",
 "owned_by": "google",
 "min_tier": 1,
 "pricing": {
 "input": 1.25,
 "cached_input": 0.625,
 "output": 5.0,
 "input_above_128k": 2.5,
 "output_above_128k": 10.0
 }
 },
 {
 "id": "cohere.command-light-text-v14",
 "object": "model",
 "owned_by": "cohere",
 "min_tier": 1,
 "pricing": {
 "input": 0.3,
 "cached_input": 0.15,
 "output": 0.6
 }
 },
 {
 "id": "cohere.command-r-plus-v1:0",
 "object": "model",
 "owned_by": "cohere",
 "min_tier": 1,
 "pricing": {
 "input": 3.0,
 "cached_input": 1.5,
 "output": 15.0
 }
 },
 {
 "id": "cohere.command-r-v1:0",
 "object": "model",
 "owned_by": "cohere",
 "min_tier": 0,
 "pricing": {
 "input": 0.5,
 "cached_input": 0.25,
 "output": 1.5
 }
 },
 {
 "id": "cohere.command-text-v14",
 "object": "model",
 "owned_by": "cohere",
 "min_tier": 1,
 "pricing": {
 "input": 1.5,
 "cached_input": 0.75,
 "output": 2
 }
 },
 {
 "id": "cohere.embed-english-v3",
 "object": "model",
 "owned_by": "cohere",
 "min_tier": 0,
 "pricing": {
 "input": 0.1,
 "cached_input": 0.05,
 "output": 0.0
 }
 },
 {
 "id": "cohere.embed-multilingual-v3",
 "object": "model",
 "owned_by": "cohere",
 "min_tier": 0,
 "pricing": {
 "input": 0.1,
 "cached_input": 0.05,
 "output": 0.0
 }
 },
 {
 "id": "deepseek-r1-0528",
 "object": "model",
 "owned_by": "deepseek",
 "min_tier": 0,
 "pricing": {
 "input": 0.55,
 "cached_input": 0.014,
 "output": 2.19
 }
 },
 {
 "id": "deepseek.r1-v1:0",
 "object": "model",
 "owned_by": "deepseek",
 "min_tier": 0,
 "pricing": {
 "input": 1.35,
 "cached_input": 0.675,
 "output": 5.4
 }
 },
 {
 "id": "deepseek-reasoner",
 "object": "model",
 "owned_by": "deepseek",
 "min_tier": 0,
 "pricing": {
 "input": 0.55,
 "cached_input": 0.014,
 "output": 2.19
 },
 "max_tokens": 8192,
 "max_input_tokens": 65536,
 "max_output_tokens": 8192,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true
 },
 {
 "id": "deepseek-v3-0324",
 "object": "model",
 "owned_by": "deepseek",
 "min_tier": 0,
 "pricing": {
 "input": 0.27,
 "cached_input": 0.014,
 "output": 1.1
 }
 },
 {
 "id": "deepseek-chat",
 "object": "model",
 "owned_by": "deepseek",
 "min_tier": 0,
 "pricing": {
 "input": 0.27,
 "cached_input": 0.014,
 "output": 1.1
 },
 "max_tokens": 8192,
 "max_input_tokens": 65536,
 "max_output_tokens": 8192,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true
 },
 {
 "id": "deepseek-coder",
 "object": "model",
 "owned_by": "deepseek",
 "min_tier": 0,
 "pricing": {
 "input": 0.27,
 "cached_input": 0.014,
 "output": 1.1
 },
 "max_tokens": 4096,
 "max_input_tokens": 128000,
 "max_output_tokens": 4096,
 "mode": "chat",
 "supports_function_calling": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true
 },
 {
 "id": "anthropic.claude-3-5-sonnet-20240620-v1:0",
 "object": "model",
 "owned_by": "anthropic",
 "min_tier": 1,
 "pricing": {
 "input": 3.0,
 "cached_input": 1.5,
 "output": 15.0
 }
 },
 {
 "id": "anthropic.claude-3-5-haiku-20241022-v1:0",
 "object": "model",
 "owned_by": "anthropic",
 "min_tier": 0,
 "pricing": {
 "input": 0.8,
 "cached_input": 0.4,
 "output": 4.0
 }
 },
 {
 "id": "anthropic.claude-3-sonnet-20240229-v1:0",
 "object": "model",
 "owned_by": "anthropic",
 "min_tier": 1,
 "pricing": {
 "input": 3.0,
 "cached_input": 1.5,
 "output": 15.0
 }
 },
 {
 "id": "anthropic.claude-3-haiku-20240307-v1:0",
 "object": "model",
 "owned_by": "anthropic",
 "min_tier": 1,
 "pricing": {
 "input": 0.25,
 "cached_input": 0.15,
 "output": 1.25
 }
 },
 {
 "id": "anthropic.claude-3-opus-20240229-v1:0",
 "object": "model",
 "owned_by": "anthropic",
 "min_tier": 1,
 "pricing": {
 "input": 15.0,
 "cached_input": 7.5,
 "output": 75.0
 }
 },
 {
 "id": "meta.llama3-1-8b-instruct-v1:0",
 "object": "model",
 "owned_by": "meta",
 "min_tier": 0,
 "pricing": {
 "input": 0.22,
 "cached_input": 0.11,
 "output": 0.22
 }
 },
 {
 "id": "meta.llama3-1-70b-instruct-v1:0",
 "object": "model",
 "owned_by": "meta",
 "min_tier": 1,
 "pricing": {
 "input": 0.5,
 "cached_input": 0.25,
 "output": 1.5
 }
 },
 {
 "id": "meta.llama3-1-405b-instruct-v1:0",
 "object": "model",
 "owned_by": "meta",
 "min_tier": 1,
 "pricing": {
 "input": 5.5,
 "cached_input": 2.5,
 "output": 16.0
 }
 },
 {
 "id": "meta.llama3-3-70b-instruct-v1:0",
 "object": "model",
 "owned_by": "meta",
 "min_tier": 1,
 "pricing": {
 "input": 0.72,
 "cached_input": 0.5,
 "output": 0.72
 }
 },
 {
 "id": "mistral.mistral-large-2407-v1:0",
 "object": "model",
 "owned_by": "mistral ai",
 "min_tier": 1,
 "pricing": {
 "input": 3.0,
 "cached_input": 1.5,
 "output": 9.0
 }
 },
 {
 "id": "gpt-4o-mini-audio-preview-2024-12-17",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.15,
 "cached_input": 0.15,
 "audio_input": 10.0,
 "output": 0.6,
 "audio_output": 20.0
 },
 "max_tokens": 16384,
 "max_input_tokens": 128000,
 "max_output_tokens": 16384,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_audio_input": true,
 "supports_audio_output": true,
 "supports_tool_choice": true
 },
 {
 "id": "gpt-4o-mini-audio-preview",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.15,
 "cached_input": 0.15,
 "audio_input": 10.0,
 "output": 0.6,
 "audio_output": 20.0
 },
 "max_tokens": 16384,
 "max_input_tokens": 128000,
 "max_output_tokens": 16384,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_audio_input": true,
 "supports_audio_output": true,
 "supports_tool_choice": true
 },
 {
 "id": "gpt-4o-audio-preview-2024-12-17",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 2.5,
 "cached_input": 1.25,
 "audio_input": 40.0,
 "output": 10.0,
 "audio_output": 80.0
 },
 "max_tokens": 16384,
 "max_input_tokens": 128000,
 "max_output_tokens": 16384,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_audio_input": true,
 "supports_audio_output": true,
 "supports_tool_choice": true
 },
 {
 "id": "gpt-4o-audio-preview-2024-10-01",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 2.5,
 "cached_input": 1.25,
 "audio_input": 100.0,
 "output": 10.0,
 "audio_output": 200.0
 },
 "max_tokens": 16384,
 "max_input_tokens": 128000,
 "max_output_tokens": 16384,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_audio_input": true,
 "supports_audio_output": true,
 "supports_tool_choice": true
 },
 {
 "id": "gpt-4o-audio-preview",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 2.5,
 "cached_input": 1.25,
 "audio_input": 100.0,
 "output": 10.0,
 "audio_output": 200.0
 },
 "max_tokens": 16384,
 "max_input_tokens": 128000,
 "max_output_tokens": 16384,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_audio_input": true,
 "supports_audio_output": true,
 "supports_tool_choice": true
 },
 {
 "id": "chatgpt-4o-latest",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 5.0,
 "cached_input": 2.5,
 "output": 15.0
 },
 "max_tokens": 4096,
 "max_input_tokens": 128000,
 "max_output_tokens": 4096,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true
 },
 {
 "id": "gpt-4o-2024-11-20",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 2.5,
 "cached_input": 1.25,
 "output": 10.0
 },
 "max_tokens": 16384,
 "max_input_tokens": 128000,
 "max_output_tokens": 16384,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "omni-moderation-latest",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.0,
 "cached_input": 0.0,
 "output": 0.0
 },
 "max_tokens": 32768,
 "max_input_tokens": 32768,
 "max_output_tokens": 0,
 "mode": "moderation"
 },
 {
 "id": "omni-moderation-2024-09-26",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.0,
 "cached_input": 0.0,
 "output": 0.0
 },
 "max_tokens": 32768,
 "max_input_tokens": 32768,
 "max_output_tokens": 0,
 "mode": "moderation"
 },
 {
 "id": "o1-mini",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 1.1,
 "cached_input": 0.55,
 "output": 4.4
 },
 "max_tokens": 65536,
 "max_input_tokens": 128000,
 "max_output_tokens": 65536,
 "mode": "chat",
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true
 },
 {
 "id": "o1-mini-2024-09-12",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 1.1,
 "cached_input": 0.55,
 "output": 4.4
 },
 "max_tokens": 65536,
 "max_input_tokens": 128000,
 "max_output_tokens": 65536,
 "mode": "chat",
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true
 },
 {
 "id": "o1",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 2,
 "pricing": {
 "input": 15.0,
 "cached_input": 7.5,
 "output": 60.0
 },
 "max_tokens": 100000,
 "max_input_tokens": 200000,
 "max_output_tokens": 100000,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "o1-2024-12-17",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 2,
 "pricing": {
 "input": 15.0,
 "cached_input": 7.5,
 "output": 60.0
 },
 "max_tokens": 100000,
 "max_input_tokens": 200000,
 "max_output_tokens": 100000,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "o1-preview",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 15.0,
 "cached_input": 7.5,
 "output": 60.0
 },
 "max_tokens": 32768,
 "max_input_tokens": 128000,
 "max_output_tokens": 32768,
 "mode": "chat",
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true
 },
 {
 "id": "o1-preview-2024-09-12",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 15.0,
 "cached_input": 7.5,
 "output": 60.0
 },
 "max_tokens": 32768,
 "max_input_tokens": 128000,
 "max_output_tokens": 32768,
 "mode": "chat",
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true
 },
 {
 "id": "gpt-4o-2024-08-06",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 2.5,
 "cached_input": 1.25,
 "output": 10.0
 },
 "max_tokens": 16384,
 "max_input_tokens": 128000,
 "max_output_tokens": 16384,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "gpt-4o",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 2.5,
 "cached_input": 1.25,
 "output": 10.0
 },
 "max_tokens": 16384,
 "max_input_tokens": 128000,
 "max_output_tokens": 16384,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "gpt-4o-2024-05-13",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 5.0,
 "cached_input": 1.25,
 "output": 15.0
 },
 "max_tokens": 4096,
 "max_input_tokens": 128000,
 "max_output_tokens": 4096,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true
 },
 {
 "id": "gpt-4o-mini-2024-07-18",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.15,
 "cached_input": 0.075,
 "output": 0.6
 },
 "max_tokens": 16384,
 "max_input_tokens": 128000,
 "max_output_tokens": 16384,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true,
 "search_context_cost_per_query": {
 "search_context_size_low": 0.025,
 "search_context_size_medium": 0.0275,
 "search_context_size_high": 0.03
 }
 },
 {
 "id": "gpt-4o-mini",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.15,
 "cached_input": 0.075,
 "output": 0.6
 },
 "max_tokens": 16384,
 "max_input_tokens": 128000,
 "max_output_tokens": 16384,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "supports_response_schema": true
 },
 {
 "id": "gpt-4",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 30.0,
 "cached_input": 15.0,
 "output": 60.0
 },
 "max_tokens": 4096,
 "max_input_tokens": 8192,
 "max_output_tokens": 4096,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true
 },
 {
 "id": "gpt-4-0125-preview",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 10.0,
 "cached_input": 5.0,
 "output": 30.0
 },
 "max_tokens": 4096,
 "max_input_tokens": 128000,
 "max_output_tokens": 4096,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true
 },
 {
 "id": "gpt-4-1106-preview",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 10.0,
 "cached_input": 5.0,
 "output": 30.0
 },
 "max_tokens": 4096,
 "max_input_tokens": 128000,
 "max_output_tokens": 4096,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true
 },
 {
 "id": "gpt-4-0613",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 2,
 "pricing": {
 "input": 10.0,
 "cached_input": 5.0,
 "output": 30.0
 },
 "max_tokens": 4096,
 "max_input_tokens": 8192,
 "max_output_tokens": 4096,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true,
 "deprecation_date": "2025-06-06"
 },
 {
 "id": "gpt-4-turbo",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 10.0,
 "cached_input": 5.0,
 "output": 30.0
 },
 "max_tokens": 4096,
 "max_input_tokens": 128000,
 "max_output_tokens": 4096,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true
 },
 {
 "id": "gpt-4-turbo-2024-04-09",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 10.0,
 "cached_input": 5.0,
 "output": 30.0
 },
 "max_tokens": 4096,
 "max_input_tokens": 128000,
 "max_output_tokens": 4096,
 "mode": "chat",
 "supports_system_messages": true,
 "supports_function_calling": true,
 "supports_parallel_function_calling": true,
 "supports_vision": true,
 "supports_pdf_input": true,
 "supports_prompt_caching": true,
 "supports_tool_choice": true
 },
 {
 "id": "whisper-1",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.0,
 "cached_input": 0.0,
 "output": 60.0,
 "input_cost_per_second": 0.0001
 },
 "mode": "audio_transcription",
 "supported_endpoints": [
 "/v1/audio/transcriptions"
 ]
 },
 {
 "id": "stability.sd3-large-v1:0",
 "object": "model",
 "owned_by": "stability",
 "min_tier": 0,
 "pricing": {
 "input": 0.0,
 "cached_input": 0.0,
 "output": 80.0,
 "output_cost_per_image": 0.08
 }
 },
 {
 "id": "stability.sd3-5-large-v1:0",
 "object": "model",
 "owned_by": "stability",
 "min_tier": 0,
 "pricing": {
 "input": 0.0,
 "cached_input": 0.0,
 "output": 80.0,
 "output_cost_per_image": 0.08
 }
 },
 {
 "id": "stability.stable-image-ultra-v1:1",
 "object": "model",
 "owned_by": "stability",
 "min_tier": 0,
 "pricing": {
 "input": 0.0,
 "cached_input": 0.0,
 "output": 140.0,
 "output_cost_per_image": 0.14
 }
 },
 {
 "id": "stability.stable-image-ultra-v1:0",
 "object": "model",
 "owned_by": "stability",
 "min_tier": 0,
 "pricing": {
 "input": 0.0,
 "cached_input": 0.0,
 "output": 140.0,
 "output_cost_per_image": 0.14
 }
 },
 {
 "id": "stability.stable-image-core-v1:1",
 "object": "model",
 "owned_by": "stability",
 "min_tier": 0,
 "pricing": {
 "input": 0.0,
 "cached_input": 0.0,
 "output": 40.0,
 "output_cost_per_image": 0.04
 }
 },
 {
 "id": "stability.stable-image-core-v1:0",
 "object": "model",
 "owned_by": "stability",
 "min_tier": 0,
 "pricing": {
 "input": 0.0,
 "cached_input": 0.0,
 "output": 40.0,
 "output_cost_per_image": 0.04
 }
 },
 {
 "id": "dall-e-3",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.0,
 "cached_input": 0.0,
 "output": 40.0,
 "output_cost_per_image": 0.04
 },
 "mode": "image_generation"
 },
 {
 "id": "tts-1-hd",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 1,
 "pricing": {
 "input": 30.0,
 "cached_input": 0.0,
 "output": 0.0,
 "input_cost_per_character": 0.00003
 },
 "mode": "audio_speech",
 "supported_endpoints": [
 "/v1/audio/speech"
 ]
 },
 {
 "id": "text-embedding-3-large",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.13,
 "cached_input": 0.06,
 "output": 0.13
 },
 "max_tokens": 8191,
 "max_input_tokens": 8191,
 "mode": "embedding"
 },
 {
 "id": "tts-1",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 15.0,
 "cached_input": 0.0,
 "output": 0.0,
 "input_cost_per_character": 0.000015
 },
 "mode": "audio_speech",
 "supported_endpoints": [
 "/v1/audio/speech"
 ]
 },
 {
 "id": "text-embedding-3-small",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.02,
 "cached_input": 0.01,
 "output": 0.02
 },
 "max_tokens": 8191,
 "max_input_tokens": 8191,
 "mode": "embedding"
 },
 {
 "id": "text-embedding-ada-002",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 0,
 "pricing": {
 "input": 0.1,
 "cached_input": 0.05,
 "output": 0.05
 },
 "max_tokens": 8191,
 "max_input_tokens": 8191,
 "mode": "embedding"
 },
 {
 "id": "text-moderation-latest",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 2,
 "pricing": {
 "input": 0.0,
 "cached_input": 0.0,
 "output": 0.0
 },
 "max_tokens": 32768,
 "max_input_tokens": 32768,
 "max_output_tokens": 0,
 "mode": "moderation"
 },
 {
 "id": "text-moderation-stable",
 "object": "model",
 "owned_by": "openai",
 "min_tier": 2,
 "pricing": {
 "input": 0.0,
 "cached_input": 0.0,
 "output": 0.0
 },
 "max_tokens": 32768,
 "max_input_tokens": 32768,
 "max_output_tokens": 0,
 "mode": "moderation"
 }
 ]
}
''';

// Function to demonstrate parsing and accessing the data
void main() {
  // Parse the model pricing data from the JSON string
  List<ModelPricingInfo> parsedModels = parseModelPricing(_modelPricingJsonData);

  print('--- Imported Model Pricing Information ---');
  print('Total models imported: ${parsedModels.length}\n');


  // Example 1: Accessing specific models and their detailed pricing
  final gpt4oMini = parsedModels.firstWhere((m) => m.id == 'gpt-4o-mini');
  print('Model: ${gpt4oMini.id} (Owned by: ${gpt4oMini.ownedBy})');
  print('  Input Price: ${gpt4oMini.inputPrice ?? 'N/A'}');
  print('  Output Price: ${gpt4oMini.outputPrice ?? 'N/A'}');
  print('  Cached Input Price: ${gpt4oMini.cachedInputPrice ?? 'N/A'}');
  print('  Search Context Pricing (Low): ${gpt4oMini.searchContextCostPerQuery?['search_context_size_low'] ?? 'N/A'}\n');


  final claudeOpus = parsedModels.firstWhere((m) => m.id == 'anthropic.claude-3-opus-20240229-v1:0');
  print('Model: ${claudeOpus.id} (Owned by: ${claudeOpus.ownedBy})');
  print('  Input Price: ${claudeOpus.inputPrice ?? 'N/A'}');
  print('  Output Price: ${claudeOpus.outputPrice ?? 'N/A'}');
  print('  Cached Input Price: ${claudeOpus.cachedInputPrice ?? 'N/A'}\n');

  final whisper1 = parsedModels.firstWhere((m) => m.id == 'whisper-1');
  print('Model: ${whisper1.id} (Owned by: ${whisper1.ownedBy})');
  print('  Input Cost Per Second: ${whisper1.inputCostPerSecond ?? 'N/A'}\n');

  final cohereRerank = parsedModels.firstWhere((m) => m.id == 'cohere.rerank-v3-5:0');
  print('Model: ${cohereRerank.id} (Owned by: ${cohereRerank.ownedBy})');
  print('  Input Cost Per Query: ${cohereRerank.inputCostPerQuery ?? 'N/A'}\n');


  // Example 2: Loop through a few models to show a general overview
  print('--- Sample of All Models and Their Prices ---');
  for (int i = 0; i < (parsedModels.length > 5 ? 5 : parsedModels.length); i++) {
    final model = parsedModels[i];
    print('  ID: ${model.id}');
    print('    Owned By: ${model.ownedBy}');
    print('    Input: ${model.inputPrice ?? 'N/A'}');
    print('    Output: ${model.outputPrice ?? 'N/A'}');
    print('    Cached Input: ${model.cachedInputPrice ?? 'N/A'}');
    if (model.inputCostPerSecond != null) {
      print('    Input Cost/Sec: ${model.inputCostPerSecond}');
    }
    if (model.inputCostPerQuery != null) {
      print('    Input Cost/Query: ${model.inputCostPerQuery}');
    }
    if (model.searchContextCostPerQuery != null) {
      print('    Search Context Costs: ${model.searchContextCostPerQuery}');
    }
    print('');
  }

  // Demonstration of existing PriceInfo functions (still functional for predefined models)
  print('--- Existing PriceInfo Lookup ---');
  final gpt4Prices = getPrices('gpt-4');
  if (gpt4Prices != null) {
    print('Traditional gpt-4 pricing:');
    print('  Input: ${gpt4Prices.input}');
    print('  Output: ${gpt4Prices.output}');
    print('  Cached Input: ${gpt4Prices.inputCache}');
  }
}