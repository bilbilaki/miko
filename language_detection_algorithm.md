# Language Detection Algorithm

## Overview
This algorithm will detect the programming language of a code snippet to apply the appropriate syntax highlighting. It follows a multi-tiered approach with fallbacks.

## Detection Flow

1. **Explicit Language Tag**
   - First check if language is explicitly specified in the markdown code block (e.g., ```python)
   - If found, use this language directly

2. **Shebang Line Detection**
   - If code starts with #!, extract interpreter path
   - Map common interpreters to languages:
     - `python` → Python
     - `node` → JavaScript
     - `dart` → Dart
     - etc.

3. **Pattern-Based Detection**
   - Analyze code for language-specific patterns and keywords
   - Use a scoring system to determine the most likely language

4. **Fallback**
   - If confidence is below threshold, default to "text" (no highlighting)

## Language-Specific Patterns

### Dart
- Keywords: `void`, `Widget`, `StatelessWidget`, `StatefulWidget`, `build`, `@override`
- Patterns: 
  - Import statements: `import 'package:flutter/...`
  - Widget tree structure: `return Scaffold(`
  - Type declarations with generics: `List<String>`

### JavaScript
- Keywords: `const`, `let`, `var`, `function`, `async`, `await`, `=>`, `export`, `import`
- Patterns:
  - DOM manipulation: `document.getElementById`
  - Arrow functions: `() => {`
  - Template literals: `` `string ${var}` ``

### Python
- Keywords: `def`, `class`, `import`, `from`, `if __name__ == "__main__":`
- Patterns:
  - Indentation-based blocks
  - Function definitions: `def function_name(params):`
  - List comprehensions: `[x for x in range(10)]`

### Java
- Keywords: `public`, `class`, `static`, `void`, `extends`, `implements`
- Patterns:
  - Class definitions: `public class ClassName {`
  - Method signatures: `public static void main(String[] args)`
  - Type declarations: `String name = "value";`

### C/C++
- Keywords: `#include`, `int main()`, `struct`, `class`, `namespace`
- Patterns:
  - Header includes: `#include <stdio.h>`
  - Pointer syntax: `int* ptr`
  - Memory management: `malloc`, `free`, `new`, `delete`

### Kotlin
- Keywords: `fun`, `val`, `var`, `suspend`, `companion object`
- Patterns:
  - Function definitions: `fun functionName(): ReturnType {`
  - Null safety operators: `?.`, `!!`
  - Lambda expressions: `{ it.property }`

### Rust
- Keywords: `fn`, `let`, `mut`, `struct`, `impl`, `match`, `Option`, `Result`
- Patterns:
  - Function definitions: `fn function_name(param: Type) -> ReturnType {`
  - Ownership syntax: `&mut variable`
  - Pattern matching: `match value {`

### Swift
- Keywords: `func`, `let`, `var`, `guard`, `if let`, `protocol`
- Patterns:
  - Function definitions: `func functionName() -> ReturnType {`
  - Optional unwrapping: `if let value = optional {`
  - Closures: `{ (parameters) -> ReturnType in`

### Lua
- Keywords: `function`, `local`, `end`, `then`, `do`
- Patterns:
  - Function definitions: `function name(params)`
  - Table definitions: `local t = {}`
  - Comments: `-- comment`

### YAML
- Patterns:
  - Key-value pairs: `key: value`
  - Lists with dashes: `- item1`
  - Document separators: `---`
  - No brackets or semicolons

## Implementation Approach

```dart
class LanguageDetector {
  // Supported languages
  static const supportedLanguages = [
    'c', 'cpp', 'dart', 'java', 'javascript', 'kotlin', 
    'lua', 'python', 'rust', 'swift', 'yaml'
  ];
  
  // Detect language from code
  String detectLanguage(String code, [String? explicitLanguage]) {
    // 1. Check explicit language
    if (explicitLanguage != null && supportedLanguages.contains(explicitLanguage.toLowerCase())) {
      return explicitLanguage.toLowerCase();
    }
    
    // 2. Check shebang
    final shebangLanguage = _detectFromShebang(code);
    if (shebangLanguage != null) {
      return shebangLanguage;
    }
    
    // 3. Pattern-based detection
    final scores = _scoreLanguages(code);
    final (language, confidence) = _getHighestScore(scores);
    
    // 4. Return detected language or fallback
    return confidence > 0.4 ? language : 'text';
  }
  
  // Implementation details for each detection method...
}
```

## Confidence Scoring

The algorithm will assign confidence scores to each language based on:
- Number of matched patterns
- Specificity of patterns (some patterns are stronger indicators than others)
- Ratio of matched keywords to code length
- Presence of definitive language markers (e.g., file extensions in imports)

The language with the highest confidence score above a certain threshold will be selected.