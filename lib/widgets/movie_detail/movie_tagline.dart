import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Widget for displaying a movie tagline with styled text
class MovieTagline extends StatelessWidget {
  final String tagline;

  const MovieTagline({
    Key? key,
    required this.tagline,
  }) : super(key: key);

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
          color: Colors.white.withOpacity(0.85),
          letterSpacing: 0.8,
          height: 1.4,
          decorationStyle: GoogleFonts.dmSerifText().decorationStyle,
          fontStyle: FontStyle.italic,
          shadows: [
            Shadow(
              offset: const Offset(1, 1),
              blurRadius: 4,
              color: Colors.black.withOpacity(0.6),
            ),
            Shadow(
              offset: const Offset(0, 0),
              blurRadius: 8,
              color: Colors.blue.withOpacity(0.2),
            ),
          ],
        ),
      ),
    );
  }
}
