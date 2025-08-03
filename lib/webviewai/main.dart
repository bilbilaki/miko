import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:miko/configs/consts.dart';
import 'package:openai_dart/openai_dart.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'dart:ui';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MaterialApp(home: AdvancedWebViewer()));
}

class AdvancedWebViewer extends StatefulWidget {
  const AdvancedWebViewer({Key? key}) : super(key: key);

  @override
  State<AdvancedWebViewer> createState() => _AdvancedWebViewerState();
}

class _AdvancedWebViewerState extends State<AdvancedWebViewer>
    with WidgetsBindingObserver {
  // All state and controllers now live here
  late final WebViewController _webViewController;
  late final AssistantService _assistantService;
  var loadingPercentage = 0;

  final TextEditingController _promptController = TextEditingController();
  final List<String> _chatMessages = [];
  bool _isAssistantProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // CORRECT: Initialize the controller here in the parent widget's initState
    _webViewController = WebViewController()
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      ) // ESSENTIAL for your JS tools
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              loadingPercentage = 0;
            });
          },
          onProgress: (progress) {
            setState(() {
              loadingPercentage = progress;
            });
          },
          onPageFinished: (url) {
            setState(() {
              loadingPercentage = 100;
            });
          },
          onWebResourceError: (error) {
            // Handle errors, e.g., show a snackbar
            debugPrint('''
            Page resource error:
            code: ${error.errorCode}
            description: ${error.description}
            errorType: ${error.errorType}
            isForMainFrame: ${error.isForMainFrame}
          ''');
          },
        ),
      )
      ..loadRequest(
        // Start with a known page
        Uri.parse('https://duckduckgo.com/'),
      );

    // Initialize the assistant service once the webview is ready
    _assistantService = AssistantService(
      webViewAIController: WebViewAIController(_webViewController),
      onNewMessage: (message) {
        _addChatMessage(message);
      },
    );
  }

  void _addChatMessage(String message) {
    setState(() {
      _chatMessages.insert(0, message); // Add to the top of the list
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _promptController.dispose();
    super.dispose();
  }

  @override
  Future<AppExitResponse> didRequestAppExit() async {
    // You can add logic here to ask the user for confirmation
    return AppExitResponse.exit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Web Assistant'),
        backgroundColor: Colors.blueGrey[800],
        actions: [
          // The controller is now correctly initialized before being used here
          NavigationControls(controller: _webViewController),
        ],
      ),
      // CORRECTED LAYOUT: Use a Column to separate WebView and Chat UI
      body: Column(
        children: [
          // The WebView area
          Expanded(
            flex: 3, // Takes 3/5 of the screen
            child: WebViewStack(
              controller: _webViewController,
              loadingPercentage: loadingPercentage,
            ),
          ),
          // The Chat UI area
          Expanded(
            flex: 2, // Takes 2/5 of the screen
            child: Container(
              color: Colors.grey[200],
              child: Column(
                children: [
                  // Chat history
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: _chatMessages.length,
                      itemBuilder: (context, index) {
                        final message = _chatMessages[index];
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          margin: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: message.startsWith("User:")
                                ? Colors.blue[100]
                                : (message.startsWith("🤖")
                                      ? Colors.green[100]
                                      : Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(message),
                        );
                      },
                    ),
                  ),
                  // Input field
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _promptController,
                            decoration: const InputDecoration(
                              hintText: 'e.g., "search for cute cat pictures"',
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: _isAssistantProcessing
                                ? null
                                : _handleSubmitted,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_isAssistantProcessing)
                          const CircularProgressIndicator()
                        else
                          IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: () =>
                                _handleSubmitted(_promptController.text),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;
    final prompt = text.trim();
    _promptController.clear();
    _addChatMessage("User: $prompt"); // Show user's prompt immediately
    setState(() {
      _isAssistantProcessing = true;
    });

    try {
      await _assistantService.processUserPrompt(prompt);
    } catch (e) {
      _addChatMessage("An error occurred: $e");
    } finally {
      setState(() {
        _isAssistantProcessing = false;
      });
    }
  }
}

// SIMPLIFIED WIDGET: This widget now only displays the webview and progress bar.
// It receives all its data from the parent.
class WebViewStack extends StatelessWidget {
  const WebViewStack({
    required this.controller,
    required this.loadingPercentage,
    super.key,
  });

  final WebViewController controller;
  final int loadingPercentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: controller),
        if (loadingPercentage < 100)
          LinearProgressIndicator(value: loadingPercentage / 100.0),
      ],
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls({required this.controller, super.key});

  final WebViewController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            if (await controller.canGoBack()) {
              await controller.goBack();
            } else {
              messenger.showSnackBar(
                const SnackBar(content: Text('No back history item')),
              );
              return;
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            if (await controller.canGoForward()) {
              await controller.goForward();
            } else {
              messenger.showSnackBar(
                const SnackBar(content: Text('No forward history item')),
              );
              return;
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () {
            controller.reload();
          },
        ),
      ],
    );
  }
}

