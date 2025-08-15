import 'dart:convert';

import 'package:miko/ai/functions/ai_browser_functions.dart';
import 'package:miko/ai/tools/ai_browser_tools.dart';
import 'package:miko/configs/consts2.dart';
import 'package:openai_dart/openai_dart.dart';
final client = OpenAIClient(
  apiKey: webVieApiKey,
  baseUrl: webViewBaseUrl,
);
class AssistantService {
  final WebViewAIController webViewAIController;
  final Function(String message) onNewMessage; // Callback to update UI

  // This holds the entire conversation history
  final List<ChatCompletionMessage> _messages = [];

  AssistantService({
    required this.webViewAIController,
    required this.onNewMessage,
  }) {
    // Start with a system prompt that defines the AI's role and rules.
    _messages.add(
      ChatCompletionMessage.system(
        content: """
    You are an advanced web browsing assistant.
    Your goal is to help the user accomplish tasks on the web.
    You operate in a strict loop: SEE, DECIDE, ACT.

    1. **SEE**: ALWAYS start by using the `getInteractiveElements` tool to see what is on the page. This gives you a list of elements and their IDs.
    2. **DECIDE**: Based on the user's request and the list of elements, decide what to do next. If you need to type, find the correct input element's ID. If you need to click, find the correct button or link's ID.
    3. **ACT**: Use the `typeInElementByAiId` or `clickElementByAiId` tools with the ID you chose.
    4. **CONFIRM**: After an action, you can use `readTextContent` to see the result of your action or call `getInteractiveElements` again to see how the page has changed.
    5. **RESPOND**: When the task is fully complete, provide a final, concise answer to the user. Do not mention your tools or IDs in the final answer.
    """,
      ),
    );
  }

  Future<void> processUserPrompt(String prompt) async {
    onNewMessage("User: $prompt");
    _messages.add(
      ChatCompletionMessage.user(
        content: ChatCompletionUserMessageContent.string(prompt),
      ),
    );

    // Start the agent loop
    while (true) {
      final res = await client.createChatCompletion(
        request: CreateChatCompletionRequest(
          model: ChatCompletionModel.modelId('gpt-4.1-mini'),
          messages: _messages,
          tools: allTools,
          toolChoice: ChatCompletionToolChoiceOption.mode(
            ChatCompletionToolChoiceMode.auto,
          ),
        ),
      );
      final choice = res.choices.first;
      final message = choice.message;

      // Add the AI's response to history (whether it's a tool call or text)
      _messages.add(message);

      if (message.toolCalls == null || message.toolCalls!.isEmpty) {
        // The AI has finished and is giving a final text response.
        onNewMessage("Assistant: ${message.content}");
        break; // Exit the loop
      }

      // The AI wants to use one or more tools.
      for (final toolCall in message.toolCalls!) {
        final functionCall = toolCall.function;
        final arguments =
            json.decode(functionCall.arguments) as Map<String, dynamic>;

        onNewMessage(
          "🤖 Calling tool: ${functionCall.name} with args: $arguments",
        );

        // --- The Tool Dispatcher ---
        String functionResult;
        try {
          switch (functionCall.name) {
            case 'loadUrl':
              functionResult = await webViewAIController.loadUrl(
                arguments['url'] as String,
              );
              break;
            case 'typeInElement':
              functionResult = await webViewAIController.typeInElement(
                arguments['selector'] as String,
                arguments['text'] as String,
              );
              break;
            case 'clickElement':
              functionResult = await webViewAIController.clickElement(
                arguments['selector'] as String,
              );
              break;
            case 'readTextContent':
              functionResult = await webViewAIController.readTextContent(
                selector: arguments['selector'] as String?,
              );
              break;
            case 'getInteractiveElements':
              functionResult = await webViewAIController
                  .getInteractiveElements();
              break;
            case 'typeInElementByAiId':
              functionResult = await webViewAIController.typeInElementByAiId(
                arguments['aiId'] as String,
                arguments['text'] as String,
              );
              break;
            case 'clickElementByAiId':
              functionResult = await webViewAIController.clickElementByAiId(
                arguments['aiId'] as String,
              );
              break;
            case 'waitForElement':
              functionResult = await webViewAIController.waitForElement(
                arguments['selector'] as String,
                timeout: arguments.containsKey('timeoutMilliseconds')
                    ? Duration(
                        milliseconds: arguments['timeoutMilliseconds'] as int,
                      )
                    : const Duration(seconds: 15),
              );
              break;
            case 'getElementValue':
              functionResult = await webViewAIController.getElementValue(
                arguments['selector'] as String,
              );
              break;
            case 'selectDropdownOption':
              functionResult = await webViewAIController.selectDropdownOption(
                arguments['selector'] as String,
                arguments['valueOrText'] as String,
                byValue: (arguments['byValue'] as bool?) ?? true,
              );
              break;
            case 'submitForm':
              functionResult = await webViewAIController.submitForm(
                arguments['selector'] as String,
              );
              break;
            case 'getElementAttributes':
              {
                final result = await webViewAIController.getElementAttributes(
                  arguments['selector'] as String,
                  (arguments['attributes'] as List).cast<String>(),
                );
                functionResult = jsonEncode(
                  result,
                ); // Encode Map to JSON string
              }
              break;
            case 'scrollIntoView':
              functionResult = await webViewAIController.scrollIntoView(
                arguments['selector'] as String,
                smooth: (arguments['smooth'] as bool?) ?? true,
                block: (arguments['block'] as String?) ?? 'center',
              );
              break;
            case 'scrollPage':
              functionResult = await webViewAIController.scrollPage(
                arguments['x'] as int,
                arguments['y'] as int,
                smooth: (arguments['smooth'] as bool?) ?? true,
              );
              break;
            case 'evaluateJavaScript':
              functionResult = await webViewAIController.evaluateJavaScript(
                arguments['script'] as String,
              );
              break;
            case 'getTextsOfAllElements':
              {
                final result = await webViewAIController.getTextsOfAllElements(
                  arguments['selector'] as String,
                );
                functionResult = jsonEncode(
                  result,
                ); // Encode List to JSON string
              }
              break;
            default:
              functionResult = "Error: Unknown tool '${functionCall.name}'";
          }
        } catch (e) {
          functionResult = "Error calling tool ${functionCall.name}: $e";
          print(
            "Error during tool call: $e",
          ); // Log the actual error for debugging
        }

        onNewMessage("Tool result: $functionResult");

        // Add the tool's result to the message history for the AI's next turn.
        _messages.add(
          ChatCompletionMessage.tool(
            toolCallId: toolCall.id,
            content: functionResult,
          ),
        );
      }
      // Continue the loop to let the AI process the tool results.
    }
  }
}
