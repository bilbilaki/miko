import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

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