class WebViewAIController {
  final WebViewController controller;

  WebViewAIController(this.controller);

  /// Navigates to a specific URL.
  Future<String> loadUrl(String url) async {
    try {
      await controller.loadRequest(Uri.parse(url));
      // It's better to wait for the page to finish loading.
      // This is a simplification; a full solution would use onPageFinished callback.
      await Future.delayed(const Duration(seconds: 3));
      final currentUrl = await controller.currentUrl();
      if (currentUrl != null && currentUrl.contains(url)) {
        return "Successfully loaded URL: $url";
      } else {
        return "Failed to load URL: $url. Current URL is $currentUrl";
      }
    } catch (e) {
      return "Error loading URL: $e";
    }
  }

  // Future<String> typeInElement(String selector, String text) async {
  //   final escapedText = jsonEncode(text);

  //   final js = """
  //     (function() {
  //       try {
  //         const element = document.querySelector('$selector');
  //         if (element) {
  //           element.value = $escapedText;
  //           // This event is important for some frameworks (like React) to recognize the change
  //           element.dispatchEvent(new Event('input', { bubbles: true }));
  //           return 'Successfully typed "$text" into element with selector "$selector".';
  //         } else {
  //           return 'Error: Element with selector "$selector" not found.';
  //         }
  //       } catch (e) {
  //         return 'Error executing script for typing: ' + e.message;
  //       }
  //     })();
  //   """;
  //   final result = await controller.runJavaScriptReturningResult(js);
  //   return result.toString().replaceAll('"', ''); // Also good to sanitize quotes
  // }

  /// Clicks an element found by a CSS selector.
  // Future<String> clickElement(String selector) async {
  //   //
  //   // Notice the new (function() { ... })(); wrapper
  //   //
  //   final js = """
  //     (function() {
  //       try {
  //         const element = document.querySelector('$selector');
  //         if (element) {
  //           element.click();
  //           return 'Successfully clicked element with selector "$selector".';
  //         } else {
  //           return 'Error: Element with selector "$selector" not found.';
  //         }
  //       } catch (e) {
  //         return 'Error executing script for clicking: ' + e.message;
  //       }
  //     })();
  //   """;
  //   final result = await controller.runJavaScriptReturningResult(js);
  //   return result.toString().replaceAll('"', '');
  // }

  /// Reads the visible text content of the entire page or a specific element.
  Future<String> readTextContent({String? selector}) async {
    final target = selector != null
        ? "document.querySelector('$selector')"
        : "document.body";
    //
    // Notice the new (function() { ... })(); wrapper
    //
    final js =
        """
      (function() {
        try {
          const element = $target;
          if (element) {
            // Limit the text length to avoid overflowing the AI's context window
            let text = element.innerText || element.textContent;
            return text.trim().substring(0, 4000);
          } else {
            return 'Error: Element with selector "$selector" not found.';
          }
        } catch (e) {
          return 'Error reading content: ' + e.message;
        }
      })();
    """;
    final result = await controller.runJavaScriptReturningResult(js);
    return result.toString().replaceAll('"', '').trim();
  }

