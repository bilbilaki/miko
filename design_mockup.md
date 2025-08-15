# Advanced Code Block Design for Miko App

## Overview
This design enhances the current code block implementation with syntax highlighting, language detection, and improved user experience.

## Visual Design

```
┌─────────────────────────────────────────────────────────┐
│ ● python                                        📋 Copy │
├─────────────────────────────────────────────────────────┤
│ 1 │ def calculate_total(items):                         │
│ 2 │     """Calculate the total value of items"""        │
│ 3 │     total = 0                                       │
│ 4 │     for item in items:                              │
│ 5 │         total += item                               │
│ 6 │     return total                                    │
└─────────────────────────────────────────────────────────┘
```

## Key Features

### 1. Header Bar
- **Language Indicator**: Shows detected language with appropriate icon
- **Copy Button**: With visual feedback animation on click
- **Theme**: Matches the app's theme while maintaining code readability

### 2. Code Content
- **Syntax Highlighting**: Using flutter_syntax_view for accurate language-specific highlighting
- **Line Numbers**: For better code reference and readability
- **Monospace Font**: Optimized for code display
- **Selectable Text**: Allows users to select portions of code

### 3. Interactions
- **Copy Feedback**: Visual indication when code is copied
- **Expandable View**: For long code blocks (optional)
- **Smooth Animations**: For all interactions

## Implementation Details

### Syntax Highlighting
Utilizing flutter_syntax_view with the following supported languages:
- C, C++, Dart, Java, JavaScript, Kotlin, Lua, Python, Rust, Swift, YAML

### Theme Options
- Default: Dark theme with high contrast for readability
- Alternative: Light theme for light mode users
- Custom themes can be created by extending SyntaxTheme

### Language Detection
- Primary: Use language specified in markdown code block
- Secondary: Auto-detect based on code patterns and keywords
- Fallback: Default to "text" if language cannot be determined

## User Experience Improvements
- Clear visual hierarchy
- Intuitive copy functionality
- Consistent styling with the rest of the app
- Optimized for both light and dark themes