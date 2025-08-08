import 'package:openai_dart/openai_dart.dart';

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


