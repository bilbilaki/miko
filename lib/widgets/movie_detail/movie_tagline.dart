import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget for displaying a movie tagline with styled text
class MovieTagline extends StatelessWidget {
  final String tagline;

  const MovieTagline({
    super.key,
    required this.tagline,
  });

  @override
  Widget build(BuildContext context) {
    if (tagline.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        '"$tagline"',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white.withValues(alpha:0.85),
          letterSpacing: 0.8,
          height: 1.4,
          decorationStyle: GoogleFonts.dmSerifText().decorationStyle,
          fontStyle: FontStyle.italic,
          shadows: [
            Shadow(
              offset: const Offset(1, 1),
              blurRadius: 4,
              color: Colors.black.withValues(alpha:0.6),
            ),
            Shadow(
              offset: const Offset(0, 0),
              blurRadius: 8,
              color: Colors.blue.withValues(alpha:0.2),
            ),
          ],
        ),
      ),
    );
  }
}
