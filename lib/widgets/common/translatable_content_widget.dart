import 'package:flutter/material.dart';
import 'package:miko/utils/ai_translator.dart';

/// A reusable widget that provides translation functionality for any text content.
/// It shows a translation button next to the text and handles the translation state.
class TranslatableContentWidget extends StatefulWidget {
  /// The original text to display and potentially translate
  final String text;

  /// The style to apply to the text
  final TextStyle? style;

  /// Maximum number of lines for the text
  final int? maxLines;

  /// How to handle text overflow
  final TextOverflow? overflow;

  /// Text alignment
  final TextAlign? textAlign;

  /// Whether to show the translation button
  final bool showTranslateButton;

  /// The size of the translation button icon
  final double iconSize;

  /// Optional callback when translation is complete
  final ValueChanged<String>? onTranslated;

  /// Whether the text should be selectable
  final bool selectable;

  const TranslatableContentWidget({
    super.key,
    required this.text,
    this.style,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.showTranslateButton = true,
    this.iconSize = 16.0,
    this.onTranslated,
    this.selectable = false,
  });

  @override
  State<TranslatableContentWidget> createState() => _TranslatableContentWidgetState();
}

class _TranslatableContentWidgetState extends State<TranslatableContentWidget> {
  String? _translatedText;
  bool _isTranslating = false;
  final _translator = MovieTvTranslator();

  Future<void> _toggleTranslation() async {
    if (_translatedText != null) {
      setState(() => _translatedText = null);
      return;
    }

    setState(() => _isTranslating = true);
    try {
      final translated = await _translator.translateTextForMoviesAndTV(widget.text);
      setState(() => _translatedText = translated);
      widget.onTranslated?.call(translated);
    } finally {
      setState(() => _isTranslating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayText = _translatedText ?? widget.text;

    if (!widget.showTranslateButton) {
      return _buildTextWidget(displayText);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildTextWidget(displayText),
        ),
        const SizedBox(width: 4),
        IconButton(
          icon: _isTranslating
              ? SizedBox(
                  width: widget.iconSize,
                  height: widget.iconSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Icon(
                  Icons.auto_awesome,
                  color: _translatedText != null ? Colors.cyan : Colors.white54,
                  size: widget.iconSize,
                ),
          onPressed: _toggleTranslation,
          tooltip: _translatedText != null ? 'Show original' : 'Translate',
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(
            minWidth: widget.iconSize + 8,
            minHeight: widget.iconSize + 8,
          ),
        ),
      ],
    );
  }

  Widget _buildTextWidget(String text) {
    if (widget.selectable) {
      return SelectableText(
        text,
        style: widget.style,
        textAlign: widget.textAlign,
        maxLines: widget.maxLines,
      );
    }
    return Text(
      text,
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}