  Future<String> getInteractiveElements() async {
    const js = r"""
    (function() {
        const elements = document.querySelectorAll('a, button, input, textarea, select, [role="button"], [role="link"]');
        const visibleElements = [];
        let idCounter = 1;

        elements.forEach(el => {
            const rect = el.getBoundingClientRect();
            // Check if element is visible in the viewport
            if (rect.width > 0 && rect.height > 0 && rect.top < window.innerHeight && rect.bottom > 0 && rect.left < window.innerWidth && rect.right > 0) {
                // Assign a temporary ID for this run
                const aiId = `ai-id-${idCounter++}`;
                el.setAttribute('data-ai-id', aiId);

                let description = el.getAttribute('aria-label') || el.textContent.trim() || el.value || el.placeholder || el.name || 'no description';
                description = description.replace(/\s+/g, ' ').substring(0, 100);

                visibleElements.push({
                    id: aiId,
                    tagName: el.tagName.toLowerCase(),
                    description: description
                });
            }
        });
        return JSON.stringify(visibleElements);
    })();
  """;
    final result = await controller.runJavaScriptReturningResult(js);
    return result.toString();
  }

  // We also need ID-based versions of click and type
  Future<String> clickElementByAiId(String aiId) async {
    final js =
        """
    (function() {
      const el = document.querySelector(`[data-ai-id="${aiId}"]`);
      if (el) { el.click(); return `Clicked element with id ${aiId}`; }
      return `Error: Element with id ${aiId} not found.`;
    })();
  """;
    return (await controller.runJavaScriptReturningResult(js)).toString();
  }

  Future<String> typeInElementByAiId(String aiId, String text) async {
    final escapedText = jsonEncode(text);
    final js =
        """
    (function() {
      const el = document.querySelector(`[data-ai-id="${aiId}"]`);
      if (el) {
        el.value = $escapedText;
        el.dispatchEvent(new Event('input', { bubbles: true }));
        return `Typed into element with id ${aiId}`;
      }
      return `Error: Element with id ${aiId} not found.`;
    })();
  """;
    return (await controller.runJavaScriptReturningResult(js)).toString();
  }

