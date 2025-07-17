// Of course. Based on the `getMovieRecommendations` function and data models you've provided, I will create a perfectly structured AI tool in the OpenAI Tools API format using the pattern you specified.

// This tool will allow the AI to intelligently request movie recommendations based on a specific movie ID, which it can then use to formulate a helpful response to the user.

// Here is the complete implementation in Flutter/Dart.

// ### 1. Tool Schema and Function Definition

// First, we define the tool's schema (`FunctionObject`) which tells the AI what the function does and what parameters it needs. Then, we create the wrapper function that executes your existing app logic and formats the result for the AI.

// ```dart
// import 'dart:convert';
// import 'package:http/http.dart' as http; // Make sure to have http package
// Assuming your Movie models and API service are in these files
// import 'path/to/your/movie_models.dart';
// import 'path/to/your/api_service.dart';

// Your existing models (MovieResponse, Movie, etc.) are assumed to be available.
// I've included placeholder classes for this code to be self-contained.
// In your app, you would REMOVE these placeholders and import your real models.

// // --- START: Placeholder Models (Remove in your actual code) ---
// class Movie {
//   final int id;
//   final String title;
//   final String overview;
//   final String releaseDate;
//   final double voteAverage;
//   Movie({required this.id, required this.title, required this.overview, required this.releaseDate, required this.voteAverage});
//   // Your real factory constructor and methods would be here
//   factory Movie.fromJson(Map<String, dynamic> json) => Movie(
//     id: json['id'] ?? 0,
//     title: json['title'] ?? '',
//     overview: json['overview'] ?? '',
//     releaseDate: json['release_date'] ?? '',
//     voteAverage: (json['vote_average'] ?? 0.0).toDouble(),
//   );
// }

// class MovieResponse {
//   final int page;
//   final List<Movie> results;
//   final int totalPages;
//   MovieResponse({required this.page, required this.results, required this.totalPages});
//   factory MovieResponse.fromJson(Map<String, dynamic> json) => MovieResponse(
//     page: json['page'] ?? 1,
//     results: (json['results'] as List?)?.map((m) => Movie.fromJson(m)).toList() ?? [],
//     totalPages: json['total_pages'] ?? 0,
//   );
// }
// --- END: Placeholder Models ---


// // --- START: OpenAI Tool Definition ---

// /// 1. Defines the structure and purpose of the movie recommendation function for the AI.

// /// 3. Wrapper function to call your app's logic and format the output.
// /// This function is called when the AI decides to use the 'getMovieRecommendations' tool.
// /// It returns a Future<Map<String, dynamic>> which will be JSON encoded and sent back to the AI.



// // --- This is your actual application logic ---
// // In a real app, this would be inside your ApiService class.
// // For this example, we'll create a placeholder that simulates the API call
// ### 2. Explain & Example

// The code above creates a robust tool for your AI assistant.

// **Explanation:**

// 1.  **`_movieRecommendFunction` (`FunctionObject`)**: This is the schema. It's a detailed "manual" for the AI. It explains that a function named `getMovieRecommendations` exists, what it's for ("Fetches a list of recommended movies..."), and exactly what data it needs (`movieId`, with optional `page` and `language`). The AI analyzes the user's request and uses this schema to decide if this tool is the right one for the job.

// 2.  **`_getMovieRecommendationsToolWrapper`**: This is the bridge between the AI and your app's code. When the AI decides to call the tool, the OpenAI SDK doesn't run your `getMovieRecommendations` function directly. Instead, it signals your app that a tool call is needed. Your code then calls this wrapper. The wrapper's job is to:
//     *   Take the parameters provided by the AI (`movieId`, etc.).
//     *   Execute your actual application logic (`await getMovieRecommendations(...)`).
//     *   Take the complex `MovieResponse` object and simplify it into a clean `Map`. This is crucial because the AI works best with straightforward, structured data. We return only the most relevant fields (`id`, `title`, `overview`, etc.).
//     *   Return this simplified `Map`, which gets sent back to the AI.

// 3.  **The Two-Step Flow**: Function calling is a two-step process.
//     *   **Step 1**: Your app sends the user's message and the list of available tools (`movieRecommendTool`) to the AI. The AI responds not with a chat message, but with a `tool_calls` object, saying "Please run the `getMovieRecommendations` function with `movieId: 27205`".
//     *   **Step 2**: Your app executes the tool call (via the wrapper function), gets the movie list, and sends the result back to the AI in a new message. Now, with the data it requested, the AI can formulate a natural language response like "Based on that movie, here are a couple of other films you might enjoy...".

// **Example of Use:**


// Future<String> getAiResponse(
//     List<ChatCompletionMessage> messages,
//     // Assume client is your configured OpenAI client instance
//     OpenAIClient client,
//   ) async {
//   try {
//     // Step 1: Send user message with the tool definition to the AI
//     final res1 = await client.createChatCompletion(
//       request: CreateChatCompletionRequest(
//         model: ChatCompletionModel.modelId('gpt-4o'), // Or another tool-enabled model
//         messages: messages,
//         tools: [movieRecommendTool], // Provide our new movie tool
//         toolChoice: ChatCompletionToolChoiceOption.mode(
//             ChatCompletionToolChoiceMode.auto),
//       ),
//     );

//     final choice1 = res1.choices.first;
//     final message1 = choice1.message;

//     // Check if the AI wants to call our function
//     if (message1.toolCalls != null && message1.toolCalls!.isNotEmpty) {
//       final toolCall = message1.toolCalls!.first;

//       // Make sure the AI is calling the function we expect
//       if (toolCall.function.name == _movieRecommendFunction.name) {
//         final arguments = json.decode(toolCall.function.arguments) as Map<String, dynamic>;

//         // Call our wrapper function with the arguments provided by the AI
//         final functionResult = await _getMovieRecommendationsToolWrapper(
//           movieId: arguments['movieId'] as int,
//           page: arguments['page'] as int?, // Handle optional params
//           language: arguments['language'] as String?,
//         );

//         // Step 2: Send the result of the function call back to the AI
//         messages.add(message1); // Add the AI's tool_calls message
//         messages.add(ChatCompletionMessage.tool(
//           toolCallId: toolCall.id,
//           content: json.encode(functionResult), // Provide the tool's output
//         ));

//         final res2 = await client.createChatCompletion(
//           request: CreateChatCompletionRequest(
//             model: ChatCompletionModel.modelId('gpt-4o'),
//             messages: messages,
//           ),
//         );

//         // The AI now has the context and the data to give a final, user-friendly answer
//         return res2.choices.first.message.content ??
//             'No content received after tool call.';
//       } else {
//         return 'Error: AI requested an unknown tool: ${toolCall.function.name}';
//       }
//     } else {
//       // The AI responded directly without calling a tool
//       return message1.content ?? 'No tool call or content.';
//     }
//   } catch (e) {
//     return 'An error occurred: $e';
//   }
// }
