import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miko/utils/ai_translator.dart';

/// Widget for displaying a movie tagline with styled text and translation support
class MovieTagline extends StatefulWidget {
  final String tagline;
  final VoidCallback? onTranslate;
  final String? translatedTagline;
  final bool isTranslating;

  const MovieTagline({
    super.key,
    required this.tagline,
    this.onTranslate,
    this.translatedTagline,
    this.isTranslating = false,
  });

  @override
  State<MovieTagline> createState() => _MovieTaglineState();
}

class _MovieTaglineState extends State<MovieTagline> {
  String? _translatedTagline;
  bool _isTranslating = false;

  Future<void> _translateTagline() async {
    if (_translatedTagline != null) {
      setState(() => _translatedTagline = null);
      return;
    }
    setState(() => _isTranslating = true);
    try {
      final translated = await MovieTvTranslator().translateTextForMoviesAndTV(widget.tagline,context);
      setState(() => _translatedTagline = translated);
    } finally {
      setState(() => _isTranslating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tagline.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayTagline = widget.translatedTagline ?? _translatedTagline ?? widget.tagline;
    final isCurrentlyTranslating = widget.isTranslating || _isTranslating;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              '"$displayTagline"',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.85),
                letterSpacing: 0.8,
                height: 1.4,
                decorationStyle: GoogleFonts.dmSerifText().decorationStyle,
                fontStyle: FontStyle.italic,
                shadows: [
                  Shadow(
                    offset: const Offset(1, 1),
                    blurRadius: 4,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                  Shadow(
                    offset: const Offset(0, 0),
                    blurRadius: 8,
                    color: Colors.blue.withValues(alpha: 0.2),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: isCurrentlyTranslating
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Icon(
                    Icons.auto_awesome,
                    color: (_translatedTagline != null || widget.translatedTagline != null)
                        ? Colors.cyan
                        : Colors.white54,
                    size: 16,
                  ),
            onPressed: widget.onTranslate ?? _translateTagline,
            tooltip: (_translatedTagline != null || widget.translatedTagline != null)
                ? 'Show original'
                : 'Translate tagline',
            style: IconButton.styleFrom(
              backgroundColor: Colors.black.withValues(alpha: 0.3),
              padding: const EdgeInsets.all(4.0),
            ),
          ),
        ],
      ),
    );
  }
}