  Future<String> waitForElement(
    String selector, {
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final js =
        """
    (function() {
      return new Promise((resolve, reject) => {
        const startTime = Date.now();
        const intervalTime = 100; // Check every 100ms
        const maxWaitTime = ${timeout.inMilliseconds};

        const checkElement = () => {
          const element = document.querySelector('$selector');
          if (element && element.offsetParent !== null) { // Check for presence and visibility (offsetParent check is a common way)
            resolve('success');
          } else if (Date.now() - startTime > maxWaitTime) {
            reject('Timeout: Element with selector "$selector" not found or not visible within ${timeout.inSeconds} seconds.');
          } else {
            setTimeout(checkElement, intervalTime);
          }
        };
        checkElement();
      });
    })();
    """;
    try {
      final result = await controller.runJavaScriptReturningResult(js);
      return result.toString().replaceAll('"', '');
    } catch (e) {
      return 'Error waiting for element: ' + e.toString();
    }
  }

  /// Types text into an element found by a CSS selector, ensuring focus and handling common input events.
  /// Improved from the original to handle more complex scenarios like contenteditable.
  Future<String> typeInElement(String selector, String text) async {
    final escapedText = jsonEncode(text);
    final js =
        """
    (function() {
      try {
        const element = document.querySelector('$selector');
        if (element) {
          element.focus();
          // For input/textarea
          if (element.tagName === 'INPUT' || element.tagName === 'TEXTAREA') {
            element.value = $escapedText;
            element.dispatchEvent(new Event('input', { bubbles: true }));
            element.dispatchEvent(new Event('change', { bubbles: true })); // Important for some frameworks
          }
          // For contenteditable elements
          else if (element.isContentEditable) {
            element.innerHTML = $escapedText;
            element.dispatchEvent(new Event('input', { bubbles: true }));
            element.dispatchEvent(new Event('blur', { bubbles: true })); // Force blur to trigger any change handlers
          } else {
             return 'Error: Element with selector "$selector" is not a standard input or contenteditable.';
          }
          return 'Successfully typed "$text" into element with selector "$selector".';
        } else {
          return 'Error: Element with selector "$selector" not found.';
        }
      } catch (e) {
        return 'Error executing script for typing: ' + e.message;
      }
    })();
    """;
    final result = await controller.runJavaScriptReturningResult(js);
    return result.toString().replaceAll('"', '');
  }

  /// Clicks an element found by a CSS selector, ensuring element is clickable.
  /// Adds a scrollIntoView and basic clickability check.
  Future<String> clickElement(String selector) async {
    final js =
        """
    (function() {
      try {
        const element = document.querySelector('$selector');
        if (element) {
          if (typeof element.click === 'function') {
            element.scrollIntoView({ behavior: 'smooth', block: 'center' }); // Scroll into view first
            element.click();
            return 'Successfully clicked element with selector "$selector".';
          } else {
            return 'Error: Element with selector "$selector" is not clickable.';
          }
        } else {
          return 'Error: Element with selector "$selector" not found.';
        }
      } catch (e) {
        return 'Error executing script for clicking: ' + e.message;
      }
    })();
    """;
    final result = await controller.runJavaScriptReturningResult(js);
    return result.toString().replaceAll('"', '');
  }

  /// Gets the value of an input, textarea, or selected option of a select element.
  Future<String> getElementValue(String selector) async {
    final js =
        """
    (function() {
      try {
        const element = document.querySelector('$selector');
        if (element) {
          if (element.tagName === 'SELECT') {
            return element.options[element.selectedIndex].value;
          }
          return element.value || element.textContent || element.innerText || '';
        } else {
          return 'Error: Element with selector "$selector" not found.';
        }
      } catch (e) {
        return 'Error getting element value: ' + e.message;
      }
    })();
    """;
    final result = await controller.runJavaScriptReturningResult(js);
    return result.toString().replaceAll('"', '').trim();
  }

  /// Selects an option in a <select> dropdown by its value or visible text.
  Future<String> selectDropdownOption(
    String selector,
    String valueOrText, {
    bool byValue = true,
  }) async {
    final escapedValueOrText = jsonEncode(valueOrText);
    final js =
        """
    (function() {
      try {
        const selectElement = document.querySelector('$selector');
        if (selectElement && selectElement.tagName === 'SELECT') {
          let optionFound = false;
          for (let i = 0; i < selectElement.options.length; i++) {
            const option = selectElement.options[i];
            if (${byValue ? 'option.value === ' : 'option.text === '} $escapedValueOrText) {
              selectElement.selectedIndex = i;
              optionFound = true;
              // Trigger change events
              selectElement.dispatchEvent(new Event('change', { bubbles: true }));
              selectElement.dispatchEvent(new Event('input', { bubbles: true }));
              break;
            }
          }
          if (optionFound) {
            return 'Successfully selected "$valueOrText" in dropdown "$selector".';
          } else {
            return 'Error: Option "$valueOrText" not found in dropdown "$selector".';
          }
        } else {
          return 'Error: Select element with selector "$selector" not found.';
        }
      } catch (e) {
        return 'Error selecting dropdown option: ' + e.message;
      }
    })();
    """;
    final result = await controller.runJavaScriptReturningResult(js);
    return result.toString().replaceAll('"', '');
  }

  /// Submits the form containing the element identified by the selector, or the form itself.
  Future<String> submitForm(String selector) async {
    final js =
        """
    (function() {
      try {
        const element = document.querySelector('$selector');
        if (element) {
          let formElement = element.tagName === 'FORM' ? element : element.closest('form');
          if (formElement) {
            formElement.submit();
            return 'Successfully submitted form for element with selector "$selector".';
          } else {
            return 'Error: No form found for element with selector "$selector".';
          }
        } else {
          return 'Error: Element with selector "$selector" not found.';
        }
      } catch (e) {
        return 'Error submitting form: ' + e.message;
      }
    })();
    """;
    final result = await controller.runJavaScriptReturningResult(js);
    return result.toString().replaceAll('"', '');
  }

  /// Gets specific attributes (e.g., 'href', 'src', 'alt', 'class') of an element.
  /// Returns a JSON string of attribute-value pairs.
  Future<Map<String, String>> getElementAttributes(
    String selector,
    List<String> attributes,
  ) async {
    final escapedAttributes = jsonEncode(attributes);
    final js =
        """
    (function() {
      try {
        const element = document.querySelector('$selector');
        const result = {};
        if (element) {
          const attributes = $escapedAttributes;
          attributes.forEach(attr => {
            const value = element.getAttribute(attr);
            if (value !== null) {
              result[attr] = value;
            }
          });
          return JSON.stringify(result);
        } else {
          return JSON.stringify({ error: 'Element with selector "$selector" not found.' });
        }
      } catch (e) {
        return JSON.stringify({ error: 'Error getting attributes: ' + e.message });
      }
    })();
    """;
    final result = await controller.runJavaScriptReturningResult(js);
    final String jsonResult = result.toString();
    try {
      final decoded = jsonDecode(jsonResult);
      if (decoded is Map<String, dynamic>) {
        if (decoded.containsKey('error')) {
          throw Exception(decoded['error']);
        }
        return decoded.map((key, value) => MapEntry(key, value.toString()));
      }
      return {};
    } catch (e) {
      print(
        'Failed to parse attributes JSON: $jsonResult, Error: $e',
      ); // For debugging
      return {'error': 'Failed to parse JSON response or script error: $e'};
    }
  }

  /// Scrolls the page to a specific element by selector.
  Future<String> scrollIntoView(
    String selector, {
    bool smooth = true,
    String block = 'center',
  }) async {
    // block can be 'start', 'center', 'end', or 'nearest'
    final js =
        """
    (function() {
      try {
        const element = document.querySelector('$selector');
        if (element) {
          element.scrollIntoView({ behavior: '${smooth ? 'smooth' : 'auto'}', block: '$block' });
          return 'Successfully scrolled element with selector "$selector" into view.';
        } else {
          return 'Error: Element with selector "$selector" not found.';
        }
      } catch (e) {
        return 'Error scrolling element into view: ' + e.message;
      }
    })();
    """;
    final result = await controller.runJavaScriptReturningResult(js);
    return result.toString().replaceAll('"', '');
  }

  /// Scrolls the entire page.
  Future<String> scrollPage(int x, int y, {bool smooth = true}) async {
    final js =
        """
    (function() {
      try {
        window.scrollBy({ top: $y, left: $x, behavior: '${smooth ? 'smooth' : 'auto'}' });
        return 'Successfully scrolled page by x: $x, y: $y.';
      } catch (e) {
        return 'Error scrolling page: ' + e.message;
      }
    })();
    """;
    final result = await controller.runJavaScriptReturningResult(js);
    return result.toString().replaceAll('"', '');
  }

  /// Executes arbitrary JavaScript and returns its result (serialized to string).
  /// This is the most powerful and flexible method, allowing you to run any custom logic.
  /// Ensure your JS returns a serializable value (string, number, boolean, array, object).
  Future<String> evaluateJavaScript(String script) async {
    try {
      // Wrap in IIFE to prevent variable leaks and ensure proper execution context
      final wrappedJs =
          """
      (function() {
        try {
          // You can put any complex JS logic here
          const result = ${script.trim().endsWith(';') ? script : script + ';'}; // Ensure semicolon for last statement
          return JSON.stringify(result); // Always return JSON stringified result
        } catch (e) {
          return JSON.stringify({ error: 'JS execution error: ' + e.message });
        }
      })();
      """;
      final result = await controller.runJavaScriptReturningResult(wrappedJs);
      final String rawResult = result.toString();
      try {
        final decoded = jsonDecode(rawResult);
        if (decoded is Map<String, dynamic> && decoded.containsKey('error')) {
          throw Exception(decoded['error']);
        }
        return decoded.toString(); // Return as string
      } catch (jsonError) {
        // If it's not JSON, return as is (e.g., numbers, simple strings)
        return rawResult.replaceAll(
          '"',
          '',
        ); // Remove quotes for basic string results
      }
    } catch (e) {
      return 'Error evaluating JavaScript: ' + e.toString();
    }
  }

  /// Retrieves the text content of all elements matching a selector.
  /// Returns a JSON array of strings.
  Future<List<String>> getTextsOfAllElements(String selector) async {
    final js =
        """
    (function() {
      try {
        const elements = document.querySelectorAll('$selector');
        const texts = [];
        elements.forEach(el => {
          let text = el.innerText || el.textContent;
          texts.push(text ? text.trim() : '');
        });
        return JSON.stringify(texts);
      } catch (e) {
        return JSON.stringify({ error: 'Error getting texts: ' + e.message });
      }
    })();
    """;
    final result = await controller.runJavaScriptReturningResult(js);
    final String jsonResult = result.toString();
    try {
      final decoded = jsonDecode(jsonResult);
      if (decoded is Map<String, dynamic> && decoded.containsKey('error')) {
        throw Exception(decoded['error']);
      }
      if (decoded is List) {
        return decoded.map((e) => e.toString()).toList();
      }
      return [];
    } catch (e) {
      return ['Error: Failed to parse JSON response or script error: $e'];
    }
  }
}

const loadUrlTool = ChatCompletionTool(
  type: ChatCompletionToolType.function,
  function: FunctionObject(
    name: 'loadUrl',
    description: 'Navigates the web browser to a specific URL.',
    parameters: {
      'type': 'object',
      'properties': {
        'url': {
          'type': 'string',
          'description': 'The full URL to load, including https://',
        },
      },
      'required': ['url'],
    },
  ),
);

const typeInElementTool = ChatCompletionTool(
  type: ChatCompletionToolType.function,
  function: FunctionObject(
    name: 'typeInElement',
    description:
        'Types text into an input field, textarea, or other editable element on the page.',
    parameters: {
      'type': 'object',
      'properties': {
        'selector': {
          'type': 'string',
          'description':
              'A CSS selector to find the target element (e.g., "#search", "input[name=\'q\']").',
        },
        'text': {
          'type': 'string',
          'description': 'The text to type into the element.',
        },
      },
      'required': ['selector', 'text'],
    },
  ),
);

const clickElementTool = ChatCompletionTool(
  type: ChatCompletionToolType.function,
  function: FunctionObject(
    name: 'clickElement',
    description:
        'Clicks a button, link, or any other clickable element on the page.',
    parameters: {
      'type': 'object',
      'properties': {
        'selector': {
          'type': 'string',
          'description':
              'A CSS selector to find the clickable element (e.g., "button[type=\'submit\']", "#login-btn").',
        },
      },
      'required': ['selector'],
    },
  ),
);

const readTextContentTool = ChatCompletionTool(
  type: ChatCompletionToolType.function,
  function: FunctionObject(
    name: 'readTextContent',
    description:
        'Reads the visible text from the page. Use this to understand the page content, find information, or confirm an action was successful. Can be used on the whole page or a specific element.',
    parameters: {
      'type': 'object',
      'properties': {
        'selector': {
          'type': 'string',
          'description':
              '(Optional) A CSS selector to read text from a specific element instead of the whole page.',
        },
      },
      'required': [],
    },
  ),
);
const getInteractiveElementsTool = ChatCompletionTool(
  type: ChatCompletionToolType.function,
  function: FunctionObject(
    name: 'getInteractiveElements',
    description:
        'Scans the current webpage and returns a JSON list of all visible, interactive elements (links, buttons, inputs). Call this first to understand what is on the page.',
    parameters: {'type': 'object', 'properties': {}},
  ),
);

// MODIFIED ACTION TOOLS
const typeInElementByIdTool = ChatCompletionTool(
  type: ChatCompletionToolType.function,
  function: FunctionObject(
    name: 'typeInElementByAiId',
    description:
        'Types text into an element using the ID from getInteractiveElements.',
    parameters: {
      'type': 'object',
      'properties': {
        'aiId': {
          'type': 'string',
          'description': 'The data-ai-id of the target element.',
        },
        'text': {'type': 'string', 'description': 'The text to type.'},
      },
      'required': ['aiId', 'text'],
    },
  ),
);

const clickElementByIdTool = ChatCompletionTool(
  type: ChatCompletionToolType.function,
  function: FunctionObject(
    name: 'clickElementByAiId',
    description: 'Clicks an element using the ID from getInteractiveElements.',
    parameters: {
      'type': 'object',
      'properties': {
        'aiId': {
          'type': 'string',
          'description': 'The data-ai-id of the target element.',
        },
      },
      'required': ['aiId'],
    },
  ),
);

// Keep loadUrl and readTextContent as they are useful.

const waitForElementTool = ChatCompletionTool(
  type: ChatCompletionToolType.function,
  function: FunctionObject(
    name: 'waitForElement',
    description:
        'Waits for an element identified by a CSS selector to appear in the DOM and become visible. Useful before interacting with dynamically loaded content.',
    parameters: {
      'type': 'object',
      'properties': {
        'selector': {
          'type': 'string',
          'description': 'A CSS selector for the element to wait for.',
        },
        'timeoutMilliseconds': {
          'type': 'integer',
          'description':
              '(Optional) The maximum time to wait for the element in milliseconds. Defaults to 15000 (15 seconds).',
        },
      },
      'required': ['selector'],
    },
  ),
);

const getElementValueTool = ChatCompletionTool(
  type: ChatCompletionToolType.function,
  function: FunctionObject(
    name: 'getElementValue',
    description:
        'Retrieves the current value of an input field, textarea, or the selected option of a select element.',
    parameters: {
      'type': 'object',
      'properties': {
        'selector': {
          'type': 'string',
          'description':
              'A CSS selector to find the target element (e.g., "input[name=\'username\']", "textarea#comment").',
        },
      },
      'required': ['selector'],
    },
  ),
);

const selectDropdownOptionTool = ChatCompletionTool(
  type: ChatCompletionToolType.function,
  function: FunctionObject(
    name: 'selectDropdownOption',
    description:
        'Selects an option in an HTML `<select>` dropdown element by its value or visible text.',
    parameters: {
      'type': 'object',
      'properties': {
        'selector': {
          'type': 'string',
          'description': 'A CSS selector for the `<select>` dropdown element.',
        },
        'valueOrText': {
          'type': 'string',
          'description':
              'The value (if `byValue` is true) or the visible text (if `byValue` is false) of the option to select.',
        },
        'byValue': {
          'type': 'boolean',
          'description':
              '(Optional) If true (default), selects the option by its `value` attribute; otherwise, selects by its visible `text` content.',
          'default': true,
        },
      },
      'required': ['selector', 'valueOrText'],
    },
  ),
);

const submitFormTool = ChatCompletionTool(
  type: ChatCompletionToolType.function,
  function: FunctionObject(
    name: 'submitForm',
    description:
        'Submits the HTML form that contains the given element, or the form itself. Useful for triggering form submissions directly.',
    parameters: {
      'type': 'object',
      'properties': {
        'selector': {
          'type': 'string',
          'description':
              'A CSS selector for an element within the form, or the form element itself (e.g., "form#loginForm", "input[type=\'submit\']").',
        },
      },
      'required': ['selector'],
    },
  ),
);

const getElementAttributesTool = ChatCompletionTool(
  type: ChatCompletionToolType.function,
  function: FunctionObject(
    name: 'getElementAttributes',
    description:
        'Retrieves specific HTML attributes (e.g., "href", "src", "class", "id") from an element. Returns a JSON string of attribute-value pairs.',
    parameters: {
      'type': 'object',
      'properties': {
        'selector': {
          'type': 'string',
          'description': 'A CSS selector for the target element.',
        },
        'attributes': {
          'type': 'array',
          'description':
              'A list of attribute names to retrieve (e.g., ["href", "alt"]).',
          'items': {'type': 'string'},
        },
      },
      'required': ['selector', 'attributes'],
    },
  ),
);

const scrollIntoViewTool = ChatCompletionTool(
  type: ChatCompletionToolType.function,
  function: FunctionObject(
    name: 'scrollIntoView',
    description:
        'Scrolls the webpage to bring a specific element into the visible viewport.',
    parameters: {
      'type': 'object',
      'properties': {
        'selector': {
          'type': 'string',
          'description': 'A CSS selector for the element to scroll into view.',
        },
        'smooth': {
          'type': 'boolean',
          'description':
              '(Optional) If true (default), the scroll will be smooth; otherwise, it will be instant.',
          'default': true,
        },
        'block': {
          'type': 'string',
          'description':
              '(Optional) Defines vertical alignment of the element within the viewport ("start", "center", "end", or "nearest"). Defaults to "center".',
          'enum': ['start', 'center', 'end', 'nearest'],
          'default': 'center',
        },
      },
      'required': ['selector'],
    },
  ),
);

const scrollPageTool = ChatCompletionTool(
  type: ChatCompletionToolType.function,
  function: FunctionObject(
    name: 'scrollPage',
    description:
        'Scrolls the entire webpage by a specified amount horizontally (x) and vertically (y).',
    parameters: {
      'type': 'object',
      'properties': {
        'x': {
          'type': 'integer',
          'description':
              'The horizontal distance to scroll (positive for right, negative for left).',
        },
        'y': {
          'type': 'integer',
          'description':
              'The vertical distance to scroll (positive for down, negative for up).',
        },
        'smooth': {
          'type': 'boolean',
          'description':
              '(Optional) If true (default), the scroll will be smooth; otherwise, it will be instant.',
          'default': true,
        },
      },
      'required': ['x', 'y'],
    },
  ),
);

const evaluateJavaScriptTool = ChatCompletionTool(
  type: ChatCompletionToolType.function,
  function: FunctionObject(
    name: 'evaluateJavaScript',
    description:
        'Executes arbitrary JavaScript code on the web page and returns the result. Use this for complex or custom interactions not covered by other tools. The script should return a JSON-serializable value.',
    parameters: {
      'type': 'object',
      'properties': {
        'script': {
          'type': 'string',
          'description':
              'The JavaScript code to execute. Must return a serializable value (e.g., a string, number, boolean, or JSON.stringify() an object/array).',
        },
      },
      'required': ['script'],
    },
  ),
);

const getTextsOfAllElementsTool = ChatCompletionTool(
  type: ChatCompletionToolType.function,
  function: FunctionObject(
    name: 'getTextsOfAllElements',
    description:
        'Retrieves the text content of all elements matching a given CSS selector, returning them as a list of strings.',
    parameters: {
      'type': 'object',
      'properties': {
        'selector': {
          'type': 'string',
          'description':
              'A CSS selector to find the target elements (e.g., "p.description", "h2").',
        },
      },
      'required': ['selector'],
    },
  ),
);

// List of all available tools
final List<ChatCompletionTool> allTools = [
  loadUrlTool,
  typeInElementTool,
  clickElementTool,
  readTextContentTool,
  getInteractiveElementsTool, // The new "vision" tool
  typeInElementByIdTool, // The new ID-based typing tool
  clickElementByIdTool,
  // New advanced tools
  waitForElementTool,
  getElementValueTool,
  selectDropdownOptionTool,
  submitFormTool,
  getElementAttributesTool,
  scrollIntoViewTool,
  scrollPageTool,
  evaluateJavaScriptTool,
  getTextsOfAllElementsTool,
];
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
